--[[DefineClass.AIPolicyAvoidDeathSpots = {
    __parents = {"AIPositioningPolicy"},
    __generated_by_class = "ClassDef",

    properties = {
        {id = "CheckLOS", editor = "bool", default = true}, {
            id = "EnvState",
            name = "Environmental State",
            editor = "set",
            default = false,
            three_state = true,
            items = function(self)
                return AIEnvStateCombo
            end
        }, {
            id = "RangeMin",
            name = "Preferred Range (Min)",
            help = "Percent of base preferred range",
            editor = "number",
            default = 80,
            min = 0,
            max = 1000
        }, {
            id = "RangeMax",
            name = "Preferred Range (Max)",
            help = "Percent of base preferred range",
            editor = "number",
            default = 120,
            min = 0,
            max = 1000
        }, {
            id = "DownedWeightModifier",
            name = "Downed Enemy Weight Modifier",
            editor = "number",
            default = 5,
            scale = "%",
            min = 0
        }, {
            id = "AllowedTriggerTypes",
            editor = "set",
            items = {"Contact", "Proximity-Timed", "Proximity", "Timed", "Remote"},
            default = set("Contact", "Proximity-Timed", "Proximity", "Timed", "Remote")
        }, {
            id = "AllowedAoeTypes",
            editor = "set",
            items = {"none", "fire", "smoke", "teargas", "toxicgas"},
            default = set("none")
        }, {id = "SaveAP", editor = "bool", default = false},
        {id = "optimal_location", editor = "bool", default = true, read_only = true, no_edit = true},
        {id = "end_of_turn", editor = "bool", default = true, read_only = true, no_edit = true}
    }
}

g_RATOAI_DeathSpots = {}

--- pos -> score on a radius, like a heatmap
---- Storage = Side{ {pos = pos, turn = turn, score = score} }
---- Each turn the score goes Downed
---- The scores can be increased by other deaths

function OnMsg.UnitDied(unit)
	if R_IsAI(unit) and g_Combat then
		g_RATOAI_DeathSpots[unit.side] = g_RATOAI_DeathSpots[unit.side] or {}
		table.insert(g_RATOAI_DeathSpots[unit.side], {pos = unit:GetPos()})
	end
end

function AIPolicyAvoidDeathSpots:EvalDest(context, dest, grid_voxel)
    if self.CheckLOS and not g_AIDestEnemyLOSCache[dest] then
        return 0
    end

    for state, value in pairs(self.EnvState) do
        if value ~= not not GameState[state] then
            return 0
        end
    end
    local enemy_grid_voxel = context.enemy_grid_voxel
    local range_type = "Weapon" -- "Absolute" --self.RangeBase
    local range_min = self.RangeMin
    local range_max = self.RangeMax
    local weight = 0
    for _, enemy in ipairs(context.enemies) do
        if self:RangeCheckGrenade(context, grid_voxel, enemy, enemy_grid_voxel[enemy], range_type,
                                  range_min, range_max, dest) then
            if enemy:IsIncapacitated() then
                weight = self.DownedWeightModifier
            else
                return 100
            end
        end
    end
    return weight
end
]] 
