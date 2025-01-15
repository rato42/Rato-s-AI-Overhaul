DefineClass.AITargetingPindownTargeting = {
    __parents = {"AITargetingPolicy"},
    __generated_by_class = "ClassDef",
    properties = {{id = "Score", editor = "number", default = 100}}
}

-----TODO: Investigar melhor o efeito dos targetings no score la
function AITargetingPindownTargeting:EvalTarget(unit, target)

    local target_cover = GetCoverFrom(GetPackedPosAndStance(target), GetPackedPosAndStance(unit))

    local score = 0

    if target and IsKindOf(target, "Unit") then
        if target:HasStatusEffect("Slowed") then
            score = score + self.Score
        end
        if target:IsThreatened(nil, 'overwatch') or target:IsThreatened(nil, "melee") then
            score = score + self.Score
        end
    end

    if target_cover == const.CoverLow then
        score = score + (MulDivRound(self.Score, 50, 100))
    end

    return score
end
