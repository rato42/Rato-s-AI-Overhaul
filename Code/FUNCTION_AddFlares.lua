function RATOAI_AddFlare(unit, check)
    if not CurrentModOptions.AddFlares then
        return
    end
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

function build_explosive_grenade_table(unit)
    local legion_thug = unit.Affiliation and
                            (unit.Affiliation == "Legion" or unit.Affiliation == "Thug")

    local EO_loaded = IsMod_loaded("RATONADE")

    local explosive_IEDs = {'PipeBomb'}
    local EO_IEDS = {"TNTBolt_IED", "NailBomb_IED"}

    local explosive_nades = {'FragGrenade', 'HE_Grenade'}
    local EO_explosives = {"HE_Grenade_1"}

    if EO_loaded then
        for _, v in ipairs(EO_IEDS) do
            table.insert(explosive_IEDs, v)
        end

        for _, v in ipairs(EO_explosives) do
            table.insert(explosive_nades, v)
        end
    end

    --- 

    return (legion_thug and EO_loaded) and explosive_IEDs or explosive_nades
end

function temporary_add_grenade(unit)
    local role = unit.role or ''
    if R_IsAI(unit) and role == "Demolitions" then
        local amount = InteractionRandRange(1, 7)
        amount = amount - 2
        if amount > 0 then
            local flare = PlaceInventoryItem("HE_Grenade")
            flare.Amount = amount
            -- unit:TryEquip(unit.Inventory, "Handheld A", "FlareStick")
            -- unit:TryEquip(unit.Inventory, "Handheld B", "FlareStick")
            unit:TryEquip({flare}, "Handheld A", "HE_Grenade")
            unit:TryEquip({flare}, "Handheld B", "HE_Grenade")
            unit:AddItem("Inventory", flare)
        end
    end
end

function OnMsg.UnitEnterCombat(unit)
    -- temporary_add_grenade(unit)
    RATOAI_AddFlare(unit, true)
end
