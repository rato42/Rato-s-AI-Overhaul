function AIGetSignatureActions(context, movement)
    local actions = {}
    -- if the behavior has any defined actions, pick from that list, otherwise revert to archetype's
    local actions_pool = context.behavior:GetSignatureActions(context)
    if not actions_pool or #actions_pool == 0 then
        actions_pool = context.archetype.SignatureActions
    end
    local unit = context.unit
    movement = movement or false
    for _, action in ipairs(actions_pool) do
        if (action.movement == movement) and action:MatchUnit(unit) then
            actions[#actions + 1] = action
        end
    end
    return actions
end

function AIChooseSignatureAction(context)
    local weight = context.archetype.BaseAttackWeight
    context.choose_actions = {{action = false, weight = weight, priority = false}}
    AIUpdateBiases()
    local sig_actions = AIGetSignatureActions(context)
    return AISelectAction(context, sig_actions, weight, context.choose_actions)
end

function AIActionSingleTargetShot:GetDefaultPropertyValue(prop, prop_meta)
    if prop == "NotificationText" then
        return self.default_notification_texts[self.action_id] or prop_meta.default
    end
    return AISignatureAction.GetDefaultPropertyValue(self, prop, prop_meta)
end

function AIActionSingleTargetShot:SetProperty(property, value)
    if property == "action_id" then
        local meta = self:GetPropertyMetadata("NotificationText")
        local cur_default_text = self.default_notification_texts[self.action_id] or meta.default
        local new_default_text = self.default_notification_texts[value] or meta.default
        if self.NotificationText == cur_default_text then
            self:SetProperty("NotificationText", new_default_text)
        end
    end
    return AISignatureAction.SetProperty(self, property, value)
end

function AIActionSingleTargetShot:GetEditorView()
    return string.format("Single Target Attack (%s)", self.action_id)
end

function AIActionSingleTargetShot:IsAvailable(context, action_state)
    if not action_state.has_ap or not action_state.has_ammo or not action_state.can_hit then
        return false
    end

    return IsValidTarget(action_state.args.target)
end

function AIActionSingleTargetShot:Execute(context, action_state)
    assert(action_state.has_ap)

    AIPlayCombatAction(self.action_id, context.unit, nil, action_state.args)
end

function AIActionSingleTargetShot:PrecalcAction(context, action_state)

    if IsKindOf(context.weapon, "Firearm") and not IsKindOf(context.weapon, "HeavyWeapon") then
        local action = CombatActions[self.action_id]

        local unit = context.unit
        local upos = GetPackedPosAndStance(unit)

        local target = context.dest_target[upos]

        local body_parts = AIGetAttackTargetingOptions(unit, context, target, action,
                                                       self.AttackTargeting)
        local targeting
        if body_parts and #body_parts > 0 then
            local pick = table.weighted_rand(body_parts, "chance",
                                             InteractionRand(1000000, "Combat"))
            targeting = pick and pick.id or nil
        end

        assert(action)
        local args, has_ap = AIGetAttackArgs(context, action, targeting or "Torso", self.Aiming)
        action_state.args = args
        action_state.has_ap = has_ap
        if has_ap and IsValidTarget(args.target) then
            local results = action:GetActionResults(context.unit, args)
            action_state.has_ammo = not not results.fired
            action_state.can_hit = results.chance_to_hit > 0
        end

        -- bp()
    end
end

function AIActionMobileShot:PrecalcAction(context, action_state)
    local unit = context.unit
    local action = CombatActions[self.action_id]

    -- only available to reach the already chosen dest
    if not context.ai_destination then
        return
    end

    -- check action state
    local state = action:GetUIState({unit})
    if state ~= "enabled" then
        return
    end

    -- check if the action would do something
    local x, y, z = stance_pos_unpack(context.ai_destination)
    local target_pos = point(x, y, z)
    local shot_voxels, shot_targets, shot_ch, canceling_reason =
        CalcMobileShotAttacks(unit, action, target_pos)
    shot_voxels = shot_voxels or empty_table
    shot_targets = shot_targets or empty_table

    if shot_voxels[1] and not canceling_reason[1] and IsValidTarget(shot_targets[1]) then
        action_state.args = {goto_pos = target_pos}
        local cost = action:GetAPCost(unit, action_state.args)
        action_state.has_ap = (cost >= 0) and unit:HasAP(cost)
    end
end

function AIActionMobileShot:IsAvailable(context, action_state)
    return action_state.has_ap
end

function CalcMobileShotAttacks(attacker, action, attack_pos, enemies, weapon)
    enemies = enemies or action:GetTargets({attacker})
    weapon = weapon or action:GetAttackWeapons(attacker)
    local aim_type = action.AimType
    if aim_type ~= "mobile" then
        return
    end
    local aim_params = action:GetAimParams(attacker, weapon)

    local combat_path = CombatPath:new()

    combat_path:RebuildPaths(attacker, aim_params.move_ap, nil, "Standing", nil, nil, action.id)
    local voxel_path = combat_path:GetCombatPathFromPos(attack_pos)
    if not voxel_path then
        DoneObject(combat_path)
        return
    end

    local shot_voxel_candidates = {}

    local path = {}
    for i, voxel in ipairs(voxel_path) do
        path[i] = point(point_unpack(voxel))
    end
    local path_voxels, voxel_dist, total_dist = CalcPathVoxels(path)
    local atk_voxel = point_pack(attack_pos)
    if path_voxels[1] ~= atk_voxel then
        table.insert(path_voxels, 1, atk_voxel)
    end

    shot_voxel_candidates[1] = {atk_voxel}
    local num_shots = aim_params.num_shots
    local step = #path_voxels / Max(1, num_shots)
    for i = 2, num_shots do
        local idx = 1 + step * (i - 1)
        table.insert(shot_voxel_candidates, 1,
                     {path_voxels[idx], path_voxels[idx - 1], path_voxels[idx + 1]})
    end

    -- process candidates
    local shot_voxels, targets, shot_cth, shot_canceling_reason = {}, {}, {}, {}

    for i, candidates in ipairs(shot_voxel_candidates) do
        shot_voxels[i] = false
        targets[i] = false
        for _, voxel in ipairs(candidates) do
            if not table.find_value(shot_voxels, voxel) then
                local pos = point(point_unpack(voxel))
                local target, cth, canceling_reason =
                    FindTargetFromPos(action.id, attacker, action, enemies, pos, weapon,
                                      i == #shot_voxel_candidates)
                if target then
                    shot_voxels[i] = voxel
                    targets[i] = target
                    shot_cth[i] = cth
                    shot_canceling_reason[i] = canceling_reason
                    break
                end
            end
        end
    end

    DoneObject(combat_path)

    return shot_voxels, targets, shot_cth, shot_canceling_reason
end
