local ItemsData = {}
local currentID = nil


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

            -- weapon id
            local wEntry = vgui.Create("DTextEntry", panel)
            wEntry:SetPos(5, 5)
            wEntry:SetSize(200, 20)
            wEntry:SetText(data.weapon)
            wEntry.OnChange = function(self)
                ItemsData[ID]["ITEMS"][index].weapon = self:GetValue()
            end

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

            -- кнопка удаления элемента
            local delBtn = vgui.Create("DButton", panel)
            delBtn:SetPos(380, 5)
            delBtn:SetSize(52, 20)
            delBtn:SetText("Remove")
            delBtn.DoClick = function()
                table.remove(ItemsData[ID]["ITEMS"], index)
                RebuildList(ID) -- обновляем список после удаления
            end
        end

        ---- ПЕРЕКЛЮЧАТЕЛЬ АКТИВАЦИИ
        local check_Colision = general_container:Add("DCheckBoxLabel")
        check_Colision:SetText("Colision")
        check_Colision:DockMargin(10, 5, 5, 0)
        check_Colision:SetTextColor(Color(0, 0, 0))

        local ColiID = ItemsData[ID]["SETTINGS"].colision
        check_Colision:SetChecked(ColiID)

        -- Событие при изменении состояния
        function check_Colision:OnChange(val)
            ItemsData[ID]["SETTINGS"].colision = val
        end

        ------------------------
        local check_Deactivate = general_container:Add("DCheckBoxLabel")
        check_Deactivate:SetText("Deactivate")
        check_Deactivate:DockMargin(10, 5, 5, 0)
        check_Deactivate.Paint = function(self, w, h)
            check_Deactivate:SetTextColor(Color(0, 0, 0))
        end

        local DeacID = ItemsData[ID]["SETTINGS"].deactivate
        check_Deactivate:SetChecked(DeacID)

        -- Событие при изменении состояния
        function check_Deactivate:OnChange(val)
            ItemsData[ID]["SETTINGS"].deactivate = val
        end
        ------------------------

    end

    ---RebuildList()


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
            BtnID.CustomColor = Color(50, 50, 50) 
            BtnID:SetTextColor(Color(255, 255, 255))
            BtnID.Paint = function(self, w, h)
                -- Рисуем фон, используя нашу переменную
                draw.RoundedBox(4, 0, 0, w, h, self.CustomColor)
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
                RebuildIDList() -- обновляем список после удаления
                RebuildList()
            end
        end
    end



    RebuildIDList()
    RebuildList()
    

    addBtnRight.DoClick = function()
        if not currentID then return end

        table.insert(ItemsData[currentID]["ITEMS"], {
            weapon = "weapon_pistol",
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


        table.insert(ItemsData[ID]["ITEMS"], {
            weapon = "weapon_pistol",
            chance = 100,
            count = 1
        })
        ItemsData[ID]["SETTINGS"] = {
            group = "general",
            colision = false,
            deactivate = false,
            maxspawns = 2,
            chance = 25
        }

        RebuildIDList()
    end




    -- кнопка отправки
    local sendBtn = vgui.Create("DButton", frame)
    sendBtn:Dock(BOTTOM)
    sendBtn:SetTall(30)
    sendBtn:SetText("Apply")

    sendBtn.DoClick = function()
        if next(ItemsData) == nil then return end

        local json = util.TableToJSON(ItemsData)

        file.Write("my_items_data.txt", json)
        print("Данные сохранены в garrysmod/data/my_items_data.txt")

        -------------
        local sendTbl = {}
        for k, v in pairs(ItemsData) do
            table.insert(sendTbl, {name = k, data = v})
        end

        net.Start("RH_A_set_items")
        net.WriteString(util.TableToJSON(sendTbl))
        net.SendToServer()
        -------------
        sendIdList()
    end

    function sendIdList()
        if next(ItemsData) == nil then 
            RunConsoleCommand("rhtool_iDlist", "Blank point")
        end
        local keys = {}

        for key, _ in pairs(ItemsData) do
            table.insert(keys, key)
        end
        local str = table.concat(keys, ",")  -- склеиваем через запятую
        RunConsoleCommand("rhtool_iDlist", str)
    end

    sendIdList()
end)

