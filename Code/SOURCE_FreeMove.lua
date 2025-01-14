function OnMsg.ClassesGenerate(classdefs)

    local RATOAI_OptionValue = CurrentModOptions.VanillaFreeMoveBonus or 100

    if RATOAI_OptionValue == 100 then
        return
    end

    if classdefs.FreeMove then
        classdefs.FreeMove.OnAdded = function(self, obj)
            if not IsKindOf(obj, "Unit") then
                return
            end

            local cur_free_ap = obj.free_move_ap
            local free_ap = Max(0, MulDivRound(obj.Agility - 40, const.Scale.AP, 10))
            local data = {min = 0, max = 999, add = 0, mul = 100}
            if obj.team and obj.team.player_enemy then
                ------
                local diff_mul =
                    GameDifficulties[Game.game_difficulty]:ResolveValue("freeMoveBonus")
                diff_mul = 100 + MulDivRound(diff_mul, RATOAI_OptionValue, 100)
                data.mul = diff_mul
                -----
            end
            obj:CallReactions("OnCalcFreeMove", data)
            free_ap = MulDivRound(free_ap + data.add * const.Scale.AP, data.mul, 100)
            free_ap = Clamp(free_ap, data.min * const.Scale.AP, data.max * const.Scale.AP)
            if IsGameRuleActive("HeavyWounds") then
                local wounds = obj:GetStatusEffect("Wounded")
                if wounds and wounds.stacks >= 1 then
                    local max_wounds = GameRuleDefs.HeavyWounds:ResolveValue("MaxWoundsEffect")
                    local per_wound_percent = GameRuleDefs.HeavyWounds:ResolveValue("FreeMoveLost")
                    free_ap = Max(0, free_ap -
                                      MulDivRound(free_ap, Min(wounds.stacks, max_wounds) *
                                                      per_wound_percent, 100))
                end
            end

            local prev_ap = obj.ActionPoints
            obj:GainAP(free_ap - cur_free_ap)
            if obj.ActionPoints > prev_ap then -- gain can be blocked by certain statuses and conditions
                obj.free_move_ap = free_ap
                Msg("UnitAPChanged", obj)
                ObjModified(obj)
            end
        end
    end

end
