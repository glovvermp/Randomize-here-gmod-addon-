TOOL.Category = "Randomize here!"
TOOL.Name = "Spawn Tool"
TOOL.Mode = "rhtool"

if CLIENT then
    language.Add("tool.rhtool.name", "Spawn Tool")      -- название
    language.Add("tool.rhtool.desc", "Spawn point for random items") -- описание
    language.Add("tool.rhtool.0", "Left click to spawn, Right click on a point to delete") -- инструкция
end

TOOL.ClientConVar = {

    items = "weapon_pistol",
    swich = "1",
    debugLabels = "1",
    iDlist = "Blank point",
    choosed = "0"

}

function TOOL:LeftClick(trace)
    if CLIENT then return true end


    local ply = self:GetOwner()
    if not IsValid(ply) then return false end


    local ISvisible = GetConVar("rhtool_swich"):GetString()
    local choosedID = GetConVar("rhtool_choosed"):GetString()
    
    local ent = ents.Create("rh_common_unit")
    ent:SetPos(trace.HitPos)

    ent:SetID(choosedID)
    ent:SetNoDraw(not (ISvisible ~= "0"))

    ent:Spawn()

    return true
end


function TOOL:RightClick(trace)
    if CLIENT then return true end


    local ply = self:GetOwner()
    if not IsValid(ply) then return false end


    local ent = trace.Entity

    if not IsValid(ent) then return false end
    if ent:GetClass() ~= "rh_common_unit" then return false end

    ent:Remove()

    return true
end


if CLIENT then

    cvars.AddChangeCallback("rhtool_swich", function(convar, old, new)

        local RH_visible = GetConVar("rhtool_swich"):GetString()

        net.Start("RH_visible_toggle")
        net.WriteBool(new == "1")
        net.SendToServer()
    end)

    -----------------------

    concommand.Add("RH_activate_all", function()

    if not LocalPlayer():IsAdmin() then
        print("Доступ запрещен!")
        notification.AddLegacy("У вас нет прав администратора!", NOTIFY_ERROR, 5)
        surface.PlaySound("buttons/button10.wav")
        return false -- Отменяет открытие меню
    end

        net.Start("RH_activate_all")
        net.SendToServer()
    end)

    concommand.Add("RH_A_clear_all", function()

    if not LocalPlayer():IsAdmin() then
        print("Доступ запрещен!")
        notification.AddLegacy("У вас нет прав администратора!", NOTIFY_ERROR, 5)
        surface.PlaySound("buttons/button10.wav")
        return false -- Отменяет открытие меню
    end

        net.Start("RH_A_clear_all")
        net.SendToServer()
    end)


    -------


    function TOOL.BuildCPanel(panel)

        panel:AddControl("Header", {
            Text = "Spawn Point Tool",
            Description = "Creates and removes a spawn point"
        })

        panel:AddControl( "Label", {
             Text = "Spawn Point ID" 
        })

        local combo = vgui.Create("DComboBox")
        combo:SetTall(22)
        combo:SetValue("Select an item from the list")
        panel:AddItem(combo)

        -- функция для обновления списка из ConVar
        local function UpdateCombo()
            combo:Clear()
            -- получаем строку с элементами через запятую без пробелов
            local raw = GetConVar("rhtool_iDlist"):GetString()
            if raw == "" then return end

            local items = string.Explode(",", raw)

            for _, item in ipairs(items) do
                combo:AddChoice(item, item)
            end

            if #items > 0 then
                combo:SetValue(items[1])
                RunConsoleCommand("rhtool_choosed", items[1])
            end
        end

        UpdateCombo()

        -- обработка выбора
        combo.OnSelect = function(_, _, value)
            RunConsoleCommand("rhtool_choosed", value)
        end

        -- обновление списка при изменении ConVar
        cvars.AddChangeCallback("rhtool_iDlist", function(convar_name, old_value, new_value)
            UpdateCombo()
        end, "UpdaterhtoolCombo")


        local spacerlist = vgui.Create("DPanel", panel)
        spacerlist:SetTall(40)
        spacerlist:Dock(TOP)
        spacerlist.Paint = nil

        
        panel:AddControl("CheckBox", {
            Label = "Show spawn points (see all players)",
            Command = "rhtool_swich"
        })

        panel:AddControl("CheckBox", {
            Label = "Show spawn points Debug Labels (see only you)",
            Command = "rhtool_debugLabels"
        })


        local spacerup = vgui.Create("DPanel", panel)
        spacerup:SetTall(10)
        spacerup:Dock(TOP)
        spacerup.Paint = nil

        panel:AddControl("Button", {
            Text = "Spawn points settings",
            Command = "RH_open_items_menu"
        })

        panel:AddControl("Button", {
            Text = "Enable all spawn points",
            Command = "RH_activate_all"
        })

        local spacer1 = vgui.Create("DPanel", panel)
        spacer1:SetTall(60)
        spacer1:Dock(TOP)
        spacer1.Paint = nil

        panel:AddControl("Button", {
            Text = "Remove all spawn points",
            Command = "RH_A_clear_all",
        })
    end

    local function IsOurToolActive()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end

        local wep = ply:GetActiveWeapon()
        if not IsValid(wep) then return false end

        return wep:GetClass() == "gmod_tool"
            and ply:GetTool() ~= nil
            and ply:GetTool().Mode == "rhtool"
    end

    hook.Add("PostDrawTranslucentRenderables", "ToolPreviewSphere", function()
        if not IsOurToolActive() then return end

        local tr = LocalPlayer():GetEyeTrace()
        if not tr.Hit then return end

        render.SetColorMaterial()
        render.DrawWireframeSphere(
            tr.HitPos,
            0.15 * 16,        -- радиус (0.5 юнита ≈ 8–16)
            12,
            12,
            Color(255, 255, 255),
            true
        )
    end)
end

----------

hook.Add("PostDrawTranslucentRenderables", "DrawEntityIDs", function()

    if not LocalPlayer():IsAdmin() then
        return -- Отменяет открытие меню
    end

    for _, ent in ipairs(ents.FindByClass("rh_common_unit")) do
        local RH_visible_text = GetConVar("rhtool_debugLabels"):GetString()
        if not IsValid(ent) then continue end
        if RH_visible_text == "0" then continue end

        local RH_visiblePoint = GetConVar("rhtool_swich"):GetString()

        local text = ent:GetID()
        if text == "" then continue end

        local pos = ent:GetPos() + Vector(0, 0, 10)
        local posGROUP = ent:GetPos() + Vector(0, 0, 15)
        local posPoint = ent:GetPos() + Vector(0, 0, 2)

        local ang = LocalPlayer():EyeAngles()
        ang:RotateAroundAxis(ang:Right(), 90)
        ang:RotateAroundAxis(ang:Up(), -90)

        cam.Start3D2D(pos, ang, 0.15)
            draw.SimpleText(
                text,
                "DermaLarge",
                0, 0,
                Color(255, 255, 255),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )
        cam.End3D2D()

        if RH_visiblePoint == "0" then
            cam.Start3D2D(posPoint, ang, 0.25)
                draw.SimpleText(
                    "x",
                    "DermaLarge",
                    0, 0,
                    Color(255, 255, 255),
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER
                )
            cam.End3D2D()
        end
    end
end)