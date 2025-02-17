return PlaceObj('ModDef', {
	'title', "Rato's AI Overhaul",
	'description', "[h1]Intro[/h1]\n\nThis AI Overhaul is designed to enhance the enemies AI to fully integrate and utilize the custom mechanics introduced in Rato's Gameplay Balance and Overhaul 3. \n\nThe core philosophy behind this mod is [b]fair play[/b]. As much as possible, the AI operates under the same rules and restrictions as the player, promoting a balanced and engaging experience without implementing unfair advantages or cheating. Every new introduced action taken by the AI will respect the constraints of available AP. As much as possible, artificial constraints or \"cheats\" from vanilla were removed.\n\nIt is the main objective here to make the AI not only more competitive but also more immersive.\n\nIt is [b]highly[/b] recommended that you use CUAE for enemy loot distribution, which can be found here: https://steamcommunity.com/sharedfiles/filedetails/?id=3148282483\n\n[h2]Features[/h2]\n\n\n[h3]Shooting Stance AI logic:[/h3]\n[list]\n[*]The AI will now evaluate if it should remain in Shooting Stance instead of moving around, using a robust logic considering AP to enter stance, cover, enemies in range and more.\n[/list]\n[h3]Signature Actions:[/h3]\n[list]\n[*]Special actions used by the AI will now be selected based on the dynamic contextual situation. Instead of a unit having 50% chance of using Autofire, for example, it will have a chance based on distance to enemies, recoil, snapshot or hipfire penalties etc. This will apply to all types of special actions, so the AI will consider its weapon and skills values, as well as its position in the battlefield, when deciding to use limb shots, overwatch etc. The enemies will also be able to use single shot instead of burst fire on some occasions.\n\n[*][b]Prepare Weapon[/b] - The AI will be able to use the Prepare Weapon action when it is positioning itself, entering Shooting Stance.\n\n[*][b]Dynamism[/b] - The AI will also be able to use different types of these special actions in a more dynamic form. For example, if using a weapon capable of Mobile Shots, even Soldiers will use it, not only Skirmishers. \n[/list]\n	\n[h3]Night Combat Enhancement[/h3]\n[list]\n[*]Units now throw flares at enemies during night time engagements for improved visibility and tactical advantage.\n[/list]\n\n[h3]Improved Tactics for Grenadiers and Machine Gunners[/h3]\n[list]\n[*]Increased grenade usage for both offensive and tactical purposes. Grenadiers will use grenades frequently, while infantry may use it from time to time or if a good situation appears. Grenadiers and MG units are more adept at targeting enemies in cover, prioritizing cover destruction. Increased the use of Machine Gun setup action, and created a custom positioning logic for it.\n[/list]\n\n[h3]Positioning:[/h3]\n[list]\n\n[*][b]Experimental Flanking Logic[/b] - Custom experimental logic improves AI flanking behaviors for more effective positioning and tactical maneuvers.\n\n[*][b]Behavioral Adjustments[/b] - Added extra logic, so the AI will try to avoid being flanked or exposed at close range. The AI will use the last enemy position to evaluate where to go to cover if there is no enemy visible. Overall the AI will use more cover.\n\n[*][b]Retreating[/b] - Snipers now swap to handguns and adopt retreat behaviors when enemies close in.\n\n[*][b]Stance[/b] -  At the end of the turn, if the AI has AP, it will try to crouch or go prone.\n\n[/list]\n[h3]Source AI Mechanics Overhaul:[/h3]\n[list]\n\n[*]Revamped source functions governing AI decision-making. Added recoil calculation, point blank, cover, and other mechanics changes from GBO. \nThe AI will take into account Bolt Action costs when making decisions.\n[*]Fixed  some issues and behaviors in the vanilla AI.\n[*]Removed some artificial limitations the vanilla AI had, like a limited number of attacks per turn. They will use their AP.\n[/list]\n\n[h3]Options:[/h3]\n[list]\n\n[*][b]Lore-Friendly Weapon Progression (CUAE)[/b] - Added a (subjective) lore-friendly progression system for weapons added by CUAE. Can be disabled.\n\n[*][b]Improve Explosives Stats[/b] - This option will moderately improve the enemies Explosive stat. Specialists (like Grenadier) will have a bigger boost. Some enemies will also have a small Dexterity boost. Highly recommended if using Rato's Explosive Overhaul 2. Restart after applying.\n\n[*][b]Boost Stats[/b] - This option will apply a moderate stat boost to enemy units, based on their Roles. Can be disabled.\n[/list]\n\n\nIf you want to buy me a coffee you can do so here: https://www.buymeacoffee.com/rato_modder\n\nMany features here are very experimental, so feedback is highly appreciated!\n",
	'image', "Mod/RATOAI/Images/ai_capa.jpg",
	'last_changes', "1.10 \n\nAdded extra CUAE params. Snipers should have more scopes, and enemies in general will have components related to their roles. Thank Lucjan :)\n\nsome changes related to shotgun rework in GBO",
	'SpellCheck', true,
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "cfahRED",
			'title', "Rato's Gameplay Balance and Overhaul 3",
			'version_major', 3,
			'version_minor', 51,
		}),
		PlaceObj('ModDependency', {
			'id', "JA3_CommonLib",
			'title', "JA3_CommonLib",
			'version_major', 1,
			'version_minor', 5,
		}),
	},
	'id', "RATOAI",
	'author', "rato",
	'version_major', 1,
	'version_minor', 10,
	'version', 3375,
	'lua_revision', 233360,
	'saved_with_revision', 350233,
	'code', {
		"Code/CONSTANTS_AI_source.lua",
		"Code/PATCH_AppendClass_source_classes.lua",
		"Code/PATCH_UnitData.lua",
		"Code/PATCH_call.lua",
		"Code/PATCH_ChangeUnitDataDef.lua",
		"Code/DEBUG.lua",
		"Code/AIPOLICYPOS_CustomFlanking.lua",
		"Code/AIPOLICYPOS_CustomSeekCover.lua",
		"Code/AIPOLICYPOS_TryNotToBeFlanked.lua",
		"Code/AIPOLICYPOS_MGSetupPosScore.lua",
		"Code/AIPOLICYPOS_Attack_StanceAP.lua",
		"Code/AIPOLICYPOS_MGSetupAP.lua",
		"Code/AIPOLICYPOS_SaveAP.lua",
		"Code/AIPOLICYPOS_DontBeExposedAtCloserRange.lua",
		"Code/AIPOLICYPOS_GrenadeRange.lua",
		"Code/AIPOLICYPOS_AvoidDeathSpots.lua",
		"Code/AIPOLICYPOS_AvoidThreatenedAreas.lua",
		"Code/AIPOLICYTARG_EnemyInCover.lua",
		"Code/AIPOLICYTARG_PindownTargeting.lua",
		"Code/AIPOLICYTARG_HasStatusEffect.lua",
		"Code/AIACTION_ThrowFlare.lua",
		"Code/AIACTION_PrepareWeapon.lua",
		"Code/UTIL.lua",
		"Code/CUAE_options.lua",
		"Code/REACTIONS_StopMGPackingUp.lua",
		"Code/FUNCTION_ChangeEquipment.lua",
		"Code/FUNCTION_EndTurnAIAction.lua",
		"Code/FUNCTION_ShouldMaxAim.lua",
		"Code/FUNCTION_getAIShootingStanceBehaviorSelectionScore.lua",
		"Code/FUNCTION_getAISoldierFlankingBehaviorSelectionScore.lua",
		"Code/FUNCTION_Get_HeavyGunnerShouldUsePositioningBehavior.lua",
		"Code/FUNCTION_get_ShouldUseGetCloserPositioningBehavior.lua",
		"Code/FUNCTION_SignaturesCustomScoring.lua",
		"Code/FUNCTION_CustomArchetypeFunc.lua",
		"Code/FUNCTION_CanDegradeToSingleShot.lua",
		"Code/FUNCTION_ScoreAttacksDetailed.lua",
		"Code/PROPERTIES_Unit.lua",
		"Code/SOURCE_AIPrecalcDamageScore.lua",
		"Code/SOURCE_AICalcAOETargetPoints.lua",
		"Code/SOURCE_AIPrecalcGrenadeZones.lua",
		"Code/SOURCE_AICalcAttacksandAim.lua",
		"Code/SOURCE_AICreateContext.lua",
		"Code/SOURCE_AIGetAttackArgs.lua",
		"Code/SOURCE_AISelectAction.lua",
		"Code/SOURCE_AIEvalZones.lua",
		"Code/SOURCE_AITakeCover.lua",
		"Code/SOURCE_AIPolicyIndoorsOutdoors_EvalDest.lua",
		"Code/SOURCE_AIActionThrowGrenade_PrecalcAction.lua",
		"Code/SOURCE_AIActionPinDown_PrecalcAction.lua",
		"Code/SOURCE_AIScoreDest.lua",
		"Code/SOURCE_AIGetAttackTargetingOptions.lua",
		"Code/SOURCE_AIPlayAttacks.lua",
	},
	'default_options', {
		AddHWStoGunners = true,
		BoostStatsDifficulty = "Hardest",
		CUAELoreProgression = true,
		DontBoostMilitia = false,
		DontChangeEquip = false,
		ImproveExplosiveStat = true,
		UseSimpleAttacksScoring = false,
	},
	'has_data', true,
	'saved', 1739800588,
	'code_hash', 5729792295789667753,
	'affected_resources', {
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Soldier",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "RATOAI_Sniper",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "HeavyGunner",
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
			'Id', "RATOAI_Rocketeer",
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
			'Id', "Scout_LastLocation",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "RATOAI_RetreatingMarksman",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "PinnedDown",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "GuardArea",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Panicked",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Beserk",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "Pierre",
			'ClassDisplayName', "AI Archetype",
		}),
		PlaceObj('ModResourcePreset', {
			'Class', "AIArchetype",
			'Id', "TheMajor",
			'ClassDisplayName', "AI Archetype",
		}),
	},
	'steam_id', "3411008594",
	'TagBalancing&Difficulty', true,
	'TagCombat&AI', true,
	'TagEnemies', true,
})