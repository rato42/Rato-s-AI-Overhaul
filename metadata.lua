return PlaceObj('ModDef', {
	'title', "Rato's AI Overhaul",
	'description', "TODO:\n\n--------MatchUnit to prevent/enable \n\nFix MGs attacking outside cone. Maybe using signature ?\nUnderstand Positioning AI\nInvestigate Seek Cover policy - improve it\n\n\nEnemies are finishing turn with AP remaining\n\n\n\n\n\n\n\nOBS: some logic will check if unit has ap after movement to attack\n\n----- Targeting\nAdd policys for grouped targets when using burst/autofire\n\n----- Movement\ngive score to voxels where they would have enough stance ap\n\n------- Actions\nAI shooting from too afar when using burst/autofire\nConsider increasing aim levels in burst fire?? maybe\nBurstFire should not be aimed at limbs\n\nHeadshots\nIncrease usage of Mobile attacks and grenades\n\nVisibility",
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
	'version', 1153,
	'lua_revision', 233360,
	'saved_with_revision', 350233,
	'code', {
		"Code/Const_APstance.lua",
		"Code/CLASS_append_AISignatureAction.lua",
		"Code/FUNCTION_getAIShootingStanceBehaviorSelectionScore.lua",
		"Code/FUNCTION_ChangeAIKeyWords.lua",
		"Code/FUNCTION_AIGetCustomBiasWeight.lua",
		"Code/FUNCTION_MGSetup.lua",
		"Code/AIACTION_ThrowFlare.lua",
		"Code/FUNCTIONS_SignaturesCustomScoring.lua",
		"Code/SOURCE_AIPrecalcDamageScore.lua",
		"Code/SOURCE_AICalcAttacksandAim.lua",
		"Code/SOURCE_SelectArchetype.lua",
		"Code/SOURCE_AICreateContext.lua",
		"Code/SOURCE_AIGetAttackArgs.lua",
		"Code/SOURCE_AIGetBias.lua",
		"Code/SOURCE_AISelectAction.lua",
		"Code/SOURCE_AIEvalZones.lua",
		"Code/PROPERTIES_Unit.lua",
		"Code/vanilla_archetype_functions_forconsult.lua",
		"Code/vanilla_action_functions_forconsult1.lua",
		"Code/AIPrecalcConeTargetZones.lua",
		"Code/AIScoreReachableVoxels.lua",
		"Code/eval_dest.lua",
		"Code/Test.lua",
		"Code/get_accuracy.lua",
		"Code/AddItem.lua",
		"UnitData/AdonisSniper_Elite_copy.lua",
		"UnitData/LegionGrenadier_copy.lua",
		"UnitData/LegionGunner_copy.lua",
		"UnitData/LegionRaider_copy_copy.lua",
		"UnitData/LegionRaider_copy.lua",
		"UnitData/LegionScout_copy.lua",
		"UnitData/LegionButcher_copy.lua",
	},
	'default_options', {},
	'has_data', true,
	'saved', 1735063641,
	'code_hash', -5560315609394796333,
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
			'Id', "RPG",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Skirmisher",
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
			'Id', "Soldier_nobias_test",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Artillery_copy",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Medic_copy",
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