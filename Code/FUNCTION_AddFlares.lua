function OnMsg.UnitEnterCombat(unit)
    RATOAI_ChangeMarksmanToHandGun(unit)
    RATOAI_UpdateUnitEquipedGrenades(unit)
    -- RATOAI_AddFlare(unit, true)
    -- RATOAI_ChangeExplosives(unit)
end

function OnMsg.ModsReloaded()
    RATOAI_BuildGrenadeTable()
end

------------------------------------
-----TODO: maybe remove handguns/melee from those guys that dont really use it
------TODO: Flash specific action. Target overwatchers

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
        Marksman = {smoke = {0, 2}},
        Demolitions = {explo = {2, 3}, timed = {1, 3}, aoe = {-2, 4}},
        Soldier = {explo = {-2, 2}, smoke = {1, 2}},
        Recon = {flash = {1, 3}, smoke = {-1, 2}},
        Stormer = {explo = {-1, 3}, aoe = {1, 3}}
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

RATOAI_GrenadeTable = {}

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
            RATOAI_GrenadeTable['flare'] = RATOAI_GrenadeTable['flare'] or {}
            table.insert(RATOAI_GrenadeTable['flare'], item.class)

        elseif IsKindOfClasses(item, "ConcussiveGrenade", 'ConcussiveGrenade_IED') then
            RATOAI_GrenadeTable['flash'] = RATOAI_GrenadeTable['flash'] or {}
            table.insert(RATOAI_GrenadeTable['flash'], item.class)

        elseif IsKindOf(item, 'ThrowableTrapItem') then

            if item.TriggerType == "Timed" then
                RATOAI_GrenadeTable['timed'] = RATOAI_GrenadeTable['timed'] or {}
                table.insert(RATOAI_GrenadeTable['timed'], item.class)

            elseif item.TriggerType == "Proximity" then
                RATOAI_GrenadeTable['proximity'] = RATOAI_GrenadeTable['proximity'] or {}
                table.insert(RATOAI_GrenadeTable['proximity'], item.class)
            end

        elseif IsKindOf(item, 'Grenade') then

            local aoe_types = {"fire", "teargas"}

            if item.aoeType and table.find(aoe_types, item.aoeType) then
                RATOAI_GrenadeTable['aoe'] = RATOAI_GrenadeTable['aoe'] or {}
                table.insert(RATOAI_GrenadeTable['aoe'], item.class)

            elseif item.aoeType and item.aoeType == "smoke" then
                RATOAI_GrenadeTable['smoke'] = RATOAI_GrenadeTable['smoke'] or {}
                table.insert(RATOAI_GrenadeTable['smoke'], item.class)

            elseif item.BaseDamage > 0 then
                RATOAI_GrenadeTable['explo'] = RATOAI_GrenadeTable['explo'] or {}
                table.insert(RATOAI_GrenadeTable['explo'], item.class)

            end
        end
    end

    RATOAI_GrenadeTable = {}
    ForEachPreset("InventoryItemCompositeDef", function(p)
        local item = g_Classes[p.id]
        if item and IsKindOf(item, "MishapProperties") then
            populate_gren_table(item)
        end
    end)
end

local grenade_immunity_list = {"ToxicGasGrenade"} ---- Will not be removed

function RATOAI_UpdateUnitEquipedGrenades(unit)

    if not R_IsAI(unit) then
        return
    end

    if not next(RATOAI_GrenadeTable) then
        RATOAI_BuildGrenadeTable()
    end

    local function RATOAI_GetReplacementIED(unit, explo_id)
        local base_replacement = get_replacement_ied(unit, {class = explo_id})

        if base_replacement then
            return base_replacement
        end

        local item = g_Classes[explo_id]
        local substances_prohibited = {"C4", "PETN"}
        if item and IsKindOf(item, "ThrowableTrapItem") and item.TriggerType == "Timed" then
            local subs = item.ExplosiveType or ''
            if subs == "C4" then
                return "PipeBomb"
            elseif subs == "PETN" then
                return "TimedTNT"
            end
        end
        return nil
    end

    local grenade_data = GetGrenadeRoleData(unit)
    local desired_grenades_num = {}
    for type, data in pairs(grenade_data) do
        local amount = InteractionRandRange(data[1], data[2])
        if amount > 0 then
            desired_grenades_num[type] = amount
        end
    end

    -- local equipped_nades = {}
    local slots = {"Handheld A", "Handheld B"}
    for _, slot in ipairs(slots) do
        unit:ForEachItemInSlot(slot, function(item)
            if IsKindOf(item, "MishapProperties") then
                for type, grenades in pairs(RATOAI_GrenadeTable) do
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
        local possible_types = RATOAI_GrenadeTable[type]
        local explo_id = possible_types[InteractionRandRange(1, #possible_types)]

        if IsMod_loaded("RATONADE") then
            local affiliation = unit.Affiliation or ""
            local islegion_thug = affiliation == "Legion" or affiliation == "Thugs"
            explo_id = islegion_thug and RATOAI_GetReplacementIED(unit, explo_id) or explo_id
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

------------------------------------

function RATOAI_AddFlare(unit, check) --------- Old Flare func
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
