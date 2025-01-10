local fuel_rod = table.deepcopy(data.raw.container["steel-chest"])
local control_rod = table.deepcopy(data.raw.container["steel-chest"])
local moderator_rod = table.deepcopy(data.raw.container["steel-chest"])
local heat_interface = table.deepcopy(data.raw["heat-interface"]["heat-interface"])
local heat_pipe = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
local interface = table.deepcopy(data.raw.container["iron-chest"])
local source_rod = table.deepcopy(data.raw.container["steel-chest"])
local reflector_rod = table.deepcopy(data.raw.container["steel-chest"])
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
circuit_interface.name = "nc-circuit-interface"
circuit_interface.sprites = nil
heat_interface.name = "nc-fuel-rod-heat"
heat_interface.heat_buffer.specific_heat = "1MJ"
heat_interface.heat_buffer.min_temperature_gradient = 1
heat_pipe.name = "nc-heat-pipe"
fuel_rod.name = "fuel-rod"
fuel_rod.picture.layers[1].tint = {255, 255, 0}
fuel_rod.minable.result = "fuel-rod"
control_rod.name = "control-rod"
control_rod.picture.layers[1].tint = {0, 255, 0}
control_rod.minable.result = "control-rod"
moderator_rod.name = "moderator-rod"
moderator_rod.picture.layers[1].tint = {255, 0, 255}
moderator_rod.minable.result = "moderator-rod"
interface.name = "reactor-interface"
interface.picture.layers[1].tint = {255, 0, 0}
interface.minable.result = "reactor-interface"
source_rod.name = "source-rod"
source_rod.picture.layers[1].tint = {255, 0, 0}
source_rod.minable.result = "source-rod"
reflector_rod.name = "reflector-rod"
reflector_rod.picture.layers[1].tint = {255, 128, 0}
reflector_rod.minable.result = "reflector-rod"
data:extend({
    {
        type = "item",
        name = "fuel-rod",
        icons = {
            {
                icon = "__base__/graphics/icons/steel-chest.png",
                tint = {255, 255, 0}
            }
        },
        place_result = "fuel-rod",
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "control-rod",
        icons = {
            {
                icon = "__base__/graphics/icons/steel-chest.png",
                tint = {0, 255, 0}
            }
        },
        place_result = "control-rod",
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "moderator-rod",
        icons = {
            {
                icon = "__base__/graphics/icons/steel-chest.png",
                tint = {255, 0, 255}
            }
        },
        place_result = "moderator-rod",
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "source-rod",
        icons = {
            {
                icon = "__base__/graphics/icons/steel-chest.png",
                tint = {255, 0, 0}
            }
        },
        place_result = "source-rod",
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "reflector-rod",
        icons = {
            {
                icon = "__base__/graphics/icons/steel-chest.png",
                tint = {255, 128, 0}
            }
        },
        place_result = "reflector-rod",
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "reactor-interface",
        icons = {
            {
                icon = "__base__/graphics/icons/iron-chest.png",
                tint = {255, 0, 0}
            }
        },
        place_result = "reactor-interface",
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
})
apply_flags(heat_interface)
apply_flags(heat_pipe)
apply_flags(connector)
apply_flags(circuit_interface)
make_composite(fuel_rod)
make_composite(control_rod)
make_composite(moderator_rod)
make_composite(source_rod)
make_composite(reflector_rod)
make_composite(interface)
data:extend({fuel_rod, control_rod, moderator_rod, reflector_rod, source_rod, interface, heat_interface, heat_pipe, connector, circuit_interface})