function ShouldMaxAim(context) ----- used in AICalcAttacksAndAim

    local target = context.current_target
    local attack_pos = context.attacker_pos
    if not target or not attack_pos or not IsKindOf(context.weapon, "Firearm") then
        return false
    end

    local dist = context.attacker_pos:Dist(target:GetPos())

    local er = context.EffectiveRange
    local pb = const.Weapons.PointBlankRange
    local to_check_range = pb
    if dist and (dist > to_check_range * const.SlabSizeX) then
        return true
    end
    return false
end

--[[function GetIdealAimLevels(context) ----- used in AICalcAttacksAndAim

    local target = context.current_target
    local attack_pos = context.attacker_pos
    if not target or not attack_pos or not IsKindOf(context.weapon, "Firearm") then
        return false
    end

    local dist = context.attacker_pos:Dist(target:GetPos())

    local er = context.EffectiveRange
    local pb = const.Weapons.PointBlankRange
    local to_check_range = pb

    if dist and (dist <= pb * const.SlabSizeX) then
        return 0
    elseif dist and (dist <= er * const.SlabSizeX) then
        return -- 1 (ou 2?)
    end
    return "Max Aim"
end]]
