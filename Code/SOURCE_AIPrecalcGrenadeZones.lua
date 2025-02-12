--[[local function IsUnitHit(hit)
    if not IsKindOf(hit.obj, "Unit") then
        return false
    end
    if hit.damage > 0 then
        return true
    end
    for _, effect in ipairs(hit.effects) do
        if effect and effect ~= "" then
            return true
        end
    end
end

function AIPrecalcGrenadeZones(context, action_id, min_range, max_range, blast_radius, aoeType,
                               target_pts)
    if context.target_locked then
        return {}
    end

    if not target_pts then
        target_pts = AICalcAOETargetPoints(context, min_range, max_range, blast_radius)
    else
        -- make sure the target points are within the allowed range
        AIFilterTargetPoints(context.unit, target_pts, min_range, max_range)
    end

    -- calculate parabolas and affected units to each target point
    local zones = {}
    local action = CombatActions[action_id]
    local args = {target = false}
    for i, target_pt in ipairs(target_pts) do
        args.target = target_pt
        local results = action:GetActionResults(context.unit, args)

        local units
        local trajectory = results.trajectory or empty_table
        local pos = #trajectory > 0 and trajectory[#trajectory].pos or results.target_pos
        if pos and (aoeType == "smoke" or aoeType == "toxicgas" or aoeType == "teargas") then
            local water = terrain.IsWater(pos) and terrain.GetWaterHeight(pos)
            if not (water and (not pos:IsValidZ() or water >= pos:z())) then
                pos = SnapToPassSlab(pos) or pos
                local dx, dy = 1, 1
                for i = #trajectory - 1, 1, -1 do
                    local step = trajectory[i]
                    if step.pos:Dist2D(pos) > 0 then
                        local px, py = step.pos:xy()
                        local x, y = pos:xy()
                        dx = (px == x) and 1 or ((x - px) / abs(x - px))
                        dy = (py == y) and 1 or ((y - py) / abs(y - py))
                        break
                    end
                end

                local gx, gy, gz = WorldToVoxel(pos)
                local smoke, blocked = PropagateSmokeInGrid(gx, gy, gz, dx, dy)
                local smoke_voxels = {}
                for _, wpt in pairs(smoke) do
                    local ppos = point_pack(WorldToVoxel(wpt))
                    smoke_voxels[ppos] = true
                end

                for _, unit in ipairs(g_Units) do
                    local _, head = unit:GetVisualVoxels()
                    if smoke_voxels[head] then
                        units = units or {}
                        table.insert(units, unit)
                    end
                end
            end
        else
            for _, hit in ipairs(results) do
                if IsUnitHit(hit) then
                    units = units or {}
                    table.insert(units, hit.obj)
                end
            end
        end
        if units then
            zones[#zones + 1] = {target_pos = target_pt, units = units}
        end
    end

    -- print("grenade targeting precalc in", GetPreciseTicks() - tstart, "ms")
    return zones
end
]] 
