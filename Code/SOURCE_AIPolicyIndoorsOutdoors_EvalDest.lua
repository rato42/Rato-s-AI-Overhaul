function AIPolicyIndoorsOutdoors:EvalDest(context, dest, grid_voxel)
    local check = AICheckIndoors(dest) == self.Indoors
    return check and self.Weight or 0
end
