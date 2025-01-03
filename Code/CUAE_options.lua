function RATOAI_CUAEoptions()

    if IsMod_loaded("LDCUAE") then
        local cuaeSettings = {
            ExtraHandgun = true,
            ExtraGrenadesChance = 100,
            ExtraGrenadesCount = 5
        }
        CUAEForceSettings(cuaeSettings)

        RATOAI_AddExclusionCUAE()
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

function RATOAI_AddExclusionCUAE()

    if not CurrentModOptions.CUAELoreProgression then
        return
    end

    local german = {
        'HK23E_1', 'HK33A2_1', 'P90_2', 'TAR21_1', 'HK53_1', 'HK23ECamo_1', 'PSG1', 'G36', 'HK21'
    }

    local german_common = {'MP5', 'MP5K', 'UMP_1', 'USP_1', 'G3A3_1', 'G3A3Green_1'}

    local eastern_common = {
        'RK95_1', 'RK62_1', 'SKS_1', 'Type56A_1', 'Type56B_1', 'Type56C_1', 'Type56D_1',
        'PapovkaSKS_1', 'Papovka2SKS_1', 'PKM_1', 'RPD_1', 'M76_1', 'PP91_1', 'M70_1', 'M70D_1',
        'AK47'
    }
    local eastern_new = {'AK74', 'RPK74', 'DragunovSVD', 'AKSU', 'Groza_1', 'VSK94_1'}
    local eastern_special = {'AN94_1', 'VSS_1'}

    local western = {
        'FNMinimi', 'M14SAW_AUTO', 'M16A2', 'AUG', 'FAMAS', 'M4Commando', 'M24Sniper', 'M41Shotgun',
        'MAC11_1'
    }

    local other = {
        'ColtAnaconda', 'DesertEagle', 'Bereta92', 'Glock18', 'M1911_1', 'B93RR_1', 'Glock17_1'
    }

    local israeli = {'MicroUZI_1', 'UZI', 'Galil'}

    local old_war = {
        'Mosin_1', 'Delisle_1', 'VigM2_1', 'StenMK2_1', 'STG44R_1', 'P08_1', 'M1Garand_2',
        'Gewehr43_1', 'Gewehr98', 'MP40', 'MG42', 'HiPower', 'Winchester1894', 'Auto5',
        'DoubleBarrelShotgun', "ColtPeacemaker"
    }

    local civilian = {'SteyrScout_1', 'SSG69_1', 'AR15', 'M14SAW'}

    local end_game = {'BarretM82', 'AA12'}

    local excl_table = {
        Army = {},
        Adonis = {},
        Rebels = {},
        Thugs = {"M14SAW_AUTO"},
        Legion = {"M14SAW_AUTO"},
        SuperSoldiers = {},
        Militia = {"M14SAW_AUTO"}
    }

    local function add_items(destination, ...)
        for _, list in ipairs({...}) do
            for _, item in ipairs(list) do
                table.insert(destination, item)
            end
        end
    end

    add_items(excl_table.Army, old_war, civilian, eastern_special, eastern_common)
    add_items(excl_table.Adonis, old_war, eastern_common)
    add_items(excl_table.Rebels, german, german_common, western)
    add_items(excl_table.Thugs, german, end_game, eastern_special, western)
    add_items(excl_table.Legion, german, end_game, eastern_special)
    add_items(excl_table.SuperSoldiers, old_war, civilian, eastern_special, eastern_common,
              eastern_new, israeli)
    add_items(excl_table.Militia, german, end_game, eastern_special)

    CUAEAddExclusionTable(excl_table)
end
