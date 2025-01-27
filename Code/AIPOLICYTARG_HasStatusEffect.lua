DefineClass.AITargetingHasStatusEffect = {
    __parents = {"AITargetingPolicy"},
    __generated_by_class = "ClassDef",
    properties = {
        {id = "Score", editor = "number", default = 100},
        {id = "StatusID", editor = "text", default = false, no_edit = false}
    }
}

function AITargetingHasStatusEffect:GetEditorView()
    return "Check if " .. (self.StatusID or '')
end
function AITargetingHasStatusEffect:EvalTarget(unit, target)
    return target and target:HasStatusEffect(self.StatusID) and self.Score or 0
end
