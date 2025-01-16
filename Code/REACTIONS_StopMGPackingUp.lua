function OnMsg.CombatActionEnd(unit)
    if unit.action_command == "MGSetup" and R_IsAI(unit) then
        unit.RATOAI_used_mg_setup_this_turn = true
    end
end

function OnMsg.TurnEnded()
    for _, unit in ipairs(g_Units) do
        unit.RATOAI_used_mg_setup_this_turn = nil
    end
end

--- Moved to GBO combat action GetAPCost

--[[local original_mgpack = Unit.MGPack
function Unit:MGPack()
    if self.RATOAI_used_mg_setup_this_turn then
        return
    end

    original_mgpack(self)
end]]

