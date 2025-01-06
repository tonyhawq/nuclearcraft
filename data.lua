local fuel_rod = table.deepcopy(data.raw.container["steel-chest"])
local control_rod = table.deepcopy(data.raw.container["steel-chest"])
local moderator_rod = table.deepcopy(data.raw.container["steel-chest"])
local heat_interface = table.deepcopy(data.raw["heat-interface"]["heat-interface"])
local heat_pipe = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
local interface = table.deepcopy(data.raw.container["iron-chest"])
local connector = {
    type = "simple-entity-with-owner",
    name = "nc-connector",
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
}
local function apply_flags(thing)
    local flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-upgradable"}
    thing.flags = flags
    thing.selectable_in_game = false
    thing.hidden = true
end

local function make_composite(thing)
    thing.created_effect = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                type = "script",
                effect_id = "built"
            }
        }
    }
end

heat_interface.name = "nc-fuel-rod-heat"
heat_interface.heat_buffer.specific_heat = "1MJ"
heat_interface.heat_buffer.min_temperature_gradient = 1
heat_pipe.name = "nc-heat-pipe"
fuel_rod.name = "fuel-rod"
fuel_rod.picture.layers[1].tint = {255, 255, 0}
control_rod.name = "control-rod"
control_rod.picture.layers[1].tint = {255, 0, 0}
moderator_rod.name = "moderator-rod"
moderator_rod.picture.layers[1].tint = {255, 0, 255}
interface.name = "reactor-interface"
interface.picture.layers[1].tint = {255, 0, 0}
apply_flags(heat_interface)
apply_flags(heat_pipe)
apply_flags(connector)
make_composite(fuel_rod)
make_composite(control_rod)
make_composite(moderator_rod)
make_composite(interface)
data:extend({fuel_rod, control_rod, moderator_rod, interface, heat_interface, heat_pipe, connector})