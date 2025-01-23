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
        Demolitions = {Health = 125, Explosives = 125, Dexterity = 120},
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
        ArmyCommander = {
            Health = 135,
            Marksmanship = 125,
            Dexterity = 125,
            Agility = 115,
            Leadership = 130
        },
        HyenaHandler = {Health = 135, Marksmanship = 125, Dexterity = 120, Agility = 110},
        Prisioner = {Health = 120, Marksmanship = 120, Dexterity = 120, Agility = 125},
        Recon = {Health = 120, Marksmanship = 120, Dexterity = 120, Agility = 125},
        Stormer = {Health = 135, Strength = 120, Dexterity = 120, Agility = 120},
        Artillery = {Health = 110, Explosives = 130},
        Rocketeer = {Health = 115, Explosives = 130, Strength = 130},
        Beast = {Health = 110, Strength = 120, Agility = 130, Dexterity = 120},
        Heavy = {Health = 130, Strength = 135, Dexterity = 120, Marksmanship = 125},
        Medic = {Health = 120, Medical = 130, Dexterity = 120, Agility = 120}
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
        -- if prop == "Health" then
        --     local max_health = class.Health
        --     if max_health then
        --         if max_health <= 30 then
        --             class.Health = Min(100, MulDivRound(class[prop] or 60, 165, 100))
        --         elseif max_health <= 40 then
        --             class.Health = Min(100, MulDivRound(class[prop] or 60, 125, 100))
        --         elseif max_health <= 80 then
        --             class.Health = 92
        --         elseif max_health <= 85 then
        --             class.Health = 97
        --         else
        --             class.Health = 100
        --         end
        --     end
        -- else
        class[prop] = Min(100, MulDivRound(class[prop] or 60, mul, 100))
        -- end

    end

    -- local max_health = class.MaxHitPoints
    -- if not max_health then
    --     return
    -- end

    -- if max_health <= 50 then
    --     class.MaxHitPoints = 62
    -- elseif max_health <= 60 then
    --     class.MaxHitPoints = 75
    -- elseif max_health <= 80 then
    --     class.MaxHitPoints = 92
    -- elseif max_health <= 85 then
    --     class.MaxHitPoints = 97
    -- else
    --     class.MaxHitPoints = 100
    -- end
end

------------TODO: change
function OnMsg.UnitEnterCombat(unit)
    if R_IsAI(unit) then
        RecalcMaxHitPoints(unit)
        -- unit.RATOAI_recalcedHP = true
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

