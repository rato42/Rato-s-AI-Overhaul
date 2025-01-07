local function AddStartingPerk(class, perk_id)
    local starting_perks = table.copy(class.StartingPerks or {})
    table.insert_unique(starting_perks, perk_id)
    class.StartingPerks = starting_perks
end

local function Set_PickCustomArchetype(func)
    return function(self, proto_context)
        return func(self, proto_context)
    end
end

function RATOAI_ChangeUnitDataDef(class, props)
    for k, v in pairs(props) do
        if k == "add_HWS" then
            if CurrentModOptions.AddHWStoGunners then
                AddStartingPerk(class, "HeavyWeaponsTraining")
            end
        elseif k == "Explosives" then
            if CurrentModOptions.ImproveExplosiveStat then
                class[k] = v
            end
            -- elseif k == 'PickCustomArchetype' then
            -- class[k] = v
        else
            class[k] = v
        end
    end
end

