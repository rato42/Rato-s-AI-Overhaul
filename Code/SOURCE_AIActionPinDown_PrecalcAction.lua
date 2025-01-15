function AIActionPinDown:PrecalcAction(context, action_state)
    if IsKindOf(context.weapon, "Firearm") then
        -- Added self.AttackTargeting
        local args, has_ap = AIGetAttackArgs(context, CombatActions.PinDown, self.AttackTargeting,
                                             "None")

        action_state.args = args
        action_state.has_ap = has_ap
    end
end
