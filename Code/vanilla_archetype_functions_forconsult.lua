--[[function Unit:GetArchetype()
    local arch = Archetypes[self.script_archetype]
    if arch then
        return arch
    end
    return Archetypes[self.current_archetype] or Archetypes.Soldier
end

function Unit:GetCurrentArchetype()
    return Archetypes[self.current_archetype] or Archetypes.Soldier
end

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

function Unit:StartAI(debug_data, forced_behavior)
    if not IsValid(self) or self:IsDead() or self.ai_context or self:HasStatusEffect("Unconscious") then
        return
    end
    AIReloadWeapons(self)

    local proto_context = {}
    self:SelectArchetype(proto_context)

    -- local context = AICreateContext(self, proto_context)
    -- local archetype = context.archetype
    local archetype = self:GetArchetype()

    local scores, available = {}, {}
    local total = 0

    AIUpdateBiases()
    for i, behavior in ipairs(archetype.Behaviors) do
        local weight_mod, disable, priority
        if behavior:MatchUnit(self) then
            weight_mod, disable, priority = AIGetBias(behavior.BiasId, self)
            priority = priority or behavior.Priority
        else
            weight_mod, disable, priority = 0, true, false
        end

        if debug_data then
            debug_data.behaviors = debug_data.behaviors or {}
            debug_data.behaviors[i] = {
                name = behavior:GetEditorView(),
                priority = priority,
                disable = disable,
                behavior = behavior,
                index = i
            }
        end

        if not disable then
            local score = MulDivRound(behavior:Score(self, proto_context, debug_data), weight_mod,
                                      100)
            if debug_data then
                debug_data.behaviors[i].score = score
            end
            if score > 0 then
                if priority and not forced_behavior then
                    forced_behavior = behavior
                    break
                end
                scores[#scores + 1] = score
                available[#available + 1] = behavior
                total = total + score
            end
        end
    end

    if total == 0 and not forced_behavior then
        printf("unit of %s archetype failed to select a behavior!", archetype.id)
        return
    end

    local roll = InteractionRand(total, "AIBehavior", self)
    local selected
    if not forced_behavior then
        for i, behavior in ipairs(available) do
            local score = scores[i]
            if roll <= score then
                selected = behavior
                break
            end
            roll = roll - score
        end
    end

    if self.ai_context then
        self.ai_context.behavior = forced_behavior or selected or available[#available]
    else
        proto_context.behavior = forced_behavior or selected or available[#available]
        AICreateContext(self, proto_context)
    end
    if self.ai_context.behavior then
        self.ai_context.behavior:OnStart(self)
    end
    return true
end
]] 
