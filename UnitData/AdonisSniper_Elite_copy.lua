UndefineClass('AdonisSniper_Elite_copy')
DefineClass.AdonisSniper_Elite_copy = {
	__parents = { "UnitData" },
	__generated_by_class = "ModItemUnitDataCompositeDef",


	object_class = "UnitData",
	Health = 71,
	Agility = 90,
	Dexterity = 100,
	Strength = 85,
	Wisdom = 80,
	Leadership = 20,
	Marksmanship = 80,
	Mechanical = 50,
	Explosives = 42,
	Medical = 53,
	Portrait = "UI/EnemiesPortraits/AdonisSniper",
	Name = T(652358849761, "Elite Marksman"),
	Randomization = true,
	elite = true,
	eliteCategory = "Foreigners",
	Affiliation = "Adonis",
	StartingLevel = 5,
	neutral_retaliate = true,
	AIKeywords = {
		"Sniper",
	},
	archetype = "RATOAI_Sniper",
	role = "Marksman",
	MaxAttacks = 1,
	PickCustomArchetype = function (self, proto_context)  end,
	MaxHitPoints = 50,
	StartingPerks = {
		"Deadeye",
		"Shatterhand",
	},
	AppearancesList = {
		PlaceObj('AppearanceWeight', {
			'Preset', "Adonis_Marksman",
		}),
	},
	Equipment = {
		"AdonisSniper",
	},
	AdditionalGroups = {
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
	Tier = "Veteran",
	pollyvoice = "Joey",
	gender = "Male",
	VoiceResponseId = "AdonisAssault",
}

