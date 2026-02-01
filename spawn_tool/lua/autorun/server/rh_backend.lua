
local spawnItemsTable = {}
local visiblePoints = false

function SetSpawnItems(tbl)
    spawnItemsTable = tbl
end

function GetSpawnItems()
    return spawnItemsTable
end


net.Receive("RH_activate_all", function(_, ply)
    if not ply:IsAdmin() then return end

    if not spawnItemsTable or next(spawnItemsTable) == nil then return end

    local entities = ents.FindByClass("rh_common_unit")
    for _, ent in ipairs(entities) do
        if not IsValid(ent) then continue end

        local entID = string.Trim(ent:GetID())

        if spawnItemsTable[entID] then
            ent:SpawnRandomItem(tostring(entID))
        end
    end
end)

net.Receive("RH_A_clear_all", function(_, ply)
    if not ply:IsAdmin() then return end

    for _, ent in ipairs( ents.FindByClass("rh_common_unit") ) do
        if IsValid(ent) then
            ent:Remove()
        end
    end

end)



net.Receive("RH_A_set_items", function(_, ply)
    if not ply:IsAdmin() then return end

    local json = net.ReadString()
    local tbl = util.JSONToTable(json)

    local fixedTbl = {}
    for _, entry in ipairs(tbl) do
        fixedTbl[entry.name] = entry.data
    end

    spawnItemsTable = fixedTbl

    SetSpawnItems(fixedTbl)
    PrintTable(fixedTbl)
end)



net.Receive("RH_visible_toggle", function(_, ply)
    if not ply:IsAdmin() then return end


    local visible = net.ReadBool()
    visiblePoints = (not visible)
    updateAllCheckbox()


    for _, ent in ipairs( ents.FindByClass("rh_common_unit") ) do
        if IsValid(ent) then
            ent:SetNoDraw(not visible)
        end
        
    end

end)

function updateAllCheckbox()

    local strbool = "0"

    if visiblePoints then
        strbool = "0"
    else
        strbool = "1"
    end

    for _, ply in ipairs(player.GetAll()) do

        ply:SetNWBool("swich", not visiblePoints)
    end

end

