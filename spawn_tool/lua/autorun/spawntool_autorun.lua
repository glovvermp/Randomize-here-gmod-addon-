-- autorun: подготавливает аддон

if SERVER then
    util.AddNetworkString("RH_activate_all")
    util.AddNetworkString("RH_A_set_items")
    
    util.AddNetworkString("RH_A_clear_all")
    util.AddNetworkString("RH_visible_toggle")
    util.AddNetworkString("RH_freezed_toggle")
end

if CLIENT then
    RunConsoleCommand("sasbaka_iDlist", "empty")
end