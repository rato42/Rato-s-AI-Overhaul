return {
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Torso" ),
		BaseMovementWeight = 0,
		Behaviors = {
			PlaceObj('HoldPositionAI', {
				'BiasId', "HoldPositionBehavior",
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
				},
				'TakeCoverChance', 0,
			}),
		},
		MoveStance = "Crouch",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'RangeMin', 25,
				'RangeMax', 100,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Autofire",
				'Weight', 150,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Autofire",
						'Effect', "disable",
						'Period', 0,
					}),
				},
				'NotificationText', "",
				'RequiredKeywords', {
					"Soldier",
				},
				'action_id', "AutoFire",
				'Aiming', "Maximum",
				'AttackTargeting', set( "Torso" ),
			}),
			PlaceObj('AIActionPinDown', {
				'BiasId', "PinDownAttack",
				'Weight', 0,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "PinDownAttack",
						'Value', -50,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Sniper",
				},
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "AssaultGrenadeThrow",
				'Weight', 50,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "AssaultGrenadeThrow",
						'Effect', "disable",
					}),
				},
				'RequiredKeywords', {
					"Explosives",
				},
				'self_score_mod', -1000,
				'AllowedAoeTypes', set( "fire", "none", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "SmokeGrenade",
				'Weight', 50,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Effect', "disable",
					}),
				},
				'RequiredKeywords', {
					"Smoke",
				},
				'enemy_score', 0,
				'team_score', 100,
				'self_score_mod', 100,
				'MinDist', 0,
				'AllowedAoeTypes', set( "smoke" ),
			}),
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "LauncherFire",
				'Weight', 50,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "LauncherFire",
						'Effect', "disable",
						'Period', 0,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "LauncherFire",
						'Value', -20,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Ordnance",
				},
				'self_score_mod', -1000,
				'MinDist', 5000,
				'LimitRange', true,
				'MaxTargetRange', 30,
			}),
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "RocketFire",
				'Weight', 50,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "RocketFire",
						'Effect', "disable",
					}),
				},
				'RequiredKeywords', {
					"Ordnance",
				},
				'self_score_mod', -1000,
				'MinDist', 5000,
				'action_id', "RocketLauncherFire",
				'LimitRange', true,
				'MaxTargetRange', 30,
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "GroinShot",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "GroinShot",
						'Effect', "disable",
					}),
				},
				'RequiredKeywords', {
					"Sniper",
				},
				'Aiming', "Remaining AP",
				'AttackTargeting', set( "Groin" ),
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Headshot",
				'Weight', 150,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Headshot",
						'Effect', "disable",
						'Period', 0,
					}),
				},
				'RequiredKeywords', {
					"Sniper",
				},
				'Aiming', "Maximum",
			}),
			PlaceObj('AIConeAttack', {
				'BiasId', "Overwatch",
				'Weight', 80,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Overwatch",
						'Value', -50,
						'ApplyTo', "Team",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "Overwatch",
						'Effect', "disable",
						'Value', -50,
						'Period', 2,
					}),
				},
				'RequiredKeywords', {
					"Soldier",
				},
				'team_score', 0,
				'min_score', 300,
				'action_id', "Overwatch",
			}),
			PlaceObj('AIConeAttack', {
				'BiasId', "SpamOverwatch",
				'Weight', 200,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SpamOverwatch",
						'Effect', "disable",
						'Value', -50,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Control",
				},
				'team_score', 0,
				'min_score', 100,
				'action_id', "Overwatch",
			}),
		},
		comment = "---- Not used",
		group = "System",
		id = "ShootingStance_Archetype",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Torso" ),
		BaseMovementWeight = 0,
		Behaviors = {
			PlaceObj('HoldPositionAI', {
				'BiasId', "HoldPositionBehavior",
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
				},
				'TakeCoverChance', 0,
			}),
		},
		MoveStance = "Crouch",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'RangeMin', 25,
				'RangeMax', 100,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Autofire",
				'Weight', 150,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Autofire",
						'Effect', "disable",
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'NotificationText', "",
				'RequiredKeywords', {
					"Soldier",
				},
				'action_id', "AutoFire",
				'AttackTargeting', set( "Torso" ),
			}),
			PlaceObj('AIActionPinDown', {
				'BiasId', "PinDownAttack",
				'Weight', 80,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "PinDownAttack",
						'Value', -50,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Sniper",
				},
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "AssaultGrenadeThrow",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "AssaultGrenadeThrow",
						'Effect', "disable",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "AssaultGrenadeThrow",
						'Effect', "disable",
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Explosives",
				},
				'self_score_mod', -1000,
				'AllowedAoeTypes', set( "fire", "none", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "SmokeGrenade",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Effect', "disable",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Effect', "disable",
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Smoke",
				},
				'enemy_score', 0,
				'team_score', 100,
				'self_score_mod', 100,
				'MinDist', 0,
				'AllowedAoeTypes', set( "smoke" ),
			}),
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "LauncherFire",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "LauncherFire",
						'Effect', "disable",
						'Period', 0,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "LauncherFire",
						'Value', -50,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Ordnance",
				},
				'self_score_mod', -1000,
				'MinDist', 5000,
				'LimitRange', true,
				'MaxTargetRange', 30,
			}),
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "RocketFire",
				'Weight', 200,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "RocketFire",
						'Effect', "disable",
					}),
				},
				'RequiredKeywords', {
					"Ordnance",
				},
				'self_score_mod', -1000,
				'MinDist', 5000,
				'action_id', "RocketLauncherFire",
				'LimitRange', true,
				'MaxTargetRange', 30,
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "GroinShot",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "GroinShot",
						'Effect', "disable",
						'Period', 0,
						'ApplyTo', "Team",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "GroinShot",
						'Effect', "disable",
					}),
				},
				'RequiredKeywords', {
					"Sniper",
				},
				'Aiming', "Remaining AP",
				'AttackTargeting', set( "Groin" ),
			}),
			PlaceObj('AIConeAttack', {
				'BiasId', "Overwatch",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Overwatch",
						'Value', -50,
						'ApplyTo', "Team",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "Overwatch",
						'Effect', "disable",
						'Value', -50,
						'Period', 2,
					}),
				},
				'RequiredKeywords', {
					"Soldier",
				},
				'team_score', 0,
				'min_score', 300,
				'action_id', "Overwatch",
			}),
			PlaceObj('AIConeAttack', {
				'BiasId', "SpamOverwatch",
				'Weight', 200,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SpamOverwatch",
						'Effect', "disable",
						'Value', -50,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Control",
				},
				'team_score', 0,
				'min_score', 100,
				'action_id', "Overwatch",
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Headshot",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Headshot",
						'Effect', "disable",
						'Period', 0,
					}),
				},
				'Aiming', "Maximum",
				'AttackTargeting', set( "Head" ),
			}),
		},
		comment = "---- Not used",
		group = "System",
		id = "ShootingStance_Archetype_copy",
	}),
	PlaceObj('ModItemCode', {
		'name', "Const_APstance",
		'CodeFileName', "Code/Const_APstance.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "CLASS_append_AISignatureAction",
		'CodeFileName', "Code/CLASS_append_AISignatureAction.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "PATCH_UnitData",
		'CodeFileName', "Code/PATCH_UnitData.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "PATCH_call",
		'CodeFileName', "Code/PATCH_call.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "DEBUG",
		'CodeFileName', "Code/DEBUG.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "AIPOLICY_CustomFlanking",
		'CodeFileName', "Code/AIPOLICY_CustomFlanking.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "AIPOLICY_CustomSeekCover",
		'comment', "--- unfinished",
		'CodeFileName', "Code/AIPOLICY_CustomSeekCover.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "AIACTION_ThrowFlare",
		'CodeFileName', "Code/AIACTION_ThrowFlare.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "UTIL",
		'CodeFileName', "Code/UTIL.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "CUAE_options",
		'CodeFileName', "Code/CUAE_options.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "FUNCTION_AddFlares",
		'CodeFileName', "Code/FUNCTION_AddFlares.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "FUNCTION_ShouldMaxAim",
		'CodeFileName', "Code/FUNCTION_ShouldMaxAim.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "FUNCTION_getAIShootingStanceBehaviorSelectionScore",
		'CodeFileName', "Code/FUNCTION_getAIShootingStanceBehaviorSelectionScore.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "FUNCTION_ChangeUnitDataDef",
		'CodeFileName', "Code/FUNCTION_ChangeUnitDataDef.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "FUNCTION_MGSetup",
		'comment', "---- unfinished",
		'CodeFileName', "Code/FUNCTION_MGSetup.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "FUNCTIONS_SignaturesCustomScoring",
		'CodeFileName', "Code/FUNCTIONS_SignaturesCustomScoring.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "FUNCTION_CustomArchetypeFunc",
		'CodeFileName', "Code/FUNCTION_CustomArchetypeFunc.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "PROPERTIES_Unit",
		'CodeFileName', "Code/PROPERTIES_Unit.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_AIPrecalcDamageScore",
		'CodeFileName', "Code/SOURCE_AIPrecalcDamageScore.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_AICalcAttacksandAim",
		'CodeFileName', "Code/SOURCE_AICalcAttacksandAim.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_SelectArchetype",
		'CodeFileName', "Code/SOURCE_SelectArchetype.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_AICreateContext",
		'comment', "--- logic for stance ap",
		'CodeFileName', "Code/SOURCE_AICreateContext.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_AIGetAttackArgs",
		'CodeFileName', "Code/SOURCE_AIGetAttackArgs.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_AIGetBias",
		'comment', "---- Not used",
		'CodeFileName', "Code/SOURCE_AIGetBias.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_AISelectAction",
		'CodeFileName', "Code/SOURCE_AISelectAction.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "SOURCE_AIEvalZones",
		'CodeFileName', "Code/SOURCE_AIEvalZones.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "vanilla_archetype_functions_forconsult",
		'CodeFileName', "Code/vanilla_archetype_functions_forconsult.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "vanilla_action_functions_forconsult1",
		'CodeFileName', "Code/vanilla_action_functions_forconsult1.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "AIPrecalcConeTargetZones",
		'CodeFileName', "Code/AIPrecalcConeTargetZones.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "AIScoreReachableVoxels",
		'CodeFileName', "Code/AIScoreReachableVoxels.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "eval_dest",
		'CodeFileName', "Code/eval_dest.lua",
	}),
	PlaceObj('ModItemCode', {
		'name', "Test",
		'CodeFileName', "Code/Test.lua",
	}),
	PlaceObj('ModItemOptionToggle', {
		'name', "ImproveExplosiveStat",
		'DisplayName', "Improve Explosive Stat",
		'Help', "This option will moderately improve the enemies Explosive stat. Specialists (like Grenadier) will have a bigger boost. Highly recommended if using Rato's Explosive Overhaul 2. Restart after applying.",
		'DefaultValue', true,
	}),
	PlaceObj('ModItemOptionToggle', {
		'name', "AddHWStoGunners",
		'DisplayName', "Add HWS to Gunners",
		'Help', "Add Heavy Weapons Specialist perk to enemy Machine Gunners",
		'DefaultValue', true,
	}),
	PlaceObj('ModItemOptionToggle', {
		'name', "AddFlares",
		'DisplayName', "Add Flares",
		'Help', "Add Flares to enemies at night",
		'DefaultValue', true,
	}),
	PlaceObj('ModItemOptionToggle', {
		'name', "CUAELoreProgression",
		'DisplayName', "CUAE Lore Friendly Weapons",
		'Help', "When using CUAE, enable a (subjective) lore friendly weapon progression based on unit affiliation.",
		'DefaultValue', true,
	}),
	PlaceObj('ModItemLootDef', {
		group = "Default",
		id = "FLARES",
		loot = "all",
		PlaceObj('LootEntryInventoryItem', {
			item = "FlareStick",
			stack_max = 10,
			stack_min = 10,
		}),
	}),
	PlaceObj('ModItemLootDef', {
		group = "Default",
		id = "he",
		loot = "all",
		PlaceObj('LootEntryInventoryItem', {
			item = "HE_Grenade",
			stack_max = 10,
			stack_min = 10,
		}),
	}),
	PlaceObj('ModItemFolder', {
		'name', "Tests",
	}, {
		PlaceObj('ModItemUnitDataCompositeDef', {
			'Group', "Adonis",
			'Id', "AdonisSniper_Elite_copy",
			'object_class', "UnitData",
			'Health', 71,
			'Agility', 90,
			'Dexterity', 100,
			'Strength', 85,
			'Wisdom', 80,
			'Leadership', 20,
			'Marksmanship', 80,
			'Mechanical', 50,
			'Explosives', 42,
			'Medical', 53,
			'Portrait', "UI/EnemiesPortraits/AdonisSniper",
			'Name', T(652358849761, --[[ModItemUnitDataCompositeDef AdonisSniper_Elite_copy Name]] "Elite Marksman"),
			'Randomization', true,
			'elite', true,
			'eliteCategory', "Foreigners",
			'Affiliation', "Adonis",
			'StartingLevel', 5,
			'neutral_retaliate', true,
			'AIKeywords', {
				"Sniper",
			},
			'role', "Marksman",
			'MaxAttacks', 1,
			'PickCustomArchetype', function (self, proto_context)  end,
			'MaxHitPoints', 50,
			'StartingPerks', {
				"Deadeye",
				"Shatterhand",
			},
			'AppearancesList', {
				PlaceObj('AppearanceWeight', {
					'Preset', "Adonis_Marksman",
				}),
			},
			'Equipment', {
				"AdonisSniper",
			},
			'AdditionalGroups', {
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "AdonisMale_1",
				}),
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "AdonisMale_2",
				}),
			},
			'Tier', "Veteran",
			'pollyvoice', "Joey",
			'gender', "Male",
			'VoiceResponseId', "AdonisAssault",
		}),
		PlaceObj('ModItemUnitDataCompositeDef', {
			'Group', "Legion",
			'Id', "LegionGrenadier_copy",
			'object_class', "UnitData",
			'Health', 53,
			'Agility', 80,
			'Dexterity', 30,
			'Strength', 53,
			'Wisdom', 14,
			'Leadership', 14,
			'Marksmanship', 43,
			'Mechanical', 0,
			'Explosives', 25,
			'Medical', 0,
			'Portrait', "UI/EnemiesPortraits/LegionDemo",
			'BigPortrait', "UI/Enemies/LegionRaider",
			'Name', T(757912188960, --[[ModItemUnitDataCompositeDef LegionGrenadier_copy Name]] "Grenadier"),
			'Randomization', true,
			'Affiliation', "Legion",
			'StartingLevel', 2,
			'neutral_retaliate', true,
			'AIKeywords', {
				"Explosives",
				"MobileShot",
			},
			'archetype', "RATOAI_Demolition",
			'role', "Demolitions",
			'CanManEmplacements', false,
			'MaxAttacks', 1,
			'PickCustomArchetype', function (self, proto_context)  end,
			'MaxHitPoints', 50,
			'StartingPerks', {
				"Throwing",
				"MinFreeMove",
			},
			'AppearancesList', {
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Demolishion",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Demolishion02",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Demolishion03",
				}),
			},
			'Equipment', {
				"he",
				"Grunty",
			},
			'AdditionalGroups', {
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_1",
				}),
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_2",
				}),
			},
			'pollyvoice', "Russell",
			'gender', "Male",
			'VoiceResponseId', "LegionRaider",
		}),
		PlaceObj('ModItemUnitDataCompositeDef', {
			'Group', "Legion",
			'Id', "LegionGunner_copy",
			'object_class', "UnitData",
			'Health', 62,
			'Agility', 65,
			'Dexterity', 39,
			'Strength', 89,
			'Wisdom', 30,
			'Leadership', 20,
			'Marksmanship', 55,
			'Mechanical', 0,
			'Explosives', 0,
			'Medical', 0,
			'Portrait', "UI/EnemiesPortraits/LegionHeavy",
			'BigPortrait', "UI/Enemies/LegionRaider",
			'Name', T(692210764193, --[[ModItemUnitDataCompositeDef LegionGunner_copy Name]] "Gunner"),
			'Randomization', true,
			'Affiliation', "Legion",
			'StartingLevel', 2,
			'neutral_retaliate', true,
			'archetype', "HeavyGunner",
			'role', "Heavy",
			'MaxAttacks', 2,
			'PickCustomArchetype', function (self, proto_context)  end,
			'MaxHitPoints', 85,
			'StartingPerks', {
				"HeavyWeaponsTraining",
			},
			'AppearancesList', {
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Heavy",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Heavy02",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Heavy03",
				}),
			},
			'Equipment', {
				"LegionGunner",
			},
			'AdditionalGroups', {
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_1",
				}),
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_2",
				}),
			},
			'pollyvoice', "Joey",
			'gender', "Male",
			'VoiceResponseId', "LegionRaider",
		}),
		PlaceObj('ModItemUnitDataCompositeDef', {
			'Group', "Legion",
			'Id', "LegionRaider_copy_copy",
			'object_class', "UnitData",
			'Agility', 70,
			'Dexterity', 34,
			'Strength', 70,
			'Wisdom', 24,
			'Leadership', 10,
			'Marksmanship', 70,
			'Mechanical', 0,
			'Explosives', 0,
			'Medical', 0,
			'Portrait', "UI/EnemiesPortraits/LegionSoldier",
			'BigPortrait', "UI/Enemies/LegionRaider",
			'Name', T(609237866839, --[[ModItemUnitDataCompositeDef LegionRaider_copy_copy Name]] "Marauder"),
			'Randomization', true,
			'Affiliation', "Legion",
			'neutral_retaliate', true,
			'AIKeywords', {
				"Soldier",
			},
			'role', "Soldier",
			'MaxAttacks', 2,
			'PickCustomArchetype', function (self, proto_context)  end,
			'MaxHitPoints', 50,
			'StartingPerks', {
				"AutoWeapons",
				"MinFreeMove",
			},
			'AppearancesList', {
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier02",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier03",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier04",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier05",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier06",
				}),
			},
			'Equipment', {
				"LegionRaiders",
			},
			'AdditionalGroups', {
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_1",
				}),
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_2",
				}),
			},
			'pollyvoice', "Joey",
			'gender', "Male",
			'VoiceResponseId', "LegionRaider",
		}),
		PlaceObj('ModItemUnitDataCompositeDef', {
			'Group', "Legion",
			'Id', "LegionRaider_copy",
			'object_class', "UnitData",
			'Agility', 70,
			'Dexterity', 34,
			'Strength', 70,
			'Wisdom', 24,
			'Leadership', 10,
			'Marksmanship', 70,
			'Mechanical', 0,
			'Explosives', 0,
			'Medical', 0,
			'Portrait', "UI/EnemiesPortraits/LegionSoldier",
			'BigPortrait', "UI/Enemies/LegionRaider",
			'Name', T(157748759185, --[[ModItemUnitDataCompositeDef LegionRaider_copy Name]] "Marauder"),
			'Randomization', true,
			'Affiliation', "Legion",
			'neutral_retaliate', true,
			'AIKeywords', {
				"Soldier",
			},
			'role', "Soldier",
			'MaxAttacks', 2,
			'PickCustomArchetype', function (self, proto_context)  end,
			'MaxHitPoints', 50,
			'StartingPerks', {
				"AutoWeapons",
				"MinFreeMove",
			},
			'AppearancesList', {
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier02",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier03",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier04",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier05",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Soldier06",
				}),
			},
			'Equipment', {
				"LegionRaiders",
				"FLARES",
			},
			'AdditionalGroups', {
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_1",
				}),
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_2",
				}),
			},
			'pollyvoice', "Joey",
			'gender', "Male",
			'VoiceResponseId', "LegionRaider",
		}),
		PlaceObj('ModItemUnitDataCompositeDef', {
			'Group', "Legion",
			'Id', "LegionScout_copy",
			'object_class', "UnitData",
			'Health', 36,
			'Agility', 79,
			'Dexterity', 73,
			'Strength', 48,
			'Wisdom', 71,
			'Leadership', 29,
			'Marksmanship', 58,
			'Mechanical', 0,
			'Explosives', 0,
			'Medical', 0,
			'Portrait', "UI/EnemiesPortraits/LegionRecon",
			'BigPortrait', "UI/Enemies/LegionRaider",
			'Name', T(933831333354, --[[ModItemUnitDataCompositeDef LegionScout_copy Name]] "Scout"),
			'Randomization', true,
			'Affiliation', "Legion",
			'StartingLevel', 2,
			'neutral_retaliate', true,
			'AIKeywords', {
				"Flank",
				"RunAndGun",
			},
			'archetype', "Skirmisher",
			'role', "Recon",
			'OpeningAttackType', "Overwatch",
			'MaxAttacks', 2,
			'PickCustomArchetype', function (self, proto_context)  end,
			'MaxHitPoints', 50,
			'AppearancesList', {
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Recon",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Recon02",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Recon03",
				}),
			},
			'Equipment', {
				"LegionScout",
			},
			'AdditionalGroups', {
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_1",
				}),
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_2",
				}),
			},
			'pollyvoice', "Joey",
			'gender', "Male",
			'VoiceResponseId', "LegionRaider",
		}),
		PlaceObj('ModItemUnitDataCompositeDef', {
			'Group', "Legion",
			'Id', "LegionButcher_copy",
			'object_class', "UnitData",
			'Health', 50,
			'Agility', 85,
			'Dexterity', 74,
			'Strength', 47,
			'Wisdom', 19,
			'Leadership', 9,
			'Marksmanship', 15,
			'Mechanical', 0,
			'Explosives', 11,
			'Medical', 0,
			'Portrait', "UI/EnemiesPortraits/LegionStormer",
			'BigPortrait', "UI/Enemies/LegionRaider",
			'Name', T(503339752786, --[[ModItemUnitDataCompositeDef LegionButcher_copy Name]] "Butcher"),
			'Randomization', true,
			'Affiliation', "Legion",
			'StartingLevel', 2,
			'neutral_retaliate', true,
			'AIKeywords', {
				"Explosives",
			},
			'role', "Stormer",
			'CanManEmplacements', false,
			'MaxAttacks', 2,
			'PickCustomArchetype', function (self, proto_context)  end,
			'MaxHitPoints', 60,
			'StartingPerks', {
				"MeleeTraining",
				"MinFreeMove",
				"InstantAutopsy",
			},
			'AppearancesList', {
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Stormer",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Stormer02",
				}),
				PlaceObj('AppearanceWeight', {
					'Preset', "Legion_Stormer03",
				}),
			},
			'Equipment', {
				"LegionMeleeFighter",
			},
			'AdditionalGroups', {
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_1",
				}),
				PlaceObj('AdditionalGroup', {
					'Weight', 50,
					'Exclusive', true,
					'Name', "LegionMale_2",
				}),
			},
			'gender', "Male",
			'VoiceResponseId', "LegionRaider",
		}),
		}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Torso" ),
		BaseMovementWeight = 10,
		Behaviors = {
			PlaceObj('StandardAI', {
				'BiasId', "Standard",
				'EndTurnPolicies', {
					PlaceObj('AIPolicyTakeCover', {
						'RequiredKeywords', {
							"Soldier",
						},
						'Weight', 300,
					}),
					PlaceObj('AIPolicyTakeCover', {
						'RequiredKeywords', {
							"Sniper",
						},
					}),
					PlaceObj('AIPolicyDealDamage', {
						'Weight', 200,
					}),
					PlaceObj('AIPolicyCustomFlanking', {
						'RequiredKeywords', {
							"Soldier",
						},
						'Weight', 200,
						'ReserveAttackAP', "Stance",
						'OnlyTarget', true,
					}),
				},
				'TakeCoverChance', 50,
			}),
			PlaceObj('HoldPositionAI', {
				'Weight', 200,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					local score = getAIShootingStanceBehaviorSelectionScore(unit, proto_context)
					return MulDivRound(score, self.Weight, 100)
				end,
				'TakeCoverChance', 0,
			}),
			PlaceObj('PositioningAI', {
				'BiasId', "SoldierFlanking",
				'Weight', 20,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SoldierFlanking",
						'Value', -33,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'Fallback', false,
				'RequiredKeywords', {
					"Soldier",
				},
				'OptLocWeight', 20,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyCustomFlanking', {
						'Required', true,
						'ReserveAttackAP', "Stance",
						'visibility_mode', "team",
					}),
					PlaceObj('AIPolicyTakeCover', {
						'Weight', 200,
						'Required', true,
					}),
				},
				'TakeCoverChance', 100,
				'VoiceResponse', "AIFlanking",
			}),
		},
		Comment = "Keywords: Soldier, Sniper, Control, Ordnance, Smoke, Explosives",
		MoveStance = "Crouch",
		OptLocPolicies = {
			PlaceObj('AIPolicyHighGround', {
				'RequiredKeywords', {
					"Sniper",
				},
				'Weight', 300,
			}),
			PlaceObj('AIPolicyTakeCover', nil),
			PlaceObj('AIPolicyLosToEnemy', {
				'Weight', 400,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 60,
				'RangeMin', 10,
				'RangeMax', 25,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'RangeMin', 26,
				'RangeMax', 49,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 20,
				'RangeMin', 50,
				'RangeMax', 100,
			}),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Autofire",
				'Weight', 150,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return AutoFire_CustomScoring(self, context)
				end,
				'action_id', "AutoFire",
				'Aiming', "Maximum",
				'AttackTargeting', set( "Torso" ),
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "GroinShot",
				'Weight', 150,
				'CustomScoring', function (self, context)
					return SingleShotTargeted_CustomScoring(self, context)
				end,
				'Aiming', "Remaining AP",
				'AttackTargeting', set( "Groin" ),
			}),
			PlaceObj('AIConeAttack', {
				'BiasId', "Overwatch",
				'Weight', 150,
				'CustomScoring', function (self, context)
					return Overwatch_CustomScoring(self, context)
				end,
				'team_score', 0,
				'min_score', 140,
				'enemy_cover_mod', 80,
				'action_id', "Overwatch",
			}),
			PlaceObj('AIActionMobileShot', {
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
				'action_id', "RunAndGun",
			}),
			PlaceObj('AIActionMobileShot', {
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
			}),
			PlaceObj('AIActionThrowFlare', {
				'BiasId', "FlareThrow",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "FlareThrow",
						'Effect', "disable",
						'Period', 0,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "FlareThrow",
						'Value', -30,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'CustomScoring', function (self, context)
					 return self.Weight, false, self.Priority
				end,
				'team_score', 0,
				'self_score_mod', 0,
				'min_score', 100,
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Headshot",
				'Weight', 200,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Headshot",
						'Effect', "disable",
						'Period', 0,
					}),
				},
				'RequiredKeywords', {
					"Sniper",
				},
				'CustomScoring', function (self, context)
					return SingleShotTargeted_CustomScoring(self, context)
				end,
				'Aiming', "Remaining AP",
				'AttackTargeting', set( "Head" ),
			}),
			PlaceObj('AIActionPinDown', {
				'BiasId', "PinDownAttack",
				'Weight', 50,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "PinDownAttack",
						'Effect', "disable",
						'Value', -50,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Sniper",
				},
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "AssaultGrenadeThrow",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "AssaultGrenadeThrow",
						'Effect', "disable",
						'Period', 0,
					}),
				},
				'self_score_mod', -1000,
				'AllowedAoeTypes', set( "fire", "none", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "SmokeGrenade",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Effect', "disable",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Value', -50,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'enemy_score', 0,
				'team_score', 100,
				'self_score_mod', 100,
				'MinDist', 0,
				'AllowedAoeTypes', set( "smoke" ),
			}),
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "LauncherFire",
				'Weight', 150,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "LauncherFire",
						'Effect', "disable",
						'Period', 0,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "LauncherFire",
						'Value', -20,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'self_score_mod', -1000,
				'MinDist', 5000,
				'LimitRange', true,
				'MaxTargetRange', 30,
			}),
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "RocketFire",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "RocketFire",
						'Effect', "disable",
					}),
				},
				'self_score_mod', -1000,
				'MinDist', 5000,
				'action_id', "RocketLauncherFire",
				'LimitRange', true,
				'MaxTargetRange', 30,
			}),
			PlaceObj('AIConeAttack', {
				'BiasId', "SpamOverwatch",
				'Weight', 200,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SpamOverwatch",
						'Effect', "disable",
						'Value', -50,
						'ApplyTo', "Team",
					}),
				},
				'RequiredKeywords', {
					"Control",
				},
				'CustomScoring', function (self, context)
					return Overwatch_CustomScoring(self, context)
				end,
				'team_score', 0,
				'min_score', 100,
				'action_id', "Overwatch",
			}),
			PlaceObj('AIActionCharge', {
				'DestPreference', "nearest",
			}),
		},
		TargetScoreRandomization = 10,
		group = "Default",
		id = "Soldier",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Torso" ),
		Behaviors = {
			PlaceObj('StandardAI', {
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyTakeCover', {
						'visibility_mode', "team",
					}),
					PlaceObj('AIPolicyCustomFlanking', {
						'ReserveAttackAP', "AP",
						'visibility_mode', "team",
						'OnlyTarget', true,
					}),
				},
				'TakeCoverChance', 50,
			}),
			PlaceObj('PositioningAI', {
				'BiasId', "Flanking",
				'Weight', 50,
				'Fallback', false,
				'OptLocWeight', 20,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyFlanking', {
						'Weight', 150,
						'ReserveAttackAP', true,
					}),
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyCustomFlanking', {
						'Required', true,
						'ReserveAttackAP', "AP",
						'visibility_mode', "team",
						'ScalePerDistance', true,
					}),
					PlaceObj('AIPolicyTakeCover', {
						'Required', true,
						'visibility_mode', "team",
					}),
				},
				'TakeCoverChance', 100,
				'VoiceResponse', "AIFlanking",
			}),
			PlaceObj('HoldPositionAI', {
				'Weight', 50,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					local score = getAIShootingStanceBehaviorSelectionScore(unit, proto_context)
					return MulDivRound(score, self.Weight, 100)
				end,
				'TakeCoverChance', 0,
			}),
		},
		Comment = "Keywords: Flank, Explosives",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 150,
				'RangeBase', "Absolute",
				'RangeMin', 6,
				'RangeMax', 8,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'RangeBase', "Absolute",
				'RangeMin', 9,
				'RangeMax', 18,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
			PlaceObj('AIPolicyTakeCover', nil),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIActionMobileShot', {
				'BiasId', "RunAndGun",
				'Weight', 200,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
				'action_id', "RunAndGun",
			}),
			PlaceObj('AIActionMobileShot', {
				'BiasId', "MobileShot",
				'Weight', 200,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Autofire",
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return AutoFire_CustomScoring(self, context)
				end,
				'action_id', "AutoFire",
				'Aiming', "Maximum",
				'AttackTargeting', set( "Torso" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "ExplosiveGrenadeThrow",
				'min_score', 130,
				'enemy_cover_mod', 50,
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "AOEGrenadeThrow",
				'AllowedAoeTypes', set( "fire", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "SmokeGrenade",
				'Weight', 80,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Effect', "disable",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Value', -50,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'enemy_score', 0,
				'team_score', 100,
				'self_score_mod', 100,
				'MinDist', 0,
				'AllowedAoeTypes', set( "smoke" ),
			}),
			PlaceObj('AIActionThrowFlare', {
				'BiasId', "FlareThrow",
				'Weight', 80,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "FlareThrow",
						'Effect', "disable",
						'Period', 0,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "FlareThrow",
						'Value', -30,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'team_score', 0,
				'self_score_mod', 0,
				'min_score', 100,
				'TargetLastAttackPos', true,
			}),
		},
		TargetScoreRandomization = 10,
		TargetingPolicies = {
			PlaceObj('AITargetingEnemyHealth', {
				'Health', 50,
			}),
			PlaceObj('AITargetingEnemyWeapon', {
				'EnemyWeapon', "Sniper",
			}),
		},
		group = "Simplified",
		id = "Skirmisher",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Torso" ),
		Behaviors = {
			PlaceObj('StandardAI', {
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyTakeCover', {
						'visibility_mode', "team",
					}),
				},
				'TakeCoverChance', 0,
			}),
			PlaceObj('PositioningAI', {
				'BiasId', "RetreatingMarksman",
				'Fallback', false,
				'OptLocWeight', 20,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyTakeCover', {
						'Required', true,
						'visibility_mode', "team",
					}),
					PlaceObj('AIPolicyWeaponRange', {
						'Weight', 500,
						'Required', true,
						'RangeBase', "Absolute",
						'RangeMin', 10,
						'RangeMax', 10,
					}),
				},
				'TakeCoverChance', 50,
			}),
			PlaceObj('HoldPositionAI', {
				'Weight', 10,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					local score = getAIShootingStanceBehaviorSelectionScore(unit, proto_context)
					return MulDivRound(score, self.Weight, 100)
				end,
				'TakeCoverChance', 0,
			}),
		},
		Comment = "Keywords: Flank, Explosives",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 200,
				'RangeBase', "Absolute",
				'RangeMin', 10,
				'RangeMax', 15,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
			PlaceObj('AIPolicyTakeCover', nil),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIActionMobileShot', {
				'BiasId', "RunAndGun",
				'Weight', 500,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
				'action_id', "RunAndGun",
			}),
			PlaceObj('AIActionMobileShot', {
				'BiasId', "MobileShot",
				'Weight', 500,
				'Priority', true,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
			}),
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Autofire",
				'Weight', 50,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return AutoFire_CustomScoring(self, context)
				end,
				'action_id', "AutoFire",
				'Aiming', "Maximum",
				'AttackTargeting', set( "Torso" ),
			}),
		},
		TargetScoreRandomization = 10,
		group = "RatoAI",
		id = "RATOAI_RetreatingMarksman",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Torso" ),
		Behaviors = {
			PlaceObj('StandardAI', {
				'OptLocWeight', 200,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyWeaponRange', {
						'RangeBase', "Absolute",
						'RangeMin', 8,
						'RangeMax', 10,
					}),
					PlaceObj('AIPolicyTakeCover', {
						'visibility_mode', "team",
					}),
				},
				'TakeCoverChance', 50,
			}),
			PlaceObj('HoldPositionAI', {
				'Weight', 10,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					local score = getAIShootingStanceBehaviorSelectionScore(unit, proto_context)
					return MulDivRound(score, self.Weight, 100)
				end,
				'TakeCoverChance', 0,
			}),
			PlaceObj('PositioningAI', {
				'BiasId', "Flanking",
				'Weight', 50,
				'Fallback', false,
				'OptLocWeight', 20,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyCustomFlanking', {
						'Required', true,
						'ReserveAttackAP', "Stance",
						'visibility_mode', "team",
					}),
					PlaceObj('AIPolicyTakeCover', {
						'Required', true,
						'visibility_mode', "team",
					}),
				},
				'TakeCoverChance', 100,
				'VoiceResponse', "AIFlanking",
			}),
		},
		Comment = "Keywords: Flank, Explosives",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 200,
				'RangeBase', "Absolute",
				'RangeMin', 8,
				'RangeMax', 10,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 0,
				'RangeBase', "Absolute",
				'RangeMin', 11,
				'RangeMax', 15,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 100,
		SignatureActions = {
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "ExplosiveGrenadeThrow",
				'Weight', 300,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "ExplosiveGrenadeThrow",
						'Effect', "disable",
						'Period', 0,
					}),
				},
				'min_score', 100,
				'enemy_cover_mod', 50,
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "AOEGrenadeThrow",
				'AllowedAoeTypes', set( "fire", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "SmokeGrenade",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Effect', "disable",
						'Period', 0,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Value', -50,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'enemy_score', 0,
				'team_score', 100,
				'self_score_mod', 100,
				'MinDist', 0,
				'AllowedAoeTypes', set( "smoke" ),
			}),
			PlaceObj('AIActionThrowFlare', {
				'BiasId', "FlareThrow",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "FlareThrow",
						'Effect', "disable",
						'Period', 0,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "FlareThrow",
						'Value', -30,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'team_score', 0,
				'self_score_mod', 0,
				'min_score', 100,
			}),
		},
		TargetScoreRandomization = 10,
		group = "RatoAI",
		id = "RATOAI_Demolition",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Torso" ),
		Behaviors = {
			PlaceObj('StandardAI', {
				'Score', function (self, unit, proto_context, debug_data)
					return self.Weight
					--return getStandardBehaviorScore_HeavyGunner(self, unit, proto_context, debug_data)
				end,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', {
						'Weight', 200,
					}),
					PlaceObj('AIPolicyWeaponRange', {
						'RangeMin', 40,
						'RangeMax', 60,
					}),
					PlaceObj('AIPolicyMGSetupAP', {
						'Weight', 150,
					}),
				},
				'SignatureActions', {
					PlaceObj('AIActionMGSetup', {
						'Weight', 660,
						'Priority', true,
						'CustomScoring', function (self, context)
							local unit = context.unit
							if unit:HasStatusEffect("ManningEmplacement") or unit:HasStatusEffect("StationedMachineGun") then
								return 0, true, false   
							end
							
							return self.Weight, false, self.Priority
						end,
						'team_score', 0,
						'min_score', 0,
						'enemy_cover_mod', 120,
						'cur_zone_mod', 140,
					}),
					PlaceObj('AIActionMGBurstFire', {
						'Weight', 200,
						'CustomScoring', function (self, context)
							                return self.Weight, false, self.Priority
						end,
						'Aiming', "Maximum",
						'AttackTargeting', set( "Torso" ),
					}),
				},
				'TargetingPolicies', {
					PlaceObj('AITargetingEnemyInCover', nil),
				},
				'TakeCoverChance', 0,
				'override_attack_id', "BurstFire",
				'override_cost_id', "MGSetup",
			}),
			PlaceObj('PositioningAI', {
				'Weight', 500,
				'Priority', true,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					if not Get_HeavyGunnerShouldUsePositioningBehavior(self, unit, proto_context, debug_data) then
						return 0
					end
					
					unit.ai_context = unit.ai_context or AICreateContext(unit, proto_context)
					local dest, score = AIScoreReachableVoxels(unit.ai_context, self.EndTurnPolicies, 0)
					return MulDivRound(score, self.Weight, 100)
				end,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyLastEnemyPos', {
						'Required', true,
					}),
				},
				'SignatureActions', {
					PlaceObj('AIActionMGSetup', {
						'Weight', 500,
						'Priority', true,
						'team_score', 0,
						'min_score', 0,
						'enemy_cover_mod', 100,
						'cur_zone_mod', 140,
					}),
				},
				'TakeCoverChance', 50,
			}),
			PlaceObj('HoldPositionAI', {
				'Weight', 250,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					if unit:HasStatusEffect("ManningEmplacement") or unit:HasStatusEffect("StationedMachineGun") then
						local score = getAIShootingStanceBehaviorSelectionScore(unit, proto_context)
						return MulDivRound(score, self.Weight, 100)
					end
					
					return 0
				end,
				'SignatureActions', {
					PlaceObj('AIActionMGBurstFire', {
						'Weight', 200,
						'Aiming', "Maximum",
						'AttackTargeting', set( "Torso" ),
					}),
				},
				'TargetingPolicies', {
					PlaceObj('AITargetingEnemyInCover', nil),
				},
				'TakeCoverChance', 0,
			}),
		},
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'RangeMin', 40,
				'RangeMax', 60,
			}),
			PlaceObj('AIPolicyLosToEnemy', {
				'Weight', 200,
			}),
		},
		OptLocSearchRadius = 100,
		PrefStance = "Prone",
		TargetScoreRandomization = 10,
		TargetingPolicies = {
			PlaceObj('AITargetingEnemyHealth', {
				'Health', 50,
				'AboveHealth', true,
			}),
			PlaceObj('AITargetingEnemyInCover', nil),
		},
		comment = "Pq as signatures estao no Comportamento e não no Arquetipo???",
		group = "Simplified",
		id = "HeavyGunner",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Neck", "Torso" ),
		BaseMovementWeight = 10,
		Behaviors = {
			PlaceObj('StandardAI', {
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
					PlaceObj('AIPolicyTakeCover', {
						'Weight', 40,
					}),
				},
				'TakeCoverChance', 0,
			}),
			PlaceObj('HoldPositionAI', {
				'Weight', 10,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					local score = getAIShootingStanceBehaviorSelectionScore(unit, proto_context)
					return MulDivRound(score, self.Weight, 100)
				end,
				'TakeCoverChance', 0,
			}),
		},
		Comment = "Keywords: Explosives",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 200,
				'RangeBase', "Melee",
				'RangeMin', 0,
				'RangeMax', 6,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 80,
		SignatureActions = {
			PlaceObj('AIActionMobileShot', {
				'BiasId', "RunAndGun",
				'Priority', true,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
				'action_id', "RunAndGun",
			}),
			PlaceObj('AIActionMobileShot', {
				'BiasId', "MobileShot",
				'Priority', true,
				'NotificationText', "",
				'CustomScoring', function (self, context)
					return MobileAttack_CustomScoring(self, context)
				end,
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "StunGrenade",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "StunGrenade",
						'Effect', "disable",
					}),
				},
				'min_score', 100,
				'MinDist', 3000,
				'AllowedAoeTypes', set( "fire", "none", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "Nova",
				'Weight', 300,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Nova",
						'Effect', "disable",
					}),
				},
				'RequiredKeywords', {
					"Nova",
				},
				'team_score', 0,
				'self_score_mod', 100,
				'MinDist', 0,
				'MaxDist', 3000,
				'AllowedAoeTypes', set( "fire", "none", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "SmokeGrenade",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Effect', "disable",
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "SmokeGrenade",
						'Value', -50,
						'Period', 0,
						'ApplyTo', "Team",
					}),
				},
				'enemy_score', 0,
				'team_score', 100,
				'self_score_mod', 100,
				'MinDist', 0,
				'AllowedAoeTypes', set( "smoke" ),
			}),
		},
		TargetChangePolicy = "restart",
		TargetScoreRandomization = 10,
		group = "Simplified",
		id = "Brute",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Arms", "Torso" ),
		BaseAttackWeight = 80,
		BaseMovementWeight = 10,
		Behaviors = {
			PlaceObj('StandardAI', {
				'BiasId', "Standard",
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', {
						'Weight', 20,
					}),
					PlaceObj('AIPolicyTakeCover', {
						'visibility_mode', "team",
					}),
					PlaceObj('AIPolicyWeaponRange', {
						'RangeMin', 60,
						'RangeMax', 100,
					}),
				},
				'SignatureActions', {
					PlaceObj('AIActionMobileShot', {
						'Priority', true,
						'NotificationText', "",
						'CustomScoring', function (self, context)
							return MobileAttack_CustomScoring(self, context)
						end,
						'action_id', "RunAndGun",
					}),
					PlaceObj('AIActionMobileShot', {
						'Priority', true,
						'NotificationText', "",
						'CustomScoring', function (self, context)
							return MobileAttack_CustomScoring(self, context)
						end,
					}),
				},
				'TakeCoverChance', 50,
			}),
			PlaceObj('StandardAI', {
				'BiasId', "Healer",
				'Priority', true,
				'Fallback', false,
				'Score', function (self, unit, proto_context, debug_data)
					for _, ally in ipairs(unit.team.units) do
						if not ally:IsDead() and ally.HitPoints < MulDivRound(ally.MaxHitPoints, 70, 100) then
							return self.Weight
						end
					end
					return 0
				end,
				'turn_phase', "Late",
				'OptLocWeight', 1,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyHealingRange', {
						'Weight', 300,
						'CanUseMod', 1000,
					}),
				},
				'SignatureActions', {
					PlaceObj('AIActionBandage', {
						'Priority', true,
						'RequiredKeywords', {
							"Heal",
						},
						'CanUseMod', 1000,
					}),
					PlaceObj('AIActionStim', {
						'Priority', true,
						'RequiredKeywords', {
							"Stim",
						},
						'TargetRules', {
							PlaceObj('AIStimRule', {
								'Keyword', "Flank",
								'Weight', 100,
							}),
							PlaceObj('AIStimRule', {
								'Keyword', "Control",
								'Weight', 50,
							}),
							PlaceObj('AIStimRule', {
								'Keyword', "Explosives",
								'Weight', 50,
							}),
							PlaceObj('AIStimRule', {
								'Keyword', "Ordnance",
								'Weight', 50,
							}),
							PlaceObj('AIStimRule', {
								'Keyword', "RunAndGun",
								'Weight', 100,
							}),
						},
					}),
				},
				'TakeCoverChance', 0,
			}),
		},
		OptLocPolicies = {
			PlaceObj('AIPolicyTakeCover', {
				'visibility_mode', "team",
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		TargetScoreRandomization = 10,
		TargetingPolicies = {
			PlaceObj('AITargetingCancelShot', {
				'Weight', 200,
			}),
		},
		group = "Simplified",
		id = "Medic",
	}),
	PlaceObj('ModItemAIArchetype', {
		Behaviors = {
			PlaceObj('StandardAI', {
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', {
						'CheckLOS', false,
					}),
				},
			}),
		},
		MoveStance = "Crouch",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'RangeBase', "Absolute",
				'RangeMin', 20,
				'RangeMax', 50,
			}),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "MortarShot",
				'Priority', true,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "MortarShot",
						'Effect', "disable",
					}),
				},
				'team_score', 0,
				'self_score_mod', 0,
				'MinDist', 12000,
				'action_id', "Bombard",
			}),
		},
		TargetScoreRandomization = 10,
		group = "Simplified",
		id = "Artillery_copy",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Arms", "Groin", "Legs", "Torso" ),
		BaseMovementWeight = 10,
		Behaviors = {
			PlaceObj('StandardAI', {
				'BiasId', "Standard",
				'Weight', 150,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyTakeCover', {
						'Weight', 50,
						'visibility_mode', "team",
					}),
					PlaceObj('AIPolicyDealDamage', nil),
				},
			}),
		},
		MoveStance = "Crouch",
		OptLocPolicies = {
			PlaceObj('AIPolicyTakeCover', nil),
			PlaceObj('AIPolicyLosToEnemy', {
				'Weight', 300,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 10,
				'RangeMin', 10,
				'RangeMax', 25,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 20,
				'RangeMin', 26,
				'RangeMax', 49,
			}),
			PlaceObj('AIPolicyWeaponRange', {
				'RangeMin', 50,
				'RangeMax', 100,
			}),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIActionHeavyWeaponAttack', {
				'BiasId', "PierreGuardLauncherFire",
				'Weight', 1000,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "PierreGuardLauncherFire",
						'Effect', "disable",
						'Period', 10,
					}),
					PlaceObj('AIBiasModification', {
						'BiasId', "PierreGuardLauncherFire",
						'Effect', "disable",
						'Value', -50,
						'Period', 10,
						'ApplyTo', "Team",
					}),
				},
				'self_score_mod', -1000,
				'min_score', 100,
				'MinDist', 5000,
			}),
		},
		TargetScoreRandomization = 10,
		group = "Lieutenants",
		id = "PierreGuard_copy",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseAttackTargeting = set( "Neck", "Torso" ),
		BaseMovementWeight = 10,
		Behaviors = {
			PlaceObj('StandardAI', {
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
				},
				'TakeCoverChance', 0,
			}),
		},
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'RangeBase', "Melee",
				'RangeMin', 0,
				'RangeMax', 6,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 80,
		SignatureActions = {
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "StunGrenade",
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "StunGrenade",
						'Effect', "disable",
					}),
				},
				'min_score', 100,
				'MinDist', 3000,
				'AllowedAoeTypes', set( "fire", "none", "teargas", "toxicgas" ),
			}),
			PlaceObj('AIActionCharge', {
				'BiasId', "PierreCharge",
				'Weight', 300,
			}),
		},
		TargetChangePolicy = "restart",
		TargetScoreRandomization = 10,
		group = "Lieutenants",
		id = "Pierre_copy",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseMovementWeight = 10,
		Behaviors = {
			PlaceObj('StandardAI', {
				'BiasId', "Standard",
				'Weight', 80,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyTakeCover', {
						'Weight', 50,
						'visibility_mode', "team",
					}),
					PlaceObj('AIPolicyDealDamage', {
						'Weight', 400,
					}),
				},
			}),
			PlaceObj('StandardAI', {
				'Fallback', false,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', nil),
				},
				'SignatureActions', {
					PlaceObj('AIAttackSingleTarget', {
						'BiasId', "Autofire",
						'Weight', 70,
						'Priority', true,
						'NotificationText', "",
						'action_id', "AutoFire",
						'AttackTargeting', set( "Torso" ),
					}),
				},
			}),
		},
		Comment = "basic flank and attack AI",
		OptLocPolicies = {
			PlaceObj('AIPolicyWeaponRange', {
				'Weight', 600,
				'RangeBase', "Absolute",
				'RangeMin', 4,
				'RangeMax', 8,
			}),
			PlaceObj('AIPolicyHighGround', {
				'Weight', 30,
			}),
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 80,
		PrefStance = "Crouch",
		SignatureActions = {
			PlaceObj('AIAttackSingleTarget', {
				'BiasId', "Autofire",
				'Weight', 70,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "Autofire",
						'Value', -500,
						'Period', 2,
					}),
				},
				'NotificationText', "",
				'action_id', "AutoFire",
				'Aiming', "Remaining AP",
				'AttackTargeting', set( "Torso" ),
			}),
			PlaceObj('AIActionThrowGrenade', {
				'BiasId', "WildThrowGrenade",
				'Weight', 300,
				'Priority', true,
				'OnActivationBiases', {
					PlaceObj('AIBiasModification', {
						'BiasId', "WildThrowGrenade",
						'Effect', "disable",
						'Value', -300,
						'Period', 0,
					}),
				},
				'team_score', 0,
				'self_score_mod', -1000,
				'AllowedAoeTypes', set( "fire", "none", "teargas", "toxicgas" ),
			}),
		},
		TargetingPolicies = {
			PlaceObj('AITargetingCancelShot', {
				'Weight', 80,
			}),
		},
		group = "Lieutenants",
		id = "TheMajor_copy",
	}),
	PlaceObj('ModItemAIArchetype', {
		BaseMovementWeight = 10,
		Behaviors = {
			PlaceObj('StandardAI', {
				'TakeCoverChance', 0,
			}),
		},
		Comment = "used to advance toward last known enemy location",
		OptLocPolicies = {
			PlaceObj('AIPolicyLastEnemyPos', nil),
		},
		OptLocSearchRadius = 80,
		comment = "--- Talvez essa sirva pra aproximar",
		group = "System",
		id = "Scout_LastLocation_copy",
	}),
	PlaceObj('ModItemAIArchetype', {
		Behaviors = {
			PlaceObj('StandardAI', {
				'Priority', true,
				'Comment', "breaking pindown",
				'Score', function (self, unit, proto_context, debug_data)
					local enemies = {}
					for _, descr in pairs(g_Pindown) do
						if descr.target == self then
							enemies[#enemies + 1] = enemy
						end
					end
					return #enemies > 0 and self.Weight or 0
				end,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyLosToEnemy', {
						'Invert', true,
					}),
					PlaceObj('AIPolicyDealDamage', nil),
				},
				'TakeCoverChance', 0,
			}),
			PlaceObj('StandardAI', {
				'Comment', "fallback (aggressive)",
				'Fallback', false,
				'EndTurnPolicies', {
					PlaceObj('AIPolicyDealDamage', {
						'Weight', 600,
					}),
					PlaceObj('AIPolicyWeaponRange', {
						'RangeBase', "Absolute",
						'RangeMin', 0,
						'RangeMax', 5,
					}),
				},
				'TakeCoverChance', 0,
			}),
		},
		OptLocPolicies = {
			PlaceObj('AIPolicyLosToEnemy', nil),
		},
		OptLocSearchRadius = 80,
		group = "System",
		id = "PinnedDown_copy",
	}),
	PlaceObj('ModItemFolder', {
		'name', "New folder",
	}, {
		PlaceObj('ModItemAIArchetype', {
			BaseAttackTargeting = set( "Arms", "Legs", "Torso" ),
			BaseAttackWeight = 50,
			BaseMovementWeight = 0,
			Behaviors = {
				PlaceObj('HoldPositionAI', {
					'BiasId', "HoldPositionBehavior",
					'EndTurnPolicies', {
						PlaceObj('AIPolicyDealDamage', nil),
					},
					'TakeCoverChance', 0,
				}),
			},
			OptLocPolicies = {
				PlaceObj('AIPolicyLosToEnemy', nil),
			},
			OptLocSearchRadius = 80,
			PrefStance = "Crouch",
			SignatureActions = {
				PlaceObj('AIAttackSingleTarget', {
					'BiasId', "Autofire",
					'OnActivationBiases', {
						PlaceObj('AIBiasModification', {
							'BiasId', "Autofire",
							'Effect', "disable",
						}),
					},
					'NotificationText', "",
					'action_id', "AutoFire",
					'Aiming', "Remaining AP",
					'AttackTargeting', set( "Torso" ),
				}),
			},
			TargetScoreRandomization = 10,
			group = "Simplified",
			id = "Turret_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			BaseAttackWeight = 0,
			Behaviors = {
				PlaceObj('StandardAI', {
					'EndTurnPolicies', {
						PlaceObj('AIPolicyDealDamage', {
							'Weight', 600,
						}),
						PlaceObj('AIPolicyWeaponRange', {
							'Weight', 300,
							'RangeBase', "Absolute",
							'RangeMin', 2,
							'RangeMax', 2,
						}),
					},
				}),
			},
			MoveStance = "",
			OptLocPolicies = {
				PlaceObj('AIPolicyWeaponRange', {
					'RangeBase', "Absolute",
					'RangeMin', 2,
					'RangeMax', 2,
				}),
				PlaceObj('AIPolicyLosToEnemy', nil),
			},
			OptLocSearchRadius = 80,
			PrefStance = "",
			TargetChangePolicy = "restart",
			group = "Beasts",
			id = "Beast_Crocodile_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			BaseAttackWeight = 0,
			Behaviors = {
				PlaceObj('StandardAI', {
					'EndTurnPolicies', {
						PlaceObj('AIPolicyDealDamage', {
							'Weight', 600,
						}),
					},
					'SignatureActions', {
						PlaceObj('AIActionHyenaCharge', nil),
					},
				}),
			},
			MoveStance = "",
			OptLocPolicies = {
				PlaceObj('AIPolicyWeaponRange', {
					'RangeBase', "Melee",
					'RangeMin', 1000,
					'RangeMax', 1000,
				}),
				PlaceObj('AIPolicyLosToEnemy', nil),
			},
			OptLocSearchRadius = 80,
			PrefStance = "",
			SignatureActions = {
				PlaceObj('AIActionCharge', {
					'BiasId', "HyenaCharge",
					'Weight', 200,
					'OnActivationBiases', {
						PlaceObj('AIBiasModification', {
							'BiasId', "HyenaCharge",
							'Effect', "disable",
						}),
					},
					'ForbiddenInState', set( "RainHeavy" ),
					'DestPreference', "nearest",
				}),
			},
			TargetChangePolicy = "restart",
			group = "Beasts",
			id = "Beast_Hyena_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			Behaviors = {
				PlaceObj('CustomAI', {
					'EndTurnPolicies', {
						PlaceObj('AIPolicyTakeCover', {
							'visibility_mode', "team",
						}),
					},
					'TakeCoverChance', 100,
					'EnumDests', function (self, unit, context, debug_data)
						if g_Encounter then 
							return g_Encounter:EnumDestsInAssignedArea(unit, context)
						end
					end,
					'PickEndTurnPolicies', function (self, unit, context, debug_data)
						if g_Encounter then
							return g_Encounter:SelectEndTurnPolicies(unit, context)
						end
					end,
					'PickOptimalLoc', function (self, unit, context, debug_data)
						if g_Encounter then
							return g_Encounter:FindOptimalLocationInAssignedArea(unit, context)
						end
					end,
					'PickEndTurnLoc', function (self, unit, context, debug_data)
						AITacticCalcPathDistances(unit, context, "disable bias")
						
						local policies = self:PickEndTurnPolicies(unit, context) or self.EndTurnPolicies
						context.ai_destination = AIScoreReachableVoxels(context, policies, self.OptLocWeight, nil, "prefer")
						return true
					end,
					'SelectSignatureActions', function (self, unit, context, debug_data)
						if g_Encounter then
							return g_Encounter:SelectSignatureActions(unit, context)
						end
					end,
				}),
			},
			Comment = "generic implementation, try reaching assigned area, valid positions are in assigned & current areas only",
			group = "BossFights",
			id = "Bossfight_GuardArea_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			Behaviors = {
				PlaceObj('CustomAI', {
					'turn_phase', "Early",
					'EndTurnPolicies', {
						PlaceObj('AIPolicyTakeCover', {
							'visibility_mode', "team",
						}),
					},
					'TakeCoverChance', 100,
					'EnumDests', function (self, unit, context, debug_data)
						if not g_Encounter then return end
						
						return CorazonEnumDestsInAssignedArea(unit, context)
					end,
					'PickOptimalLoc', function (self, unit, context, debug_data)
						if g_Encounter:GetUnitArea(unit) == g_Encounter.areaFinalRoom then
							context.best_dest = GetPackedPosAndStance(unit)
							return true
						end
						
						local _, positions = CorazonGetAreaMarkerPositions(g_Encounter.areaFinalRoom)
						positions = positions or empty_table
						if #positions > 0 then
							local goto_pos = table.interaction_rand(positions, "Behavior")
							local x, y, z = point_unpack(goto_pos)
							context.best_dest = stance_pos_pack(x, y, z, StancesList.Standing)
							return true
						end
					end,
					'PickEndTurnLoc', function (self, unit, context, debug_data)
						CorazonCalcPathDistances(unit, context, "disable bias")
					end,
				}),
			},
			group = "BossFights",
			id = "Corazon_BossRetreating_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			Behaviors = {
				PlaceObj('CustomAI', {
					'EndTurnPolicies', {
						PlaceObj('AIPolicyTakeCover', {
							'visibility_mode', "team",
						}),
					},
					'TakeCoverChance', 100,
					'EnumDests', function (self, unit, context, debug_data)
						if not g_Encounter then return end
						
						return CorazonEnumDestsInAssignedArea(unit, context)
					end,
					'PickEndTurnPolicies', function (self, unit, context, debug_data)
						if IsKindOf(g_Encounter, "BossfightCorazon") then
							return g_Encounter:SelectEndTurnPolicies(unit, context)
						end
					end,
					'PickOptimalLoc', function (self, unit, context, debug_data)
						return CorazonOptimalLocationInAssignedArea(unit, context)
					end,
					'PickEndTurnLoc', function (self, unit, context, debug_data)
						CorazonCalcPathDistances(unit, context, "disable bias")
						
						local policies = self:PickEndTurnPolicies(unit, context) or self.EndTurnPolicies
						context.ai_destination = AIScoreReachableVoxels(context, policies, self.OptLocWeight, nil, "prefer")
						return true
					end,
					'SelectSignatureActions', function (self, unit, context, debug_data)
						if IsKindOf(g_Encounter, "BossfightCorazon") then
							return g_Encounter:SelectSignatureActions(unit, context)
						end
					end,
					'Execute', function (self, unit, context, debug_data)
						-- todo: set context.force_max_aim if smoke
						-- todo: swap to shotgun if in close range, out of it if not
					end,
				}),
			},
			Comment = "basic logic: move to assigned area, engange enemies in/from it until assigned elsewhere",
			group = "BossFights",
			id = "Corazon_GuardArea_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			Behaviors = {
				PlaceObj('CustomAI', {
					'EndTurnPolicies', {
						PlaceObj('AIPolicyTakeCover', {
							'visibility_mode', "team",
						}),
					},
					'TakeCoverChance', 100,
					'EnumDests', function (self, unit, context, debug_data)
						if not g_Encounter then return end
						
						return CorazonEnumDestsInAssignedArea(unit, context)
					end,
					'PickOptimalLoc', function (self, unit, context, debug_data)
						return CorazonOptimalLocationInAssignedArea(unit, context)
					end,
					'PickEndTurnLoc', function (self, unit, context, debug_data)
						CorazonCalcPathDistances(unit, context, "disable bias")
					end,
					'SelectSignatureActions', function (self, unit, context, debug_data)
						if IsKindOf(g_Encounter, "BossfightCorazon") then
							return g_Encounter:SelectSignatureActions(unit, context)
						end
					end,
					'Execute', function (self, unit, context, debug_data)
						-- todo: set context.force_max_aim if smoke
						-- todo: swap to shotgun if in close range, out of it if not
					end,
				}),
			},
			Comment = "right corridor kite back - similar to GuardArea but maybe more defensive?",
			group = "BossFights",
			id = "Corazon_KiteBack_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			Behaviors = {
				PlaceObj('CustomAI', {
					'EndTurnPolicies', {
						PlaceObj('AIPolicyTakeCover', {
							'visibility_mode', "team",
						}),
					},
					'TakeCoverChance', 100,
					'EnumDests', function (self, unit, context, debug_data)
						if not g_Encounter then return end
						
						return CorazonEnumDestsInAssignedArea(unit, context)
					end,
					'EvalDamageScore', function (self, unit, context, debug_data)
						context.max_attacks = 1
						AIPrecalcDamageScore(context)
					end,
					'PickOptimalLoc', function (self, unit, context, debug_data)
						return CorazonOptimalLocationInAssignedArea(unit, context)
					end,
					'PickEndTurnLoc', function (self, unit, context, debug_data)
						-- we need 2 destinations: attack one and end turn one
						local hide_dests = {}
						local attack_dest, attack_score, scoot_ap
						
						for _, dest in ipairs(context.destinations) do
							if not g_AIDestEnemyLOSCache[dest] then
								hide_dests[#hide_dests+1] = dest
							else
								local score = context.dest_target_score or 0
								if score > 0 then
									-- modify score by remaining ap at dest
									local move_stance_idx = context.dest_combat_path[dest]
									local cpath = context.combat_paths[move_stance_idx]
									local ap_at_dest = cpath:GetAP(dest)
									score = MulDivRound(score, ap_at_dest, Max(1, unit.ActionPoints))
									
									if score > (attack_score or 0) then
										attack_dest, attack_score, scoot_ap = dest, score, ap_at_dest - context.default_attack_cost
									end
								end
							end
						end
						
						if not attack_dest or #hide_dests < 1 or not scoot_ap then return end
						
						-- pick a reachable hiding dest
						local x, y, z, stance_idx = stance_pos_unpack(attack_dest)
						local atk_pos = point(x, y, z)
						local combat_path = CombatPath:new()
						local weights, total_weight = {}, 0
						local hide_dest
						
						combat_path:RebuildPaths(unit, scoot_ap, atk_pos, StancesList[stance_idx])
						for i, dest in ipairs(hide_dests) do
							local x, y, z = stance_pos_unpack(dest)
							local pos = point_pack(x, y, z)
							local ap = combat_path:GetAP(pos)
							weights[i] = ap
							total_weight = total_weight + ap
						end
						
						if total_weight < 1 then return end
						local roll = unit:Random(total_weight)
						for i = 1, #hide_dests - 1 do
							local w = weights[i]
							if w >= roll then
								hide_dest = hide_dests[i]
								break
							end
						end
						
						context.ai_destination = attack_dest
						context.scoot_and_shoot_dest = hide_dest or hide_dests[#hide_dests]
						DoneObject(combat_path)
						return true
					end,
					'SelectSignatureActions', function (self, unit, context, debug_data)
						if IsKindOf(g_Encounter, "BossfightCorazon") then
							return g_Encounter:SelectSignatureActions(unit, context)
						end
					end,
					'Execute', function (self, unit, context, debug_data)
						if not context.scoot_and_shoot_dest then return end
						
						-- do a single attack, then scoot to the hidey place
						local dest = GetPackedPosAndStance(unit)
						AIPrecalcDamageScore(context, {dest})
						local target = (context.dest_target or empty_table)[dest]
						
						local args = { target = target }--, voiceResponse = voice_response }
						AIPlayCombatAction(context.default_attack.id, unit, nil, args)
						
						-- recalc path to make sure the position is free
						local x, y, z = stance_pos_unpack(context.scoot_and_shoot_dest)
						local combat_path = CombatPath:new()
						combat_path:RebuildPaths(unit)
						
						if not combat_path:GetAP(point_pack(x, y, z)) then
							local hide_dests = {}
							for _, dest in ipairs(context.destinations) do
								local x, y, z = stance_pos_unpack(dest)
								if not g_AIDestEnemyLOSCache[dest] and combat_path:GetAP(point_pack(x, y, z)) then			
									hide_dests[#hide_dests+1] = dest
								end
							end
							if #hide_dests > 0 then
								local dest = table.interaction_rand(hide_dests, "Behavior")
								local x, y, z = stance_point_unpack(dest)
								AIPlayCombatAction("Move", unit, unit.ActionPoints, { goto_pos = point(x, y, z) })
							else
								AIPlayAttacks(unit, context)
							end
						else
							AIPlayCombatAction("Move", unit, unit.ActionPoints, { goto_pos = point(x, y, z) })
						end
						AITakeCover(unit)
						DoneObject(combat_path)
						return "done"
					end,
				}),
			},
			Comment = "right corridor shoot-and-scoot action",
			group = "BossFights",
			id = "Corazon_ShootAndScoot_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			Behaviors = {
				PlaceObj('CustomAI', {
					'turn_phase', "Early",
					'EndTurnPolicies', {
						PlaceObj('AIPolicyTakeCover', {
							'visibility_mode', "team",
						}),
					},
					'TakeCoverChance', 100,
					'EnumDests', function (self, unit, context, debug_data)
						if g_TacticalMap then 
							return g_TacticalMap:EnumDestsInAssignedArea(unit, context)
						end
					end,
					'PickOptimalLoc', function (self, unit, context, debug_data)
						if g_TacticalMap then
							return g_TacticalMap:FindOptimalLocationInAssignedArea(unit, context)
						end
					end,
					'PickEndTurnLoc', function (self, unit, context, debug_data)
						AITacticCalcPathDistances(unit, context, "disable bias")
						
						local policies = self:PickEndTurnPolicies(unit, context) or self.EndTurnPolicies
						context.ai_destination = AIScoreReachableVoxels(context, policies, self.OptLocWeight, nil, "avoid")
						return true
					end,
					'SelectSignatureActions', function (self, unit, context, debug_data)
						return AITacticSelectSignatureActions(unit, context)
					end,
				}),
			},
			group = "BossFights",
			id = "Faucheaux_BossRetreating_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			BaseMovementWeight = 10,
			Behaviors = {
				PlaceObj('StandardAI', {
					'EndTurnPolicies', {
						PlaceObj('AIPolicyTakeCover', {
							'visibility_mode', "team",
						}),
						PlaceObj('AIPolicyProximity', {
							'Weight', 1000,
							'MinScore', 10,
						}),
					},
					'TakeCoverChance', 100,
				}),
			},
			OptLocPolicies = {
				PlaceObj('AIPolicyTakeCover', {
					'visibility_mode', "team",
				}),
				PlaceObj('AIPolicyProximity', {
					'Weight', 1000,
					'MinScore', 10,
				}),
			},
			OptLocSearchRadius = 80,
			PrefStance = "Crouch",
			SignatureActions = {
				PlaceObj('AIActionMobileShot', {
					'Weight', 200,
					'NotificationText', "",
					'action_id', "RunAndGun",
				}),
			},
			TargetScoreRandomization = 40,
			group = "Lieutenants",
			id = "CorazonBoss_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			BaseAttackTargeting = set( "Torso" ),
			BaseAttackWeight = 50,
			BaseMovementWeight = 0,
			Behaviors = {
				PlaceObj('HoldPositionAI', {
					'BiasId', "HoldPositionBehavior",
					'EndTurnPolicies', {
						PlaceObj('AIPolicyDealDamage', nil),
					},
					'SignatureActions', {
						PlaceObj('AIAttackSingleTarget', {
							'BiasId', "LegShot",
							'Weight', 120,
							'OnActivationBiases', {
								PlaceObj('AIBiasModification', {
									'BiasId', "LegShot",
									'Effect', "disable",
								}),
								PlaceObj('AIBiasModification', {
									'BiasId', "DefensiveOverwatch",
									'Effect', "priority",
									'Period', 0,
								}),
							},
							'Aiming', "Remaining AP",
							'AttackTargeting', set( "Legs" ),
						}),
						PlaceObj('AIAttackSingleTarget', {
							'BiasId', "ArmShot",
							'Weight', 120,
							'OnActivationBiases', {
								PlaceObj('AIBiasModification', {
									'BiasId', "ArmShot",
									'Effect', "disable",
								}),
								PlaceObj('AIBiasModification', {
									'BiasId', "DefensiveOverwatch",
									'Effect', "priority",
									'Period', 0,
								}),
							},
							'Aiming', "Remaining AP",
							'AttackTargeting', set( "Groin" ),
						}),
						PlaceObj('AIConeAttack', {
							'BiasId', "DefensiveOverwatch",
							'Weight', 10,
							'team_score', 0,
							'min_score', 100,
							'action_id', "Overwatch",
						}),
					},
					'TakeCoverChance', 0,
				}),
			},
			OptLocPolicies = {
				PlaceObj('AIPolicyWeaponRange', {
					'RangeMin', 25,
					'RangeMax', 100,
				}),
				PlaceObj('AIPolicyLosToEnemy', nil),
			},
			OptLocSearchRadius = 80,
			PrefStance = "Crouch",
			group = "Lieutenants",
			id = "TurretBoss_copy",
		}),
		PlaceObj('ModItemAIArchetype', {
			Behaviors = {
				PlaceObj('ApproachInteractableAI', {
					'Comment', "approach/man the selected emplacement",
					'Score', function (self, unit, proto_context, debug_data)
						local emplacement = g_Combat and g_Combat:GetEmplacementAssignment(unit)
						if not emplacement or emplacement.manned_by then
							return 0
						end
						return self.Weight
					end,
					'OptLocWeight', 1000,
					'TakeCoverChance', 0,
				}),
				PlaceObj('HoldPositionAI', {
					'Comment', "when manning emplacement",
					'Score', function (self, unit, proto_context, debug_data)
						local emplacement = g_Combat and g_Combat:GetEmplacementAssignment(unit)
						if not emplacement or emplacement.manned_by ~= unit then
							return 0
						end
						return self.Weight
					end,
					'TakeCoverChance', 0,
				}),
			},
			OptLocSearchRadius = 80,
			group = "System",
			id = "EmplacementGunner_copy",
		}),
		}),
}