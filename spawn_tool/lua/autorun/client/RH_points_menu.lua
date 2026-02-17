local ItemsData = {}
local currentID = nil
local SwepList = {}

concommand.Add("RH_open_items_menu", function()

    if not LocalPlayer():IsAdmin() then
        print("Доступ запрещен!")
        notification.AddLegacy("У вас нет прав администратора!", NOTIFY_ERROR, 5)
        surface.PlaySound("buttons/button10.wav")
        return false -- Отменяет открытие меню
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(720, 580)
    frame:Center()
    frame:SetTitle("Randomize Here!")
    frame:MakePopup()

    local container = vgui.Create("DPanel", frame)
    container:Dock(FILL)
    container:DockPadding(5, 5, 5, 5)
    container.Paint = function() end -- прозрачный

        -- левая панель и хедер над ней
    local leftPanelContainer = vgui.Create("DPanel", container)
    leftPanelContainer:Dock(LEFT)
    leftPanelContainer:SetWide(200)
    leftPanelContainer:DockPadding(0, 0, 0, 0)
    leftPanelContainer:DockMargin(0, 0, 5, 0)

    local headerLeft = vgui.Create("DPanel", leftPanelContainer)
    headerLeft:SetTall(30)
    headerLeft:Dock(TOP)
    headerLeft:DockMargin(0, 0, 0, 5)
    headerLeft.Paint = function(self, w, h)
        surface.SetDrawColor(60, 60, 60, 255)
        surface.DrawRect(0, 0, w, h)
    end

        --элемент
    local lblWeapon = vgui.Create("DLabel", headerLeft)
    lblWeapon:SetPos(10, 7)
    lblWeapon:SetText("Point ID")
    lblWeapon:SizeToContents()
    lblWeapon:SetTextColor(Color(255, 255, 255))


        -- Левая панель (пустая)
    local scroll1 = vgui.Create("DScrollPanel", leftPanelContainer)
    scroll1:Dock(FILL)

    local addBtnLeft = vgui.Create("DButton", leftPanelContainer)
    addBtnLeft:Dock(BOTTOM)
    addBtnLeft:SetTall(30)
    addBtnLeft:SetText("+")
    
    local textEntry = vgui.Create("DTextEntry", leftPanelContainer)
    textEntry:SetPlaceholderText("ID name") -- показывает серый текст, если пусто 
    textEntry:Dock(BOTTOM)
    textEntry:DockMargin(5, 5, 5, 5)

    -----------------------

    -- Правая панель и хедер над ней
    local rightPanelContainer = vgui.Create("DPanel", container)
    rightPanelContainer:Dock(FILL)

    -- Хедер над правой панелью
    local header = vgui.Create("DPanel", rightPanelContainer)
    header:SetTall(30)
    header:Dock(TOP)
    header:DockMargin(0, 0, 0, 5)
    header.Paint = function(self, w, h)
        surface.SetDrawColor(60, 60, 60, 255)
        surface.DrawRect(0, 0, w, h)
    end

    -- Названия колонок
    local lblWeapon = vgui.Create("DLabel", header)
    lblWeapon:SetPos(30, 7)
    lblWeapon:SetText("Weapon / Entity")
    lblWeapon:SizeToContents()
    lblWeapon:SetTextColor(Color(255, 255, 255))

    local lblChance = vgui.Create("DLabel", header)
    lblChance:SetPos(230, 7)
    lblChance:SetText("Chance")
    lblChance:SizeToContents()
    lblChance:SetTextColor(Color(255, 255, 255))

    local lblCount = vgui.Create("DLabel", header)
    lblCount:SetPos(320, 7)
    lblCount:SetText("Amount")
    lblCount:SizeToContents()
    lblCount:SetTextColor(Color(255, 255, 255))

    -- Правая панель прокрутки
    local scrollRight = vgui.Create("DScrollPanel", rightPanelContainer)
    scrollRight:Dock(FILL) -- Растягивает по ширине родителя

    local scroll2 = vgui.Create("DScrollPanel", scrollRight)
    scroll2:Dock(TOP) -- Растягивает по ширине родителя
    scroll2:SetTall(250)
    scroll2:DockMargin(20, 5, 20, 0)
    scroll2.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(100, 100, 100, 255))
    end


            -- Категория базовых настроек
    local general_settings = vgui.Create("DCollapsibleCategory", scrollRight)
    general_settings:Dock(TOP)
    general_settings:DockMargin(5, 20, 5, 5)
    general_settings:SetLabel("General settings") -- Текст в заголовке
    general_settings:SetExpanded(true) -- По умолчанию открыта (false - закрыта)
    general_settings:SetZPos(1)
    -- Стилизация заголовка
    general_settings.Header.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(68, 68, 68)) -- Цвет фона шапки
    end
    -- Стилизация текста в заголовке
    general_settings.Header:SetTextColor(Color(255, 255, 255))
    -- Цвет фона при разворачивании
    general_settings.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(188, 188, 188, 255))
    end

    local general_container  = vgui.Create("DListLayout", general_settings)
    general_settings:SetContents(general_container)

    


    local addBtnRight = vgui.Create("DButton", scrollRight)
    addBtnRight:Dock(TOP)
    addBtnRight:SetZPos(0)
    addBtnRight:SetTall(30)
    addBtnRight:DockMargin(20, 5, 20, 0)
    addBtnRight:SetText("Add weapon / entity")

    local function RebuildList(ID)
        scroll2:Clear()
        general_container:Clear()
        if ItemsData[ID] == 0 then return end

        currentID = ID
        if not ItemsData[ID] then return end

        for index, data in ipairs(ItemsData[ID]["ITEMS"]) do
            local panel = vgui.Create("DPanel", scroll2)
            panel:Dock(TOP)
            panel:SetTall(30)
            panel:DockMargin(5, 5, 5, 0)
            panel.Paint = function(self, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(0, 0, 0, 150)) -- цвет фона (RGBA)
            end


            local btn = vgui.Create("DButton", panel)
            btn:SetText(ItemsData[ID]["ITEMS"][index].weapon)
            btn:SetSize(200, 20)
            btn:SetPos(5, 5)

            btn.DoClick = function()
                local menu = DermaMenu()

                menu:SetMaxHeight(ScrH() * 0.5) -- 60% высоты экрана
                menu:SetMinimumWidth(200)

                menu:AddSpacer()

                for category, class in pairs(SwepList) do
                    menu:AddOption(category):SetDisabled(true)
                    for name, class in pairs(SwepList[category]) do

                        menu:AddOption(name, function()
                            btn:SetText(name)
                            ItemsData[ID]["ITEMS"][index].weapon = name

                            print(SwepList[category][name])
                            print(ItemsData[ID]["ITEMS"][index].weapon)
                        end)
                    end
                end

                menu:Open()
            end
            -----------


            -- chance
            local cEntry = vgui.Create("DNumberWang", panel)
            cEntry:SetPos(210, 5)
            cEntry:SetSize(80, 20)
            cEntry:SetValue(data.chance)
            cEntry.OnValueChanged = function(self, val)
                ItemsData[ID]["ITEMS"][index].chance = val
            end

            -- count
            local cntEntry = vgui.Create("DNumberWang", panel)
            cntEntry:SetPos(295, 5)
            cntEntry:SetSize(80, 20)
            cntEntry:SetValue(data.count)
            cntEntry.OnValueChanged = function(self, val)
                if val > 0 then
                    ItemsData[ID]["ITEMS"][index].count = val
                end
            end

            -- delete
            local delBtn = vgui.Create("DButton", panel)
            delBtn:SetPos(380, 5)
            delBtn:SetSize(52, 20)
            delBtn:SetText("Remove")
            delBtn.DoClick = function()
                table.remove(ItemsData[ID]["ITEMS"], index)
                RebuildList(ID) -- обновляем список
            end
        end

        ---- ПЕРЕКЛЮЧАТЕЛЬ АКТИВАЦИИ
        local check_Colision = general_container:Add("DCheckBoxLabel")
        check_Colision:SetText("Collision")
        check_Colision:DockMargin(10, 5, 5, 0)
        check_Colision:SetTextColor(Color(0, 0, 0))

        local ColiID = ItemsData[ID]["SETTINGS"].collision
        check_Colision:SetChecked(ColiID)

        function check_Colision:OnChange(val)
            ItemsData[ID]["SETTINGS"].collision = val
        end


        ------------------------ Проверка на деактивацию спавна
        local check_Deactivate = general_container:Add("DCheckBoxLabel")
        check_Deactivate:SetText("Deactivate")
        check_Deactivate:DockMargin(10, 5, 5, 0)
        check_Deactivate.Paint = function(self, w, h)
            check_Deactivate:SetTextColor(Color(0, 0, 0))
        end

        local DeacID = ItemsData[ID]["SETTINGS"].deactivate
        check_Deactivate:SetChecked(DeacID)

        function check_Deactivate:OnChange(val)
            ItemsData[ID]["SETTINGS"].deactivate = val
        end
        ------------------------

    end


    local function RebuildIDList()
        scroll1:Clear()

        for key, _ in pairs(ItemsData) do

            local panelId = vgui.Create("DPanel", scroll1)
            panelId:Dock(TOP)
            panelId:SetTall(30)
            panelId:DockMargin(2, 0, 2, 2)
            panelId.Paint = function(self, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50, 255)) -- цвет фона (RGBA)
            end

            ---
            local BtnID = vgui.Create("DButton", panelId)
            BtnID:SetTall(30)
            BtnID:SetPos(2, 2)
            BtnID:SetSize(162, 26)
            BtnID:SetText(key)
            BtnID.ID = key
            BtnID.btColor = Color(50, 50, 50) 
            BtnID:SetTextColor(Color(255, 255, 255))
            BtnID.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, self.btColor)
            end
            BtnID.DoClick = function(self)
                RebuildList(self.ID)
            end
            ---

            -- кнопка удаления элемента
            local delIDBtn = vgui.Create("DButton", panelId)
            delIDBtn:SetPos(170, 5)
            delIDBtn:SetSize(20, 20)
            delIDBtn:SetText("×")
            delIDBtn:SetFont("DermaLarge")
            delIDBtn.DoClick = function()
                ItemsData[key] = nil
                currentID = nil
                RebuildIDList()
                RebuildList()
            end
        end
    end



    RebuildIDList()
    RebuildList()
    

    addBtnRight.DoClick = function()
        if not currentID then return end

        table.insert(ItemsData[currentID]["ITEMS"], { --Базовые данные для нового элемента
            weapon = "Pistol",
            chance = 100,
            count = 1
        })

        RebuildList(currentID)
    end

    ------

    addBtnLeft.DoClick = function()
        local ID = tostring(textEntry:GetValue())

        if ID == "" then return end

        -- Добавляем если нет
        if not ItemsData[ID] then
            ItemsData[ID] = {}
        end
        if not ItemsData[ID]["ITEMS"] then
            ItemsData[ID]["ITEMS"] = {}
        end


        table.insert(ItemsData[ID]["ITEMS"], { --Добавляем новый элемент с базовыми данными
            weapon = "Pistol",
            chance = 100,
            count = 1
        })
        ItemsData[ID]["SETTINGS"] = {
            group = "general",
            collision = false,
            deactivate = false,
            maxspawns = 2,
            chance = 25
        }

        RebuildIDList()
    end




    -- кнопка отправки
    local panelbuttons = vgui.Create("DPanel", frame)
    panelbuttons:Dock(BOTTOM)
    panelbuttons:SetTall(30)
    panelbuttons:DockMargin(2, 0, 2, 2)
    panelbuttons.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50, 255)) -- цвет фона (RGBA)
    end

    local sendBtn = vgui.Create("DButton", panelbuttons)
    sendBtn:Dock(LEFT)
    sendBtn:SetTall(30)
    sendBtn:SetWide(350)
    sendBtn:SetText("Apply")


    local restoreBtn = vgui.Create("DButton", panelbuttons)
    restoreBtn:Dock(RIGHT)
    restoreBtn:SetTall(30)
    restoreBtn:SetWide(350)
    restoreBtn:SetText("Restore save")



    --=========--
    sendBtn.DoClick = function()
        if next(ItemsData) == nil then return end
        -------------
        local sendTbl = {}
        for k, v in pairs(ItemsData) do
            table.insert(sendTbl, {name = k, data = v})
        end

        local json = util.TableToJSON(sendTbl)

        file.Write("my_items_data.txt", json) -- сохраняем в файл

        net.Start("RH_A_set_items")
        net.WriteString(json)
        net.SendToServer()
        -------------
        sendIdList()
    end




    restoreBtn.DoClick = function()

        -- Читаем строку из файла
        local content = file.Read("my_items_data.txt", "DATA")

        if content then

            local tbl = util.JSONToTable(content)

            local fixedTbl = {}
            for _, entry in ipairs(tbl) do
                fixedTbl[entry.name] = entry.data
            end

            data = fixedTbl

            ItemsData = data

            PrintTable(data)
        else
            print("No save file found!")
        end

        RebuildIDList()
        RebuildList()

    end
    --=========--



    function sendIdList()
        if next(ItemsData) == nil then 
            RunConsoleCommand("rhtool_iDlist", "Blank point")
        end
        local keys = {}

        for key, _ in pairs(ItemsData) do
            table.insert(keys, key)
        end
        local str = table.concat(keys, ",")
        RunConsoleCommand("rhtool_iDlist", str)
    end

    sendIdList()


    net.Receive("RH_SendSWEPSToClient", function() -- Получаем данные от сервера при открытии меню
        local jsonData = net.ReadString()
        local tbl = util.JSONToTable(jsonData)

        if tbl then
            print("Данные от сервера получены:")
            SwepList = tbl
            PrintTable(tbl)
        end
    end)

    net.Start("RH_OrderSWEPSToClient")
    net.SendToServer()
end)