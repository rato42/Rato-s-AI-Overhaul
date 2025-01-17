----- Discontinued
--[[DefineClass.AIPolicyDontBeExposedAtCloserRange = {
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
        }, -- {
        --     id = "RangeBase",
        --     name = "Preferred Range (Base)",
        --     editor = "combo",
        --     default = "Effective",
        --     items = function(self)
        --         return {"Weapon", "Absolute"}
        --     end
        -- },
        {
            id = "RangeMin",
            name = "Preferred Range (Min)",
            help = "Percent of base preferred range",
            editor = "number",
            default = 1,
            -- no_edit = function(self)
            --     return self.RangeBase == "Melee"
            -- end,
            min = 0,
            max = 1000
        }, {
            id = "RangeMax",
            name = "Preferred Range (Max)",
            help = "Percent of base preferred range",
            editor = "number",
            default = 30,
            -- no_edit = function(self)
            --     return self.RangeBase == "Melee"
            -- end,
            min = 0,
            max = 1000
        }, {
            id = "DownedWeightModifier",
            name = "Downed Enemy Weight Modifier",
            editor = "number",
            default = 5,
            scale = "%",
            min = 0
        },
        {id = "optimal_location", editor = "bool", default = true, read_only = true, no_edit = true},
        {id = "end_of_turn", editor = "bool", default = true, read_only = true, no_edit = true}
    }
}

function AIPolicyDontBeExposedAtCloserRange:EvalDest(context, dest, grid_voxel)
    if self.CheckLOS and not g_AIDestEnemyLOSCache[dest] then
        return 0
    end

    for state, value in pairs(self.EnvState) do
        if value ~= not not GameState[state] then
            return 0
        end
    end

    ----
    local enemy_in_range
    for _, enemy in ipairs(context.enemies) do

        local range_type = "Weapon"

        enemy_in_range = enemy_in_range or
                             self:AIRangeCheck(context, grid_voxel, context.unit,
                                               context.enemy_grid_voxel[enemy], range_type,
                                               self.RangeMin, self.RangeMax, enemy)
        if enemy_in_range then
            break
        end
    end
    ----

    return enemy_in_range and 0 or self.Weight
end

---- probably needed to revise this
function AIPolicyDontBeExposedAtCloserRange:AIRangeCheck(context, ppt1, target, ppt2, range_type,
                                                         range_min, range_max, enemy)
    if range_type == "Melee" then
        local p1 = point_pack(VoxelToWorld(point_unpack(ppt1)))
        local p2 = point_pack(VoxelToWorld(point_unpack(ppt2)))
        ----
        return IsMeleeRangeTarget(enemy, p1, context.unit.stance, target, p2, target.stance)
        ---
    end
    if range_type ~= "Absolute" then
        -- weapon range based
        assert(range_type == "Weapon")
        local base_range = context.ExtremeRange
        range_min = range_min and MulDivRound(range_min, base_range, 100)
        range_max = range_max and MulDivRound(range_max, base_range, 100)
    end
    local x1, y1, z1 = point_unpack(ppt1)
    local x2, y2, z2 = point_unpack(ppt2)
    if (range_min or 0) > 0 and IsCloser(x1, y1, z1, x2, y2, z2, range_min) then
        return false
    end
    if (range_max or 0) > 0 and not IsCloser(x1, y1, z1, x2, y2, z2, range_max + 1) then
        return false
    end
    return true
end
]] 
