DefineClass.AIPrepareWeapon = {
    __parents = {"AIActionBasicAttack"},
    properties = {
        -- 	{ id = "enemy_score", name = "Enemy Hit Score", editor = "number", default = 100, },
        -- 	{ id = "team_score", name = "Teammate Hit Score", editor = "number", default = -1000, },
        -- 	{ id = "self_score_mod", name = "Self Score Modifier", editor = "number", scale = "percent", default = -100, help = "Score will be modified with this value if the targeted zone includes the unit performing the attack" },
        -- 	{ id = "min_score", name = "Score Threshold", editor = "number", default = 200, help = "Action will not be taken if best score is lower than this", },
    },
    action_id = "R_PrepareWeapon",
    hidden = false
}

function AIPrepareWeapon:PrecalcAction(context, action_state)
    local unit = context.unit
    local dest = context.ai_destination or GetPackedPosAndStance(unit)
    local x, y, z = stance_pos_unpack(dest)
    local new_pos = point(x, y, z)
    local target = unit:GetClosestEnemy(new_pos) -- (context.dest_target or empty_table)[dest]

    -- local target_pts
    if not target then
        for _, enemy in ipairs(context.enemies) do
            if enemy.last_attack_pos then
                target = enemy.last_attack_pos
                break
                -- target_pts = target_pts or {}
                -- target_pts[#target_pts + 1] = enemy.last_attack_pos
            end
        end
    end

    --[[if not IsValidTarget(target) then
        return
    end]]
    if not target then
        return
    end

    local weapon = context.weapon or unit:GetActiveWeapons()
    local cost = weapon and (GetWeapon_StanceAP(unit, weapon) + Get_AimCost(unit)) or -1

    if cost >= 0 and unit:HasAP(cost) then
        action_state.args = {target = target}
        action_state.has_ap = true
    end
end

function AIPrepareWeapon:Execute(context, action_state)
    assert(action_state.args.target and action_state.has_ap)

    AIPlayCombatAction(self.action_id, context.unit, nil, action_state.args)
end
