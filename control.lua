Formula = require("__yantm__.scripts.formula")
Schedule = require("__yantm__.scripts.schedule")
Rods = require("__yantm__.scripts.rods")
InterfaceGUI = require("__yantm__.scripts.interface-gui")
RodGUI = require("__yantm__.scripts.rod-gui")
ControlRodGUI = require("__yantm__.scripts.control-rod-gui")
Remnants = require("__yantm__.scripts.remnants")
Cooling = require("__yantm__.scripts.cooling-towers")
Cameras = require("__yantm__.scripts.camera-surface")
Explorer = require("__yantm__.scripts.formula-explorer")
require("__yantm__.scripts.remote")

commands.add_command("explore", "", function (command)
    if command.player_index ~= nil then
        local player = game.get_player(command.player_index)
        Explorer.open(player--[[@as LuaPlayer]])
    end
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

script.on_configuration_changed(function()
    Rods.setup()
    Schedule.setup()
    Remnants.setup()
    Cooling.setup()
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
                for _, controller in pairs(reactor.controllers) do
                    Rods.update_controller(controller)
                end
                for _, control_rod in pairs(reactor.control_rods) do
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

script.on_event(defines.events.on_player_created, function (event)
    local player = game.get_player(event.player_index)
    if not player then
        return
    end
    Explorer.on_player_created(player)
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