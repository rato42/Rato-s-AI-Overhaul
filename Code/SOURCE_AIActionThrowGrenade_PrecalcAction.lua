function AIActionThrowGrenade:PrecalcAction(context, action_state)
    local action_id, grenade
    local actions = {"ThrowGrenadeA", "ThrowGrenadeB", "ThrowGrenadeC", "ThrowGrenadeD"}
    for _, id in ipairs(actions) do
        local caction = CombatActions[id]
        local cost = caction and caction:GetAPCost(context.unit) or -1
        if cost > 0 and context.unit:HasAP(cost) then
            action_id = id
            local weapon = caction:GetAttackWeapons(context.unit)
            local aoetype = weapon.aoeType or "none"

            ----
            local triggerType = weapon.TriggerType or "Contact"
            ----

            if IsKindOf(weapon, "Grenade") and self.AllowedAoeTypes[aoetype] and
                self.AllowedTriggerTypes[triggerType] then
                grenade = weapon
                break
            end
        end
    end

    if not action_id or not grenade then
        return
    end

    local max_range = Min(self.MaxDist, grenade:GetMaxAimRange(context.unit) * const.SlabSizeX)
    local blast_radius = grenade.AreaOfEffect * const.SlabSizeX
    local target_pts
    if self.TargetLastAttackPos then
        -- collect enemy last attack positions and pass them as target_pos array to AIPrecalcGrenadeZones
        for _, enemy in ipairs(context.enemies) do
            if enemy.last_attack_pos then
                target_pts = target_pts or {}
                target_pts[#target_pts + 1] = enemy.last_attack_pos
            end
        end
    end
    local zones = AIPrecalcGrenadeZones(context, action_id, self.MinDist, max_range, blast_radius,
                                        grenade.aoeType, target_pts)
    local zone, score = self:EvalZones(context, zones)
    if zone then
        action_state.action_id = action_id
        action_state.target_pos = zone.target_pos
        action_state.score = score
    end
end
