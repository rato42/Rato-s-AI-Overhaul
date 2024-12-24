function OnMsg.ClassesGenerate(classdefs)
    if classdefs.AISignatureAction then
        local props = classdefs.AISignatureAction.properties
        props[#props + 1] = {
            id = "CustomScoring",
            name = "Custom Scoring",
            editor = "func",
            default = function(self)
                return self.Weight, false, self.Priority
            end,
            params = "self, context"
        }

    end

    if classdefs.AIActionBaseZoneAttack then
        local props = classdefs.AIActionBaseZoneAttack.properties
        props[#props + 1] = {
            id = "enemy_cover_mod",
            name = "Enemy In Cover Score",
            help = "this value, scaled by InterpolatedCoverEffect %, will be added to the AIEvalZones score for a enemy in cover",
            editor = "number",
            default = 0
        }
    end
end

DefineClass.AITargetingEnemyInCover = {
    __parents = {"AITargetingPolicy"},
    __generated_by_class = "ClassDef",
    properties = {{id = "Score", editor = "number", default = 100}}
}

function AITargetingEnemyInCover:EvalTarget(unit, target)

    local target_cover = GetCoverFrom(GetPackedPosAndStance(target), GetPackedPosAndStance(unit))

    -- local target_id = target.session_id
    -- ic(target_id, target_cover, target_cover == const.CoverLow or target_cover == const.CoverHigh)

    if target_cover == const.CoverLow or target_cover == const.CoverHigh then
        return self.Score or 100
    end
    return 0
end

------------ Not used for now
DefineClass.AIPolicyAttack_StanceAP = {
    __parents = {"AIPositioningPolicy"},
    __generated_by_class = "ClassDef",

    properties = {
        {id = "end_of_turn", editor = "bool", default = true, read_only = true, no_edit = true}
    }
}

function AIPolicyAttack_StanceAP:EvalDest(context, dest, grid_voxel)
    local unit = context.unit

    local stance_cost = GetWeapon_StanceAP(unit, context.weapon) + Get_AimCost(unit)

    local ap = context.dest_ap[dest] or 0
    return ap >= context.default_attack_cost + stance_cost and 100 or 0
end

DefineClass.AIPolicyMGSetupAP = {
    __parents = {"AIPositioningPolicy"},
    __generated_by_class = "ClassDef",

    properties = {
        {id = "end_of_turn", editor = "bool", default = true, read_only = true, no_edit = true},
        {id = "CheckLOS", editor = "bool", default = true}
    }
}

function AIPolicyMGSetupAP:EvalDest(context, dest, grid_voxel)
    if self.CheckLOS and not g_AIDestEnemyLOSCache[dest] then
        return 0
    end

    local unit = context.unit

    local setup_cost = CombatActions.MGSetup:GetAPCost(unit, false)
    -- ic(setup_cost)
    local ap = context.dest_ap[dest] or 0
    -- return ap > context.default_attack_cost and 100 or 0

    return ap > setup_cost and self.Weight or 0
end

DefineClass.AIPolicyCustomFlanking = {
    __parents = {"AIPositioningPolicy"},
    __generated_by_class = "ClassDef",

    properties = {
        {id = "end_of_turn", editor = "bool", default = true, read_only = true, no_edit = true},

        --    { id = "AllyPlannedPosition",
        --     help = "consider allies being on their destination positions instead of their current ones (when available)",
        --     editor = "bool",
        --     default = false
        -- }, 
        {
            id = "ReserveAttackAP",
            name = "Reserve Attack AP",
            help = "do not consider locations where the unit will be out of ap and couldn't attack",
            editor = "bool",
            default = false
        },
        {id = "optimal_location", editor = "bool", default = true, read_only = true, no_edit = true}
    }
}

local function IsInCover(unit, target, override_pos)
    local target_pos = GetPackedPosAndStance(target)
    local att_pos = override_pos or GetPackedPosAndStance(unit)

    local target_cover = GetCoverFrom(target_pos, att_pos)

    if target_cover == const.CoverLow or target_cover == const.CoverHigh then
        return true
    end
end

function AIPolicyCustomFlanking:EvalDest(context, dest, grid_voxel)
    local unit = context.unit

    local ap = context.dest_ap[dest] or 0
    if self.ReserveAttackAP and ap < context.default_attack_cost then
        return 0
    end

    -- if not context.position_override then
    --     context.position_override = {}
    --     if self.AllyPlannedPosition then
    --         for _, ally in ipairs(unit.team.units) do
    --             local dest = ally.ai_context and ally.ai_context.ai_destination
    --             if dest then
    --                 local x, y, z = stance_pos_unpack(dest)
    --                 context.position_override[ally] = point(x, y, z)
    --             end
    --         end
    --     end
    -- end

    -- local x, y, z = stance_pos_unpack(dest)
    -- context.position_override[unit] = point(x, y, z)

    if not context.enemy_in_cover then
        context.enemy_in_cover = {}
        for _, enemy in ipairs(context.enemies) do
            if IsInCover(unit, enemy) then
                context.enemy_in_cover[enemy] = true
            end
        end
    end

    local delta = 0
    for _, enemy in ipairs(context.enemies) do
        local new_in_cover = IsInCover(unit, enemy, dest)
        if new_in_cover and not context.enemy_in_cover[enemy] then
            delta = delta - 1
        elseif not new_in_cover and context.enemy_in_cover[enemy] then
            delta = delta + 1
        end
    end

    return delta * self.Weight
end
