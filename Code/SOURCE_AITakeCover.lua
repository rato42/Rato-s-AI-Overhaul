function AITakeCover(unit, context)
    local context = unit.ai_context
    ----------------
    if unit:HasStatusEffect("shooting_stance") then
        return
    end
    local ap_after_sig = context.ap_after_signature or 0
    ---------------

    if unit:HasPreparedAttack() or not context or (ap_after_sig <= 0) then
        return
    end
    local cover_high, cover_low = GetCoverTypes(unit)
    if not cover_high and not cover_low then
        ---------------------
        local prone_AP = unit.stance == "Crouch" and 1000 or 2000
        if unit.species == "Human" and unit.stance ~= "Prone" and ap_after_sig >= prone_AP then
            AIPlayCombatAction("StanceProne", unit, prone_AP)
        end
        --------------------
        return
    end
    if unit.species == "Human" and unit.stance ~= "Prone" then
        -----
        local take_cover_ap_cost = CombatActions["TakeCover"].ActionPoints
        if ap_after_sig >= take_cover_ap_cost then
            -----

            local context = unit.ai_context
            -- local chance = context and context.behavior and context.behavior.TakeCoverChance or 0
            -- if chance > 0 and (chance >= 100 or unit:Random(100) < chance) then
            local dest = GetPackedPosAndStance(unit)
            local enemy_visible = context.enemy_visible
            local enemy_pos = context.enemy_pack_pos_stance
            for _, enemy in ipairs(context.enemies) do
                if (enemy_visible[enemy] and GetCoverFrom(dest, enemy_pos[enemy]) or 0) > 0 then
                    -----------
                    AIPlayCombatAction("TakeCover", unit, take_cover_ap_cost) --- was 0
                    -----------
                    return
                end
            end
            -- end
        end
    end
    if cover_low then
        AIPlayCombatAction("StanceCrouch", unit, 0)
    end
end
