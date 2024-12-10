function AIPolicyTakeCover:EvalDest(context, dest, grid_voxel)
    local score = 0
    local tbl = context.enemies or empty_table
    for _, enemy in ipairs(tbl) do
        local visible = true
        if self.visibility_mode == "self" then
            visible = context.enemy_visible[enemy]
        elseif self.visibility_mode == "team" then
            visible = context.enemy_visible_by_team[enemy]
        end
        if visible then
            local cover = GetCoverFrom(dest, context.enemy_pack_pos_stance[enemy])
            score = score + self.CoverScores[cover]
        end
    end

    return score / Max(1, #tbl)
end

AIPolicyTakeCover.CoverScores = {
    [const.CoverPass] = 0,
    [const.CoverNone] = 0,
    [const.CoverLow] = 50,
    [const.CoverHigh] = 100
}

function AIPolicyFlanking:EvalDest(context, dest, grid_voxel)
    local unit = context.unit

    local ap = context.dest_ap[dest] or 0
    if self.ReserveAttackAP and ap < context.default_attack_cost then
        return 0
    end

    if not context.position_override then
        context.position_override = {}
        if self.AllyPlannedPosition then
            for _, ally in ipairs(unit.team.units) do
                local dest = ally.ai_context and ally.ai_context.ai_destination
                if dest then
                    local x, y, z = stance_pos_unpack(dest)
                    context.position_override[ally] = point(x, y, z)
                end
            end
        end
    end

    local x, y, z = stance_pos_unpack(dest)
    context.position_override[unit] = point(x, y, z)

    if not context.enemy_surrounded then
        context.enemy_surrounded = {}
        for _, enemy in ipairs(context.enemies) do
            if enemy:IsSurrounded() then
                context.enemy_surrounded[enemy] = true
            end
        end
    end

    local delta = 0
    for _, enemy in ipairs(context.enemies) do
        local new_surrounded = enemy:IsSurrounded(context.position_override)
        if new_surrounded and not context.enemy_surrounded[enemy] then
            delta = delta + 1
        elseif not new_surrounded and context.enemy_surrounded[enemy] then
            delta = delta - 1
        end
    end

    return delta * self.Weight
end

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
