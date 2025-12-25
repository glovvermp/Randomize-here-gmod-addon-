-- autorun: подготавливает аддон

if SERVER then
    util.AddNetworkString("RH_activate_all")
    util.AddNetworkString("RH_A_set_items")
    
    util.AddNetworkString("RH_A_clear_all")
    util.AddNetworkString("RH_visible_toggle")
end
