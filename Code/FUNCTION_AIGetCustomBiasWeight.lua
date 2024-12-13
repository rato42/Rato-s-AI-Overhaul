--[[last_bias_context = {}

-- O ataque normal n é considerado no "roll"? Se tive ruma ação disponivel, será usada?

function AIGetCustomBiasWeight(id, unit, context, ai_action)

    local weight_mod, disable, priority = 100, false, false
    last_bias_context = context

    ----- if id == "Standard" we wont have ai_action, should get default attack from context
    local action = ai_action and CombatActions[ai_action.action_id]

    if not context or not action then
        return weight_mod, disable, priority
    end

    --------------------------

    local dist, target, dest_cth, dest_recoil, attacker_pos
    local action_id = action and action.id or ''
    local upos = context.ai_destination
    ----------------- HoldPosition behavior wont have ai_destination for some reason

    if upos then
        dest_cth = context.dest_cth and context.dest_cth[upos]
        dest_recoil = context.dest_target_recoil_cth and context.dest_target_recoil_cth[upos]
        local ux, uy, uz, ustance_idx = stance_pos_unpack(upos)
        attacker_pos = point(ux, uy, uz)
        -- ic(attacker_pos)
        target = context.dest_target[upos]
        local target_id = target and target.session_id or ''
        -- ic(target_id)
        DbgAddCircle(attacker_pos)
        if target then
            dist = (attacker_pos:Dist(target:GetPos()) or 0)
            -- ic(dist)
        end
    end

    ------------------------
    local snap_shot_cth_mod = Presets.ChanceToHitModifier.Default.HipshotPenalty
    local run_gun_cth_mod = Presets.ChanceToHitModifier.Default.RunAndGun

    local ratio, score_mod

    if action_id == "MobileShot" or action_id == "RunAndGun" then
        if target and unit:IsPointBlankRange(target) then
            priority = true
        elseif dist and target and attacker_pos then

            -- local use, snap_penal = snap_shot_cth_mod:CalcValue(unit, target, nil, action,
            --                                                     unit:GetActiveWeapons(), nil, nil,
            --                                                     1, false, attacker_pos,
            --                                                     target:GetPos())

            local mul = GetHipfirePenal(unit:GetActiveWeapons(), unit, action, false, 1)
            local snap_penal = MulDivRound(dist, const.Combat.SnapshotMaxPenalty, const.Combat
                                               .Snapshot_MaxDistforPenalty * const.SlabSizeX)
            -- ic(snap_penal, mul)
            ratio = MulDivRound(dest_cth + const.Combat.Snapshot_BasePenalty + snap_penal * mul *
                                    1.5, 100, dest_cth)
            score_mod = 100 - (ratio)
            weight_mod = weight_mod - score_mod
        end
    elseif action_id == "AutoFire" then
        if target and unit:IsPointBlankRange(target) then
            priority = true
        elseif dest_cth and dest_recoil then
            ---- revisar esses calculos, feito durante privacao de sono kkkkk

            ratio = MulDivRound(dest_cth + dest_recoil, 100, dest_cth) -- dest_cth / (dest_cth + dest_recoil)
            score_mod = 100 - (ratio)
            weight_mod = weight_mod - score_mod
        end
        ic(action_id, priority, ratio, dest_cth, dest_recoil, score_mod, weight_mod)
        -- disable = true
    end

    -- ic(action_id, priority, ratio, dest_cth, dest_recoil, score_mod, weight_mod)

    return weight_mod, disable, priority
end
]] 
