UndefineClass('LegionGunner_copy')
DefineClass.LegionGunner_copy = {
	__parents = { "UnitData" },
	__generated_by_class = "ModItemUnitDataCompositeDef",


	object_class = "UnitData",
	Health = 62,
	Agility = 65,
	Dexterity = 39,
	Strength = 89,
	Wisdom = 30,
	Leadership = 20,
	Marksmanship = 55,
	Mechanical = 0,
	Explosives = 0,
	Medical = 0,
	Portrait = "UI/EnemiesPortraits/LegionHeavy",
	BigPortrait = "UI/Enemies/LegionRaider",
	Name = T(692210764193, --[[ModItemUnitDataCompositeDef LegionGunner_copy Name]] "Gunner"),
	Randomization = true,
	Affiliation = "Legion",
	StartingLevel = 2,
	neutral_retaliate = true,
	archetype = "HeavyGunner",
	role = "Heavy",
	MaxAttacks = 2,
	PickCustomArchetype = function (self, proto_context)  end,
	MaxHitPoints = 85,
	StartingPerks = {
		"HeavyWeaponsTraining",
	},
	AppearancesList = {
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
	Equipment = {
		"LegionGunner",
	},
	AdditionalGroups = {
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
	pollyvoice = "Joey",
	gender = "Male",
	VoiceResponseId = "LegionRaider",
}

