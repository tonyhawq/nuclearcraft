Schedule = require("__nuclearcraft__.scripts.schedule")
Rods = require("__nuclearcraft__.scripts.rods")
InterfaceGUI = require("__nuclearcraft__.scripts.interface-gui")
RodGUI = require("__nuclearcraft__.scripts.rod-gui")

script.on_init(function()
    Rods.setup()
    Schedule.setup()
end)

script.on_configuration_changed(function()
    Rods.setup()
    Schedule.setup()
end)

script.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id == "built" then
        Rods.on_built(event.source_entity)
    end
end)

script.on_event(defines.events.on_gui_opened, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    local entity = event.entity --[[@as LuaEntity]]
    InterfaceGUI.open(player, entity)
    RodGUI.open(player, entity)
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    InterfaceGUI.close(player)
    RodGUI.close(player)
end)

script.on_event(defines.events.on_gui_click, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    InterfaceGUI.player_clicked_gui(event, player)
    RodGUI.player_clicked_gui(event, player)
end)