AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GLOBAL_SPAWN_ITEMS = {}
freezedPhyz = true
-----
function ENT:Initialize()
    self:SetModel("models/hunter/misc/sphere025x025.mdl")
    self:SetMaterial("models/wireframe")

    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(Vector(-4, -4, -4), Vector(4, 4, 4))
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

    self:SetMoveType(MOVETYPE_NONE)
    self:SetModelScale(0.5, 0)
    self:DrawShadow(false)
end
-----
function ENT:SpawnRandomItem(ID)

    spawnItems = {}
    Randomize = true

    while Randomize do
        local totalChance = 0
        for _, item in ipairs(GLOBAL_SPAWN_ITEMS[ID]) do
            totalChance = totalChance + item.chance + 1
        end

        local roll = math.random(totalChance)

        if table.getn(GLOBAL_SPAWN_ITEMS[ID]) == 1 then 
            item = GLOBAL_SPAWN_ITEMS[ID][1]
            if math.random(1, 100) <= item.chance then
                table.insert(spawnItems, item.weapon)
            end
        else
            local cumulative = 0
            for _, item in ipairs(GLOBAL_SPAWN_ITEMS[ID]) do
                cumulative = cumulative + item.chance
                if roll <= cumulative then
                    count = math.random(tonumber(item.count))
                    for i = 1, count do
                        table.insert(spawnItems, item.weapon)
                    end
                end
            end
        end

        breakItems = math.random(25)
        if breakItems > 2 then
            break
        end
    end


    for i, val in ipairs(spawnItems) do
        local ent = ents.Create(val)
        if not IsValid(ent) then return end
        
        ent:SetPos(self:GetPos() + Vector(0,0,6))
        ent:Spawn()

        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(freezedPhyz)
        end
    end

end

-----
net.Receive("RH_activate_all", function(_, ply)
    PrintTable(GLOBAL_SPAWN_ITEMS)

    if next(GLOBAL_SPAWN_ITEMS) == nil then return end

    for key, _ in pairs(GLOBAL_SPAWN_ITEMS) do
        print(key, "элемент")

        for _, ent in ipairs( ents.FindByClass("my_spawn_point") ) do
            if IsValid(ent) then
                print("Энтити:", ent, "ID:", ent:GetID())
                if string.Trim(ent:GetID()) == tostring(key) then

                    print(key, "в теории спавн")
                
                    ent:SpawnRandomItem(key)

                end
            end
        end

        print("--------------")
    end
end)
-----
net.Receive("RH_A_clear_all", function(_, ply)

    for _, ent in ipairs( ents.FindByClass("my_spawn_point") ) do
        if IsValid(ent) then
            ent:Remove()
        end
    end

end)
-----
net.Receive("RH_A_set_items", function(_, ply)

    local json = net.ReadString()
    local tbl = util.JSONToTable(json)
    print(tbl)  -- теперь tbl — полноценная таблица
    GLOBAL_SPAWN_ITEMS = tbl

end)
-----
net.Receive("RH_visible_toggle", function(_, ply)

    local visible = net.ReadBool()

    for _, ent in ipairs( ents.FindByClass("my_spawn_point") ) do
        if IsValid(ent) then
            ent:SetNoDraw(not visible)
        end
        
    end

end)

net.Receive("RH_freezed_toggle", function(_, ply)

    local phyz = net.ReadBool()
    freezedPhyz = phyz


end)

function ENT:PhysgunPickup(ply)
    return false
end