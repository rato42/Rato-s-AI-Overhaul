function RATOAI_AIEndTurn(unit)

    if unit:HasStatusEffect("shooting_stance") or unit:HasPreparedAttack() then
        return
    end

    if unit.species == "Human" and unit.stance ~= "Prone" then
        local cover_high, cover_low = GetCoverTypes(unit)

        if not cover_high and not cover_low then
            ---------------------
            local prone_AP = unit.stance == "Crouch" and 1000 or 2000
            if unit.species == "Human" and unit.stance ~= "Prone" then
                AIPlayCombatAction("StanceProne", unit, prone_AP)
            end
            --------------------

        end
    end
end

-- function OnMsg.TurnEnded
