function AISelectAction(context, actions, base_weight, dbg_available_actions)
    local available = {}
    local weight = base_weight or 0
    -- bp()    context.action_states = context.action_states or {}

    for _, action in ipairs(actions) do
        context.action_states[action] = {}
        local weight_mod, disable, priority = AIGetBias(action.BiasId, context.unit)
        disable = disable or context.disable_actions[action.BiasId or false]
        if not disable then
            action:PrecalcAction(context, context.action_states[action])
            if action:IsAvailable(context, context.action_states[action]) then
                local action_weight = MulDivRound(action.Weight, weight_mod, 100)
                priority = priority or action.Priority
                if dbg_available_actions then
                    table.insert(dbg_available_actions,
                                 {action = action, weight = action_weight, priority = priority})
                end
                if priority then
                    return action
                end
                available[#available + 1] = action
                available[available] = action_weight
                weight = weight + action_weight
            elseif dbg_available_actions then
                table.insert(dbg_available_actions, {action = action, weight = false})
            end
        end
    end

    if weight > 0 then
        local roll = InteractionRand(weight, "AISignatureAction", context.unit)
        for _, action in ipairs(available) do
            local w = available[action]
            if roll <= weight then
                return action
            end
            roll = roll - weight
        end
    end

    return available[#available]
end

function AIGetBias(id, unit)

    local weight_mod, disable, priority = 100, false, false

    if id and id ~= "" then
        local mods = g_AIBiases[id] or empty_table
        if mods[unit] then
            weight_mod = weight_mod + mods[unit].total
            disable = disable or mods[unit].disable
            priority = priority or mods[unit].priority
        end
        if mods[unit.team] then
            weight_mod = weight_mod + mods[unit.team].total
            disable = disable or mods[unit.team].disable
            priority = priority or mods[unit.team].priority
        end
    end

    disable = disable or (weight_mod <= 0)
    return weight_mod, disable, priority
end

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
    context.choose_actions = {{action = false, weight = weight, priority = false}}, AIUpdateBiases()
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

