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
    {
        type = "item",
        name = "thorium-fuel-cycle-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/thorium-fuel-cycle-cell-light.png",
            },
        },
        localised_description = {
            "nuclearcraft.fuel-description",
            {"nuclearcraft.character-uthor-flux"},
            {"nuclearcraft.character-uthor-power"},
            {"nuclearcraft.character-thorium-cycle-efficiency"},
            {"nuclearcraft.not-self-starting"},
            "[item=depleted-thorium-fuel-cycle-cell]",
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
        fuel_value = "12GJ",
        fuel_category = "nuclear",
        burnt_result = "depleted-thorium-fuel-cycle-cell",
    },
    {
        type = "item",
        name = "thorium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/thorium-fuel-cell-light.png",
            },
        },
        localised_description = {
            "nuclearcraft.fuel-description",
            {"nuclearcraft.character-uthor-flux"},
            {"nuclearcraft.character-uthor-power"},
            {"nuclearcraft.character-thorium-efficiency"},
            {"nuclearcraft.not-self-starting"},
            "[item=depleted-thorium-fuel-cell]",
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
        fuel_value = "12GJ",
        fuel_category = "nuclear",
        burnt_result = "depleted-thorium-fuel-cell",
    },
    {
        type = "item",
        name = "plutonium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/plutonium-fuel-cell-light.png",
            },
        },
        localised_description = {
            "nuclearcraft.fuel-description",
            {"nuclearcraft.character-plutonium-flux"},
            {"nuclearcraft.character-plutonium-power"},
            {"nuclearcraft.character-plutonium-efficiency"},
            {"nuclearcraft.self-starting"},
            "[item=depleted-plutonium-fuel-cell]",
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
        fuel_value = "20GJ",
        fuel_category = "nuclear",
        burnt_result = "depleted-plutonium-fuel-cell",
    },
    {
        type = "item",
        name = "mox-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/mox-fuel-cell-light.png",
            },
        },
        localised_description = {
            "nuclearcraft.fuel-description",
            {"nuclearcraft.character-mox-flux"},
            {"nuclearcraft.character-mox-power"},
            {"nuclearcraft.character-mox-cycle-efficiency"},
            {"nuclearcraft.self-starting"},
            "[item=depleted-mox-fuel-cell]",
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
        fuel_value = "20GJ",
        fuel_category = "nuclear",
        burnt_result = "depleted-mox-fuel-cell",
    },
    {
        type = "item",
        name = "americium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/americium-fuel-cell-light.png",
            },
        },
        localised_description = {
            "nuclearcraft.fuel-description",
            {"nuclearcraft.character-americium-flux"},
            {"nuclearcraft.character-americium-power"},
            {"nuclearcraft.character-americium-efficiency"},
            {"nuclearcraft.self-starting"},
            "[item=depleted-americium-fuel-cell]",
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
        fuel_value = "5GJ",
        fuel_category = "nuclear",
        burnt_result = "depleted-americium-fuel-cell",
    },
    {
        type = "item",
        name = "depleted-thorium-fuel-cycle-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/depleted-thorium-fuel-cycle-cell-light.png",
            },
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-thorium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/depleted-thorium-fuel-cell-light.png",
            },
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-plutonium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/depleted-plutonium-fuel-cell-light.png",
            },
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-mox-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/depleted-mox-fuel-cell-light.png",
            },
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-americium-fuel-cell",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/icons/base-cell.png",
            },
            {
                icon = "__nuclearcraft__/graphics/icons/depleted-americium-fuel-cell-light.png",
            },
        },
        subgroup = "production-machine",
        order = "a",
        stack_size = 50,
    },
})
data.raw.item["uranium-fuel-cell"].localised_description = {
    "nuclearcraft.fuel-description",
    {"nuclearcraft.character-uthor-flux"},
    {"nuclearcraft.character-uthor-power"},
    {"nuclearcraft.character-uranium-efficiency"},
    {"nuclearcraft.self-starting"},
    "[item=depleted-uranium-fuel-cell]",
}