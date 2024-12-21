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
            name = "Enemy In Cover Modifier Score (multiplier)",
            editor = "number",
            default = 100
        }
    end
end

function AIActionBaseZoneAttack:EvalZones(context, zones)
    return AIEvalZones(context, zones, self.min_score, self.enemy_score, self.team_score,
                       self.self_score_mod, self.enemy_cover_mod)
end

function AIEvalZones(context, zones, min_score, enemy_score, team_score, self_score_mod,
                     enemy_cover_score)
    local best_target, best_score = nil, (min_score or 0) - 1

    for _, zone in ipairs(zones) do
        local score
        local selfmod = 0
        for _, unit in ipairs(zone.units) do
            local uscore = 0
            if not unit:IsDead() and not unit:IsDowned() then
                if unit:IsOnEnemySide(context.unit) then
                    -----------------------------------
                    if enemy_cover_score and enemy_cover_score ~= 100 then
                        local attacker = context.unit
                        local cover, any, coverage =
                            unit:GetCoverPercentage(attacker:GetPos(), unit:GetPos())
                        if coverage >= 100 then
                            uscore = MulDivRound(enemy_score, enemy_cover_score, 100) or 0
                        else
                            uscore = enemy_score or 0
                        end
                        ic(coverage, uscore) ------------------ FIX
                    else
                        ---------------------------------
                        uscore = enemy_score or 0
                    end

                elseif unit.team == context.unit.team then
                    uscore = team_score or 0
                    if unit == context.unit then
                        selfmod = self_score_mod or 0
                    end
                end
            end
            score = (score or 0) + uscore
        end
        score = score and MulDivRound(score, zone.score_mod or 100, 100)
        score = score and MulDivRound(score, 100 + selfmod, 100)
        if score and score > best_score then
            best_target, best_score = zone, score
        end
        zone.score = score
    end

    return best_target, best_score
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
