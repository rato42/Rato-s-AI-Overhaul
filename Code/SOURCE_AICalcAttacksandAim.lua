---TODO: Consider leaving this function as "pre-planning" and moving the more complex logic to when the positions are defined?
function AICalcAttacksAndAim(context, ap)

    ------- Fix for min aim
    local unit = context.unit
    unit.AI_dont_return_Stance_min_aim_level = true --- avoiding duplicates. GetBaseAimLevelRange check considers unit position, not future positions like the current function calculates
    local min_aim, max_aim = unit:GetBaseAimLevelRange(context.default_attack, false)
    unit.AI_dont_return_Stance_min_aim_level = false

    local free_move_ap = unit.free_move_ap or 0
    ----

    ---- Shooting Stance checks
    local stance_cost = 0
    local recoil_aim_cost = 0
    local rotation_cost = 0
    local aim_cost = Get_AimCost(unit)

    local not_moved, has_stance
    if IsKindOf(context.weapon, "Firearm") then
        local unit_pos = unit and unit:GetPos()
        local attack_pos = context.attacker_pos

        if attack_pos and unit_pos then
            attack_pos = attack_pos:SetTerrainZ()
            unit_pos = unit_pos:SetTerrainZ()

            not_moved = attack_pos == unit_pos
            has_stance = not_moved and context.unit:HasStatusEffect("shooting_stance")
        end

        -------- Persistant recoil aim cost increase
        --- I dont think this is going to work 
        --[[if not_moved then
            local recoil = unit:GetStatusEffect("Rat_recoil")
            if recoil then
                recoil_aim_cost = recoil:ResolveValue("aim_cost")
            end
        end]]

        if has_stance then
            rotation_cost = unit:GetShootingStanceAP(context.current_target, context.weapon, 1,
                                                     context.default_attack, "rotate")
        else
            stance_cost = GetWeapon_StanceAP(unit, context.weapon) + aim_cost
        end
    end
    ------

    local cost = context.default_attack_cost

    ---- Manual Cycling
    local bolting_cost = 0
    local is_unbolted, can_bolt

    if context.weapon and rat_canBolt(context.weapon) then
        can_bolt = true
        bolting_cost = rat_get_manual_cyclingAP(unit, context.weapon, true) * const.Scale.AP
        is_unbolted = context.weapon.unbolted
    end

    if can_bolt and not is_unbolted then ---- if is_unbolted the atk_cost will already have bolting cost
        ap = ap + bolting_cost ----- otherwise, discount the first shot cost
        cost = cost + bolting_cost ---- and increase the atk cost
    end

    ----

    ------- Verify if has AP to enter Stance

    ---TODO:Check if this deduction is correct
    local ap = ap --- - free_move_ap
    local total_stance_cost = cost + stance_cost

    ---- support for reverting to basic attacks from AIPlayAttacks (always on the same position as the signature)
    total_stance_cost = (context.ap_after_signature and unit:HasStatusEffect("shooting_stance")) and
                            0 or total_stance_cost
    stance_cost = (context.ap_after_signature and unit:HasStatusEffect("shooting_stance")) and 0 or
                      stance_cost
    ----

    local has_stance_ap = ap >= total_stance_cost

    if not has_stance_ap then
        stance_cost = 0
        ---RATOAI_TryDegradeToSingleShot(context)
    else ---- and modify min aim level if it has
        min_aim = min_aim + 1
    end
    -------

    local should_max_aim = ShouldMaxAim(context) or context.force_max_aim
    local aims = {}

    if not has_stance_ap then
        -- if should_max_aim then
        --     return 0, min_aim
        -- end
        local num_atks = (ap / cost)
        local aims = {}
        for i = 1, num_atks do
            aims[i] = min_aim
        end
        return num_atks, aims
    end

    local remaining_ap = ap

    if should_max_aim then
        local first_atk_cost = stance_cost + rotation_cost + cost
        local to_reach_max_aim = max_aim - min_aim
        if to_reach_max_aim > 0 then
            local remaining_ap_after_first_atk = ap - first_atk_cost

            local aim = min_aim
            while remaining_ap > aim_cost do
                if aim >= max_aim then
                    break
                end
                aim = aim + 1
                remaining_ap_after_first_atk = remaining_ap_after_first_atk - aim_cost
            end
            aims[1] = aim
            remaining_ap = remaining_ap_after_first_atk
        end
    end

    local index = (#aims or 0) + 1
    while remaining_ap > 0 do
        local atk_cost = cost
        local aim = min_aim
        while aim < max_aim and remaining_ap >= aim_cost + atk_cost do
            aim = aim + 1
            remaining_ap = remaining_ap - aim_cost
        end

        if remaining_ap >= atk_cost then
            aims[index] = aim
            index = index + 1
            remaining_ap = remaining_ap - atk_cost
        else
            break
        end
    end

    -- ic(#aims, aims)
    return #aims, aims
end

-- function AICalcAttacksAndAim(context, ap)

--     ------- Fix for min aim
--     local unit = context.unit
--     unit.AI_dont_return_Stance_min_aim_level = true --- avoiding duplicates. GetBaseAimLevelRange check considers unit position, not future positions like the current function calculates
--     local min_aim, max_aim = unit:GetBaseAimLevelRange(context.default_attack, false)
--     unit.AI_dont_return_Stance_min_aim_level = false

--     local free_move_ap = unit.free_move_ap or 0
--     ----

--     ---- Shooting Stance checks
--     local stance_cost = 0
--     local recoil_aim_cost = 0
--     local rotation_cost = 0
--     local aim_cost = Get_AimCost(unit)

--     local not_moved, has_stance
--     if IsKindOf(context.weapon, "Firearm") then
--         local unit_pos = unit and unit:GetPos()
--         local attack_pos = context.attacker_pos

--         if attack_pos and unit_pos then
--             attack_pos = attack_pos:SetTerrainZ()
--             unit_pos = unit_pos:SetTerrainZ()

--             not_moved = attack_pos == unit_pos
--             has_stance = not_moved and context.unit:HasStatusEffect("shooting_stance")
--             -- ic(attack_pos, unit_pos, not_moved, has_stance)
--         end

--         -------- Persistant recoil aim cost increase
--         --- I dont think this is going to work 
--         --[[if not_moved then
--             local recoil = unit:GetStatusEffect("Rat_recoil")
--             if recoil then
--                 recoil_aim_cost = recoil:ResolveValue("aim_cost")
--             end
--         end]]

--         if has_stance then
--             rotation_cost = unit:GetShootingStanceAP(context.current_target, context.weapon, 1,
--                                                      context.default_attack, "rotate")
--         else
--             stance_cost = GetWeapon_StanceAP(unit, context.weapon) + aim_cost
--         end
--     end
--     ------

--     local cost = context.default_attack_cost

--     ---- Manual Cycling
--     local bolting_cost = 0
--     local is_unbolted, can_bolt

--     if context.weapon and rat_canBolt(context.weapon) then
--         can_bolt = true
--         bolting_cost = rat_get_manual_cyclingAP(unit, context.weapon, true) * const.Scale.AP
--         is_unbolted = context.weapon.unbolted
--     end

--     if can_bolt and not is_unbolted then ---- if is_unbolted the atk_cost will already have bolting cost
--         ap = ap + bolting_cost ----- otherwise, discount the first shot cost
--         cost = cost + bolting_cost ---- and increase the atk cost
--     end

--     ----

--     ------- Verify if has AP to enter Stance

--     ---TODO:Check if this deduction is correct
--     local ap = ap - free_move_ap --- Fixes considering free move ap as AP
--     local total_stance_cost = cost + stance_cost

--     ---- support for reverting to basic attacks from AIPlayAttacks (always on the same position as the signature)
--     total_stance_cost = (context.ap_after_signature and unit:HasStatusEffect("shooting_stance")) and
--                             0 or total_stance_cost
--     stance_cost = (context.ap_after_signature and unit:HasStatusEffect("shooting_stance")) and 0 or
--                       stance_cost
--     ----

--     local has_stance_ap = ap >= total_stance_cost

--     if not has_stance_ap then
--         stance_cost = 0
--         ---RATOAI_TryDegradeToSingleShot(context)
--     else ---- and modify min aim level if it has
--         min_aim = min_aim + 1
--     end
--     -------

--     local num_attacks = Min((ap - stance_cost - rotation_cost) / cost, context.max_attacks)
--     local should_max_aim = ShouldMaxAim(context)

--     if (context.force_max_aim or should_max_aim) and has_stance_ap then --- Only Aim if can enter stance
--         num_attacks = ------ stance_cost added
--         Min((ap - stance_cost - rotation_cost) /
--                 (cost + aim_cost * (max_aim - min_aim) +
--                     (recoil_aim_cost * Min(3, (max_aim - min_aim)))), context.max_attacks)

--         -- if num_attacks < 1 then
--         -- RATOAI_TryDegradeToSingleShot(context)
--         -- end

--         -- num_attacks = (not can_bolt) and Max(1, num_attacks) or num_attacks
--         ------
--     end

--     ------ Stance Cost addition
--     local remaining = ap - (num_attacks * cost) - stance_cost - rotation_cost
--     ------

--     local aims = {}

--     ------ Debug
--     if debug then
--         print("----AI calc attacks and aim ----")
--         print("min aim = ", min_aim)
--         print("has_stance =", has_stance)
--         print("not moved = ", not_moved)
--         print("base cost = ", cost)
--         print("stance cost = ", stance_cost)
--         print("rotation_cost = ", rotation_cost)
--         print("cycling cost = ", bolting_cost, not is_unbolted)
--         -- print("recoil_aim_cost = ", recoil_aim_cost)
--         print("total_stance_cost = ", total_stance_cost)
--         print("has_stance_ap = ", has_stance_ap)
--         print("baseap = ", ap)
--         print("free_move_ap = ", free_move_ap)
--         print("atts = ", num_attacks)
--         print("remaining ap = ", remaining)
--         print("current target = ", context.current_target.session_id)
--     end
--     ------

--     ------ Min aim fix
--     for i = 1, num_attacks do
--         aims[i] = min_aim
--     end
--     ------

--     --
--     if has_stance_ap then --- Only Aim if can enter stance
--         --
--         local attack_idx = 1
--         while remaining > aim_cost do
--             local aim = (aims[attack_idx] or min_aim) + 1
--             ----
--             if aim > max_aim then -- context.weapon.MaxAimActions then 
--                 ---- 
--                 break
--             end
--             aims[attack_idx] = aim
--             attack_idx = attack_idx + 1
--             if attack_idx > num_attacks then
--                 attack_idx = 1
--             end
--             remaining = remaining - aim_cost

--             -------- Persistant recoil aim cost increase
--             remaining = aim <= 3 and remaining - recoil_aim_cost or remaining
--         end
--         --
--     end
--     --

--     ------ Debug
--     if debug then
--         print("AI atks and aim = ", num_attacks, aims)
--         print("-----------------------------------")
--         print(HasPerk(unit, "shooting_stance"))
--     end
--     ------

--     return num_attacks, aims
-- end
