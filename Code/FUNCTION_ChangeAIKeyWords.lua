--[[function OnMsg.UnitEnterCombat(unit)
    print(unit.session_id, "entering combat")
    local weapon = unit:GetActiveWeapons()
    local keywords = unit.AIKeywords
    local available_attacks = weapon and weapon.AvailableAttacks
	for i, keywords in ipairs(keywords) do
		if not table.find()
	end
	for i, attack in ipairs(available_attacks) do
		if not table.find()
	end
	
end]] -- "MobileShot",
-- "RunAndGun",
-- "Sniper", --- Pindown
-- "Soldier", ---- Autofire
