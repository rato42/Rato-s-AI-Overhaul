UndefineClass('LegionGrenadier_copy')
DefineClass.LegionGrenadier_copy = {
	__parents = { "UnitData" },
	__generated_by_class = "ModItemUnitDataCompositeDef",


	object_class = "UnitData",
	Health = 53,
	Agility = 80,
	Dexterity = 30,
	Strength = 53,
	Wisdom = 14,
	Leadership = 14,
	Marksmanship = 43,
	Mechanical = 0,
	Explosives = 25,
	Medical = 0,
	Portrait = "UI/EnemiesPortraits/LegionDemo",
	BigPortrait = "UI/Enemies/LegionRaider",
	Name = T(757912188960, --[[ModItemUnitDataCompositeDef LegionGrenadier_copy Name]] "Grenadier"),
	Randomization = true,
	Affiliation = "Legion",
	StartingLevel = 2,
	neutral_retaliate = true,
	AIKeywords = {
		"Explosives",
		"MobileShot",
	},
	archetype = "RATOAI_Demolition",
	role = "Demolitions",
	CanManEmplacements = false,
	MaxAttacks = 1,
	PickCustomArchetype = function (self, proto_context)  end,
	MaxHitPoints = 50,
	StartingPerks = {
		"Throwing",
		"MinFreeMove",
	},
	AppearancesList = {
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
	Equipment = {
		"he",
		"Grunty",
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
	pollyvoice = "Russell",
	gender = "Male",
	VoiceResponseId = "LegionRaider",
}

