function AIActionBaseZoneAttack:EvalZones(context, zones)
    return AIEvalZones(context, zones, self.min_score, self.enemy_score, self.team_score,
                       self.self_score_mod, self.enemy_cover_mod) -- , self.enemy_height_mod)
    --- addition of "self.enemy_cover_mod" and "enemy_height_mod"
end

function AIEvalZones(context, zones, min_score, enemy_score, team_score, self_score_mod,
                     enemy_cover_score) -- , heigth_score)
    local best_target, best_score = nil, (min_score or 0) - 1

    for _, zone in ipairs(zones) do
        local score
        local selfmod = 0
        for _, unit in ipairs(zone.units) do
            local uscore = 0
            if not unit:IsDead() and not unit:IsDowned() then
                if unit:IsOnEnemySide(context.unit) then

                    uscore = enemy_score or 0
                    -----------------------------------
                    --[[if enemy_cover_score and enemy_cover_score ~= 0 then
                        local attacker = context.unit
                        local cover, any, coverage =
                            unit:GetCoverPercentage(attacker:GetPos(), unit:GetPos())

                        local cover_effect = InterpolateCoverEffect(coverage, 100, 0)
                        -- coverage = coverage >= 80 and 100 or coverage < 40 and 0 or coverage --- values from InterpolateCoverEffect
                        local to_add = 0
                        if cover_effect > 0 then
                            to_add = MulDivRound(enemy_cover_score, cover_effect, 100)

                        end
                        uscore = uscore + to_add
                        -- ic(unit.session_id, cover, any, coverage, uscore, cover_effect, to_add)
                    end]]

                    if enemy_cover_score and enemy_cover_score ~= 0 then
                        ----GetCoversAt(unit:GetPos())
                        local cover_high, cover_low = GetCoverTypes(unit)
                        if cover_low or cover_high then
                            uscore = uscore + enemy_cover_score
                        end
                    end

                    -- if heigth_score and heigth_score ~= 0 then

                    -----------------------------------

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
