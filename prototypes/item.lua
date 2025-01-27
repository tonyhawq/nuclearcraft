data:extend({
    {
        type = "item",
        name = "fuel-rod",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/entity/green.png",
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
                icon = "__nuclearcraft__/graphics/entity/yellow.png",
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
                icon = "__nuclearcraft__/graphics/entity/purple.png",
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
                icon = "__nuclearcraft__/graphics/entity/red.png",
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
                icon = "__nuclearcraft__/graphics/entity/lime.png",
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
                icon = "__nuclearcraft__/graphics/icons/reactor-interface.png",
            }
        },
        place_result = "reactor-interface",
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "cooling-tower",
        icon = "__nuclearcraft__/graphics/icons/cooling-tower.png",
        icon_size = 32,
        subgroup = "energy",
        order = "b[steam-power]-d[cooling-tower]",
        place_result = "cooling-tower",
        stack_size = 10,
      },
})