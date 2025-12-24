AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GLOBAL_SPAWN_ITEMS = {
    "weapon_pistol"
}
-----
function ENT:Initialize()
    self:SetModel("models/props_junk/garbage_metalcan002a.mdl")
    self:SetMaterial("models/wireframe")
    self:SetNoDraw(false)
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)

    self:SpawnRandomItem()
end
-----
function ENT:SpawnRandomItem()
    if not GLOBAL_SPAWN_ITEMS or #GLOBAL_SPAWN_ITEMS == 0 then return end

    local class = GLOBAL_SPAWN_ITEMS[ math.random(#GLOBAL_SPAWN_ITEMS) ]
    local ent = ents.Create(class)
    if not IsValid(ent) then return end

    ent:SetPos(self:GetPos() + Vector(0,0,12))
    ent:Spawn()
end
-----
function ENT:SetItemsFromString(str)
    local tbl = string.Explode(",", str)

    for i, v in ipairs(tbl) do
        tbl[i] = string.Trim(v)
    end

    GLOBAL_SPAWN_ITEMS = tbl
end
-----
net.Receive("RH_activate_all", function(_, ply)

    for _, ent in ipairs( ents.FindByClass("my_spawn_point") ) do
        if IsValid(ent) then
            ent:SpawnRandomItem()
        end
    end

end)
-----
net.Receive("RH_A_set_items", function(_, ply)

    local text = net.ReadString()

    for _, ent in ipairs( ents.FindByClass("my_spawn_point") ) do
        ent:SetItemsFromString(text)
    end
    
end)