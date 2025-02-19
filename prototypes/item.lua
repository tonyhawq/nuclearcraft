data:extend({
    {
        type = "item-subgroup",
        name = "fuel-cells",
        group = "intermediate-products",
        order = "ibb",
    },
    {
        type = "item-subgroup",
        name = "depleted-fuel-cells",
        group = "intermediate-products",
        order = "ibc",
    },
    {
        type = "item-subgroup",
        name = "isotopes",
        group = "intermediate-products",
        order = "iba",
    },
    {
        type = "item-subgroup",
        name = "fuel-reprocessing",
        group = "intermediate-products",
        order = "ibd",
    },
    {
        type = "item-subgroup",
        name = "reactor-infrastructure",
        group = "production",
        order = "bb",
    },
})

data:extend({
    {
        type = "item",
        name = "fuel-rod",
        icons = {
            {
                icon = "__control-your-rods__/graphics/entity/green.png",
            }
        },
        place_result = "fuel-rod",
        subgroup = "reactor-infrastructure",
        order = "b",
        stack_size = 50,
    },
    {
        type = "item",
        name = "control-rod",
        icons = {
            {
                icon = "__control-your-rods__/graphics/entity/yellow.png",
            }
        },
        place_result = "control-rod",
        subgroup = "reactor-infrastructure",
        order = "c",
        stack_size = 50,
    },
    {
        type = "item",
        name = "moderator-rod",
        icons = {
            {
                icon = "__control-your-rods__/graphics/entity/purple.png",
            }
        },
        place_result = "moderator-rod",
        subgroup = "reactor-infrastructure",
        order = "d",
        stack_size = 50,
    },
    {
        type = "item",
        name = "source-rod",
        icons = {
            {
                icon = "__control-your-rods__/graphics/entity/red.png",
            }
        },
        place_result = "source-rod",
        subgroup = "reactor-infrastructure",
        order = "e",
        stack_size = 50,
    },
    {
        type = "item",
        name = "reflector-rod",
        icons = {
            {
                icon = "__control-your-rods__/graphics/entity/lime.png",
            }
        },
        place_result = "reflector-rod",
        subgroup = "reactor-infrastructure",
        order = "e",
        stack_size = 50,
    },
    {
        type = "item",
        name = "reactor-interface",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/reactor-interface.png",
            }
        },
        place_result = "reactor-interface",
        subgroup = "reactor-infrastructure",
        order = "a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "crushed-coal",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/crushed-coal.png",
            }
        },
        subgroup = "raw-material",
        order = "a[smelting]-d[graphite]-a",
        fuel_value = "1MJ",
        fuel_category = "chemical",
        stack_size = 50,
    },
    {
        type = "item",
        name = "graphite",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/graphite.png",
            }
        },
        subgroup = "raw-material",
        order = "a[smelting]-d[graphite]-b",
        fuel_value = "5MJ",
        fuel_category = "chemical",
        stack_size = 50,
    },
    {
        type = "item",
        name = "cooling-tower",
        icon = "__control-your-rods__/graphics/icons/cooling-tower.png",
        icon_size = 32,
        subgroup = "energy",
        order = "b[steam-power]-d[cooling-tower]",
        place_result = "cooling-tower",
        stack_size = 10,
    },
})
data.raw.item["uranium-fuel-cell"].subgroup = "fuel-cells"
data.raw.item["uranium-fuel-cell"].order = "a"
data.raw.item["depleted-uranium-fuel-cell"].subgroup = "depleted-fuel-cells"
data.raw.item["depleted-uranium-fuel-cell"].order = "a"
data:extend({
    {
        type = "item",
        name = "thorium-fuel-cycle-cell",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/thorium-fuel-cycle-cell-light.png",
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
        subgroup = "fuel-cells",
        order = "ab",
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
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/thorium-fuel-cell-light.png",
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
        subgroup = "fuel-cells",
        order = "ac",
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
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/plutonium-fuel-cell-light.png",
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
        subgroup = "fuel-cells",
        order = "ae",
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
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/mox-fuel-cell-light.png",
            },
        },
        localised_description = {
            "nuclearcraft.fuel-description",
            {"nuclearcraft.character-mox-flux"},
            {"nuclearcraft.character-mox-power"},
            {"nuclearcraft.character-mox-efficiency"},
            {"nuclearcraft.self-starting"},
            "[item=depleted-mox-fuel-cell]",
        },
        subgroup = "fuel-cells",
        order = "ad",
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
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/americium-fuel-cell-light.png",
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
        subgroup = "fuel-cells",
        order = "af",
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
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/depleted-thorium-fuel-cycle-cell-light.png",
            },
        },
        subgroup = "depleted-fuel-cells",
        order = "bb",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-thorium-fuel-cell",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/depleted-thorium-fuel-cell-light.png",
            },
        },
        subgroup = "depleted-fuel-cells",
        order = "bc",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-plutonium-fuel-cell",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/depleted-plutonium-fuel-cell-light.png",
            },
        },
        subgroup = "depleted-fuel-cells",
        order = "be",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-mox-fuel-cell",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/depleted-mox-fuel-cell-light.png",
            },
        },
        subgroup = "depleted-fuel-cells",
        order = "bd",
        stack_size = 50,
    },
    {
        type = "item",
        name = "depleted-americium-fuel-cell",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/base-cell.png",
            },
            {
                icon = "__control-your-rods__/graphics/icons/depleted-americium-fuel-cell-light.png",
            },
        },
        subgroup = "depleted-fuel-cells",
        order = "bf",
        stack_size = 50,
    },
    {
        type = "item",
        name = "thorium-232",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/thorium-232.png",
            },
        },
        subgroup = "isotopes",
        order = "b[thorium]-a",
        stack_size = 50,
    },
})
data.raw.item["uranium-235"].subgroup = "isotopes"
data.raw.item["uranium-235"].order = "a[uranium]-a"
data.raw.item["uranium-238"].subgroup = "isotopes"
data.raw.item["uranium-238"].order = "a[uranium]-b"
data:extend({
    {
        type = "item",
        name = "uranium-233",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/uranium-233.png",
            },
        },
        subgroup = "isotopes",
        order = "a[uranium]-c",
        stack_size = 50,
    },
    {
        type = "item",
        name = "uranium-232",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/uranium-232.png",
            },
        },
        subgroup = "isotopes",
        order = "a[uranium]-d",
        stack_size = 50,
    },
    {
        type = "item",
        name = "plutonium-239",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/plutonium-239.png",
            },
        },
        subgroup = "isotopes",
        order = "c[plutonium]-a",
        stack_size = 50,
    },
    {
        type = "item",
        name = "plutonium-240",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/plutonium-240.png",
            },
        },
        subgroup = "isotopes",
        order = "c[plutonium]-b",
        stack_size = 50,
    },
    {
        type = "item",
        name = "americium-241",
        icons = {
            {
                icon = "__control-your-rods__/graphics/icons/americium-241.png",
            },
        },
        subgroup = "isotopes",
        order = "d[americium]-a",
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