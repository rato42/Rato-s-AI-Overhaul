DefineClass.AIPolicyCustomSeekCover = {
    __parents = {"AIPositioningPolicy"},
    __generated_by_class = "ClassDef",

    properties = {
        {id = "end_of_turn", editor = "bool", default = true, read_only = true, no_edit = true}, {
            id = "ReserveAttackAP",
            name = "Reserve Attack AP",
            help = "do not consider locations where the unit will be out of ap and couldn't attack",
            editor = "bool",
            default = false
        }, {
            id = "visibility_mode",
            name = "Visibility Mode",
            editor = "choice",
            default = "self",
            items = function(self)
                return {"self", "team", "all"}
            end
        },
        {id = "optimal_location", editor = "bool", default = true, read_only = true, no_edit = true},
        {id = "OnlyTarget", editor = "bool", default = false, read_only = false, no_edit = false}
    }
}

function AIPolicyCustomSeekCover:EvalDest(context, dest, grid_voxel)
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

            score = score + self.CoverScores[cover]
        end
    end

    return score -- / Max(1, #tbl)
end

AIPolicyCustomSeekCover.CoverScores = {
    [const.CoverPass] = 0,
    [const.CoverNone] = 0,
    [const.CoverLow] = 50,
    [const.CoverHigh] = 100
}

local function IsInCover(unit, enemy, cover_data, los_data)
    local cover_penalty =
        Presets["ChanceToHitModifier"]["Default"]["RangeAttackTargetStanceCover"]:ResolveValue(
            "Cover")

    if not los_data or (not los_data[enemy] or los_data[enemy] == 0) then
        return true, cover_penalty, "No LOS"
    end

    if cover_data and cover_data[enemy] then
        return true, cover_data[enemy]
    end

    return false
end

local function CompareCovers(enemy, current_pos_cover_data, new_pos_cover_data)
    local cover_penalty =
        Presets["ChanceToHitModifier"]["Default"]["RangeAttackTargetStanceCover"]:ResolveValue(
            "Cover")

    local current_cover_cth = current_pos_cover_data[enemy].cover_cth or 0
    local new_cover_cth = new_pos_cover_data[enemy].cover_cth or 0
    local new_ratio = new_cover_cth * 1.00 / cover_penalty
    local current_ratio = current_cover_cth * 1.00 / cover_penalty

    local cover_difference = current_ratio - new_ratio

    -- ic(enemy.session_id, new_cover_cth, current_cover_cth, cover_difference)
    -- ic(new_ratio, current_ratio)
    return cover_difference
end

function Update_AIPrecalcDamageScore(unit)
    local context = unit.ai_context or {}
    if not context.damage_score_precalced then
        print("-- not precalced", GameTime())
        AIPrecalcDamageScore(context)
        -- unit.ai_context = context
        return context
    end
    return nil
    -- print("Already precalced", GameTime())
end

