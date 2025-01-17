function Update_AIPrecalcDamageScore(unit)
    local context = unit.ai_context or {}
    if not context.damage_score_precalced then
        AIPrecalcDamageScore(context)
        return context
    end
    return nil
end

function R_IsAI(unit)
    local side = unit and unit.team and unit.team.side or ''
    if (side == "player1" or side == "player2") then
        return false
    end
    return true
end

function RATOAI_UnpackPos(pos)
    if not pos then
        return
    end
    local ux, uy, uz, ustance_idx = stance_pos_unpack(pos)
    local new_pos = point(ux, uy, uz)
    return new_pos
end

-- GetPackedPosAndStance(unit, stance)
