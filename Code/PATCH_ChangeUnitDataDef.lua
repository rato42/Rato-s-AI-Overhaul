local function AddStartingPerk(class, perk_id)
    local starting_perks = table.copy(class.StartingPerks or {})
    table.insert_unique(starting_perks, perk_id)
    class.StartingPerks = starting_perks
end

local stats = {
    "Health", "Agility", "Dexterity", "Strength", "Wisdom", "Leadership", "Marksmanship",
    "Mechanical", "Explosives", "Medical"
}

local function GetRoleArgs_BoostStats(class)
    local role = class.custom_role or class.role or ""

    if class.militia then
        return false
    end

    local map = {
        Commander = {
            Health = 15,
            Marksmanship = 15,
            Dexterity = 10,
            Strength = 15,
            Agility = 8,
            Explosives = 8,
            Wisdom = 0,
            Medical = 0,
            Leadership = 20,
            Mechanical = 0
        },
        Stormer = {
            Health = 15,
            Marksmanship = 8,
            Dexterity = 10,
            Strength = 15,
            Agility = 15,
            Explosives = 8,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Marksman = {
            Health = 15,
            Marksmanship = 15,
            Dexterity = 15,
            Strength = 5,
            Agility = 10,
            Explosives = 0,
            Wisdom = 15,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Heavy = {
            Health = 15,
            Marksmanship = 15,
            Dexterity = 10,
            Strength = 10,
            Agility = 15,
            Explosives = 0,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Soldier = {
            Health = 15,
            Marksmanship = 15,
            Dexterity = 10,
            Strength = 15,
            Agility = 8,
            Explosives = 8,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Recon = {
            Health = 15,
            Marksmanship = 15,
            Dexterity = 10,
            Strength = 8,
            Agility = 15,
            Explosives = 8,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Beast = {
            Health = 15,
            Marksmanship = 0,
            Dexterity = 15,
            Strength = 15,
            Agility = 10,
            Explosives = 0,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Medic = {
            Health = 15,
            Marksmanship = 10,
            Dexterity = 10,
            Strength = 0,
            Agility = 15,
            Explosives = 0,
            Wisdom = 0,
            Medical = 15,
            Leadership = 0,
            Mechanical = 0
        },
        Artillery = {
            Health = 15,
            Marksmanship = 15,
            Dexterity = 8,
            Strength = 8,
            Agility = 10,
            Explosives = 15,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Demolitions = {
            Health = 15,
            Marksmanship = 8,
            Dexterity = 10,
            Strength = 8,
            Agility = 15,
            Explosives = 15,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        ArmyCommander = {
            Health = 15,
            Marksmanship = 15,
            Dexterity = 10,
            Strength = 15,
            Agility = 8,
            Explosives = 8,
            Wisdom = 0,
            Medical = 0,
            Leadership = 20,
            Mechanical = 0
        },
        Prisioner = {
            Health = 15,
            Marksmanship = 10,
            Dexterity = 15,
            Strength = 8,
            Agility = 15,
            Explosives = 8,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        HyenaHandler = {
            Health = 15,
            Marksmanship = 10,
            Dexterity = 15,
            Strength = 8,
            Agility = 15,
            Explosives = 8,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        },
        Rocketeer = {
            Health = 15,
            Marksmanship = 8,
            Dexterity = 8,
            Strength = 15,
            Agility = 10,
            Explosives = 15,
            Wisdom = 0,
            Medical = 0,
            Leadership = 0,
            Mechanical = 0
        }
    }

    return map[role] or map["Soldier"]
end

local function BoostStats(class)

    if not CurrentModOptions.BoostStats then
        return
    end

    local args = GetRoleArgs_BoostStats(class)
    if not args then
        return
    end

    local test
    for prop, mul in pairs(args) do
        if mul ~= 0 then
            class[prop] = Min(100, MulDivRound(class[prop] or 60, 100 + mul, 100))
        end
    end
end

function OnMsg.UnitCreated(unit)
    if R_IsAI(unit) then
        RecalcMaxHitPoints(unit)
    end
end

-- function OnMsg.UnitEnterCombat(unit)
--     if R_IsAI(unit) then
--         RecalcMaxHitPoints(unit)
--     end
-- end

function RATOAI_ChangeUnitDataDef(class, props)
    for k, v in pairs(props) do
        if k == "add_HWS" then
            if CurrentModOptions.AddHWStoGunners then
                AddStartingPerk(class, "HeavyWeaponsTraining")
            end
        elseif k == "Explosives" or k == "Dexterity" then
            if CurrentModOptions.ImproveExplosiveStat then
                class[k] = v
            end
        elseif k == "boost_stats" then
            BoostStats(class)
        else
            class[k] = v
        end
    end
end

