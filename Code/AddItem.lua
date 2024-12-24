function RATOAI_AddFlare(unit, check)
    if GameState.Night or GameState.Underground then
        if R_IsAI(unit) and (not check or not unit.RATOAI_flare_added) then
            local amount = InteractionRandRange(1, 7)
            amount = amount - 2
            if amount > 0 then
                local flare = PlaceInventoryItem("FlareStick")
                flare.Amount = amount
                -- unit:TryEquip(unit.Inventory, "Handheld A", "FlareStick")
                -- unit:TryEquip(unit.Inventory, "Handheld B", "FlareStick")
                unit:TryEquip({flare}, "Handheld A", "FlareStick")
                unit:TryEquip({flare}, "Handheld B", "FlareStick")
                unit:AddItem("Inventory", flare)
            end
            unit.RATOAI_flare_added = true
        end
    end
end

function OnMsg.UnitEnterCombat(unit)
    RATOAI_AddFlare(unit, true)
end
