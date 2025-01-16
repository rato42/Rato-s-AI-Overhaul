DefineClass.AIPolicyCustomSeekCover = {
    __parents = {"AIPolicyTakeCover"}, -- "AIPositioningPolicy"},
    __generated_by_class = "ClassDef",

    properties = {
        {
            id = "ScalePerDistance",
            editor = "bool",
            default = true,
            read_only = false,
            no_edit = false
        }
    }
}

local distance_impact = 1.00
local max_range = 30

function AIPolicyCustomSeekCover:GetEditorView()
    return "Custom Seek Cover"
end

function AIPolicyCustomSeekCover:EvalDest(context, dest, grid_voxel)
    local score = 0

    local ux, uy, uz, ustance_idx = stance_pos_unpack(dest)

    local tbl = context.enemies or empty_table

    ---
    local denominador = 0
    local total_score = 0
    ---
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

            -------------
            total_score = total_score + cover_score
            denominador = denominador + 1

            local cover_score1 = cover_score
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
end

--[[function AIPolicyCustomSeekCover:EvalDest(context, dest, grid_voxel)
    local score = 0

    local ux, uy, uz, ustance_idx = stance_pos_unpack(dest)

    local tbl = context.enemies or empty_table

    ---
    local denominador = 0
    local total_score = 0
    ---
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

            -------------
            total_score = total_score + cover_score
            denominador = denominador + 1

            local cover_score1 = cover_score
            if self.ScalePerDistance and cover_score > 0 then
                local ux, uy, uz, ustance_idx = stance_pos_unpack(dest)
                local new_pos = point(ux, uy, uz)

                local dist = new_pos:Dist(enemy:GetPos())
                local range = max_range * const.Scale.AP
                local ratio = 100 - ((Min(range, dist) * 1.00) / (range * 1.00)) *
                                  (100 * distance_impact)

                cover_score = MulDivRound(cover_score, ratio, 100)
                print(enemy.session_id, dist / const.SlabSizeX, cover_score1, cover_score, ratio)

            end

            -------------
            score = score + cover_score

        end
    end

    local score_ratio = 0
    if total_score > 0 then
        total_score = total_score / Max(1, denominador)
        -- score = score / Max(1, denominador)

        local ux, uy, uz, ustance_idx = stance_pos_unpack(dest)
        local new_pos = point(ux, uy, uz)

        score_ratio = ((score * 1.00) / (total_score * 1.00)) * 100
        DbgAddText(total_score .. " / " .. score .. " = " .. score_ratio, new_pos)
    end

    local final_score = MulDivRound(self.Score, score_ratio, 100)
    ic(total_score, score, final_score)
    return score / Max(1, #tbl)
end]]
