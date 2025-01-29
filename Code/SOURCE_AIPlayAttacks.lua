local RATOAI_originalAIPlayAttacks = AIPlayAttacks

function AIPlayAttacks(unit, context, dbg_action, force_or_skip_action)
    context.AIisPlayingAttacks = true
    RATOAI_originalAIPlayAttacks(unit, context, dbg_action, force_or_skip_action)
    context.AIisPlayingAttacks = false
end
