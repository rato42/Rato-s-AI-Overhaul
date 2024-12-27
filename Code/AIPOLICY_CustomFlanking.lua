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
        {id = "optimal_location", editor = "bool", default = true, read_only = true, no_edit = true},
        {id = "OnlyTarget", editor = "bool", default = false, read_only = false, no_edit = false}
    }
}

local draw_debug = true

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

function Update_AICoverLOS_currentpos(unit, current_pos_arg)
    local context = unit.ai_context
    local context_copy = table.copy(unit.ai_context)
    local current_pos = current_pos_arg or context.unit_stance_pos -- stance_pos_pack(unit:GetPos())
    if current_pos then
        if not context.dest_target_cover_score[current_pos] or
            not context.dest_target_los[current_pos] then
            print("-- not current_pos", GameTime())
            AIPrecalcDamageScore(context_copy, {current_pos})

            context.dest_target_cover_score[current_pos] =
                context_copy.dest_target_cover_score[current_pos]
            context.dest_target_los[current_pos] = context_copy.dest_target_los[current_pos]
            -- unit.ai_context = context
            return context
        end

    end
    return nil
end

function AIPolicyCustomFlanking:EvalDest(context, dest, grid_voxel)
    ---- Args
    local effective_range_mul = 1.0
    local distance_impact = 0.5
    local extra_target_weight = 100
    local unit_weight = 100
    ----

    local unit = context.unit
    local current_pos = context.unit_stance_pos -- stance_pos_pack(unit, StancesList.Crouch) -- unit.stance)
    context = Update_AIPrecalcDamageScore(unit) or context
    -- context = Update_AICoverLOS_currentpos(unit, current_pos) or context
    -- current_pos = context.unit_stance_pos

    local target = context.dest_target[dest]

    local ap = context.dest_ap[dest] or 0
    if self.ReserveAttackAP and ap < context.default_attack_cost then
        return 0
    end

    local x, y, z = stance_pos_unpack(dest)
    local new_pos = point(x, y, z)

    local enemies = {}
    local enemies_weight = {}

    if self.OnlyTarget then
        if target then
            enemies = {target}
            enemies_weight[target] = 100
        else
            return 0
        end
    else
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
                    local weight = unit_weight
                    if target and enemy == target then
                        weight = weight + extra_target_weight
                    end
                    --  weight = Max(0, 100 - (dist / effective_range) * (100 * distance_impact))

                    enemies_weight[enemy] = weight
                    enemies[#enemies + 1] = enemy
                end
            end

            ------------------------
        end
    end

    local context_cover_data = context.dest_target_cover_score[dest]
    local context_los_data = context.dest_target_los[dest]

    local context_currentpos_cover_data = context.currentpos_target_cover_score -- context.dest_target_cover_score[current_pos]
    local context_currentpos_los_data = context.enemy_visible -- context.dest_target_los[current_pos]

    local current_pos_cover_data, new_pos_cover_data = {}, {}
    for _, enemy in ipairs(enemies) do

        local in_cover, cover_cth, no_los = IsInCover(unit, enemy, context_currentpos_cover_data,
                                                      context_currentpos_los_data)

        current_pos_cover_data[enemy] = {
            in_cover = in_cover,
            cover_cth = cover_cth,
            no_los = no_los
        }

        local in_cover, cover_cth, no_los = IsInCover(unit, enemy, context_cover_data,
                                                      context_los_data)
        new_pos_cover_data[enemy] = {in_cover = in_cover, cover_cth = cover_cth, no_los = no_los}
    end

    local delta = 0
    local total_weight = 0

    local debug_data = {}
    for _, enemy in ipairs(enemies) do
        local delta_weight = enemies_weight[enemy] or 100

        debug_data[enemy] = {
            new_in_cover = new_pos_cover_data[enemy].in_cover,
            old_in_cover = current_pos_cover_data[enemy].cover_cth,
            delta = 0,
            cover = context_cover_data and context_cover_data[enemy] or 0,
            los = context_los_data and context_los_data[enemy] or "NoLosData"
        }

        --------- New
        local dif = CompareCovers(enemy, current_pos_cover_data, new_pos_cover_data)
        delta_weight = delta_weight * dif
        -- ic(delta_weight)

        -- total_weight = total_weight + abs(delta_weight)

        -- debug_data[enemy].delta = delta_weight
        -- delta = delta + delta_weight

        if new_pos_cover_data[enemy].in_cover and not current_pos_cover_data[enemy].in_cover then
            delta = delta + delta_weight
            debug_data[enemy].delta = delta_weight
        elseif not new_pos_cover_data[enemy].in_cover and current_pos_cover_data[enemy].in_cover then
            delta = delta + delta_weight
            debug_data[enemy].delta = delta_weight
        end

        -------------------- Simple

        --[[if not new_pos_cover_data[enemy].in_cover then
            delta = delta + delta_weight
            debug_data[enemy].delta = delta_weight
        else
            debug_data[enemy].delta = 0
        end]]
        -------------------- 

    end

    local denominador = (Max(1, #enemies)) * 100
    local score = delta -- (delta / (Max(1, denominador))) * 100
    ------------ FIX THIS

    -- ic(delta, final_delta, #enemies, denominador, total_weight, score)

    ----------------------- Debug

    if draw_debug then
        DbgAddCircle(new_pos)
    end
    local all_enemy_debug_info = "\n"

    for enemy, data in pairs(debug_data) do
        local delta = data.delta

        local dbg_text = string.format("  %s, 1stCover: %s, 2ndCover: %s Delta: %d, LOS: %s",
                                       tostring(enemy.session_id), tostring(data.old_in_cover),
                                       tostring(data.cover), delta, tostring(data.los))

        all_enemy_debug_info = all_enemy_debug_info .. dbg_text .. "\n"

        if delta ~= 0 then
            local color = delta > 0 and const.clrGreen or delta == 0 and const.clrGray or
                              const.clrRed
            if not data.los or data.los == 0 then
                color = const.clrBlue
            end
            if draw_debug then
                DbgAddVector(new_pos, enemy:GetPos() - new_pos, color)
            end
        end
    end

    local total_dbg_text = string.format("Score: %s", tostring(score))
    all_enemy_debug_info = total_dbg_text .. all_enemy_debug_info

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
