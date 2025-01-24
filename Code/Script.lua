MapSlabsBBox_MaxZ = 100000
function AIEnumValidDests(context)
    local unit = context.unit
    local r = context.archetype.OptLocSearchRadius * const.SlabSizeX
    local ux, uy, uz = point_unpack(context.unit_grid_voxel)
    local px, py, pz = VoxelToWorld(ux, uy, uz)
    local bbox = box(px - r, py - r, 0, px + r + 1, py + r + 1, MapSlabsBBox_MaxZ)

    local dests, dest_added = {}, {}
    local function push_dest(x, y, z, context, dests, dest_added, ux, uy, uz)
        local gx, gy, gz = WorldToVoxel(x, y, z)

        if not IsCloser(gx, gy, gz, ux, uy, uz, context.archetype.OptLocSearchRadius) then
            return
        end
        if not CanOccupy(unit, x, y, z) then
            return
        end

        local world_voxel = point_pack(x, y, z)
        local dest = context.voxel_to_dest[world_voxel]
        if not dest then
            dest = stance_pos_pack(x, y, z, StancesList[context.archetype.PrefStance])
        end
        if not dest_added[dest] then
            dests[#dests + 1] = dest
            dest_added[dest] = true
        end
    end

    ForEachPassSlab(bbox, push_dest, context, dests, dest_added, ux, uy, uz)

    -- add current pos
    if not dest_added[context.unit_stance_pos] then
        local x, y, z = stance_pos_unpack(context.unit_stance_pos)
        if CanOccupy(unit, x, y, z) then
            dests[#dests + 1] = context.unit_stance_pos
            dest_added[context.unit_stance_pos] = true
        end
    end

    -- add from context.destinations
    for _, dest in ipairs(context.destinations) do
        if not dest_added[dest] then
            dests[#dests + 1] = dest
        end
    end

    dests = CollapsePoints(dests, 1)
    for _, dest in ipairs(context.important_dests) do
        table.insert_unique(dests, dest)
    end
    return dests
end
