local ItemsData = {}
local currentID = ""

concommand.Add("open_items_menu", function()

    local frame = vgui.Create("DFrame")
    frame:SetSize(680, 480)
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
    textEntry:SetPlaceholderText("...") -- показывает серый текст, если пусто 
    textEntry:Dock(BOTTOM)
    textEntry:DockMargin(5, 5, 5, 5)

    -----------------------

    -- Правая панель и хедер над ней
    local rightPanelContainer = vgui.Create("DPanel", container)
    rightPanelContainer:Dock(FILL)
    rightPanelContainer:DockPadding(0, 0, 0, 0)
    ---rightPanelContainer.Paint = function() end

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
    lblWeapon:SetPos(10, 7)
    lblWeapon:SetText("Weapon / Entity")
    lblWeapon:SizeToContents()
    lblWeapon:SetTextColor(Color(255, 255, 255))

    local lblChance = vgui.Create("DLabel", header)
    lblChance:SetPos(220, 7)
    lblChance:SetText("Chance")
    lblChance:SizeToContents()
    lblChance:SetTextColor(Color(255, 255, 255))

    local lblCount = vgui.Create("DLabel", header)
    lblCount:SetPos(320, 7)
    lblCount:SetText("Amount")
    lblCount:SizeToContents()
    lblCount:SetTextColor(Color(255, 255, 255))

    -- Правая панель прокрутки
    local scroll2 = vgui.Create("DScrollPanel", rightPanelContainer)
    scroll2:Dock(FILL)

    local addBtnRight = vgui.Create("DButton", rightPanelContainer)
    addBtnRight:Dock(BOTTOM)
    addBtnRight:SetTall(30)
    addBtnRight:DockMargin(0, 5, 0, 0)
    addBtnRight:SetText("+")

    local function RebuildList(ID)
        scroll2:Clear()
        if ItemsData[ID] == 0 then return end

        currentID = ID
        if not ItemsData[ID] then return end

        for index, data in ipairs(ItemsData[ID]) do
            local panel = vgui.Create("DPanel", scroll2)
            panel:Dock(TOP)
            panel:SetTall(30)
            panel:DockMargin(2, 0, 2, 2)
            panel.Paint = function(self, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50, 255)) -- цвет фона (RGBA)
            end

            -- weapon id
            local wEntry = vgui.Create("DTextEntry", panel)
            wEntry:SetPos(5, 5)
            wEntry:SetSize(200, 20)
            wEntry:SetText(data.weapon)
            wEntry.OnChange = function(self)
                ItemsData[ID][index].weapon = self:GetValue()
            end

            -- chance
            local cEntry = vgui.Create("DNumberWang", panel)
            cEntry:SetPos(210, 5)
            cEntry:SetSize(80, 20)
            cEntry:SetValue(data.chance)
            cEntry.OnValueChanged = function(self, val)
                ItemsData[ID][index].chance = val
            end

            -- count
            local cntEntry = vgui.Create("DNumberWang", panel)
            cntEntry:SetPos(295, 5)
            cntEntry:SetSize(80, 20)
            cntEntry:SetValue(data.count)
            cntEntry.OnValueChanged = function(self, val)
                if val > 0 then
                    ItemsData[ID][index].count = val
                end
            end

            -- кнопка удаления элемента
            local delBtn = vgui.Create("DButton", panel)
            delBtn:SetPos(380, 5)
            delBtn:SetSize(52, 20)
            delBtn:SetText("Remove")
            delBtn.DoClick = function()
                table.remove(ItemsData[ID], index)
                RebuildList(ID) -- обновляем список после удаления
            end
        end
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

            local BtnID = vgui.Create("DButton", panelId)
            BtnID:SetTall(30)
            BtnID:SetPos(8, 5)
            BtnID:SetSize(130, 20)
            BtnID:SetText(key)
            BtnID.ID = key
            BtnID.DoClick = function(self)
                print("Нажата кнопка:", self.ID)
                RebuildList(self.ID)
            end

            -- кнопка удаления элемента
            local delIDBtn = vgui.Create("DButton", panelId)
            delIDBtn:SetPos(140, 5)
            delIDBtn:SetSize(52, 20)
            delIDBtn:SetText("Remove")
            delIDBtn.DoClick = function()
                ItemsData[key] = nil
                currentID = ""
                RebuildIDList() -- обновляем список после удаления
            end
        end
    end

    RebuildIDList()
    

    addBtnRight.DoClick = function()
        if currentID == "" then return end

        table.insert(ItemsData[currentID], {
            weapon = "weapon_pistol",
            chance = 100,
            count = 1
        })

        RebuildList(currentID)
    end

    addBtnLeft.DoClick = function()
        local ID = textEntry:GetValue()
        if ID == "" then return end

        if not ItemsData[ID] then
            ItemsData[ID] = {}
        end

        table.insert(ItemsData[ID], {
            weapon = "weapon_pistol",
            chance = 100,
            count = 1
        })

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
        local keys = {}

        for key, _ in pairs(ItemsData) do
            table.insert(keys, key)
        end
        local str = table.concat(keys, ",")  -- склеиваем через запятую
        print(str)

        RunConsoleCommand("sasbaka_iDlist", str)


        net.Start("RH_A_set_items")
        net.WriteString(json)
        net.SendToServer()

    end

end)