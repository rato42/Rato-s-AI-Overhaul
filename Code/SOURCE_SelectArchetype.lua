function UnitProperties:SelectArchetype(proto_context)
    local archetype
    local func = empty_func

    if IsKindOf(self, "Unit") then
        local emplacement = g_Combat and g_Combat:GetEmplacementAssignment(self)
        if self.retreating then
            archetype = "Deserter"
        elseif self:HasStatusEffect("Panicked") then
            archetype = "Panicked"
        elseif self:HasStatusEffect("Berserk") then
            archetype = "Berserk"
        elseif emplacement then
            assert(self.CanManEmplacements)
            archetype = "EmplacementGunner"
            proto_context.target_interactable = emplacement
        elseif self.command == "Reposition" and self.RepositionArchetype then
            archetype = self.RepositionArchetype
        end

        -- check for scout archetype first
        local can_scout = not archetype
        can_scout = can_scout and (not g_Encounter or g_Encounter:CanScout())
        can_scout = can_scout and self.script_archetype ~= "GuardArea"
        if can_scout then
            local enemies = self:GetVisibleEnemies()
            if #enemies == 0 then
                self.last_known_enemy_pos = self.last_known_enemy_pos or AIPickScoutLocation(self)
                if self.last_known_enemy_pos then
                    archetype = "Scout_LastLocation"
                end
            end
        end

        if not archetype then
            for _, descr in pairs(g_Pindown) do
                if descr.target == self then
                    if self:Random(100) < self.PinnedDownChance then
                        archetype = "PinnedDown"
                    end
                    break
                end
            end
        end

        local template = UnitDataDefs[self.unitdatadef_id]
        func = template and template.PickCustomArchetype or self.PickCustomArchetype
    end

    self.current_archetype = archetype or func(self, proto_context) or self.archetype or "Assault"
end
