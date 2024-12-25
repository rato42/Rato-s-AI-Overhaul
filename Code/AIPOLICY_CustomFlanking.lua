DefineClass.AIPolicyCustomFlanking = {
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
        {id = "optimal_location", editor = "bool", default = true, read_only = true, no_edit = true}
    }
}

local function IsInCover(unit, target, override_pos)
    local target_pos = GetPackedPosAndStance(target)
    local att_pos = override_pos or GetPackedPosAndStance(unit)

    local target_cover = GetCoverFrom(target_pos, att_pos)

    if target_cover == const.CoverLow or target_cover == const.CoverHigh then
        return true
    end
    return false
end

function AIPolicyCustomFlanking:EvalDest(context, dest, grid_voxel)
    ---- Args
    local effective_range_mul = 1.0
    local distance_impact = 0.5
    ----

    local unit = context.unit

    local ap = context.dest_ap[dest] or 0
    if self.ReserveAttackAP and ap < context.default_attack_cost then
        return 0
    end

    local x, y, z = stance_pos_unpack(dest)
    local new_pos = point(x, y, z)

    local enemies = {}
    local enemies_weight = {}
    for _, enemy in ipairs(context.enemies) do
        local dist = new_pos:Dist(enemy:GetPos())
        local effective_range = context.EffectiveRange * const.SlabSizeX * effective_range_mul

        -------------------- Simple
        --[[
		enemies[#enemies + 1] = enemy
        local weight = Max(0, 100 - (dist / effective_range) * (100 * distance_impact))
        enemies_weight[enemy] = weight]]
        ------------------------

        if dist <= effective_range then
            local visible = true

            if self.visibility_mode == "self" then
                visible = context.enemy_visible[enemy]
            elseif self.visibility_mode == "team" then
                visible = context.enemy_visible_by_team[enemy]
            end

            if visible then
                local weight = Max(0, 100 - (dist / effective_range) * (100 * distance_impact))
                enemies_weight[enemy] = weight
                enemies[#enemies + 1] = enemy
            end
        end
        ------------------------
    end

    local enemies_in_cover = {}
    ------ Check if enemies in cover is being populated correctly
    for _, enemy in ipairs(enemies) do
        if IsInCover(unit, enemy) then
            enemies_in_cover[enemy] = true
        end
    end

    local delta = 0
    local total_weight = 0

    local cover_data = context.dest_target_cover_score[dest]
    --- check if we already have LOS in precalc damage score
    local debug_data = {}
    for _, enemy in ipairs(enemies) do
        local delta_weight = enemies_weight[enemy] or 100
        total_weight = total_weight + delta_weight

        local new_in_cover = IsInCover(unit, enemy, dest)

        debug_data[enemy] = {
            new_in_cover = new_in_cover,
            old_in_cover = enemies_in_cover[enemy],
            delta = 0,
            cover = nil
        }
        if cover_data and cover_data[enemy] then
            debug_data[enemy].cover = cover_data[enemy]
            print(enemy.session_id, cover_data[enemy])
        end

        ----- Exclude enemies that are not visible in new pos, if possible
        if new_in_cover and not enemies_in_cover[enemy] then
            delta = delta - delta_weight
            debug_data[enemy].delta = -delta_weight
        elseif not new_in_cover and enemies_in_cover[enemy] then
            delta = delta + delta_weight
            debug_data[enemy].delta = delta_weight
        end

        -------------------- Simple
        --[[
        if not new_in_cover then
            delta = delta + delta_weight
            debug_data[enemy] = delta_weight
        else
            debug_data[enemy] = 0
        end]]
        -------------------- 

    end

    local final_delta = total_weight > 0 and (delta / total_weight) or 0
    -- final_delta = delta / Max(1, #enemies)

    local score = final_delta * self.Weight

    ----------------------- Debug
    DbgAddCircle(new_pos)
    local all_enemy_debug_info = "\n"
    for enemy, data in pairs(debug_data) do
        local delta = data.delta

        local dbg_text = string.format(
                             "Enemy: %s, New in Cover: %s, Old in Cover: %s, Delta: %d, Cover: %s",
                             tostring(enemy.session_id), tostring(data.new_in_cover),
                             tostring(data.old_in_cover), delta, tostring(data.cover))

        all_enemy_debug_info = all_enemy_debug_info .. dbg_text .. "\n"

        if delta ~= 0 then
            local color = delta > 0 and const.clrGreen or delta == 0 and const.clrGray or
                              const.clrRed
            DbgAddVector(new_pos, enemy:GetPos() - new_pos, color)
        end
    end
    context.dest_flanking_pol_debug[dest] = all_enemy_debug_info
    ----------------------- 

    return score > 0 and score or 0
end

--[[function AIPolicyCustomFlanking_IndividualTarget:EvalDest(context, dest, grid_voxel)

    local unit = context.unit

    local ap = context.dest_ap[dest] or 0
    if self.ReserveAttackAP and ap < context.default_attack_cost then
        return 0
    end

    local target = context.dest_target[dest]

    if not target then

        return 0
    end
    ic(target.session_id)

    local target_in_cover = IsInCover(unit, target)
    local new_target_in_cover = IsInCover(unit, target, dest)

    return (target_in_cover and not new_target_in_cover) and self.Weight or 0
end]]
