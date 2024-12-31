function BruteArchetypeSelection(self)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_class = "Firearm"

    if enemy and dist < 6 * const.SlabSizeX then
        weapon_class = "MeleeWeapon"
        PlayVoiceResponse(self, "AIArchetypeAngry")
    end

    if not self:GetActiveWeapons(weapon_class) then
        AIPlayCombatAction("ChangeWeapon", self, 0)
    end

    return archetype
end

function GetArgsForArchetypeAndWeaponSelection(unit)
    local args = {}

    if not unit then
        return args
    end

    local role = unit.role or ''

    local map = {
        Marksman = {
            main_w_classes = {"SniperRifle", "AssaultRifle"},
            close_w_classes = {"SubmachineGun", "Revolver", "Pistol"},
            close_archetype = "Skirmisher",
            vr = "AIArchetypeScared"
        },
        Stormer = {
            main_w_classes = {"Firearm"},
            close_w_classes = {"MeleeWeapon"},
            close_archetype = false,
            vr = "AIArchetypeAngry"
        },
        Artillery = {
            main_w_classes = {"Artillery"},
            close_w_classes = {"Firearm"},
            close_archetype = "Skirmisher",
            vr = "AIArchetypeScared"
        }

    }

    args = map[role] or args
    return args
end

---- TODO: check why its changing back to sniper when close conditions are true
function CloseRangeArchetypeSelection(self, context)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype

    local args = GetArgsForArchetypeAndWeaponSelection(self)
    local weapon_classes = args.main_w_classes

    local close_archetype
    if enemy and dist < 6 * const.SlabSizeX then
        weapon_classes = args.close_w_classes
        close_archetype = args.close_archetype
        if args.vr then
            PlayVoiceResponse(self, args.vr)
        end
    end

    local active_w = self:GetActiveWeapons()
    local slot = self.current_weapon or self:GetEquippedWeaponSlot(active_w)
    local alt_slot = slot and (slot == "Handheld A" and "Handheld B" or "Handheld A")
    local secondary_weapons_table = alt_slot and self:GetEquippedWeapons(alt_slot)

    local correct_weapon_equipped = false
    for i, class in ipairs(weapon_classes) do
        if IsKindOf(active_w, class) then
            correct_weapon_equipped = true
            break
        end
    end

    local function can_change()
        if not correct_weapon_equipped and secondary_weapons_table then
            for i, wep in ipairs(secondary_weapons_table) do
                for j, class in ipairs(weapon_classes) do
                    if IsKindOf(wep, class) then
                        return true
                    end
                end
            end
        end
        return false
    end

    local can_change = can_change()

    if can_change() then
        AIPlayCombatAction("ChangeWeapon", self, 0)
        archetype = close_archetype or archetype
    end

    return archetype
end

--[[function CloseRangeArchetypeAndWeaponSelection(self, context, main_weapons, secondary_weapons)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_classes = main_weapons

	local args = GetArgsForArchetypeAndWeaponSelection(unit)

    if enemy and dist < 6 * const.SlabSizeX then
        weapon_classes = secondary_weapons or {"SubmachineGun", "Revolver", "Pistol", "MeleeWeapon"}
        PlayVoiceResponse(self, "AIArchetypeScared")
    end

    local active_w = self:GetActiveWeapons()
    local slot = self.current_weapon or self:GetEquippedWeaponSlot(active_w)
    local alt_slot = slot and (slot == "Handheld A" and "Handheld B" or "Handheld A")
    local secondary_weapons_table = alt_slot and self:GetEquippedWeapons(alt_slot)

    local correct_weapon_equipped = false
    for i, class in ipairs(weapon_classes) do
        if IsKindOf(active_w, class) then
            correct_weapon_equipped = true
            break
        end
    end

    local function check_can_change()
        if not correct_weapon_equipped and secondary_weapons_table then
            for i, wep in ipairs(secondary_weapons_table) do
                for j, class in ipairs(weapon_classes) do
                    if IsKindOf(wep, class) then
                        return true
                    end
                end
            end
        end
        return false
    end

    local can_change = check_can_change()

    -- ic(correct_weapon_equipped, can_change)
    if can_change then
        AIPlayCombatAction("ChangeWeapon", self, 0)
        archetype = "Skirmisher"
    end

    return archetype
end]]

function SoldierArchetypeCustomSelection(self)

    print("SoldierArchetypeCustomSelection")
    if table.find(self.AIKeywords or {}, "Sniper") then
        return SniperArchetypeSelection(self)
    end

    return self.archetype
end

function SniperArchetypeSelection(self)
    local enemy, dist = GetNearestEnemy(self)
    local archetype = self.archetype
    local weapon_classes = {"SniperRifle"}

    if enemy and dist < 6 * const.SlabSizeX then

        weapon_classes = {"SubmachineGun", "Revolver", "Pistol", "MeleeWeapon"}
        PlayVoiceResponse(self, "AIArchetypeScared")
    end

    local using_weapon = false
    for i, class in ipairs(weapon_classes) do
        if self:GetActiveWeapons(class) then
            using_weapon = true
            break
        end
    end

    if not using_weapon then
        AIPlayCombatAction("ChangeWeapon", self, 0)
        archetype = "Skirmisher"
    end

    return archetype
end

