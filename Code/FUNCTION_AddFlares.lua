function RATOAI_AddFlare(unit, check)
    if not CurrentModOptions.AddFlares then
        return
    end
    if GameState.Night or GameState.Underground then
        if R_IsAI(unit) and (not check or not unit.RATOAI_flare_added) then
            local amount = InteractionRandRange(1, 8)
            amount = amount - 4
            if amount > 0 then
                local flare = PlaceInventoryItem("FlareStick")
                flare.Amount = amount
                -- unit:TryEquip(unit.Inventory, "Handheld A", "FlareStick")
                -- unit:TryEquip(unit.Inventory, "Handheld B", "FlareStick")
                unit:TryEquip({flare}, "Handheld A", "FlareStick")
                unit:TryEquip({flare}, "Handheld B", "FlareStick")
                unit:AddItem("Inventory", flare)
                ObjModified(unit)
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

---------TODO: Make a complete explosive distribution based on role

---- Recon - Flashbang 
---- Demolitions - 1 explosive, 1 aoe, 1 smoke or trap?
---- Soldiers - mostly smoke i guess  
---- Stormer -- 2 explosves? 

function RATOAI_ChangeExplosives(unit)
    local role = unit.role or ''

    -- if not (role == "Demolitions" or role == "Brute" or role == "Recon" ) then
    --    return
    -- end

    local explosive_nades = build_explosive_grenade_table(unit)

    local function check_and_change_grenade(slot, unit)
        local not_explosive = {}
        local explo = {}
        unit:ForEachItemInSlot(slot, function(item)
            if IsKindOf(item, 'ThrowableTrapItem') then
                local substance = g_Classes[item.ExplosiveType]
                if substance then
                    if substance.BaseDamage <= 0 then
                        table.insert(not_explosive, item)
                    else
                        table.insert(explo, item)
                    end
                end
            elseif IsKindOf(item, 'Grenade') then
                if item.BaseDamage <= 0 then
                    table.insert(not_explosive, item)
                else
                    table.insert(explo, item)
                end
            end
        end)

        local min_explosive_grenades = 1

        if role == "Demolitions" then
            min_explosive_grenades = 2
        elseif role == "Brute" then
            min_explosive_grenades = Max(2, Max(#explo, #not_explosive))
        end

        local number_of_explosives = #explo
        while number_of_explosives < min_explosive_grenades do
            local amount = 3

            if #not_explosive > 0 then
                local rand_ind = InteractionRandRange(1, #not_explosive)
                local item_to_remove = not_explosive[rand_ind]
                amount = item_to_remove.Amount
                unit:RemoveItem(slot, item_to_remove)
                table.remove(not_explosive, rand_ind)
            end

            local explosive = explosive_nades[InteractionRandRange(1, #explosive_nades)]

            local new_item = PlaceInventoryItem(explosive)
            new_item.Amount = amount

            unit:AddItem(slot, new_item)
            ObjModified(unit)
            number_of_explosives = number_of_explosives + 1
        end
    end

    check_and_change_grenade("Handheld A", unit)
    check_and_change_grenade("Handheld B", unit)

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
    RATOAI_ChangeExplosives(unit)
end
