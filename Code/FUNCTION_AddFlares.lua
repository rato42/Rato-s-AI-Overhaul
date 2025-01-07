function OnMsg.UnitEnterCombat(unit)
    RATOAI_ChangeMarksmanToHandGun(unit)
    RATOAI_UpdateUnitEquipedGrenades(unit)
    -- RATOAI_AddFlare(unit, true)
    -- RATOAI_ChangeExplosives(unit)
end

function OnMsg.ModsReloaded()
    RATOAI_BuildGrenadeTable()
end

-----TODO: maybe remove handguns/melee from those guys that dont really use it

------TODO: Flash specific action. Target overwatchers

function RATOAI_AddFlare(unit, check)
    if not CurrentModOptions.AddFlares then
        return
    end
    if GameState.Night or GameState.Underground then
        if R_IsAI(unit) and (not check or not unit.RATOAI_flare_added) then
            local amount = InteractionRandRange(1, 8) - 4
            if amount > 0 then
                local flare = PlaceInventoryItem("FlareStick")
                flare.Amount = amount
                -- unit:TryEquip(unit.Inventory, "Handheld A", "FlareStick")
                -- unit:TryEquip(unit.Inventory, "Handheld B", "FlareStick")
                local can_in_A = unit:TryEquip({flare}, "Handheld A", "FlareStick")
                if not can_in_A then
                    unit:TryEquip({flare}, "Handheld B", "FlareStick")
                end
                -- unit:AddItem("Inventory", flare)
                ObjModified(unit)
            end
            unit.RATOAI_flare_added = true
        end
    end
end

local function build_explosive_grenade_table(unit)
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

function RATOAI_ChangeExplosives(unit)
    local role = unit.role or ''

    -- if not (role == "Demolitions" or role == "Brute" or role == "Recon" ) then
    --    return
    -- end

    local explosive_nades = build_explosive_grenade_table(unit)

    local function check_and_change_grenade(slot, unit, data)
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

        --[[ if role == "Demolitions" then
            min_explosive_grenades = 2
        elseif role == "Brute" then
            min_explosive_grenades = Max(2, Max(#explo, #not_explosive))
        end]]

        data.current_explosives = data.current_explosives + #explo

        local number_of_explosives = #explo
        while number_of_explosives < data.min_explosive_grenades do
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
            data.current_explosives = data.current_explosives + 1
        end

        return data
    end

    local data = {min_explosive_grenades = 3, current_explosives = 0}

    data = check_and_change_grenade("Handheld A", unit, data)
    data = check_and_change_grenade("Handheld B", unit, data)

end

function RATOAI_ChangeMarksmanToHandGun(unit)
    if not R_IsAI(unit) then
        return
    end
    local role = unit.role or ''
    if not (role == "Marksman") then
        return
    end

    local function gethandgun_id(unit)
        local level = unit:GetLevel() or 1
        local map = {[8] = 'DesertEagle', [4] = 'Glock17', [0] = "Bereta92"}

        local gun = map[0]
        for lvl, g in pairs(map) do
            if level >= lvl then
                gun = g
                break
            end
        end
        return gun
    end

    local function check_and_change_handgun(slot, unit)
        unit:ForEachItemInSlot(slot, function(item)
            if IsKindOf(item, 'MeleeWeapon') then
                local weapon = PlaceInventoryItem(gethandgun_id(unit))
                unit:RemoveItem(slot, item)
                unit:AddItem(slot, weapon)
                unit:ReloadWeapon(weapon, false, "delay fx", "ai")
                ObjModified(weapon)
                ObjModified(unit)
                unit:UpdateOutfit()
            end
        end)
    end
    check_and_change_handgun("Handheld A", unit)
    check_and_change_handgun("Handheld B", unit)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local grenade_immunity_list = {"ToxicGasGrenade"} ---- Will not be removed

function RATOAI_UpdateUnitEquipedGrenades(unit)
    if not R_IsAI(unit) then
        return
    end

    if not next(grenade_table) then
        RATOAI_BuildGrenadeTable()
    end

    local grenade_data = GetGrenadeRoleData(unit)
    local desired_grenades_num = {}
    for type, data in pairs(grenade_data) do
        local amount = InteractionRandRange(data[1], data[2])
        ic(type, amount)
        if amount > 0 then
            desired_grenades_num[type] = amount
        end
    end

    -- local equipped_nades = {}
    local slots = {"Handheld A", "Handheld B"}
    for _, slot in ipairs(slots) do
        unit:ForEachItemInSlot(slot, function(item)
            if IsKindOf(item, "MishapProperties") then
                for type, grenades in pairs(grenade_table) do
                    if table.find(grenades, item.class) then
                        local desired_num = desired_grenades_num[type]
                        if desired_num then
                            if item.Amount ~= desired_num then
                                item.Amount = desired_num
                            end
                            desired_grenades_num[type] = nil
                            --------------------------------------
                            --[[equipped_nades[type] = equipped_nades[type] or {}
                            table.insert(equipped_nades[type],
                                         {item = item, slot = slot, amount = item.Amount})]]
                            ------------------------------------------------
                            break
                        elseif not table.find(grenade_immunity_list, item.class) then
                            unit:RemoveItem(slot, item)
                        end
                    end
                end
            end
        end)
    end

    for type, num in pairs(desired_grenades_num) do
        local possible_types = grenade_table[type]
        local explo_id = possible_types[InteractionRandRange(1, #possible_types)]

        if IsMod_loaded("RATONADE") then
            local affiliation = unit.Affiliation or ""
            local islegion_thug = affiliation == "Legion" or affiliation == "Thugs"
            explo_id = islegion_thug and get_replacement_ied(unit, {class = explo_id}) or explo_id
        end

        local new_item = PlaceInventoryItem(explo_id)
        new_item.Amount = num

        local can_in_A = unit:TryEquip({new_item}, "Handheld A", explo_id)
        if not can_in_A then
            unit:TryEquip({new_item}, "Handheld B", explo_id)
        end
    end
    ObjModified(unit)
end

local function check_and_change_grenade(slot, unit, type)
    local type_to_check = {}
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

    --[[ if role == "Demolitions" then
		min_explosive_grenades = 2
	elseif role == "Brute" then
		min_explosive_grenades = Max(2, Max(#explo, #not_explosive))
	end]]

    data.current_explosives = data.current_explosives + #explo

    local number_of_explosives = #explo

    return data
end

function GetGrenadeRoleData(unit)

    if not unit then
        return false
    end

    local role = unit.role or ''

    -- @ explo
    -- @ timed
    -- @ proximity
    -- @ aoe
    -- @ flash
    -- @ smoke
    -- @ flare

    local map = {
        Marksman = {smoke = {0, 1}},
        Demolitions = {explo = {2, 3}, timed = {2, 4}, aoe = {0, 4}},
        Soldier = {explo = {0, 2}, smoke = {1, 2}},
        Recon = {flash = {1, 3}, smoke = {0, 2}},
        Stormer = {explo = {0, 2}, aoe = {1, 3}}
        -- Artillery = {},
    }

    local gren_data = map[role] or {}

    if CurrentModOptions.AddFlares and (GameState.Night or GameState.Underground) then
        local flare_carriers = {'Soldier', 'Recon', 'Stormer', 'Demolitions'}
        if table.find(flare_carriers, role) then
            gren_data.flare = {0, 3}
        end
    end

    -- if not gren_data then
    --     ic()
    --     print("RATOAI - ERROR - No gren_data found for GetGrenadeUpdateTable for unit_id: ",
    --           unit.session_id, " role:", role)
    -- end

    return gren_data
end

grenade_table = {}

function RATOAI_BuildGrenadeTable()
    local exclusion_list = {
        "Car", "FuelTank", "Moped", "PickupTruck", "PowerGenerator", "PowerGenerator_Military",
        "SteroidPunchGrenade", "ConcussiveGrenade_Mine", "ShapedCharge", "Super_HE_Grenade"
    }

    local function populate_gren_table(item)

        if table.find(exclusion_list, item.class) then
            return
        end

        if IsKindOf(item, "FlareStick") then
            grenade_table['flare'] = grenade_table['flare'] or {}
            table.insert(grenade_table['flare'], item.class)
        elseif IsKindOfClasses(item, "ConcussiveGrenade", 'ConcussiveGrenade_IED') then
            grenade_table['flash'] = grenade_table['flash'] or {}
            table.insert(grenade_table['flash'], item.class)
        elseif IsKindOf(item, 'ThrowableTrapItem') then
            if item.TriggerType == "Timed" then
                grenade_table['timed'] = grenade_table['timed'] or {}
                table.insert(grenade_table['timed'], item.class)
            elseif item.TriggerType == "Proximity" then
                grenade_table['proximity'] = grenade_table['proximity'] or {}
                table.insert(grenade_table['proximity'], item.class)
            end
        elseif IsKindOf(item, 'Grenade') then
            local aoe_types = {"fire", "teargas"}
            if item.aoeType and table.find(aoe_types, item.aoeType) then
                grenade_table['aoe'] = grenade_table['aoe'] or {}
                table.insert(grenade_table['aoe'], item.class)
            elseif item.aoeType and item.aoeType == "smoke" then
                grenade_table['smoke'] = grenade_table['smoke'] or {}
                table.insert(grenade_table['smoke'], item.class)
            elseif item.BaseDamage > 0 then
                grenade_table['explo'] = grenade_table['explo'] or {}
                table.insert(grenade_table['explo'], item.class)
            end
        end
    end

    grenade_table = {}
    ForEachPreset("InventoryItemCompositeDef", function(p)
        local item = g_Classes[p.id]
        if item and IsKindOf(item, "MishapProperties") then
            populate_gren_table(item)
        end
    end)
end

---------TODO: Make a complete explosive distribution based on role
---------TODO: Similar function to swap melee for handgun for snipers

---- Recon - Flashbang 
---- Demolitions - 1 explosive, 1 aoe, 1 smoke or trap?
---- Soldiers - mostly smoke i guess  
---- Stormer -- 2 explosves?  --- Im not sure brutes should have explo.

---- Also, think about a disabling check if target is too close (because of EO overhaul and possible miss)

---- possible version 2
function POSSIBLEV2_RATOAI_ChangeExplosives(unit)
    local role = unit.role or ''

    -- if not (role == "Demolitions" or role == "Brute" or role == "Recon" ) then
    --    return
    -- end

    local explosive_nades = build_explosive_grenade_table(unit)

    local function get_equipped_inSlots(slot, unit, all_explosives)

        local not_explosive = {}
        local explo = {}
        unit:ForEachItemInSlot(slot, function(item)
            if IsKindOf(item, 'ThrowableTrapItem') then
                local substance = g_Classes[item.ExplosiveType]
                if substance then
                    if substance.BaseDamage <= 0 then
                        table.insert(all_explosives.non_damage, {item = item, slot = slot})
                    else
                        table.insert(all_explosives.damage, {item = item, slot = slot})
                    end
                end
            elseif IsKindOf(item, 'Grenade') then
                if item.BaseDamage <= 0 then
                    table.insert(all_explosives.non_damage, {item = item, slot = slot})
                else
                    table.insert(all_explosives.damage, {item = item, slot = slot})
                end
            end
        end)
        return all_explosives
    end

    local function check_and_change_grenade(unit, all_explosives)

        local explo = all_explosives.damage
        local not_explosive = all_explosives.non_damage

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
                local item_to_remove = not_explosive[rand_ind].item
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

    local all_explosives = {non_damage = {}, damage = {}}
    all_explosives = get_equipped_inSlots("Handheld A", unit, all_explosives)
    all_explosives = get_equipped_inSlots("Handheld B", unit, all_explosives)
    check_and_change_grenade(unit, all_explosives)
end

