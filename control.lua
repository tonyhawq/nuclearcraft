Formula = require("__nuclearcraft__.scripts.formula")
Schedule = require("__nuclearcraft__.scripts.schedule")
Rods = require("__nuclearcraft__.scripts.rods")
InterfaceGUI = require("__nuclearcraft__.scripts.interface-gui")
RodGUI = require("__nuclearcraft__.scripts.rod-gui")

script.on_init(function()
    Rods.setup()
    Schedule.setup()
end)

script.on_nth_tick(15, function (_)
    for _, player in pairs(game.connected_players) do
        RodGUI.update(player)
    end
end)

script.on_nth_tick(60, function (_)
    for _, reactor in pairs(storage.reactors) do
        Rods.update_reactor(reactor)
    end
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

script.on_event(defines.events.on_object_destroyed, function(event)
    Rods.on_destroyed(event)
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

script.on_event(defines.events.on_gui_elem_changed, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    RodGUI.player_changed_elem(event, player)
end)

commands.add_command("power", "", function (event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    local gui = player.gui.relative[RodGUI.root]
    if not gui then
        return
    end
    local rod = storage.rods[gui.tags.id] --[[@as FuelRod]]
    rod.power = tonumber(event.parameter) or 0
    RodGUI.update(player)
end)
commands.add_command("slow", "", function (event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    local gui = player.gui.relative[RodGUI.root]
    if not gui then
        return
    end
    local rod = storage.rods[gui.tags.id] --[[@as FuelRod]]
    rod.slow_flux = tonumber(event.parameter) or 0
    RodGUI.update(player)
end)
commands.add_command("fast", "", function (event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    local gui = player.gui.relative[RodGUI.root]
    if not gui then
        return
    end
    local rod = storage.rods[gui.tags.id] --[[@as FuelRod]]
    rod.fast_flux = tonumber(event.parameter) or 0
    RodGUI.update(player)
end)