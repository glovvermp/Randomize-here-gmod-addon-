
local spawnItemsTable = {}
local visiblePoints = false

local CategorizedWeapons = { --Базовая таблица ваниьных свепов для поиска классов оружия
    ["Half-Life 2"] = {
        ["Crowbar"]        = "weapon_crowbar",
        ["Pistol"]         = "weapon_pistol",
        ["357 Magnum"]     = "weapon_357",
        ["SMG"]            = "weapon_smg1",
        ["AR2"]            = "weapon_ar2",
        ["Shotgun"]        = "weapon_shotgun",
        ["Crossbow"]       = "weapon_crossbow",
        ["RPG"]            = "weapon_rpg",
        ["Grenade"]        = "weapon_frag",
        ["Stunstick"]      = "weapon_stunstick",
        ["Gravity Gun"]    = "weapon_physcannon"
    },
    ["Other"] = { 
            ["Physgun"]        = "weapon_physgun",
            ["Gravity Gun"]    = "weapon_physcannon",
            ["Tool Gun"]       = "gmod_tool",
            ["Camera"]         = "weapon_camera"
    },
    ["Entity"] = {
        
            ["Health Kit"]          = "item_healthkit",
            ["Health Vial"]        = "item_healthvial",

            -- Armor
            ["Suit Battery"]       = "item_battery",

            -- Ammo
            ["Pistol Ammo"]        = "item_ammo_pistol",
            ["Pistol Ammo Large"]  = "item_ammo_pistol_large",

            ["SMG Ammo"]           = "item_ammo_smg1",
            ["SMG Ammo Large"]     = "item_ammo_smg1_large",
            ["SMG Grenade"]        = "item_ammo_smg1_grenade",

            ["AR2 Ammo"]           = "item_ammo_ar2",
            ["AR2 Ammo Large"]     = "item_ammo_ar2_large",
            ["AR2 Combine Ball"]   = "item_ammo_ar2_altfire",

            ["Shotgun Ammo"]       = "item_box_buckshot",

            ["357 Ammo"]           = "item_ammo_357",
            ["357 Ammo Large"]     = "item_ammo_357_large",

            ["Crossbow Ammo"]      = "item_ammo_crossbow",

            ["RPG Rocket"]         = "item_rpg_round",

            -- Grenades
            ["Frag Grenade"]       = "weapon_frag"
    }
}

function SetSpawnItems(tbl) --логика для замены имен оружия на классы
    spawnItemsTable = tbl
    for ID, _ in pairs(spawnItemsTable) do
        print("a1", ID)

            for index, item in ipairs(spawnItemsTable[ID]["ITEMS"]) do

                local name = item.weapon
                local found = false

                -- значение по умолчанию
                spawnItemsTable[ID]["ITEMS"][index].weapon = weapon_pistol

                for category, _ in pairs(CategorizedWeapons) do
                    if CategorizedWeapons[category][name] then
                        spawnItemsTable[ID]["ITEMS"][index].weapon = CategorizedWeapons[category][name]
                        print(spawnItemsTable[ID]["ITEMS"][index].weapon)
                        found = true
                        break
                    end
                end
            end
    end
end

function GetSpawnItems()
    return spawnItemsTable
end


net.Receive("RH_activate_all", function(_, ply) --логика для активации всех точек спавна с текущими данными
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

net.Receive("RH_A_clear_all", function(_, ply) --логика для очистки всех точек спавна на карте
    if not ply:IsAdmin() then return end

    for _, ent in ipairs( ents.FindByClass("rh_common_unit") ) do
        if IsValid(ent) then
            ent:Remove()
        end
    end

end)



net.Receive("RH_A_set_items", function(_, ply) --логика для получения данных из меню
    if not ply:IsAdmin() then return end

    local json = net.ReadString()
    local tbl = util.JSONToTable(json)

    local fixedTbl = {}
    for _, entry in ipairs(tbl) do
        fixedTbl[entry.name] = entry.data
    end

    spawnItemsTable = fixedTbl

    SetSpawnItems(fixedTbl)
end)



net.Receive("RH_visible_toggle", function(_, ply) --логика для переключения видимости точек спавна на карте
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


function updateAllCheckbox() --Логика для обновления чекбокса видимости точек спавна у всех игроков (не корректно, но работает)

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


--[[ НА ДАННЫЙ МОМЕНТ НЕ ИСПОЛЬЗУЕТСЯ, НО ЗАГОТОВЛЕНО ДЛЯ БУДУЩЕГО ФУНКЦИОНАЛА.

local CategorizedEntities = {}

for classname, ent in pairs(scripted_ents.GetList()) do --Ищем все энтити в игре и сортируем их по категориям (не используется сейчас, но заготовено для будущего функционала)
    local data = ent.t
    if data and data.Spawnable then
        local cat = data.Category or "Other" -- Если категория не указана
        local name = data.PrintName or classname
        
        CategorizedEntities[cat] = CategorizedEntities[cat] or {}
        CategorizedEntities[cat][name] = classname
    end
end

]]

for _, swep in pairs(weapons.GetList()) do --Ищем все оружия и предметы в игре и сортируем их по категориям
    if swep.Spawnable then

        local cat = swep.Category or "Other"
        local name = swep.PrintName or swep.ClassName

        if isstring(name) and name:sub(1, 1) == "#" then --Игнорируем локализованные имена
            continue
        end
        
        CategorizedWeapons[cat] = CategorizedWeapons[cat] or {}
        CategorizedWeapons[cat][name] = swep.ClassName
    end
end




net.Receive("RH_OrderSWEPSToClient", function(_, ply) --Логика для отправки клиенту таблицы всех свепов и предметов в игре для отображения в меню

    local jsonData = util.TableToJSON(CategorizedWeapons)
    
    net.Start("RH_SendSWEPSToClient")
        net.WriteString(jsonData)
        print("Отправка JSON для: " .. ply:Nick())
    net.Send(ply) -- Отправляем конкретному игроку

end)