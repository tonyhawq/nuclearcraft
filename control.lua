Formula = require("__control-your-rods__.scripts.formula")
Schedule = require("__control-your-rods__.scripts.schedule")
Rods = require("__control-your-rods__.scripts.rods")
InterfaceGUI = require("__control-your-rods__.scripts.interface-gui")
RodGUI = require("__control-your-rods__.scripts.rod-gui")
ControlRodGUI = require("__control-your-rods__.scripts.control-rod-gui")
Remnants = require("__control-your-rods__.scripts.remnants")
Cooling = require("__control-your-rods__.scripts.cooling-towers")
Cameras = require("__control-your-rods__.scripts.camera-surface")
Explorer = require("__control-your-rods__.scripts.formula-explorer")
require("__control-your-rods__.scripts.remote")

--TODO: allow ctrl-c ctrl-v to save fuel request config.

commands.add_command("dbgcyr", "Debug mode", function ()
    game.print("Enabling debug mode.")
    storage.debug = true
end)

script.on_init(function()
    Rods.setup()
    Schedule.setup()
    Remnants.setup()
    Cooling.setup()
    Cameras.setup()
end)

script.on_load(function ()
    Cameras.on_load()
end)

script.on_nth_tick(15, function (_)
    for _, player in pairs(game.connected_players) do
        RodGUI.update(player)
        InterfaceGUI.update(player)
        ControlRodGUI.update(player)
    end
end)

script.on_configuration_changed(function(event)
    Rods.setup()
    Rods.on_configuration_changed(event.new_version)
    Schedule.setup()
    Remnants.setup()
    Cooling.setup()
end)

script.on_event(defines.events.on_lua_shortcut, function (event)
    if event.prototype_name == "control-your-rods-explorer" then
        local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
        Explorer.open(player)
        return
    end
    local name = event.prototype_name:gsub("^cyr%-explorer%-shortcut%-", "")
    if Explorer.has_page(name) then
        local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
        return Explorer.open_page(name, player)
    end
end)

script.on_event(defines.events.on_tick, function(event)
    Remnants.update()
    Cooling.update()
    for _, reactor in pairs(storage.reactors) do
        ---@cast reactor Reactor
        if next(reactor.fuel_rods) then
            local score = reactor.score
            score = score + reactor.add_score
            if score > 0 then
                local reactor_controllers = reactor.controllers
                for _, controller in pairs(reactor_controllers) do
                    Rods.update_controller(controller, reactor)
                end
                local reactor_control_rods = reactor.control_rods
                for _, control_rod in pairs(reactor_control_rods) do
                    Rods.update_control_rod(control_rod)
                end
                reactor.fuels = {}
                reactor.dumps = {}
                if reactor.need_fuel > 0 and next(reactor.inputs) then
                    Rods.get_available_fuels(reactor)
                end
                if reactor.need_waste > 0 and next(reactor.outputs) then
                    Rods.get_available_dumps(reactor)
                end
                local k = reactor.k
                local v
                local fuel_rods = reactor.fuel_rods
                while score > 0 do
                    score = score - 1
                    k, v = next(fuel_rods, k)
                    if not v then k, v = next(fuel_rods, k) end
                    ---@cast v FuelRod
                    -- because this code only runs if fuel_rods contains something, v is guaranteed to have a value.
                    Rods.update_fuel_rod(v)
                    if reactor.melting_down then
                        break
                    end
                end
                reactor.k = k
            end
            reactor.score = score
        end
        --[[
        if not reactor.melting_down and next(reactor.control_rods) then
            local score = reactor.cscore
            score = score + reactor.add_cscore
            if score > 0 then
                for _, controller in pairs(reactor.controllers) do
                    Rods.update_controller(controller)
                end
                local k = reactor.ck
                local v
                local control_rods = reactor.control_rods
                while score > 0 do
                    score = score - 1
                    k, v = next(control_rods, k)
                    if not v then k, v = next(control_rods, k) end
                    Rods.update_control_rod(v)
                end
                reactor.ck = k
            end
            reactor.cscore = score
        end]]
        --[[
        if not reactor.melting_down and reactor.group_controllers then
            local score = reactor.iscore
            score = score + reactor.add_iscore
            if score > 0 then
                local k = reactor.ik
                local v
                local controllers = reactor.controllers
                while score > 0 do
                    score = score - 1
                    k, v = next(controllers, k)
                    if not v then k, v = next(controllers, k) end
                    Rods.update_controller(v)
                end
                reactor.ik = k
            end
            reactor.iscore = score
        end]]
    end
end)

script.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id == "built" then
        Rods.on_built(event.source_entity)
        Cooling.on_built(event.source_entity)
    elseif event.effect_id == "cap-land" then
        Remnants.on_cap_land(event.source_entity)
    end
end)

script.on_event(defines.events.on_object_destroyed, function(event)
    Rods.on_destroyed(event)
    Cooling.on_destroyed(event)
end)

script.on_event(defines.events.on_entity_settings_pasted, function(event)
    Rods.on_paste(event.source, event.destination)
end)

script.on_event(defines.events.on_gui_value_changed, function (event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    RodGUI.value_changed(event, player)
    Explorer.on_value_changed(event.element)
end)

script.on_event(defines.events.on_gui_confirmed, function (event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    RodGUI.on_gui_confirmed(event, player)
    InterfaceGUI.on_gui_confirmed(event, player)
end)

script.on_event(defines.events.on_gui_opened, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    local entity = event.entity --[[@as LuaEntity]]
    InterfaceGUI.open(player, entity)
    RodGUI.open(player, entity)
    ControlRodGUI.open(player, entity)
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
    Explorer.gui_text_changed(event.element, event.text)
    RodGUI.gui_text_changed(event.element, game.get_player(event.player_index) --[[@as LuaPlayer]])
end)

script.on_event(defines.events.on_gui_selection_state_changed, function(event)
    Explorer.on_gui_selection_state_changed(event.element)
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    InterfaceGUI.close(player)
    RodGUI.on_close(event, player)
    ControlRodGUI.on_close(event, player)
    Explorer.on_close(event, player)
end)

script.on_event(defines.events.on_gui_switch_state_changed, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    InterfaceGUI.on_gui_switch_state_changed(event, player)
    RodGUI.on_gui_switch_state_changed(event, player)
end)

script.on_event(defines.events.on_player_mined_entity, function (event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    Rods.on_player_mined(player, event.entity)
end)

script.on_event(defines.events.on_robot_mined_entity, function (event)
    Rods.on_robot_mined(event.entity)
end)

script.on_event(defines.events.on_gui_click, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    InterfaceGUI.player_clicked_gui(event, player)
    RodGUI.player_clicked_gui(event, player)
    ControlRodGUI.player_clicked_gui(event, player)
    Explorer.player_clicked_gui(event, player)
end)

script.on_event(defines.events.on_gui_elem_changed, function(event)
    local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
    RodGUI.player_changed_elem(event, player)
    InterfaceGUI.player_changed_elem(event, player)
end)