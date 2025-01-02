function GetArgsForArchetypeAndWeaponSelection(unit)

    if not unit then
        return false
    end

    local role = unit.role or ''

    local map = {
        Marksman = {
            main_w_classes = {"SniperRifle", "AssaultRifle"},
            close_w_classes = {"SubmachineGun", "Revolver", "Pistol"},
            close_archetype = "RATOAI_RetreatingMarksman",
            vr = "AIArchetypeScared"
        },
        Stormer = {
            main_w_classes = {"Firearm"},
            close_w_classes = {"MeleeWeapon"},
            close_archetype = "Brute",
            vr = "AIArchetypeAngry"
        },
        Artillery = {
            main_w_classes = {"Artillery"},
            close_w_classes = {"Firearm"},
            close_archetype = "RATOAI_RetreatingMarksman",
            vr = "AIArchetypeScared"
        }

    }

    local args = map[role] or false

    if not args then
        ic()
        print("RATOAI - ERROR - No args found for PickCustomArchetype for unit_id: ",
              unit.session_id, " role:", role)
    end

    return args
end

---- TODO: snipers should have Handgun
---- TODO: grenadiers only offensive grenades

function CloseRangeArchetypeSelection(self, context)
    local archetype = self.archetype
    local args = GetArgsForArchetypeAndWeaponSelection(self)

    if not args then
        return archetype
    end

    local enemy, dist = GetNearestEnemy(self)
    local weapon_classes = args.main_w_classes

    if enemy and dist <= const.Weapons.PointBlankRange * const.SlabSizeX then
        weapon_classes = args.close_w_classes
        archetype = args.close_archetype or archetype
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

    if can_change() then
        AIPlayCombatAction("ChangeWeapon", self, 0)
    end

    return archetype
end
