local heat_interface = table.deepcopy(data.raw["heat-interface"]["heat-interface"])
local heat_pipe = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
local circuit_interface = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
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
    thing.collision_mask = {layers={}}
end
circuit_interface.name = "nc-circuit-interface"
circuit_interface.sprites = nil
heat_interface.collision_box = {{-0.5, -0.5}, {0.5, 0.5}}
heat_interface.name = "nc-fuel-rod-heat"
heat_interface.heat_buffer.specific_heat = "1MJ"
heat_interface.heat_buffer.max_temperature = 3000
heat_interface.heat_buffer.max_transfer = "1GW"
heat_interface.heat_buffer.min_temperature_gradient = 1
heat_pipe.name = "nc-heat-pipe"
heat_pipe.heat_buffer.max_temperature = 3000
heat_pipe.heat_buffer.max_transfer = "1GW"
apply_flags(heat_interface)
apply_flags(heat_pipe)
apply_flags(connector)
apply_flags(circuit_interface)
data:extend({heat_interface, heat_pipe, connector, circuit_interface})


require("prototypes.projectiles")
require("prototypes.entity")
require("prototypes.signal")
require("prototypes.recipe")
require("prototypes.item")