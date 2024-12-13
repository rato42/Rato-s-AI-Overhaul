function AutoFire_CustomScoring(self, context)

    local weight, disable, priority = self.Weight, self.Priority, false

    local action = CombatActions[self.action_id]
    local unit = context.unit
    local dist, target, dest_cth, dest_recoil, attacker_pos, ratio, score_mod
    local upos = context.ai_destination
    ----------------- HoldPosition behavior wont have ai_destination for some reason

    if upos then
        dest_cth = context.dest_cth and context.dest_cth[upos]
        dest_recoil = context.dest_target_recoil_cth and context.dest_target_recoil_cth[upos]
        local ux, uy, uz, ustance_idx = stance_pos_unpack(upos)
        attacker_pos = point(ux, uy, uz)
        target = context.dest_target[upos]
        if target then
            dist = attacker_pos:Dist(target:GetPos())
        end
    end

    if target and unit:IsPointBlankRange(target) then
        priority = true
    elseif dest_cth and dest_recoil then
        ---- revisar esses calculos, feito durante privacao de sono kkkkk
        ratio = MulDivRound(dest_cth + dest_recoil, 100, dest_cth) -- dest_cth / (dest_cth + dest_recoil)
        score_mod = 100 - (100 - ratio)
        weight = MulDivRound(weight, score_mod, 100)
    end

    -- ic(priority, ratio, dest_cth, dest_recoil, score_mod)
    return Max(0, weight), weight < 0 and false or disable, priority
end

function MobileAttack_CustomScoring(self, context)

    local weight, disable, priority = self.Weight, self.Priority, false

    local action = CombatActions[self.action_id]
    local unit = context.unit
    local dist, target, dest_cth, dest_recoil, attacker_pos, ratio, score_mod
    local upos = context.ai_destination
    ----------------- HoldPosition behavior wont have ai_destination for some reason

    if upos then
        dest_cth = context.dest_cth and context.dest_cth[upos]
        dest_recoil = context.dest_target_recoil_cth and context.dest_target_recoil_cth[upos]
        local ux, uy, uz, ustance_idx = stance_pos_unpack(upos)
        attacker_pos = point(ux, uy, uz)
        -- ic(attacker_pos, unit:GetPos())
        -- ic(attacker_pos == unit:GetPos())
        -- DbgAddCircle(attacker_pos, const.SlabSizeX / 2, const.clrRed)
        target = context.dest_target[upos]
        if target then
            dist = attacker_pos:Dist(target:GetPos())
        end
    end

    if target and unit:IsPointBlankRange(target) then
        priority = true
    elseif dist and target and attacker_pos then

        -- local use, snap_penal = snap_shot_cth_mod:CalcValue(unit, target, nil, action,
        --                                                     unit:GetActiveWeapons(), nil, nil,
        --                                                     1, false, attacker_pos,
        --                                                     target:GetPos())

        local mul = GetHipfirePenal(unit:GetActiveWeapons(), unit, action, false, 1)
        local snap_penal = MulDivRound(dist, const.Combat.SnapshotMaxPenalty,
                                       const.Combat.Snapshot_MaxDistforPenalty * const.SlabSizeX)
        -- ic(snap_penal, mul)
        ratio = MulDivRound(dest_cth + const.Combat.Snapshot_BasePenalty + snap_penal * mul, 100,
                            dest_cth)
        score_mod = 100 - (100 - ratio)
        weight = MulDivRound(weight, score_mod, 100)
    end
    -- ic(weight, priority, ratio, dest_cth, dest_recoil, score_mod)
    return Max(0, weight), weight < 0 and false or disable, priority
end
