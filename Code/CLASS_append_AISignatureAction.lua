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

