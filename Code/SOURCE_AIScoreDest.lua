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
        ---- changed == 0 to <= 0 to suport negative values
        local failed = policy.Required and pscore <= 0
        ----
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
