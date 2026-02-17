AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("autorun/server/rh_backend.lua")

-----
function ENT:Initialize()
    self:SetModel("models/hunter/misc/sphere025x025.mdl")
    self:SetMaterial("models/wireframe")

    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:SetCollisionBounds(Vector(-1.2, -1.2, -1.2), Vector(1.2, 1.2, 1.2))


    self:SetMoveType(MOVETYPE_NONE)
    self:SetModelScale(0.4, 0)
    self:DrawShadow(false)
end

-----

function ENT:SpawnRandomItem(ID)

    local spawnItems = {}
    local GLOBAL_SPAWN_ITEMS = GetSpawnItems()

    local data = GLOBAL_SPAWN_ITEMS[ID]


    local deac = data.SETTINGS.deactivate -- проверка оключенна ли точка
    if deac == true then return end

    local Randomize = tonumber(data.SETTINGS.maxspawns) or 1
    local RerollChance = tonumber(data.SETTINGS.chance) or 100

    ------ ОБЩИЙ ВЕС ШАНСА ----
    local totalChance = 0
    
    for _, item in ipairs(data.ITEMS) do
        totalChance = totalChance + item.chance
        if totalChance <= 0 then return end
    end
    ----------------------------

    for i = 1, Randomize do --лимит спавнов у точки

        ------ ЛОГИКА ВЫБОРА -------
        local roll = math.random(totalChance)

        if #data.ITEMS == 1 then 
            local item = data.ITEMS[1]
            if math.random(1, 100) <= item.chance then
                table.insert(spawnItems, item.weapon)
            end

        else
            local cumulative = 0
            for _, item in ipairs(data.ITEMS) do
                cumulative = cumulative + item.chance

                if roll <= cumulative then

                    --local maxCount = tonumber(item.count) or 1       может быть
                    --local count = math.random(1, maxCount)
                    local count = tonumber(item.count) or 1

                    for h = 1, count do
                        table.insert(spawnItems, item.weapon)
                    end

                    break
                end
            end
        end
        ----------------------------
        
    --- шанс продолжить ---
    if math.random(100) > RerollChance then
        break
    end
    end

    --- СПАВН ПРЕДМЕТОВ САМОЙ ТОЧКОЙ ---
    for i, val in ipairs(spawnItems) do
        local ent = ents.Create(val)

        if not IsValid(ent) then continue end
        
        ent:SetPos(self:GetPos() + Vector(0,0,6))
        ent:Spawn()

        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(data.SETTINGS.collision)
        end
    end

end

-----

function ENT:PhysgunPickup(ply)
    return false
end

function ENT:GravGunPickupAllowed(ply)
    return false
end

function ENT:GravGunPunt(ply)
    return false
end

function ENT:Use(activator, caller, type, value)
    return false -- Ничего не делает при нажатии E
end