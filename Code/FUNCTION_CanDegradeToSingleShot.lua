--[[function RATOAI_TryDegradeToSingleShot(context)
    if not context then
        return false
    end
    if context.default_attack == "BurstFire" and context.weapon and
        table.find(context.weapon.AvailableAttacks, "SingleShot") then
        
    end
end]] 
