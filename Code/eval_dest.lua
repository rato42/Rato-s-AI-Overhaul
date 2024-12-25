table_score_cover = {}

function AIPolicyTakeCover:EvalDest(context, dest, grid_voxel)
    local score = 0
    -- local test_score = 0

    -- local context_cover = context.dest_target_cover_score[dest]

    local ux, uy, uz, ustance_idx = stance_pos_unpack(dest)
    -- DbgAddCircle(point(ux, uy, uz))
    local tbl = context.enemies or empty_table
    for _, enemy in ipairs(tbl) do
        local visible = true
        if self.visibility_mode == "self" then
            visible = context.enemy_visible[enemy]
        elseif self.visibility_mode == "team" then
            visible = context.enemy_visible_by_team[enemy]
        end
        if visible then
            local cover = GetCoverFrom(dest, context.enemy_pack_pos_stance[enemy])

            score = score + self.CoverScores[cover]
        end
    end

    -- DbgAddText(score / Max(1, #tbl), point(ux, uy, uz))
    -- local end_score = MulDivRound(score, Max(1, #tbl), 1)
    -- table.insert(table_score_cover, end_score)

    -- ic(score / Max(1, #tbl), test_score / Max(1, #tbl))
    return score / Max(1, #tbl)
end

AIPolicyTakeCover.CoverScores = {
    [const.CoverPass] = 0,
    [const.CoverNone] = 0,
    [const.CoverLow] = 50,
    [const.CoverHigh] = 100
}

function AIPolicyFlanking:EvalDest(context, dest, grid_voxel)
    local unit = context.unit

    local ap = context.dest_ap[dest] or 0
    if self.ReserveAttackAP and ap < context.default_attack_cost then
        return 0
    end

    if not context.position_override then
        context.position_override = {}
        if self.AllyPlannedPosition then
            for _, ally in ipairs(unit.team.units) do
                local dest = ally.ai_context and ally.ai_context.ai_destination
                if dest then
                    local x, y, z = stance_pos_unpack(dest)
                    context.position_override[ally] = point(x, y, z)
                end
            end
        end
    end

    local x, y, z = stance_pos_unpack(dest)
    context.position_override[unit] = point(x, y, z)

    if not context.enemy_surrounded then
        context.enemy_surrounded = {}
        for _, enemy in ipairs(context.enemies) do
            if enemy:IsSurrounded() then
                context.enemy_surrounded[enemy] = true
            end
        end
    end

    local delta = 0
    for _, enemy in ipairs(context.enemies) do
        local new_surrounded = enemy:IsSurrounded(context.position_override)
        if new_surrounded and not context.enemy_surrounded[enemy] then
            delta = delta + 1
        elseif not new_surrounded and context.enemy_surrounded[enemy] then
            delta = delta - 1
        end
    end

    return delta * self.Weight
end
