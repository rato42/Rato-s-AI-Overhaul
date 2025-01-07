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
        print("----------", context.unit.session_id, " should max aim bcause", target.session_id,
              "is at ", dist / const.SlabSizeX)
        return true
    end
    return false
end
