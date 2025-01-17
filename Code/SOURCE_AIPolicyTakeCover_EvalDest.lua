--[[function AIPolicyTakeCover:EvalDest(context, dest, grid_voxel)
    local score = 0

    local ux, uy, uz, ustance_idx = stance_pos_unpack(dest)

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
            local cover_score = self.CoverScores[cover] or 0

            if self.ScalePerDistance and cover_score > 0 then
                local ux, uy, uz, ustance_idx = stance_pos_unpack(dest)
                local new_pos = point(ux, uy, uz)

                local dist = new_pos:Dist(enemy:GetPos())
                local range = max_range * const.Scale.AP
                local ratio = 100 - ((Min(range, dist) * 1.00) / (range * 1.00)) *
                                  (100 * distance_impact)

                cover_score = MulDivRound(cover_score, ratio, 100)
                -- print(enemy.session_id, dist / const.SlabSizeX, cover_score1, cover_score, ratio)
            end

            -------------
            score = score + cover_score

        end
    end

    return score / Max(1, #tbl)
end]] 
