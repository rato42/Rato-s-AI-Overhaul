function AIPlayAttacks(unit, context, dbg_action, force_or_skip_action)
    -- filter enemies because they might have been killed by a teammate
    if g_AIExecutionController then
        g_AIExecutionController:Log("Unit %s (%d) start attack sequence", unit.unitdatadef_id,
                                    unit.handle)
    end
    local enemies = context.enemies
    for i = #enemies, 1, -1 do
        if not IsValidTarget(enemies[i]) then
            table.remove(enemies, i)
        end
    end

    local remaining_free_ap = unit.free_move_ap
    unit:RemoveStatusEffect("FreeMove") -- lose any remaining free movement points, we're going to use actions now
    AIUpdateContext(context, unit)

    if g_AIExecutionController then
        g_AIExecutionController:Log("  Num enemies: %d", #enemies)
        g_AIExecutionController:Log("  Action Points: %d", unit.ActionPoints)
    end

    local dest = not force_or_skip_action and context.ai_destination or GetPackedPosAndStance(unit)

    -- recalc target to make sure we're firing at a valid target, but prefer the already picked target if there's one
    -- table.insert(g_AIDamageScoreLog, string.format("[%s] AIPlayAttacks (%s)", _InternalTranslate(unit.Name or ""), context.archetype.id))
    context.dest_ap[dest] = context.dest_ap[dest] or unit.ActionPoints
    AIPrecalcDamageScore(context, {dest},
                         context.target_locked or (context.dest_target or empty_table)[dest])

    -- archetype signature actions
    local signature_action
    if dbg_action then
        context.action_states = context.action_states or {}
        context.action_states[dbg_action] = {}
        dbg_action:PrecalcAction(context, context.action_states[dbg_action])
        if dbg_action:IsAvailable(context, context.action_states[dbg_action]) then
            signature_action = dbg_action
        elseif force_or_skip_action then
            table.insert(failed_actions, dbg_action.BiasId or dbg_action.class)
            return
        end
    end
    if not context.reposition and not unit:HasStatusEffect("Numbness") then
        signature_action = signature_action or AIChooseSignatureAction(context)
    end

    local default_attack = context.default_attack
    local default_attack_vr = "AIAttack"
    if default_attack and default_attack.FiringModeMember and default_attack.FiringModeMember ==
        "AttackShotgun" then
        default_attack_vr = "AIDoubleBarrel"
    end
    local voice_response = signature_action and (signature_action:GetVoiceResponse() or "") or
                               default_attack_vr
    if voice_response == "" then
        voice_response = nil
    end

    if signature_action then
        if g_AIExecutionController then
            g_AIExecutionController:Log("  Signature Action: %s", signature_action:GetEditorView())
        end
        signature_action:OnActivate(unit)
        -- printf("[signature] %s (%d)", _InternalTranslate(unit.Name or ""), unit.handle)
        if voice_response then
            context.action_states[signature_action].args =
                context.action_states[signature_action].args or {}
            context.action_states[signature_action].args.voiceResponse = voice_response
        end
        local status = signature_action:Execute(context, context.action_states[signature_action])
        context.ap_after_signature = unit.ActionPoints
        if status then -- support signature actions that want to restart or stop ai turn execution
            return status
        end
        AIReloadWeapons(unit)
        context.max_attacks = context.max_attacks - 1
    else
        if g_AIExecutionController then
            g_AIExecutionController:Log("  No Signature Action chosen")
        end
    end

    local target = (context.dest_target or empty_table)[dest]
    if signature_action and
        (not IsValidTarget(target) or (IsKindOf(target, "Unit") and target:IsIncapacitated())) then
        -- table.insert(g_AIDamageScoreLog, string.format("[%s] TargetChange (%s)", _InternalTranslate(unit.Name or ""), context.archetype.TargetChangePolicy))
        if context.archetype.TargetChangePolicy == "restart" then
            return "restart"
        end
        context.dest_ap[dest] = unit.ActionPoints
        context.target_locked = nil
        AIPrecalcDamageScore(context, {dest})
        target = context.dest_target[dest]
    end

    if IsValidTarget(target) then
        if g_AIExecutionController then
            g_AIExecutionController:Log("  Target: %s", IsKindOf(target, "Unit") and
                                            target.unitdatadef_id or target.class)
        end
        -- revert to basic attacks
        local attacks, aim = AICalcAttacksAndAim(context, unit.ActionPoints)
        if context.default_attack.id == "Bombard" and AICheckIndoors(dest) then
            attacks = 0
        end

        local args = {target = target, voiceResponse = voice_response}
        if attacks > 1 then
            unit:SequentialActionsStart()
        end
        if g_AIExecutionController then
            g_AIExecutionController:Log("  Executing %d attacks...", attacks)
        end
        local body_parts = AIGetAttackTargetingOptions(unit, context, target)

        for i = 1, attacks do
            args.aim = aim[i]
            args.target_spot_group = nil
            if body_parts and #body_parts > 0 then
                local pick = table.weighted_rand(body_parts, "chance",
                                                 InteractionRand(1000000, "Combat"))
                if pick then
                    args.target_spot_group = pick.id
                end
            end
            Sleep(0)
            local result = AIPlayCombatAction(context.default_attack.id, unit, nil, args)
            context.max_attack = context.max_attacks - 1
            if g_AIExecutionController then
                g_AIExecutionController:Log("  Attack %d result: %s", i, tostring(result))
            end
            if IsSetpiecePlaying() then
                unit:SequentialActionsEnd()
                return
            end
            AIReloadWeapons(unit)
            if not result or i == attacks or not IsValidTarget(unit) or context.max_attacks <= 0 then
                break
            end
            while IsKindOf(target, "Unit") and target:IsGettingDowned() do
                WaitMsg("UnitDowned", 20)
            end
            if not IsValidTarget(target) or (IsKindOf(target, "Unit") and target:IsIncapacitated()) then
                -- table.insert(g_AIDamageScoreLog, string.format("[%s] TargetChange (%s)", _InternalTranslate(unit.Name or ""), context.archetype.TargetChangePolicy))
                if context.archetype.TargetChangePolicy == "restart" then
                    unit:SequentialActionsEnd()
                    return "restart"
                end
                -- look for another target
                context.dest_ap[dest] = unit.ActionPoints
                context.target_locked = nil
                AIPrecalcDamageScore(context, {dest})
                target = context.dest_target[dest]
                if not IsValidTarget(target) then
                    break
                end
            end
            Sleep(0)
        end
        unit:SequentialActionsEnd()
    elseif unit:HasStatusEffect("StationedMachineGun") and CombatActions.MGPack:GetUIState({unit}) ==
        "enabled" then
        unit:SequentialActionsEnd()
        AIPlayCombatAction("MGPack", unit)
        return "restart"
    else
        if g_AIExecutionController then
            g_AIExecutionController:Log("  No target")
        end
    end
    unit:SequentialActionsEnd()

    while not unit:IsIdleCommand() do
        WaitMsg("Idle", 50)
    end

    if unit.ActionPoints + remaining_free_ap == context.start_ap and
        not unit:HasStatusEffect("ManningEmplacement") then
        -- no action was taken, use a fallback one
        -- if all fails, move toward optimal loc
        if context.closest_dest then
            unit:GainAP(remaining_free_ap)
            local dest = context.closest_dest
            local x, y, z, stance_idx = stance_pos_unpack(dest)
            local move_stance_idx = context.dest_combat_path[dest]
            local cpath = context.combat_paths[move_stance_idx]
            local pt = SnapToPassSlab(x, y, z)
            local path = pt and cpath and cpath:GetCombatPathFromPos(pt)
            if path then
                local goto_stance = StancesList[move_stance_idx]
                if goto_stance ~= unit.stance then
                    AIPlayChangeStance(unit, goto_stance, point(point_unpack(path[2])))
                end
                local goto_ap = unit.ActionPoints -- context.dest_ap[dest] --cpath.paths_ap[point_pack(x, y, z)] or 0
                context.ai_destination = path[1]
                AIPlayCombatAction("Move", unit, goto_ap, {
                    goto_pos = point(point_unpack(path[1])),
                    fallbackMove = true,
                    goto_stance = stance_idx
                })
            end
        end
        if unit:GetDist(context.unit_pos) < const.SlabSizeX / 2 then
            local revert = true
            if context.archetype.FallbackAction == "overwatch" then
                -- try to place overwatch
                revert = not AIPlaceFallbackOverwatch(unit, context)
            end
            if revert then
                -- we're stuck somewhere and unable to move or act, revert back to being Unaware (only if no sight of any enemies)
                local sight = false
                for _, enemy in ipairs(context.enemies) do
                    sight = sight or HasVisibilityTo(unit, enemy)
                end
                if not sight then
                    table.insert(g_UnawareQueue, unit)
                end
            end
        end
    end
end
