function AIScoreDest(context, policies, dest, grid_voxel, base_score, visual_voxels, score_details)
    local score = 0
    local x, y, z, stance_idx = stance_pos_unpack(dest)
    if not grid_voxel then
        local vx, vy, vz = WorldToVoxel(x, y, z)
        grid_voxel = point_pack(vx, vy, vz)
    end

    local voxels, head = context.unit:GetVisualVoxels(point_pack(x, y, z), StancesList[stance_idx],
                                                      visual_voxels)
    if AreVoxelsInFireRange(voxels) then
        score = const.AIAvoidFireWeigth
        if score_details then
            score_details[#score_details + 1] = "ADJACENT FIRE"
            score_details[#score_details + 1] = const.AIAvoidFireWeigth
        end
    elseif g_SmokeObjs[head] then
        score = const.AIAvoidFireWeigth
        if score_details then
            score_details[#score_details + 1] = "GASSED AREA"
            score_details[#score_details + 1] = const.AIAvoidGasWeigth
        end
    end

    for _, policy in ipairs(policies) do
        local peval = policy:EvalDest(context, dest, grid_voxel)
        local pscore = MulDivRound(peval or 0, policy.Weight, 100)
        local failed = policy.Required and pscore == 0
        score = score + pscore
        if score_details then
            score_details[#score_details + 1] = (failed and "[FAILED] " or "") ..
                                                    policy:GetEditorView()
            score_details[#score_details + 1] = pscore
        end
        if failed then
            return 0
        end
    end

    score = (base_score or 0) + score

    -- bombard zone modifier
    for _, zone in ipairs(g_Bombard) do
        local dist = zone:GetDist(x, y, z)
        local radius = zone.radius * const.SlabSizeX
        if dist <= radius then
            local mod = MulDivRound(dist, const.AIAvoidBombardEdge, radius) +
                            MulDivRound(radius - dist, const.AIAvoidBombardCenter, radius)
            local loss = MulDivRound(score, 100 - mod, 100)
            if score_details and loss > 0 then
                score_details[#score_details + 1] = "BOMBARD ZONE"
                score_details[#score_details + 1] = -loss
            end
            score = Max(0, score - loss)
        end
    end

    -- apply modifiers from bias markers at the end
    if context.apply_bias then
        local unit = context.unit
        for _, marker in ipairs(g_BiasMarkers) do
            local bias = marker:GetAIBias(unit, dest)
            if bias ~= 100 then
                score = MulDivRound(score, bias, 100)
                if score_details then
                    score_details[#score_details + 1] =
                        string.format("Bias Marker %s (%%): ", marker.ID)
                    score_details[#score_details + 1] = bias
                end
            end
        end
    end

    return score
end

function AIScoreReachableVoxels(context, policies, opt_loc_weight, dest_score_details,
                                cur_dest_preference)
    local unit = context.unit
    policies = table.ifilter(policies, function(idx, policy)
        return policy:MatchUnit(unit)
    end)
    unit.ai_end_turn_search = {}

    local total_dist = context.total_dist
    local dest_dist = context.dest_dist or empty_table

    local curr_dest = context.voxel_to_dest[context.unit_world_voxel] or
                          context.voxel_to_dest[context.closest_free_pos] or context.unit_stance_pos
    local dist = dest_dist[curr_dest] or total_dist
    local score = -opt_loc_weight

    if (total_dist or 0) > 0 then
        score = MulDivRound(score, dist, total_dist)
    end

    local unit_voxels = {}
    local best_end_score = curr_dest and
                               AIScoreDest(context, policies, curr_dest, context.unit_grid_voxel,
                                           score, unit_voxels)

    -- cache the best voxel on the way to optimal location to use as fallback if needed
    local best_dist_score, closest_dest
    local potential_dests, dest_scores = {curr_dest}, {best_end_score}

    for _, dest in ipairs(context.destinations) do
        total_dist = Max(total_dist or 0, dest_dist[dest] or 0)
    end

    for _, dest in ipairs(context.destinations) do
        local score = 0
        local scores

        local dist = dest_dist[dest] or 100 * guim
        local dist_score = 0
        if total_dist and total_dist > 0 then
            dist_score = MulDivRound(100 - MulDivRound(100, dist, total_dist), opt_loc_weight, 100)
        end
        if dist_score > (best_dist_score or 0) then
            best_dist_score, closest_dest = dist_score, dest
        end

        score = score + dist_score
        if dest_score_details then
            scores = {"Distance to optimal location", dist_score}
            dest_score_details[dest] = scores
        end

        table.iclear(unit_voxels)
        score = AIScoreDest(context, policies, dest, nil, score, unit_voxels, scores)

        if MulDivRound(best_end_score or 0, const.AIDecisionThreshold, 100) <= score then
            best_end_score = Max(score, best_end_score or 0)
            local n = #potential_dests
            potential_dests[n + 1] = dest
            dest_scores[n + 1] = score
            local threshold = MulDivRound(best_end_score, const.AIDecisionThreshold, 100) -- updated threshold
            for i = n, 1, -1 do
                if dest_scores[i] < threshold then
                    table.remove(dest_scores, i)
                    table.remove(potential_dests, i)
                end
            end
        end
        if scores then
            scores.final_score = score
        end
    end

    -- pick best_end_dest/score from potential_dests
    assert(#potential_dests > 0)
    context.best_end_dest = false
    if cur_dest_preference == "prefer" then
        if table.find(potential_dests, curr_dest) then
            context.best_end_dest = curr_dest
        end
    elseif cur_dest_preference == "avoid" then
        if #potential_dests > 1 then
            table.remove_value(potential_dests, curr_dest)
        end
    end

    NetUpdateHash("AIScoreReachableVoxels", unit, unit:GetPos(), unit.ActionPoints,
                  context.archetype.id, #(context.destinations or ""),
                  hashParamTable(context.destinations), #(potential_dests or ""),
                  hashParamTable(potential_dests), cur_dest_preference)

    if not context.best_end_dest then
        local total = 0
        for _, score in ipairs(potential_dests) do
            total = total + score
        end
        local roll = InteractionRand(total, "AIDecision")
        for i, dest in ipairs(potential_dests) do
            local score = dest_scores[i]
            if score <= roll then
                context.best_end_dest = dest
                break
            end
            roll = roll - score
        end
        context.best_end_dest = context.best_end_dest or potential_dests[#potential_dests] or
                                    curr_dest
    end
    context.best_end_score = best_end_score

    context.closest_dest = closest_dest
    return context.best_end_dest, context.best_end_score
end

function AIFindOptimalLocation(context, dest_score_details)
    if context.best_dest then
        -- optimal location doesn't change across behaviors, no need to recalc it
        return context.best_dest
    end

    local unit = context.unit
    context.best_dests = {}

    local r = context.archetype.OptLocSearchRadius * const.SlabSizeX
    local ux, uy, uz = point_unpack(context.unit_grid_voxel)
    local px, py, pz = VoxelToWorld(ux, uy, uz)
    local bbox = box(px - r, py - r, 0, px + r + 1, py + r + 1, MapSlabsBBox_MaxZ)
    context.best_score = 0
    local unit_voxels = {}
    local dest_scores = {}

    local policies = table.ifilter(context.archetype.OptLocPolicies, function(idx, policy)
        return policy:MatchUnit(unit)
    end)

    for _, dest in ipairs(context.all_destinations) do
        local x, y, z = stance_pos_unpack(dest)
        local gx, gy, gz = WorldToVoxel(x, y, z)
        local world_voxel = point_pack(x, y, z)
        local grid_voxel = point_pack(gx, gy, gz)
        -- eval_voxel(x, y, z, context, ux, uy, uz)

        if not context.voxel_to_dest[world_voxel] then
            context.voxel_to_dest[world_voxel] = dest
        end
        local scores
        if dest_score_details then
            scores = {}
            dest_score_details[dest] = scores
        end
        table.iclear(unit_voxels)
        local score = AIScoreDest(context, policies, dest, grid_voxel, 0, unit_voxels, scores)
        if score > 0 then
            context.best_score = Max(context.best_score, score)
            local threshold = MulDivRound(context.best_score, const.AIDecisionThreshold, 100)
            if score >= threshold then
                dest_scores[dest] = score
                context.best_dests[#context.best_dests + 1] = dest
                for i = #context.best_dests, 1, -1 do
                    local dest = context.best_dests[i]
                    if dest_scores[dest] < threshold then
                        table.remove(context.best_dests, i)
                    end
                end
            end
        end
        if scores then
            scores.final_score = score
        end
    end

    -- check if a best dest candidate is on our starting voxel, default to it
    for _, dest in ipairs(context.best_dests) do
        if stance_pos_dist(context.unit_stance_pos, dest) == 0 then
            context.best_dest = dest
        end
    end

    if not context.best_dest and #(context.best_dests or empty_table) > 0 then
        if #(context.best_dests or empty_table) > 15 then
            context.collapsed = CollapsePoints(context.best_dests, 1)
        else
            context.collapsed = context.best_dests
        end
        local pf_dests = {}
        for i, dest in ipairs(context.collapsed) do
            local x, y, z = stance_pos_unpack(dest)
            pf_dests[i] = point(x, y, z)
        end

        context.best_dest_path = pf.GetPosPath(unit, pf_dests)
        if #(context.best_dest_path or empty_table) > 0 then
            local voxel = point_pack(SnapToPassSlabXYZ(context.best_dest_path[1]))
            local dest = context.voxel_to_dest[voxel]
            if not dest then
                -- try non-snapped
                voxel = point_pack(context.best_dest_path[1])
                dest = context.voxel_to_dest[voxel]
            end
            -- assert(dest and (not dest_score_details or dest_score_details[dest]))
            context.best_dest = dest
        end
    end

    context.dest_scores = dest_scores
    context.best_dest = context.best_dest or context.voxel_to_dest[context.unit_world_voxel] or
                            context.unit_stance_pos
    if context.dest_combat_path[context.best_dest] then
        table.insert_unique(context.important_dests, context.best_dest)
        table.insert_unique(context.destinations, context.best_dest)
    end
    return context.best_dest
end
