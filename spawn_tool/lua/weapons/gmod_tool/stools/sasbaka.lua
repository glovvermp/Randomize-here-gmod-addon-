TOOL.Category = "Randomize here!"
TOOL.Name = "Spawn Tool - A"
TOOL.Mode = "sasbaka"

TOOL.ClientConVar = {

    items = "weapon_pistol"
    swich = "1"

}

function TOOL:LeftClick(trace)
    if CLIENT then return true end
    
    local ent = ents.Create("my_spawn_point")
    ent:SetPos(trace.HitPos)
    ent:Spawn()

    return true
end

if CLIENT then

    cvars.AddChangeCallback("sasbaka_swich", function(convar, old, new)

        local RH_visible = GetConVar("sasbaka_swich"):GetString()

        print("-------")
        print(RH_visible)
        print(new)

        net.Start("RH_visible_toggle")
        net.WriteBool(new == "1")
        net.SendToServer()
    end)

    concommand.Add("RH_activate_all", function()
        net.Start("RH_activate_all")
        net.SendToServer()
    end)

    concommand.Add("RH_A_clear_all", function()
        net.Start("RH_A_clear_all")
        net.SendToServer()
    end)

    concommand.Add("spawnpoint_apply_items", function()
        local text = GetConVar("sasbaka_items"):GetString()
        print(text)
        net.Start("RH_A_set_items")
        net.WriteString(text)
        net.SendToServer()
    end)


    function TOOL.BuildCPanel(panel)
        panel:AddControl("Header", {
            Text = "Spawn Point Tool",
            Description = "Создаёт невидимую точку спавна"
        })

        panel:AddControl( "Label", {
            Text = "Список предметов (через запятую)"
        })
        panel:AddControl("TextBox", {
            Command = "sasbaka_items"
        })
        panel:AddControl("Button", {
            Text = "применить",
            Command = "spawnpoint_apply_items"
        })

        panel:AddControl( "Label", {
             Text = "   " 
        })

        panel:AddControl("Button", {
            Text = "Активировать точки",
            Command = "RH_activate_all"
        })

        panel:AddControl( "Label", {
             Text = "   " 
        })

        panel:AddControl("Button", {
            Text = "Удалить все точки",
            Command = "RH_A_clear_all"
        })

        panel:AddControl("CheckBox", {
            Label = "Показывать энтити",
            Command = "sasbaka_swich"
        })

    end
end
