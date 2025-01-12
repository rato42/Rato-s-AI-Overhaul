function get_ShouldUseGetCloserPositioningBehavior(unit, context, percentage_override,
                                                   absolute_override)
    local weapon = context.weapon or unit:GetActiveWeapons()

    if not weapon or not IsKindOf(weapon, "Firearm") then
        return false
    end

    local range
    if absolute_override then
        range = absolute_override * const.SlabSizeX
    else
        range = MulDivRound((context.ExtremeRange or 0) * const.SlabSizeX,
                            (percentage_override or 60), 100)
    end

    local att_pos = unit:GetPos()
    for enemy, pos in pairs(context.enemy_pos) do
        if not enemy:IsDowned() and context.enemy_visible[enemy] and IsValidPos(pos) and
            IsValidPos(att_pos) then
            local pos = IsValidZ(pos) and pos or pos:SetTerrainZ()
            att_pos = IsValidZ(att_pos) and att_pos or att_pos:SetTerrainZ()
            local dist = att_pos:Dist(pos)

            if dist <= range then
                return false
            end
        end
    end

    return true
end
