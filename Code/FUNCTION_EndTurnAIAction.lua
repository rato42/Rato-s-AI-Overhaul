function RATOAI_TryChangeStance(unit)

    if not g_Combat then
        return
    end

    if unit:HasPreparedAttack() then
        return
    end

    -- local enemies = GetAllEnemyUnits(unit)
    local stance_effect = unit:GetStatusEffect("shooting_stance")
    local aim_pos = stance_effect and stance_effect:ResolveValue("aim_pos")

    local angle
    if aim_pos then
        angle = CalcOrientation(unit:GetPos(), aim_pos)
    end

    local weapon = unit:GetActiveWeapons()
    if not weapon or not IsKindOf(weapon, "Firearm") then
        return
    end

    if unit.species == "Human" and unit.stance ~= "Prone" then
        local cover_high, cover_low = GetCoverTypes(unit)
        local ap = unit.ActionPoints
        if not cover_high and not cover_low then
            local prone_AP = unit.stance == "Crouch" and 1000 or 2000
            if ap >= prone_AP then
                unit:SetActionCommand("ChangeStance", "RATOAI_ChangeStance", prone_AP, "Prone")
                if angle then
                    unit:AnimatedRotation(angle)
                end
                return
            end
        end

        if unit.stance ~= "Crouch" then
            local crouch_ap = 1000
            if ap >= crouch_ap then
                unit:SetActionCommand("ChangeStance", "RATOAI_ChangeStance", crouch_ap, "Crouch")
                if angle then
                    unit:AnimatedRotation(angle)
                end
                return
            end
        end
    end
end

function OnMsg.TurnEnded(teamId)
    local t = g_Teams and g_Teams[teamId]
    if t and not (t.side == NetPlayerSide()) then
        for _, unit in ipairs(g_Units) do
            if R_IsAI(unit) then
                RATOAI_TryChangeStance(unit)
            end
        end
    end
end

