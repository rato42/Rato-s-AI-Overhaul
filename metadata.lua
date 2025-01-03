return PlaceObj('ModDef', {
	'title', "Rato's AI Overhaul",
	'description', "Features\n\nLogic for keeping stance AP\n\nAI will be able to use single shot instead of burst shot if  otherwise it wouldnt have enough AP to enter shooting stance\n\nMore aiming, more shooting stance entering.\n\nCustom decision making when AI decides to use special attacks like mobile attack, overwatch, limb shots, etc. The logic is based on distance, weapons and components, and takes into effect the new mechanics from GBO.\n\nThe AI will be able to use most of the abilities of new weapons added by CUAE (example, a stockless rifle will use run and gun, SKS users will use their mobile attacks, they will be able to use grenades).\n\nCustom logic for Grenadiers and MGs to try to attack targets in cover and destroy the cover\n\nMore use of grenades.\n\nUnits will throw flares at the enemy at night.\n\nCreated a custom experimental logic for AI to flank more efficiently \n\nRevamped source functions that control the inner workings of the AI decision making. Added recoil calculation, point blank mechanics changes from GBO, cover, mechanics changes. The AI will take into account Bolt Action costs when making decisions.\n\nFixed some behaviors that made AI use FreeMove ap for aiming.\n\nAlso took away some limitations AI had to make it less punishing in the base game.\n\nIncreased AI use of cover. \nIncreased AI use of MGsetup.\n\nSnipers will swap to handguns and start retreating behaviors when you get too close to them.\n\nNew lore friendly weapon progression to be used with CUAE!\n\nThe philosophy here was to change mostly/only the behavior of the AI, with no cheating (I even fixed some cheating the AI did). \n\n\nThe only additions to units are increased explosive stats skill (if you use Rato's Explosive Overhaul, this is recommended) and the addition of Heavy Weapon's Specialist to machine gunners. Both can be disabled in the mod options\n\n\n\n\n\n\n\n----- Targeting\nAdd policys for grouped targets when using burst/autofire\n\n\nVisibility",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "cfahRED",
			'title', "Rato's Gameplay Balance and Overhaul 3",
			'version_major', 3,
			'version_minor', 51,
		}),
	},
	'id', "rEYcAD4",
	'author', "rato",
	'version', 1676,
	'lua_revision', 233360,
	'saved_with_revision', 350233,
	'code', {
		"Code/Const_APstance.lua",
		"Code/CLASS_append_AISignatureAction.lua",
		"Code/PATCH_UnitData.lua",
		"Code/PATCH_call.lua",
		"Code/DEBUG.lua",
		"Code/AIPOLICY_CustomFlanking.lua",
		"Code/AIPOLICY_CustomSeekCover.lua",
		"Code/AIACTION_ThrowFlare.lua",
		"Code/UTIL.lua",
		"Code/CUAE_options.lua",
		"Code/FUNCTION_AddFlares.lua",
		"Code/FUNCTION_getAIShootingStanceBehaviorSelectionScore.lua",
		"Code/FUNCTION_ChangeUnitDataDef.lua",
		"Code/FUNCTION_MGSetup.lua",
		"Code/FUNCTIONS_SignaturesCustomScoring.lua",
		"Code/FUNCTION_CustomArchetypeFunc.lua",
		"Code/PROPERTIES_Unit.lua",
		"Code/SOURCE_AIPrecalcDamageScore.lua",
		"Code/SOURCE_AICalcAttacksandAim.lua",
		"Code/SOURCE_SelectArchetype.lua",
		"Code/SOURCE_AICreateContext.lua",
		"Code/SOURCE_AIGetAttackArgs.lua",
		"Code/SOURCE_AIGetBias.lua",
		"Code/SOURCE_AISelectAction.lua",
		"Code/SOURCE_AIEvalZones.lua",
		"Code/vanilla_archetype_functions_forconsult.lua",
		"Code/vanilla_action_functions_forconsult1.lua",
		"Code/AIPrecalcConeTargetZones.lua",
		"Code/AIScoreReachableVoxels.lua",
		"Code/eval_dest.lua",
		"Code/Test.lua",
		"UnitData/AdonisSniper_Elite_copy.lua",
		"UnitData/LegionGrenadier_copy.lua",
		"UnitData/LegionGunner_copy.lua",
		"UnitData/LegionRaider_copy_copy.lua",
		"UnitData/LegionRaider_copy.lua",
		"UnitData/LegionScout_copy.lua",
		"UnitData/LegionButcher_copy.lua",
	},
	'default_options', {
		AddFlares = true,
		AddHWStoGunners = true,
		CUAELoreProgression = true,
		ImproveExplosiveStat = true,
	},
	'has_data', true,
	'saved', 1735880438,
	'code_hash', -1442087879323949699,
	'affected_resources', {
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "ShootingStance_Archetype",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "ShootingStance_Archetype_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "LootDef",
			'Id', "FLARES",
			'ClassDisplayName', "Loot definition",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "LootDef",
			'Id', "he",
			'ClassDisplayName', "Loot definition",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "UnitDataCompositeDef",
			'Id', "AdonisSniper_Elite_copy",
			'ClassDisplayName', "Unit",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "UnitDataCompositeDef",
			'Id', "LegionGrenadier_copy",
			'ClassDisplayName', "Unit",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "UnitDataCompositeDef",
			'Id', "LegionGunner_copy",
			'ClassDisplayName', "Unit",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "UnitDataCompositeDef",
			'Id', "LegionRaider_copy_copy",
			'ClassDisplayName', "Unit",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "UnitDataCompositeDef",
			'Id', "LegionRaider_copy",
			'ClassDisplayName', "Unit",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "UnitDataCompositeDef",
			'Id', "LegionScout_copy",
			'ClassDisplayName', "Unit",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "UnitDataCompositeDef",
			'Id', "LegionButcher_copy",
			'ClassDisplayName', "Unit",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Soldier",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Skirmisher",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "RATOAI_RetreatingMarksman",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "RATOAI_Demolition",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "HeavyGunner",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Brute",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Medic",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Artillery_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Turret_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Beast_Crocodile_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Beast_Hyena_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Bossfight_GuardArea_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Corazon_BossRetreating_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Corazon_GuardArea_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Corazon_KiteBack_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Corazon_ShootAndScoot_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Faucheaux_BossRetreating_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "CorazonBoss_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Pierre_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "PierreGuard_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "TheMajor_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "TurretBoss_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "EmplacementGunner_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Scout_LastLocation_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "PinnedDown_copy",
			'ClassDisplayName', "AI Archetype",
		}),
	},
	'TagCombat&AI', true,
})