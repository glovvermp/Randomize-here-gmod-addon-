-- не трогать, это авторан для спавнтула, в котором прописаны все сетевые строки и начальные команды для клиента

if SERVER then
    util.AddNetworkString("RH_activate_all")
    util.AddNetworkString("RH_A_set_items")
    
    util.AddNetworkString("RH_A_clear_all")
    util.AddNetworkString("RH_visible_toggle")
    util.AddNetworkString("RH_freezed_toggle")


    util.AddNetworkString("RH_SendSWEPSToClient")
    util.AddNetworkString("RH_OrderSWEPSToClient")
end

if CLIENT then
    RunConsoleCommand("rhtool_iDlist", "empty")
end