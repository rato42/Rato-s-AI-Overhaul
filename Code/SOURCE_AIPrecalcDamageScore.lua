-- local number_of_precalcs = {}
-- function ins_n()
--     Inspect(number_of_precalcs)
-- end
-- function clr_n()
--     number_of_precalcs = {}
-- end
function AIPrecalcDamageScore(context, destinations, preferred_target, debug_data)
    local unit = context.unit

    local weapon = context.weapon
    local action = CombatActions[context.override_attack_id or false] or context.default_attack
    local archetype = context.archetype
    local behavior = context.behavior

    if not weapon or context.reposition or unit:HasStatusEffect("Burning") then
        return
    end
    if not destinations and context.damage_score_precalced then
        return
    end

    local action_targets = action:GetTargets({unit})
    local targets = table.ifilter(action_targets, function(idx, target)
        return unit:IsOnEnemySide(target)
    end)
    if #targets == 0 then
        return
    end
    context.damage_score_precalced = true

    -----
    -- if not number_of_precalcs[unit.session_id] then
    --     number_of_precalcs[unit.session_id] = 0
    -- end
    -- number_of_precalcs[unit.session_id] = number_of_precalcs[unit.session_id] + 1
    -- if number_of_precalcs[unit.session_id] > 1 then
    --     bp()
    -- end
    ----

    local target_score_mod = {}
    local tsr = archetype.TargetScoreRandomization
    for i, target in ipairs(targets) do
        target_score_mod[i] = 100 + ((tsr > 0) and unit:RandRange(-tsr, tsr) or 0)
    end
    context.target_score_mod = target_score_mod

    local base_mod = unit[weapon.base_skill]
    local cost_ap = context.override_attack_cost or context.default_attack_cost

    local max_check_range, is_melee = AIGetWeaponCheckRange(unit, weapon, action)
    local is_heavy = IsKindOf(weapon, "HeavyWeapon")

    local hit_modifiers = Presets["ChanceToHitModifier"]["Default"]
    -- stance mod
    -- TODO: #64 check messing around with modCrouchBonus and modProneBonus
    local modCrouchBonus = 0
    local modProneBonus = 0
    -- if IsKindOf(weapon, "Firearm") then
    -- modCrouchBonus = hit_modifiers.AttackerStance:ResolveValue("CrouchBonus")
    -- modProneBonus = hit_modifiers.AttackerStance:ResolveValue("ProneBonus")
    local value = GetComponentEffectValue(weapon, "AccuracyBonusProne", "bonus_cth")
    if value then
        modProneBonus = modProneBonus + value
    end
    -- end
    -- ground difference mod
    local MinGroundDifference = hit_modifiers.GroundDifference:ResolveValue("RangeThreshold") *
                                    const.SlabSizeZ / 100
    local modHighGround = hit_modifiers.GroundDifference:ResolveValue("HighGround")
    local modLowGround = hit_modifiers.GroundDifference:ResolveValue("LowGround")
    -- cover
    local modCover = hit_modifiers.RangeAttackTargetStanceCover:ResolveValue("Cover")
    local modSameTarget = hit_modifiers.SameTarget:ResolveValue("Bonus")

    local target_policies = archetype.TargetingPolicies
    if behavior and #(behavior.TargetingPolicies or empty_table) > 0 then
        target_policies = behavior.TargetingPolicies
    end

    local dest_target = context.dest_target
    local dest_target_score = context.dest_target_score
    local dest_ap = context.dest_ap
    local aim_mod = Presets.ChanceToHitModifier.Default.Aim
    ---
    local pb_cth_mod = Presets.ChanceToHitModifier.Default.PointBlank
    local scope_cth_mod = Presets.ChanceToHitModifier.Default.ScopePenal
    ---
    local dest_cth = {}
    context.dest_cth = dest_cth
    local lof_params
    local attacker_pos = unit:GetPos()

    -- script-driven modifiers (based on groups)
    local target_modifiers
    for _, groupname in ipairs(unit.Groups) do
        local group_modifiers = gv_AITargetModifiers[groupname]
        for target_group, mod in pairs(group_modifiers) do
            target_modifiers = target_modifiers or {}
            target_modifiers[target_group] = (target_modifiers[target_group] or 0) + mod
            for _, obj in ipairs(Groups[target_group]) do
                if IsKindOf(obj, "Unit") and not table.find(targets, obj) then
                    table.insert(targets, obj) -- make sure the target is considired regardless if it's an enemy or not
                    table.insert(target_score_mod,
                                 100 + ((tsr > 0) and unit:RandRange(-tsr, tsr) or 0))
                end
            end
        end
    end

    if unit:HasStatusEffect("StationedMachineGun") or unit:HasStatusEffect("ManningEmplacement") then
        local ow_units = {unit}
        targets = table.ifilter(targets, function(idx, target)
            return target:IsThreatened(ow_units, "overwatch")
        end)
    end

    if not IsValidTarget(preferred_target) or
        (IsKindOf(preferred_target, "Unit") and preferred_target:IsIncapacitated() or
            not table.find(targets, preferred_target)) then
        preferred_target = nil
    end

    if weapon and not is_melee then
        lof_params = {
            obj = unit,
            action_id = action.id,
            weapon = weapon,
            step_pos = false,
            stance = false,
            range = max_check_range,
            prediction = true,
            output_collisions = true
        }
        if not destinations or #destinations > 1 then
            lof_params.target_spot_group = "Torso"
        end
    end
    --[[	local logdata = {}
	if destinations then
		table.insert(g_AIDamageScoreLog, logdata)
	end
	logdata.preferred_target = preferred_target and (IsKindOf(preferred_target, "Unit") and _InternalTranslate(preferred_target.Name or "") or preferred_target.class) or tostring(preferred_target)--]]
    destinations = destinations or context.destinations
    NetUpdateHash("AIPrecalcDamageScore", unit, hashParamTable(destinations),
                  hashParamTable(targets), preferred_target)

    for j, upos in ipairs(destinations) do
        local ux, uy, uz, ustance_idx = stance_pos_unpack(upos)
        local ustance = StancesList[ustance_idx]
        uz = uz or terrain.GetHeight(ux, uy)

        local ap = dest_ap[upos] or 0
        local best_target, best_cth
        local best_score = 0
        local potential_targets, target_score, target_cth = {}, {}, {}

        ------------------ Recoil storage -- Only best target goes to context
        local recoil_score = {}
        ------------------

        ------> refactor to follow dest_target_dist model			
        local target_covers = {}
        local target_los = {}
        context.dest_target_dist[upos] = {}
        ----

        ------------------ Debug
        local old_scores_dbg, old_cth_debug = {}, {}
        ------------------

        if weapon and ap >= cost_ap then
            local pos_mod = base_mod
            pos_mod = pos_mod +
                          (ustance_idx == 2 and modCrouchBonus or ustance_idx == 3 and modProneBonus or
                              0)

            local targets_attack_data
            if not is_melee then
                attacker_pos = point(ux, uy, uz)
                lof_params.step_pos = point_pack(ux, uy, uz)
                lof_params.stance = ustance
                targets_attack_data = GetLoFData(unit, targets, lof_params)
                ---- temporary
                context.attacker_pos = attacker_pos
                ----
            end

            for k, target in ipairs(targets) do
                local tpos = GetPackedPosAndStance(target)
                local dist = stance_pos_dist(upos, tpos)
                ---- temporary
                context.current_target = target
                ---

                ----
                context.dest_target_dist[upos][target] = dist
                ----

                ------ Recoil CTH Calculation 
                local recoil_cth = 0

                if IsKindOf(weapon, "Firearm") then
                    recoil_cth = get_recoil(unit, target, target:GetPos(), context.default_attack,
                                            weapon, nil,
                                            weapon:GetAutofireShots(context.default_attack), nil,
                                            nil, nil, nil, nil, attacker_pos)

                end

                recoil_score[target] = recoil_cth
                -------------

                if dist <= (max_check_range or dist) and
                    (is_melee or targets_attack_data[k] and not targets_attack_data[k].stuck) then

                    ------------ RATO AI precalc
                    local mod = 0

                    if CurrentModOptions.UseSimpleAttacksScoring then
                        ------ Old logic
                        mod, target_covers, target_los =
                            RATOAI_ScoreAttacks_Simple(mod, target, dist, upos, tpos, uz, k, dist,
                                                       ap, context, action, weapon,
                                                       targets_attack_data, target_covers,
                                                       target_los, attacker_pos)
                    else
                        mod, target_covers, target_los =
                            RATOAI_ScoreAttacksDetailed(mod, target, dist, upos, tpos, uz, k, ap,
                                                        context, action, weapon,
                                                        targets_attack_data, target_covers,
                                                        target_los, attacker_pos, recoil_cth)
                    end

                    if mod > const.AIShootAboveCTH then
                        -------------
                        mod = mod + pos_mod
                        -------------------------------------------------------------------------------------------
                        -- Vanilla
                        --------------------------------------- 
                        -- modify score by archetype-specific weight and (optional) targeting policies
                        mod = MulDivRound(mod, archetype.TargetBaseScore, 100)
                        for _, policy in ipairs(target_policies) do
                            local peval = policy:EvalTarget(unit, target)
                            mod = mod + MulDivRound(peval or 0, policy.Weight, 100)
                        end

                        if IsKindOf(target, "Unit") and
                            (target:IsDowned() or target:IsGettingDowned()) then
                            mod = MulDivRound(mod, 5, 100)
                        end

                        local attack_data = targets_attack_data and targets_attack_data[k]
                        local ally_in_danger = attack_data and
                                                   (attack_data.best_ally_hits_count or 0) > 0

                        if action and action.AimType == "cone" then
                            ally_in_danger = ally_in_danger or
                                                 AIAllyInDanger(context.allies, context.ally_pos,
                                                                attacker_pos, target,
                                                                const.AIFriendlyFire_LOFConeNear,
                                                                const.AIFriendlyFire_LOFConeFar)
                        else
                            ally_in_danger = ally_in_danger or
                                                 AIAllyInDanger(context.allies, context.ally_pos,
                                                                attacker_pos, target,
                                                                const.AIFriendlyFire_LOFWidth,
                                                                const.AIFriendlyFire_LOFWidth)
                        end
                        if ally_in_danger then
                            mod = MulDivRound(mod, const.AIFriendlyFire_ScoreMod, 100)
                        end

                        mod = MulDivRound(mod, target_score_mod[k], 100)

                        -- apply group-based modifiers
                        if target_modifiers and IsKindOf(target, "Unit") then
                            local group_mod = 0
                            for _, groupname in ipairs(target.Groups) do
                                group_mod = group_mod + (target_modifiers[groupname] or 0)
                            end
                            if group_mod > 0 then
                                mod = MulDivRound(mod, group_mod, 100)
                            end
                        end

                        --[[table.insert(logdata, {
							name = IsKindOf(target, "Unit") and _InternalTranslate(target.Name or "") or target.class,
							score = mod
						})--]]

                        if mod > 0 and target == preferred_target then
                            best_target = target
                            best_score = mod
                            best_cth = base_mod
                            potential_targets = {}
                            break
                        end

                        ----------------- DEBUG
                        ------------

                        best_score = Max(best_score, mod)
                        target_cth[target] = base_mod
                        target_score[target] = mod

                        local threshold = MulDivRound(best_score or 0, const.AIDecisionThreshold,
                                                      100)
                        if mod >= threshold then
                            potential_targets[#potential_targets + 1] = target
                            for i = #potential_targets, 1, -1 do
                                local target = potential_targets[i]
                                local score = target_score[target]
                                if score < threshold then
                                    table.remove(potential_targets, i)
                                end
                            end
                            -- best_target, best_score, best_cth = target, mod, base_mod
                        end

                        ----- Clear Context from my additions
                        context.current_target = nil
                        context.attacker_pos = nil
                        -----
                    end
                end
            end
        end

        ------- looped all targets in this pos, store in the context
        context.dest_target_cover_score[upos] = target_covers
        context.dest_target_los[upos] = target_los
        -------

        if #potential_targets > 0 then
            local total = 0
            for _, target in ipairs(potential_targets) do
                local score = target_score[target]
                total = total + score
                if debug_data then
                    debug_data[target] = score
                end
            end
            local roll = InteractionRand(total, "AIDecision")
            for _, target in ipairs(potential_targets) do
                local score = target_score[target]
                if roll < score then
                    best_target = target
                    break
                end
                roll = roll - score
            end
            best_target = best_target or potential_targets[#potential_targets] or false
            best_score = target_score[best_target] or 0
            best_cth = target_cth[best_target] or 0

            --[[print("-------------------")
            ic(best_target.session_id)
            ic(best_score)
            ic(old_scores_dbg[best_target])
            ic(best_cth)
            ic(old_cth_debug[best_target])
            ic(recoil_score_dbg[best_target])
            print("-------------------")]]
        end

        --[[
		if destinations and IsKindOf(best_target, "Unit") then
			if best_target == preferred_target then
				printf("%s (%d) selected target (preferred): %s (score %d)", _InternalTranslate(unit.Name or ""), unit.handle, _InternalTranslate(best_target.Name or ""), best_score)
			else
				printf("%s (%d) selected target: %s (score %d)", _InternalTranslate(unit.Name or ""), unit.handle, _InternalTranslate(best_target.Name or ""), best_score)
				printf("  potential targets:")
				for _, target in ipairs(potential_targets) do
					printf("    %s (score %d)", _InternalTranslate(target.Name or ""), target_score[target])
				end
			end
		end--]]

        -- logdata.chosen_target = best_target and (IsKindOf(best_target, "Unit") and _InternalTranslate(best_target.Name or "") or best_target.class) or tostring(best_target)

        ------------------------------
        context.dest_target_recoil_cth[upos] = recoil_score[best_target]
        ------------------------------

        dest_target_score[upos] = best_score ------ This defines DealDamage policy score
        dest_target[upos] = best_target
        dest_cth[upos] = best_cth

        ----Debug vectors
        -- local dux, duy, duz, dustance_idx = stance_pos_unpack(upos)
        -- local debug_score_pos = point(dux, duy, duz)

        -- if best_cth and best_cth > 0 and best_target then
        --     DbgAddText(best_cth, debug_score_pos)
        --     DbgAddVector(debug_score_pos, best_target:GetPos() - debug_score_pos)
        -- end
        -----
    end
end
