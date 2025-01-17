data:extend({
    {
        type = "item",
        name = "low-enriched-uranium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/low-enriched-uranium-fuel-cell.png",
                icon_size = 64,
            }
        },
        subgroup = "uranium-processing",
        order = "b[uranium-products]-a[uranium-fuel-cell]",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-low-enriched-uranium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/depleted-low-enriched-uranium-fuel-cell.png",
                icon_size = 64,
            }
        },
        subgroup = "uranium-processing",
        order = "b[uranium-products]-a[uranium-fuel-cell]",
        stack_size = 50,
    },
})
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
})