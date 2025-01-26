local hit_modifiers = Presets["ChanceToHitModifier"]["Default"]

local function GetDestArgs(self, context)

    local unit = context.unit
    context = Update_AIPrecalcDamageScore(unit) or context

    local action = IsKindOf(self, "AIActionPinDown") and CombatActions["PinDown"] or
                       CombatActions[self.action_id]
    local dist, target, dest_cth, dest_recoil, attacker_pos
    local upos = context.ai_destination

    if not upos then ---- HoldPosition Behavior
        local packed_pos = GetPackedPosAndStance(unit)
        if packed_pos and context.dest_cth and context.dest_cth[packed_pos] then
            upos = packed_pos
        end
    end

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

    return upos, unit, action, dist, target, dest_cth, dest_recoil, attacker_pos
end

function AutoFire_CustomScoring(self, context)

    local weight, disable, priority = self.Weight, false, self.Priority

    local upos, unit, action, dist, target, dest_cth, dest_recoil, attacker_pos = GetDestArgs(self,
                                                                                              context)
    local ratio, score_mod
    if target and unit:IsPointBlankRange(target) then
        priority = true
    elseif dest_cth and dest_recoil then
        ---- revisar esses calculos, feito durante privacao de sono kkkkk
        ratio = MulDivRound(dest_cth + dest_recoil, 100, dest_cth) -- dest_cth / (dest_cth + dest_recoil)
        score_mod = 100 - (100 - ratio)
        weight = MulDivRound(weight, score_mod, 100)
    end

    -- ic(priority, ratio, dest_cth, dest_recoil, score_mod)
    return Max(0, weight), weight < 0 and true or disable, priority
end

function MobileAttack_CustomScoring(self, context)

    local weight, disable, priority = self.Weight, false, self.Priority

    local upos, unit, action, dist, target, dest_cth, dest_recoil, attacker_pos = GetDestArgs(self,
                                                                                              context)

    local ratio, score_mod, use, snap_penal
    if target and unit:IsPointBlankRange(target) then
        priority = true
    elseif dist and target and attacker_pos then

        -- local use, snap_penal = snap_shot_cth_mod:CalcValue(unit, target, nil, action,
        --                                                     unit:GetActiveWeapons(), nil, nil,
        --                                                     1, false, attacker_pos,
        --                                                     target:GetPos())

        --[[local mul = GetWeaponHipfireOrSnapshotMul(unit:GetActiveWeapons(), unit, action, false, 1)
        local snap_penal = MulDivRound(dist, const.Combat.SnapshotMaxPenalty,
                                       const.Combat.Snapshot_MaxDistforPenalty * const.SlabSizeX)
        -- ic(snap_penal, mul)
        ratio = MulDivRound(dest_cth + const.Combat.Snapshot_BasePenalty + snap_penal * mul, 100,
                            dest_cth)]]
        use, snap_penal = hit_modifiers.HipshotPenalty:CalcValue(unit, target, nil, action,
                                                                 unit:GetActiveWeapons(), nil, nil,
                                                                 1, false, attacker_pos,
                                                                 target:GetPos())
        ratio = MulDivRound(dest_cth + snap_penal, 100, dest_cth)
        score_mod = 100 - (100 - ratio)
        weight = MulDivRound(weight, score_mod, 100)
    end
    -- ic(weight, snap_penal, ratio, dest_cth, dest_recoil, score_mod)
    return Max(0, weight), weight < 0 and true or disable, priority
end

function SingleShotTargeted_CustomScoring(self, context)

    local weight, disable, priority = self.Weight, false, self.Priority

    local upos, unit, action, dist, target, dest_cth, dest_recoil, attacker_pos = GetDestArgs(self,
                                                                                              context)

    local leg_mul = 115

    local body_part = "Head"

    if IsKindOf(self, "AIActionPinDown") then
        body_part = self.AttackTargeting
    else
        for part, boleano in pairs(self.AttackTargeting) do
            if boleano then
                body_part = part
                break
            end
        end
    end

    local leg_shot = body_part == "Legs"

    local ratio, score_mod
    if upos and target then
        local use, targeted_penal = hit_modifiers.TargetedShot:CalcValue(unit, target,
                                                                         Presets.TargetBodyPart
                                                                             .Default[body_part],
                                                                         action,
                                                                         unit:GetActiveWeapons(),
                                                                         nil, nil, 3, false,
                                                                         attacker_pos,
                                                                         target:GetPos())
        ratio = MulDivRound(dest_cth + targeted_penal, 100, dest_cth)
        score_mod = 100 - (100 - ratio)
        weight = MulDivRound(weight, score_mod, 100)
        -- ic(targeted_penal, dest_cth, score_mod)
    end

    if target and leg_shot then
        local target_weapon = target:GetActiveWeapons()
        if target_weapon and
            IsKindOfClasses(target_weapon, "SubmachineGun", "MeleeWeapon", "Pistol", "Revolver") then
            weight = MulDivRound(weight, leg_mul, 100)
        end
    end

    return Max(0, weight), weight < 0 and true or disable, priority
end

function Overwatch_CustomScoring(self, context)
    local weight, disable, priority = self.Weight, false, self.Priority

    local upos, unit, action, dist, target, dest_cth, dest_recoil, attacker_pos = GetDestArgs(self,
                                                                                              context)

    if not upos then
        return weight, disable, priority
    end

    local under_timed_multiplier = 125
    local sniper_mul = 60
    ---------
    local interrupt_cth_mod = 0
    local ow_cth = 0
    local use
    if target and attacker_pos then
        use, ow_cth = hit_modifiers["OpportunityAttack"]:CalcValue(unit, target, false, action,
                                                                   context.weapon, nil, nil, 1,
                                                                   true, attacker_pos,
                                                                   target:GetPos())
    end

    interrupt_cth_mod = interrupt_cth_mod + ow_cth
    ---------

    ---------
    local snap_penal = 0
    if unit and target then
        --[[local mul = GetWeaponHipfireOrSnapshotMul(unit:GetActiveWeapons(), unit, action, false, 1)

        --- Idea 1: calc a arbitrary snap penal using local effective_range = context.EffectiveRange * const.SlabSizeX
        --- Idea 2: calc snap penal getting the closer visible target.

        local effective_range = context.EffectiveRange * const.SlabSizeX
        local snap_penal = MulDivRound(effective_range, const.Combat.SnapshotMaxPenalty,
                                       const.Combat.Snapshot_MaxDistforPenalty * const.SlabSizeX) *
                               mul

        snap_penal = use and snap_penal + ow_cth]]
        use, snap_penal = hit_modifiers.HipshotPenalty:CalcValue(unit, target, nil, action,
                                                                 unit:GetActiveWeapons(), nil, nil,
                                                                 1, false, attacker_pos,
                                                                 target:GetPos())
    end

    interrupt_cth_mod = interrupt_cth_mod + snap_penal
    ---------

    ---------
    local cover_penal = 0
    if unit and target then -- TODO: Make a special ratio for the cover. The more cover/cth ratio, the more chances to use overwatch
        use, cover_penal = hit_modifiers.RangeAttackTargetStanceCover:CalcValue(unit, target, nil,
                                                                                action,
                                                                                unit:GetActiveWeapons(),
                                                                                nil, nil, 1, false,
                                                                                attacker_pos,
                                                                                target:GetPos())
    end

    interrupt_cth_mod = interrupt_cth_mod + (cover_penal * -1)

    ---------
    --[[if attacker_pos then
        local cover = GetCoversAt(attacker_pos)
        interrupt_cth_mod = not cover and MulDivRound(interrupt_cth_mod, 50, 100) or
                                interrupt_cth_mod
    end]]
    ---------

    ---------
    local ratio, score_mod
    if dest_cth then
        ratio = MulDivRound(dest_cth + interrupt_cth_mod, 100, dest_cth)
        score_mod = 100 - (100 - ratio)

        weight = MulDivRound(weight, score_mod, 100)
    end
    ---------

    if target and (target:IsUnderTimedTrap() or target:IsUnderBombard()) then
        weight = MulDivRound(weight, under_timed_multiplier, 100)
    end

    if context.unit and (context.unit.role or '') == "Marksman" then
        weight = MulDivRound(weight, sniper_mul, 100)
    end

    -- ic(snap_penal, ow_cth, interrupt_cth_mod, weight, cover_penal)
    return Max(0, weight), weight < 0 and true or disable, priority
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Pindown_CustomScoring(self, context)
    local weight, disable, priority = self.Weight, false, self.Priority
    if true then
        return weight, disable, priority
    end

    local upos, unit, action, dist, target, dest_cth, dest_recoil, attacker_pos = GetDestArgs(self,
                                                                                              context)

    if not upos then
        return weight, disable, priority
    end
    -------------------------------------------------------
    if self.AttackTargeting ~= "Torso" then
        weight = SingleShotTargeted_CustomScoring(self, context)
    end
    -------------------------------------------------------

    local _, max_aim = unit:GetBaseAimLevelRange(action, target) or 0, 3
    local extra_aim = Max(0, max_aim - 3)
    local extra_aim_bonus_mul = (extra_aim * 12) + 100
    -----------

    local pindown_score = 0
    ---------
    local cover_penal = 0
    local use, cover_type
    if unit and target then -- TODO: Make a special ratio for the cover. The more cover/cth ratio, the more chances to use overwatch
        use, cover_penal, cover_type = hit_modifiers.RangeAttackTargetStanceCover:CalcValue(unit,
                                                                                            target,
                                                                                            nil,
                                                                                            context.default_attack,
                                                                                            unit:GetActiveWeapons(),
                                                                                            nil,
                                                                                            nil, 1,
                                                                                            false,
                                                                                            attacker_pos,
                                                                                            target:GetPos())
    end

    if use and (cover_type or "") == "Cover" then
        pindown_score = pindown_score + (cover_penal * -1)
    end

    local ratio, score_mod
    if dest_cth then --------- revisa essass pora kkkk
        ratio = MulDivRound(dest_cth + pindown_score, 100, dest_cth)
        score_mod = 100 - (100 - ratio)

        weight = MulDivRound(weight, score_mod, 100)
    end

    -----------------
    if target and IsKindOf(target, "Unit") then
        if target:HasStatusEffect("Slowed") then
            weight = MulDivRound(weight, 120, 100)
        end
        if target:IsThreatened(nil, 'overwatch') or target:IsThreatened(nil, "melee") then
            weight = MulDivRound(weight, 120, 100)
        end
    end
    -----------------

    weight = MulDivRound(weight, extra_aim_bonus_mul, 100)

    return Max(0, weight), weight < 0 and true or disable, priority
end
