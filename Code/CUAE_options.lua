function RATOAI_CUAEoptions()

    if IsMod_loaded("LDCUAE") then
        local cuaeSettings = {
            ExtraHandgun = true
            -- ExtraGrenadesChance = 100,
            -- ExtraGrenadesCount = 10,
            -- AlternativeWeaponTypeTables = {
            --     Handgun = {{"SMG", 50}, {"Shotgun", 80}, {"AssaultRifle", 100}},
            --     SMG = {{"AssaultRifle", 25}},
            --     Shotgun = {{"AssaultRifle", 15}},
            --     AssaultRifle = {{"MachineGun", 15}, {"Sniper", 20}}
            -- }
        }
        CUAEForceSettings(cuaeSettings)
    end
end

function OnMsg.ModsReloaded()
    RATOAI_CUAEoptions()
end
function OnMsg.DataLoaded()
    RATOAI_CUAEoptions()
end
function OnMsg.OptionsApply()
    RATOAI_CUAEoptions()
end

