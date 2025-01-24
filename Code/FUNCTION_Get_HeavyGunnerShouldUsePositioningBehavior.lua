function Get_HeavyGunnerShouldUsePositioningBehavior(behavior, unit, proto_context, debug_data)
    unit.ai_context = unit.ai_context or AICreateContext(unit, proto_context)

    local context = unit.ai_context
    context.action_states = context.action_states or {}

    if unit:HasStatusEffect("ManningEmplacement") or unit:HasStatusEffect("StationedMachineGun") then
        return false
    end

    local enemy, dist = unit:GetClosestEnemy()
    if enemy and (not enemy:IsDowned()) and dist <= const.Weapons.PointBlankRange * const.SlabSizeX then
        return false
    end

    local sigs = behavior.SignatureActions
    for i, action in ipairs(sigs) do
        if action.class == "AIActionMGSetup" then
            context.action_states[action] = {}
            action:PrecalcAction(context, context.action_states[action])
            if action:IsAvailable(context, context.action_states[action]) then
                -- print("MG Setup Available")
                return false
            end
            -- print("== MG Setup NOT Available")
            return true
        end
    end

    return false
end

---- Not used
--[[function getStandardBehaviorScore_HeavyGunner(behavior, unit, proto_context, debug_data) 
    unit.ai_context = unit.ai_context or AICreateContext(unit, proto_context)
    local dest, score = AIScoreReachableVoxels(unit.ai_context, behavior.EndTurnPolicies, 0)

    local context = unit.ai_context
    context.action_states = context.action_states or {}

    local sigs = behavior.SignatureActions
    for i, action in ipairs(sigs) do
        if action.class == "AIActionMGSetup" then
            context.action_states[action] = {}
            action:PrecalcAction(context, context.action_states[action])
            if action:IsAvailable(context, context.action_states[action]) then
                return behavior.Weight
            end
            return 0
        end
    end

    return behavior.Weight
end]]
