ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Spawn Point"
ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE


function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ID")
end