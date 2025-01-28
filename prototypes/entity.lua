data:extend({
    {
        type = "constant-combinator",
        name = "fuel-rod",
        flags = {"placeable-neutral", "player-creation"},
        icons = {
            {
                icon = "__nuclearcraft__/graphics/entity/green.png",
                icon_size = 64,
            }
        },
        activity_led_light_offsets = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"].activity_led_light_offsets),
        circuit_wire_connection_points = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"].circuit_wire_connection_points),
        circuit_wire_max_distance = 16,
        max_health = 500,
        collision_box = {{-0.4,-0.4},{0.4,0.4}},
        selection_box = {{-0.5,-0.5},{0.5,0.5}},
        map_color = {94,140,99},
        minable = {result="fuel-rod",mining_time=0.5},
        sprites = {
            north = {
                filename = "__nuclearcraft__/graphics/entity/fuel-rod.png",
                width = 64,
                height = 64,
                scale = 0.5,
            },
            east = {
                filename = "__nuclearcraft__/graphics/entity/fuel-rod.png",
                width = 64,
                height = 64,
                scale = 0.5,
            },
            south = {
                filename = "__nuclearcraft__/graphics/entity/fuel-rod.png",
                width = 64,
                height = 64,
                scale = 0.5,
            },
            west = {
                filename = "__nuclearcraft__/graphics/entity/fuel-rod.png",
                width = 64,
                height = 64,
                scale = 0.5,
            },
        }
    },
    {
        type = "container",
        name = "control-rod",
        flags = {"placeable-neutral", "player-creation"},
        inventory_size = 1,
        max_health = 500,
        circuit_wire_max_distance = 16,
        circuit_connector = table.deepcopy(data.raw.container["steel-chest"].circuit_connector),
        collision_box = {{-0.4,-0.4},{0.4,0.4}},
        selection_box = {{-0.5,-0.5},{0.5,0.5}},
        map_color = {255,255,0},
        minable = {result="control-rod", mining_time=0.5},
        icons = {
            {
                icon = "__nuclearcraft__/graphics/entity/yellow.png",
                icon_size = 64,
            }
        },
        picture = {
            filename = "__nuclearcraft__/graphics/entity/control-rod.png",
            width = 64,
            height = 64,
            scale = 0.5,
        }
    },
    {
        type = "container",
        name = "moderator-rod",
        flags = {"placeable-neutral", "player-creation"},
        inventory_size = 1,
        localised_description = {"nuclearcraft.moderator-description", "80"},
        max_health = 500,
        collision_box = {{-0.4,-0.4},{0.4,0.4}},
        selection_box = {{-0.5,-0.5},{0.5,0.5}},
        map_color = {255,0,255},
        minable = {result="moderator-rod", mining_time=0.5},
        icons = {
            {
                icon = "__nuclearcraft__/graphics/entity/purple.png",
                icon_size = 64,
            }
        },
        picture = {
            filename = "__nuclearcraft__/graphics/entity/moderator-rod.png",
            width = 64,
            height = 64,
            scale = 0.5,
        }
    },
    {
        type = "container",
        name = "source-rod",
        flags = {"placeable-neutral", "player-creation"},
        inventory_size = 1,
        max_health = 500,
        collision_box = {{-0.4,-0.4},{0.4,0.4}},
        selection_box = {{-0.5,-0.5},{0.5,0.5}},
        map_color = {255,0,0},
        minable = {result="source-rod", mining_time=0.5},
        icons = {
            {
                icon = "__nuclearcraft__/graphics/entity/red.png",
                icon_size = 64,
            }
        },
        picture = {
            filename = "__nuclearcraft__/graphics/entity/source-rod.png",
            width = 64,
            height = 64,
            scale = 0.5,
        }
    },
    {
        type = "container",
        name = "reflector-rod",
        flags = {"placeable-neutral", "player-creation"},
        inventory_size = 1,
        max_health = 500,
        collision_box = {{-0.4,-0.4},{0.4,0.4}},
        selection_box = {{-0.5,-0.5},{0.5,0.5}},
        map_color = {0,255,0},
        localised_description = {"nuclearcraft.reflector-description", "5", "2"},
        minable = {result="reflector-rod", mining_time=0.5},
        icons = {
            {
                icon = "__nuclearcraft__/graphics/entity/lime.png",
                icon_size = 64,
            }
        },
        picture = {
            filename = "__nuclearcraft__/graphics/entity/reflector-rod.png",
            width = 64,
            height = 64,
            scale = 0.5,
        }
    },
    {
        type = "container",
        name = "reactor-interface",
        flags = {"placeable-neutral", "player-creation"},
        inventory_size = 10,
        circuit_wire_max_distance = 16,
        circuit_connector = table.deepcopy(data.raw.container["steel-chest"].circuit_connector),
        max_health = 500,
        collision_box = {{-0.4,-0.4},{0.4,0.4}},
        selection_box = {{-0.5,-0.5},{0.5,0.5}},
        map_color = {0,0,255},
        minable = {result="reactor-interface", mining_time=0.5},
        icons = {
            {
                icon = "__nuclearcraft__/graphics/entity/lime.png",
                icon_size = 64,
            }
        },
        picture =
        {
            layers =
            {
                {
                    filename = "__nuclearcraft__/graphics/entity/reactor-interface.png",
                    priority = "extra-high",
                    width = 68,
                    height = 84,
                    shift = util.by_pixel(0, -3),
                    scale = 0.5
                },
            },
        },
    },
})

data:extend({
    {
        type = "simple-entity",
        name = "open-fuel-rod",
        icon = "__nuclearcraft__/graphics/entity/base-rod.png",
        flags = {"placeable-neutral"},
        minable = {mining_time=5},
        subgroup = "storage-remnants",
        max_health = 2000,
        created_smoke = nil,
        resistances = {
            {
                type = "explosion",
                percent = 100,
            },
            {
                type = "physical",
                percent = 100,
            },
            {
                type = "fire",
                percent = 100,
            },
            {
                type = "acid",
                percent = 100,
            },
            {
                type = "electric",
                percent = 100,
            },
            {
                type = "laser",
                percent = 100,
            },
        },
        order = "a-b-a",
        collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        selectable_in_game = true,
        picture =
        {
            filename = "__nuclearcraft__/graphics/entity/rod-remnants.png",
            line_length = 1,
            width = 75,
            height = 75,
            direction_count = 1,
            shift = util.by_pixel(0, 0),
            scale = 0.5
        }
    },
})
data:extend({
    {
        type = "corpse",
        name = "rod-remnants",
        icon = "__nuclearcraft__/graphics/entity/base-rod.png",
        hidden_in_factoriopedia = true,
        flags = {"placeable-neutral", "building-direction-8-way", "not-on-map"},
        subgroup = "storage-remnants",
        order = "a-b-a",
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        tile_width = 1,
        tile_height = 1,
        selectable_in_game = false,
        time_before_removed = 60 * 60 * 15, -- 15 minutes
        expires = false,
        final_render_layer = "remnants",
        remove_on_tile_placement = false,
        animation =
        {
            filename = "__nuclearcraft__/graphics/entity/rod-remnants.png",
            line_length = 1,
            width = 75,
            height = 75,
            direction_count = 1,
            shift = util.by_pixel(0, 0),
            scale = 0.5
        }
    },
})

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

make_composite(data.raw["constant-combinator"]["fuel-rod"])
make_composite(data.raw.container["control-rod"])
make_composite(data.raw.container["moderator-rod"])
make_composite(data.raw.container["source-rod"])
make_composite(data.raw.container["reflector-rod"])
make_composite(data.raw.container["reactor-interface"])

data:extend({
    {
        type = "recipe-category",
        name = "water-cooling",
    }
})

data:extend({
    {
        type = "furnace",
        name = "cooling-tower",
        icon = "__nuclearcraft__/graphics/icons/cooling-tower.png",
        icon_size = 32,
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.5, result = "cooling-tower"},
        max_health = 500,
        corpse = "medium-remnants",
        icon_draw_specification = {scale = 0},
        resistances =
        {
            {
                type = "fire",
                percent = 70
            }
        },
        collision_box = {{-1.3, -1.3}, {1.3, 1.3}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        drawing_box = {{-1.5, -1.5}, {1.5, 1.5}},
        fluid_boxes =
        {
            {
                production_type = "input",
                volume = 1000,
                pipe_covers = pipecoverspictures(),
                pipe_connections =
                {
                    {flow_direction="input", direction = defines.direction.west, position = {-1, -1}},  --{position = {-2, -1},type = "input"},
                    {flow_direction="input", direction = defines.direction.west, position = {-1, 1}},   --{position = {-2, 1},type = "input"},
                    {flow_direction="input", direction = defines.direction.north, position = {-1, -1}}, --{position = {-1, -2},type = "input"},
                    {flow_direction="input", direction = defines.direction.south, position = {-1, 1}}   --{position = {-1, 2},type = "input"}
                }
            },
            {
                production_type = "output",
                volume = 1000,
                pipe_covers = pipecoverspictures(),
                pipe_connections =
                {
                    {flow_direction="output", direction = defines.direction.north, position = {1, -1}}, --{position = {1, -2},type = "output"},
                    {flow_direction="output", direction = defines.direction.south, position = {1, 1}},  --{position = {1, 2},type = "output"},
                    {flow_direction="output", direction = defines.direction.east, position = {1, -1}},  --{position = {2, -1},type = "output"},
                    {flow_direction="output", direction = defines.direction.east, position = {1, 1}}    --{position = {2, 1},type = "output"}
                }
            }
        },
        source_inventory_size = 0,
        result_inventory_size = 0,
        crafting_categories = {"water-cooling"},
        energy_usage = "230kW",
        crafting_speed = 1,
        energy_source =
        {
            type = "electric",
            usage_priority = "primary-input",
            emissions = 0,
            drain = "20kW",
        },
        graphics_set =
        {
            animation =
            {
                layers=
                {
                    {
                        filename = "__nuclearcraft__/graphics/entity/cooling-tower-hr.png",
                        width = 308,
                        height = 310,
                        frame_count = 1,
                        shift = {0.695, -0.66},
                        scale = 0.505
                    },
                    {
                        filename = "__nuclearcraft__/graphics/entity/cooling-tower-hr-shadow.png",
                        width = 308,
                        height = 310,
                        frame_count = 1,
                        shift = {0.695, -0.66},
                        scale = 0.505,
                        draw_as_shadow = true,
                    }
                }
            }
        }
    }
})
make_composite(data.raw.furnace["cooling-tower"])