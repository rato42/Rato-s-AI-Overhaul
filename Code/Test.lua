function StandardAI:Think(unit, debug_data)
    -- print("standard AI think", GameTime())

    self:BeginStep("think", debug_data)
    local context = unit.ai_context

    self:BeginStep("destinations", debug_data)
    AIFindDestinations(unit, context)
    self:EndStep("destinations", debug_data)

    self:BeginStep("optimal location", debug_data)
    AIFindOptimalLocation(context, debug_data and debug_data.optimal_scores)
    self:EndStep("optimal location", debug_data)

    self:BeginStep("end of turn location", debug_data)
    AICalcPathDistances(context)
    if self.override_attack_id ~= "" then
        context.override_attack_id = self.override_attack_id
    end
    if self.override_cost_id and CombatActions[self.override_cost_id] then
        context.override_attack_cost = CombatActions[self.override_cost_id]:GetAPCost(unit)
    end
    AIPrecalcDamageScore(context)
    context.override_attack_id = nil
    context.override_attack_cost = nil
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------- LOOK HERE!

    unit.ai_context.ai_destination = AIScoreReachableVoxels(context, self.EndTurnPolicies,
                                                            self.OptLocWeight, debug_data and
                                                                debug_data.reachable_scores)
    --------- Also look at AIPlayAttacks and AIChooseSignatureAction
    ----------------------------------------------------------------------

    self:EndStep("end of turn location", debug_data)

    self:BeginStep("movement action", debug_data)
    context.movement_action = AIChooseMovementAction(context)
    self:EndStep("movement action", debug_data)
    self:EndStep("think", debug_data)
end

---- CombatAI.lua
--[[function AITakeCover(unit, context)
	local context = unit.ai_context
	if unit:HasPreparedAttack() or not context or ((context.ap_after_signature or 0) <= 0) then
		return
	end
	local cover_high, cover_low = GetCoverTypes(unit)
	if not cover_high and not cover_low then
		return
	end
	if unit.species == "Human" and unit.stance ~= "Prone" then
		local context = unit.ai_context
		local chance = context and context.behavior and context.behavior.TakeCoverChance or 0
		if chance > 0 and (chance >= 100 or unit:Random(100) < chance) then
			local dest = GetPackedPosAndStance(unit)
			local enemy_visible = context.enemy_visible
			local enemy_pos = context.enemy_pack_pos_stance
			for _, enemy in ipairs(context.enemies) do
				if (enemy_visible[enemy] and GetCoverFrom(dest, enemy_pos[enemy]) or 0) > 0 then
					AIPlayCombatAction("TakeCover", unit, 0)
					return
				end
			end
		end
	end
	if cover_low then
		AIPlayCombatAction("StanceCrouch", unit, 0)
	end
end]]

local function VoxelToPoint(voxel)
    return point(point_unpack(voxel))
end

local function DestToPoint(dest)
    local x, y, z = stance_pos_unpack(dest)
    return point(x, y, z)
end
local function PlaceTextFx(text, pos, color)
    local dbg_text = Text:new()
    dbg_text:SetText(tostring(text))
    dbg_text:SetPos(pos)
    if color then
        dbg_text:SetColor(color)
    end
    return dbg_text
end

local ap_scale = const.Scale.AP

local function format_ap(ap)
    return ap and string.format("%d.%d", ap / ap_scale, (10 * ap / ap_scale) / 10) or "N/A"
end

function IModeAIDebug:ShowAIVoxels(group)
    local fx = {}
    self:ClearVoxelFx(fx)
    if not self.selected_unit then
        return
    end

    if group == "candidates" then
        for _, dest in ipairs(self.ai_context.best_dests or empty_table) do
            fx[#fx + 1] = PlaceSquareFX(5 * guic, DestToPoint(dest), const.clrSilverGray)
        end
    elseif group == "collapsed" then
        for _, dest in ipairs(self.ai_context.collapsed or empty_table) do
            fx[#fx + 1] = PlaceSquareFX(5 * guic, DestToPoint(dest), const.clrSilverGray)
        end
    elseif group == "combatpath_ap" then
        for _, dest in ipairs(self.ai_context.destinations or empty_table) do
            local pt = DestToPoint(dest)
            local ap = self.ai_context.dest_ap[dest]
            fx[#fx + 1] = PlaceSquareFX(5 * guic, pt, const.clrYellow)
            fx[#fx + 1] = PlaceTextFx(format_ap(ap), pt, const.clrYellow)
        end
    elseif group == "combatpath_score" then
        local dest_scores = self.think_data.reachable_scores or empty_table
        local threshold =
            MulDivRound(self.ai_context.best_end_score, const.AIDecisionThreshold, 100)
        for _, dest in ipairs(self.ai_context.destinations or empty_table) do
            local scores = dest_scores[dest] or empty_table
            local pt = DestToPoint(dest)
            local score = scores.final_score or 0
            local color = (score >= threshold) and const.clrWhite or const.clrOrange
            fx[#fx + 1] = PlaceSquareFX(5 * guic, pt, color)
            fx[#fx + 1] = PlaceTextFx(string.format("%d", scores.final_score or 0), pt, color)
        end
    elseif group == "combatpath_dist" then
        local dists = self.ai_context.dest_dist or empty_table
        for _, dest in ipairs(self.ai_context.destinations or empty_table) do
            local dist = dists[dest]
            local pt = DestToPoint(dest)
            fx[#fx + 1] = PlaceSquareFX(5 * guic, pt, const.clrYellow)
            fx[#fx + 1] = PlaceTextFx(string.format("%s", tostring(dist)), pt, const.clrYellow)
        end
    elseif group == "combatpath_optscore" then
        local dest_scores = self.think_data.optimal_scores or empty_table
        local threshold =
            MulDivRound(self.ai_context.best_end_score, const.AIDecisionThreshold, 100)
        for _, dest in ipairs(self.ai_context.destinations or empty_table) do
            local scores = dest_scores[dest] or empty_table
            local pt = DestToPoint(dest)
            local score = scores.final_score or 0
            local color = (score >= threshold) and const.clrWhite or const.clrOrange
            fx[#fx + 1] = PlaceSquareFX(5 * guic, pt, color)
            fx[#fx + 1] = PlaceTextFx(string.format("%d", score), pt, color)
        end
    elseif group == "pathtotarget" then
        local reachable = self.ai_context.voxel_to_dest or empty_table

        for _, voxel in ipairs(self.ai_context.path_to_target or empty_table) do
            local dest = reachable[voxel]
            local clr = reachable[voxel] and const.clrYellow or const.clrRed
            local pt = VoxelToPoint(voxel)
            fx[#fx + 1] = PlaceSquareFX(5 * guic, pt, clr)
            fx[#fx + 1] =
                PlaceTextFx(tostring(self.ai_context.dest_dist[dest]), pt, const.clrYellow)
        end
    end
end

