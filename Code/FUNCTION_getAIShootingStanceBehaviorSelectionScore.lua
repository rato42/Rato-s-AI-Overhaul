last_proto = {}
last_context = {}

function getAIShootingStanceBehaviorSelectionScore(unit, proto_context)
    last_proto = proto_context

    if unit:HasStatusEffect("ManningEmplacement") or unit:HasStatusEffect("StationedMachineGun") then
        return 0
    end

    if not unit:HasStatusEffect("shooting_stance") then
        return 0
    end

    if unit:IsUnderTimedTrap() or unit:IsUnderBombard() then
        return 0
    end

    ---- Parameters
    local angle_ap_threshold = 2 -- AP
    local closeness_threshold = 4 -- slab
    local distance_to_check_lack_of_cover = 20 -- slab
    local effective_range_mul = 1.5

    ----- Weights
    local weight_close_enemy = -50
    local weight_no_cover = -20
    local weight_enemy_in_cone = 35
    local weight_per_AP_stance = 10

    ----- Initialization
    local context = AICreateContext(unit, proto_context)
    local weapon = context.weapon or unit:GetActiveWeapons()
    local score = 100
    local no_enemy_in_range = true
    local att_pos = context.unit_pos or unit:GetPos()
    local prone_cover_CTH = Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover
    local cover_max_malus = prone_cover_CTH:ResolveValue("Cover")

    last_context = context

    ----- Stance AP score
    local wep_stance_ap = GetWeapon_StanceAP(unit, weapon) or 1000
    score = score + MulDivRound(wep_stance_ap, weight_per_AP_stance, const.Scale.AP)
    -----

    for enemy, pos in pairs(context.enemy_pos) do

        --- Can use enemy_visible_by_team as well
        ---- Beware the cover will not consider lack of line of sight, complete obstruction etc
        if not enemy:IsDowned() and context.enemy_visible[enemy] and IsValidPos(pos) and
            IsValidPos(att_pos) then
            local pos = IsValidZ(pos) and pos or pos:SetTerrainZ()
            att_pos = IsValidZ(att_pos) and att_pos or att_pos:SetTerrainZ()
            local dist = att_pos:Dist(pos)

            if dist <= closeness_threshold * const.SlabSizeX then
                score = score + weight_close_enemy
            end

            if dist <= distance_to_check_lack_of_cover * const.SlabSizeX then
                local enemy_weapon = enemy:GetActiveWeapons()
                if enemy_weapon and not enemy_weapon:IsKindOf("MeleeWeapon") then
                    local use, value = prone_cover_CTH:CalcValue(enemy, unit, false, nil,
                                                                 enemy_weapon, nil, nil, 0, false,
                                                                 pos, att_pos)
                    value = value or 0
                    if use then
                        local ratio = 100 - Clamp(MulDivRound(value, 100, cover_max_malus), 0, 100)
                        local add = MulDivRound(weight_no_cover, ratio, 100)
                        score = score + add
                        -- print("self cover", use, enemy.session_id, value, ratio, add)
                    end
                end
            end

            local effective_range = context.EffectiveRange * const.SlabSizeX * effective_range_mul
            if dist <= effective_range then
                local angle_ap = unit:GetShootingStanceAP(enemy, weapon, 1, false, "rotate")
                if angle_ap <= angle_ap_threshold * const.Scale.AP then
                    local use, value = prone_cover_CTH:CalcValue(unit, enemy, false,
                                                                 context.default_attack, weapon,
                                                                 nil, nil, 0, false, att_pos, pos)

                    value = value or 0
                    if use then
                        local ratio = 100 - Clamp(MulDivRound(value, 100, cover_max_malus), 0, 100)
                        local add = MulDivRound(weight_enemy_in_cone, ratio, 100)
                        score = score + add
                        -- print("enemy cover", use, enemy.session_id, value, ratio, add)
                    end
                    no_enemy_in_range = false
                end
            end
        end
    end

    score = no_enemy_in_range and 0 or score
    -- print(score)
    return score
end
