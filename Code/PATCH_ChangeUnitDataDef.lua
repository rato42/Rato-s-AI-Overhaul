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
        Marksman = {Health = 115, Marksmanship = 130, Dexterity = 130, Wisdom = 130},
        Demolitions = {Explosives = 125, Dexterity = 120, Health = 125},
        Soldier = {
            Health = 135,
            Marksmanship = 125,
            Dexterity = 120,
            Agility = 110,
            Explosives = 110
        },
        Commander = {
            Health = 135,
            Marksmanship = 125,
            Dexterity = 125,
            Agility = 115,
            Leadership = 130
        },
        Recon = {Health = 120, Marksmanship = 120, Dexterity = 120, Agility = 125},
        Stormer = {Strength = 120, Dexterity = 120, Agility = 120, Health = 135},
        Artillery = {Explosives = 130, Health = 110},
        Rocketeer = {Explosives = 130, Strength = 130, Health = 115},
        Beast = {Strength = 120, Agility = 130, Dexterity = 120, Health = 110},
        Heavy = {Strength = 135, Dexterity = 120, Marksmanship = 125, Health = 130},
        Medic = {Medical = 130, Dexterity = 120, Agility = 120, Health = 120}
    }

    return map[role] or false
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
        -- print("-------", class.class)
        -- print("--Boosting", prop, "=", class[prop] or 60)
        class[prop] = Min(100, MulDivRound(class[prop] or 60, mul, 100))
        -- print("--------to", prop, "=", class[prop])
    end
end

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

