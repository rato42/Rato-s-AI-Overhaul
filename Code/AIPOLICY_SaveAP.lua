DefineClass.AIPolicySaveAP = {
    __parents = {"AIPositioningPolicy"},
    __generated_by_class = "ClassDef",

    properties = {
        {id = "end_of_turn", editor = "bool", default = true, read_only = true, no_edit = true},
        {id = "optimal_location", editor = "bool", default = true, read_only = true, no_edit = true},
        {
            id = "ReserveAP",
            name = "Reserve AP",
            help = "do not consider locations where the unit will be out of ap",
            editor = "number",
            default = 2

        }
    }
}

function AIPolicySaveAP:EvalDest(context, dest, grid_voxel)

    local ap = context.dest_ap[dest] or 0

    local check_ap = self.ReserveAP * const.Scale.AP or 0

    return ap < check_ap and 0 or self.Weight
end
