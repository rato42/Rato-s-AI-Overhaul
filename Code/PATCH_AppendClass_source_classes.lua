function OnMsg.ClassesGenerate(classdefs)

    AppendClass.AISignatureAction = {
        properties = {
            {
                id = "CustomScoring",
                name = "Custom Scoring",
                editor = "func",
                default = function(self)
                    return self.Weight, false, self.Priority
                end,
                params = "self, context"
            }
        }
    }

    AppendClass.AIActionBaseZoneAttack = {
        properties = {
            {
                id = "enemy_cover_mod",
                name = "Enemy In Cover Score",
                help = "this value, scaled by InterpolatedCoverEffect %, will be added to the AIEvalZones score for a enemy in cover",
                editor = "number",
                default = 0
            }
        }
    }

    AppendClass.AIActionThrowGrenade = {
        properties = {
            {
                id = "AllowedTriggerTypes",
                editor = "set",
                items = {"Contact", "Proximity-Timed", "Proximity", "Timed", "Remote"},
                default = set("Contact", "Proximity-Timed", "Proximity", "Timed", "Remote")
            }
        }
    }

    AppendClass.AIActionPinDown = {
        properties = {
            {
                id = "AttackTargeting",
                help = "if any parts are set the unit will pick one of them randomly for each of its basic attacks; otherwise it will always use the default (torso) attacks",
                editor = "dropdownlist",
                default = "Torso",
                items = {"Arms", "Groin", "Head", "Legs", "Torso"}
            }
        }
    }

    -- AppendClass.AIPolicyTakeCover = {
    --     properties = {{id = "ScalePerDistance", editor = "bool", default = true}}
    -- }

end

