function AIExecuteUnitBehavior(unit, force_or_skip_action)
    if not g_Combat or not IsValid(unit) or unit:IsDead() then
        return
    end

    if unit.ai_context.behavior then
        local status = unit.ai_context.behavior:Play(unit)
        if g_AIExecutionController then
            g_AIExecutionController:Log("  Behavior %s for unit %s (%d) returned '%s'",
                                        unit.ai_context.behavior:GetEditorView(),
                                        unit.unitdatadef_id, unit.handle, tostring(status))
        end

        if status then -- support behaviors that want to restart or stop the unit's ai
            return status
        end
    end

    -- recheck unit, they could be killed or despawned during Play
    if IsValid(unit) and not unit:IsDead() then
        -- use the rest of the ap (if any) in signature actions and basic attacks
        return AIPlayAttacks(unit, unit.ai_context, unit.ai_context.forced_signature_action,
                             force_or_skip_action) or AITakeCover(unit)
    end
end
