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
        --[[props[#props + 1] = {
            id = "enemy_height_mod",
            name = "Enemy Height Score",
            help = "UNFINISHED",
            editor = "number",
            default = 0
        }]]
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
    local ap = context.dest_ap[dest] or 0

    return ap >= setup_cost and self.Weight or 0
end

