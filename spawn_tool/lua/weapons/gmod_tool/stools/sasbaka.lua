TOOL.Category = "Randomize here!"
TOOL.Name = "Spawn Tool"
TOOL.Mode = "sasbaka"

if CLIENT then
    language.Add("tool.sasbaka.name", "Spawn Tool")      -- название
    language.Add("tool.sasbaka.desc", "Spawn point for random items") -- описание
    language.Add("tool.sasbaka.0", "Left click to spawn, Right click on a point to delete") -- инструкция
end

TOOL.ClientConVar = {

    items = "weapon_pistol",
    swich = "1",
    freezed = "0",
    iDlist = "empty",
    choosed = "0"
}

function TOOL:LeftClick(trace)
    if CLIENT then return true end

    local ISvisible = GetConVar("sasbaka_swich"):GetString()
    local choosedID = GetConVar("sasbaka_choosed"):GetString()
    
    local ent = ents.Create("my_spawn_point")
    ent:SetPos(trace.HitPos)

    ent:SetID(choosedID)
    ent:SetNoDraw(not (ISvisible ~= "0"))

    ent:Spawn()

    return true
end

function TOOL:RightClick(trace)
    if CLIENT then return true end

    local ent = trace.Entity

    if not IsValid(ent) then return false end
    if ent:GetClass() ~= "my_spawn_point" then return false end

    ent:Remove()

    return true
end

if CLIENT then

    cvars.AddChangeCallback("sasbaka_swich", function(convar, old, new)

        local RH_visible = GetConVar("sasbaka_swich"):GetString()

        net.Start("RH_visible_toggle")
        net.WriteBool(new == "1")
        net.SendToServer()
    end)
    ---
    cvars.AddChangeCallback("sasbaka_freezed", function(convar, old, new)

        local RH_freezed = GetConVar("sasbaka_freezed"):GetString()

        net.Start("RH_freezed_toggle")
        net.WriteBool(new == "1")
        net.SendToServer()
    end)

    -----------------------

    concommand.Add("RH_activate_all", function()
        net.Start("RH_activate_all")
        net.SendToServer()
    end)

    concommand.Add("RH_A_clear_all", function()
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

        -- создаём выпадающий список один раз
        local combo = vgui.Create("DComboBox")
        combo:SetTall(22)
        combo:SetValue("Select an item from the list")

        panel:AddItem(combo)

        -- функция для обновления списка из ConVar
        local function UpdateCombo()
            combo:Clear() -- очищаем старые элементы

            -- получаем строку с элементами через запятую без пробелов
            local raw = GetConVar("sasbaka_iDlist"):GetString()
            if raw == "" then return end

            local items = string.Explode(",", raw)

            for _, item in ipairs(items) do
                combo:AddChoice(item, item)
            end

            -- можно выбрать первый элемент по умолчанию
            if #items > 0 then
                combo:SetValue(items[1])
                RunConsoleCommand("sasbaka_choosed", items[1])
            end
        end

        -- изначально заполняем список
        UpdateCombo()

        -- обработка выбора
        combo.OnSelect = function(_, _, value)
            RunConsoleCommand("sasbaka_choosed", value)
        end

        -- обновление списка при изменении ConVar
        cvars.AddChangeCallback("sasbaka_iDlist", function(convar_name, old_value, new_value)
            UpdateCombo()
        end, "UpdateSasbakaCombo")


        local spacerup = vgui.Create("DPanel", panel)
        spacerup:SetTall(10)
        spacerup:Dock(TOP)
        spacerup.Paint = nil

        panel:AddControl("CheckBox", {
            Label = "Show spawn points",
            Command = "sasbaka_swich"
        })

        panel:AddControl("CheckBox", {
            Label = "Enable item physics",
            Command = "sasbaka_freezed"
        })

        local spacer = vgui.Create("DPanel", panel)
        spacer:SetTall(40)
        spacer:Dock(TOP)
        spacer.Paint = nil

        panel:AddControl("Button", {
            Text = "Spawn points settings",
            Command = "open_items_menu"
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

        local spacer2 = vgui.Create("DPanel", panel)
        spacer2:SetTall(10)
        spacer2:Dock(TOP)
        spacer2.Paint = nil
    end


    

    local function IsOurToolActive()
        local ply = LocalPlayer()
        if not IsValid(ply) then return false end

        local wep = ply:GetActiveWeapon()
        if not IsValid(wep) then return false end

        return wep:GetClass() == "gmod_tool"
            and ply:GetTool() ~= nil
            and ply:GetTool().Mode == "sasbaka"
    end

    hook.Add("PostDrawTranslucentRenderables", "ToolPreviewSphere", function()
        if not IsOurToolActive() then return end

        local tr = LocalPlayer():GetEyeTrace()
        if not tr.Hit then return end

        render.SetColorMaterial()
        render.DrawWireframeSphere(
            tr.HitPos,
            0.2 * 16,        -- радиус (0.5 юнита ≈ 8–16)
            12,
            12,
            Color(255, 255, 255),
            true
        )
    end)
end

----------

hook.Add("PostDrawTranslucentRenderables", "DrawEntityIDs", function()

    for _, ent in ipairs(ents.FindByClass("my_spawn_point")) do
        local RH_visible_text = GetConVar("sasbaka_swich"):GetString()
        if not IsValid(ent) then continue end
        if RH_visible_text == "0" then continue end

        local text = ent:GetID()
        if text == "" then continue end

        local pos = ent:GetPos() + Vector(0, 0, 10)

        local ang = LocalPlayer():EyeAngles()
        ang:RotateAroundAxis(ang:Right(), 90)
        ang:RotateAroundAxis(ang:Up(), -90)

        cam.Start3D2D(pos, ang, 0.15)
            draw.SimpleText(
                text,
                "DermaLarge",
                1, 1,
                Color(255, 255, 255),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )
        cam.End3D2D()
    end
end)