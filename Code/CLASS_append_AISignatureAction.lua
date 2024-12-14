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
end

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
