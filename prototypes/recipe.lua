

data:extend({
    {
        type = "recipe",
        name = "fuel-rod",
        enabled = true,
        main_product = "fuel-rod",
        ingredients = {
            {type="item", name="steel-plate", amount=100},
            {type="item", name="concrete", amount=100},
            {type="item", name="copper-plate", amount=100},
            {type="item", name="advanced-circuit", amount=25},
        },
        results = {
            {type="item", name="fuel-rod", amount=1}
        }
    },
    {
        type = "recipe",
        name = "control-rod",
        enabled = true,
        main_product = "control-rod",
        ingredients = {
            {type="item", name="steel-plate", amount=100},
            {type="item", name="concrete", amount=100},
            {type="item", name="copper-plate", amount=100},
            {type="item", name="engine-unit", amount=100},
            {type="item", name="advanced-circuit", amount=25},
        },
        results = {
            {type="item", name="control-rod", amount=1}
        }
    },
    {
        type = "recipe",
        name = "moderator-rod",
        enabled = true,
        main_product = "moderator-rod",
        ingredients = {
            {type="item", name="steel-plate", amount=100},
            {type="item", name="concrete", amount=100},
            {type="item", name="advanced-circuit", amount=25},
            {type="item", name="graphite", amount=100},
        },
        results = {
            {type="item", name="moderator-rod", amount=1}
        }
    },
    {
        type = "recipe",
        name = "reflector-rod",
        enabled = true,
        main_product = "reflector-rod",
        ingredients = {
            {type="item", name="steel-plate", amount=100},
            {type="item", name="concrete", amount=100},
            {type="item", name="advanced-circuit", amount=25},
            {type="item", name="uranium-238", amount=50},
            {type="item", name="copper-plate", amount=100},
        },
        results = {
            {type="item", name="reflector-rod", amount=1}
        }
    },
    {
        type = "recipe",
        name = "reactor-interface",
        enabled = true,
        main_product = "reactor-interface",
        ingredients = {
            {type="item", name="steel-plate", amount=100},
            {type="item", name="concrete", amount=100},
            {type="item", name="advanced-circuit", amount=100},
        },
        results = {
            {type="item", name="reactor-interface", amount=1}
        }
    },
    {
        type = "recipe",
        name = "nc-steam-cooling",
        category = "water-cooling",
        enabled = true,
        hidden = true,
        energy_required = 0.1,
        ingredients =
        {
            {type="fluid", name="steam", amount=30}
        },
        results =
        {
            {type="fluid", name="water", amount=3}
        },
        icon = "__base__/graphics/icons/fluid/water.png",
        icon_size = 64,
        subgroup = "fluid-recipes",
        order = "z"
    },
    {
        type = "recipe",
        name = "graphite",
        category = "smelting",
        enabled = true,
        energy_required = 12.8,
        main_product = "graphite",
        ingredients =
        {
            {type="item", name="coal", amount=1},
        },
        results =
        {
            {type="item", name="graphite", amount=1},
        },
    },
    {
        type = "recipe",
        name = "thorium-232",
        category = "chemistry",
        enabled = false,
        energy_required = 2,
        icons = {
            {
                icon = "__yantm__/graphics/icons/thorium-232.png",
            }
        },
        main_product = "thorium-232",
        ingredients =
        {
            {type="fluid", name="steam", amount=500, temperature=500},
            {type="item", name="uranium-ore", amount=1},
            {type="fluid", name="sulfuric-acid", amount=20},
        },
        results =
        {
            {type="item", name="thorium-232", amount=1, probability=0.1},
            {type="item", name="iron-ore", amount=1, probability=0.5},
            {type="fluid", name="water", amount=50},
        },
        icon_size = 64,
        subgroup = "isotopes",
        order = "a"
    },
    {
        type = "recipe",
        name = "mox-fuel-cell",
        category = "crafting",
        enabled = false,
        energy_required = 2,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/mox-fuel-cell-light.png",
            },
        },
        main_product = "mox-fuel-cell",
        ingredients =
        {
            {type="item", name="depleted-uranium-fuel-cell", amount=1},
            {type="item", name="plutonium-239", amount=1},
        },
        results =
        {
            {type="item", name="mox-fuel-cell", amount=1},
        },
        icon_size = 64,
    },
    {
        type = "recipe",
        name = "plutonium-fuel-cell",
        category = "crafting",
        enabled = false,
        energy_required = 2,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/plutonium-fuel-cell-light.png",
            },
        },
        main_product = "plutonium-fuel-cell",
        ingredients =
        {
            {type="item", name="iron-plate", amount=1},
            {type="item", name="plutonium-240", amount=1},
        },
        results =
        {
            {type="item", name="plutonium-fuel-cell", amount=1},
        },
        icon_size = 64,
    },
    {
        type = "recipe",
        name = "americium-fuel-cell",
        category = "crafting",
        enabled = false,
        energy_required = 2,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/americium-fuel-cell-light.png",
            },
        },
        main_product = "americium-fuel-cell",
        ingredients =
        {
            {type="item", name="iron-plate", amount=1},
            {type="item", name="americium-241", amount=1},
        },
        results =
        {
            {type="item", name="americium-fuel-cell", amount=1},
        },
        icon_size = 64,
    },
})
data:extend({
    {
        type = "recipe",
        name = "thorium-fuel-cycle-cell",
        category = "crafting",
        enabled = false,
        energy_required = 2,
        main_product = "",
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/thorium-fuel-cycle-cell-light.png",
            },
        },
        ingredients =
        {
            {type="item", name="iron-plate", amount=1},
            {type="item", name="uranium-235", amount=1},
            {type="item", name="thorium-232", amount=29},
        },
        results =
        {
            {type="item", name="thorium-fuel-cycle-cell", amount=10},
        },
        icon_size = 64,
        subgroup = "fuel-cells",
        order = "aba",
    },
    {
        type = "recipe",
        name = "thorium-fuel-cycle-cell-2",
        category = "crafting",
        enabled = false,
        energy_required = 2,
        main_product = "",
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/thorium-fuel-cycle-cell-light.png",
            },
        },
        ingredients =
        {
            {type="item", name="iron-plate", amount=1},
            {type="item", name="uranium-233", amount=1},
            {type="item", name="thorium-232", amount=19},
        },
        results =
        {
            {type="item", name="thorium-fuel-cycle-cell", amount=10},
        },
        icon_size = 64,
        subgroup = "fuel-cells",
        order = "abb",
    },
    {
        type = "recipe",
        name = "thorium-fuel-cell",
        category = "crafting",
        enabled = false,
        energy_required = 2,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/thorium-fuel-cell-light.png",
            },
        },
        main_product = "thorium-fuel-cell",
        ingredients =
        {
            {type="item", name="iron-plate", amount=1},
            {type="item", name="uranium-233", amount=1},
            {type="item", name="thorium-232", amount=9},
        },
        results =
        {
            {type="item", name="thorium-fuel-cell", amount=10},
        },
        icon_size = 64,
    },
    {
        type = "recipe",
        name = "thorium-fuel-cycle-cell-reprocessing",
        category = "centrifuging",
        enabled = false,
        energy_required = 15,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/thorium-fuel-cycle-cell-light.png",
            },
            {
                icon = "__yantm__/graphics/icons/arrow.png",
            },
        },
        ingredients =
        {
            {type="item", name="depleted-thorium-fuel-cycle-cell", amount=1},
        },
        results =
        {
            {type="item", name="uranium-238", --[[replacement from u232]] amount=1},
            {type="item", name="uranium-233", amount=2},
        },
        icon_size = 64,
        subgroup = "fuel-reprocessing",
        order = "b"
    },
    {
        type = "recipe",
        name = "thorium-fuel-cell-reprocessing",
        category = "centrifuging",
        enabled = false,
        energy_required = 15,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/thorium-fuel-cell-light.png",
            },
            {
                icon = "__yantm__/graphics/icons/arrow.png",
            },
        },
        ingredients =
        {
            {type="item", name="depleted-thorium-fuel-cell", amount=1},
        },
        results =
        {
            {type="item", name="uranium-232", amount=1},
            {type="item", name="uranium-233", amount=1, probability=0.5},
        },
        icon_size = 64,
        subgroup = "fuel-reprocessing",
        order = "c"
    },
    {
        type = "recipe",
        name = "mox-fuel-cell-reprocessing",
        category = "centrifuging",
        enabled = false,
        energy_required = 15,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/mox-fuel-cell-light.png",
            },
            {
                icon = "__yantm__/graphics/icons/arrow.png",
            },
        },
        ingredients =
        {
            {type="item", name="depleted-mox-fuel-cell", amount=1},
        },
        results =
        {
            {type="item", name="uranium-238", amount=1},
            {type="item", name="plutonium-240", amount=1, probability=0.5},
            {type="item", name="uranium-233", amount=1, probability=0.5},
        },
        icon_size = 64,
        subgroup = "fuel-reprocessing",
        order = "d"
    },
    {
        type = "recipe",
        name = "plutonium-fuel-cell-reprocessing",
        category = "centrifuging",
        enabled = false,
        energy_required = 15,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/plutonium-fuel-cell-light.png",
            },
            {
                icon = "__yantm__/graphics/icons/arrow.png",
            },
        },
        ingredients =
        {
            {type="item", name="depleted-plutonium-fuel-cell", amount=1},
        },
        results =
        {
            {type="item", name="uranium-232", amount=1},
            {type="item", name="americium-241", amount=1, probability=0.1},
        },
        icon_size = 64,
        subgroup = "fuel-reprocessing",
        order = "e"
    },
    {
        type = "recipe",
        name = "americium-fuel-cell-reprocessing",
        category = "centrifuging",
        enabled = false,
        energy_required = 15,
        icons = {
            {
                icon = "__yantm__/graphics/icons/base-cell.png",
            },
            {
                icon = "__yantm__/graphics/icons/americium-fuel-cell-light.png",
            },
            {
                icon = "__yantm__/graphics/icons/arrow.png",
            },
        },
        ingredients =
        {
            {type="item", name="depleted-americium-fuel-cell", amount=1},
        },
        results =
        {
            {type="item", name="uranium-232", amount=1},
            {type="item", name="plutonium-240", amount=1},
        },
        icon_size = 64,
        subgroup = "fuel-reprocessing",
        order = "f"
    },
})
data.raw.recipe["uranium-fuel-cell"].subgroup = "fuel-cells"
data.raw.recipe["uranium-fuel-cell"].order = "a"
local reprocessing = data.raw.recipe["nuclear-fuel-reprocessing"]
reprocessing.ingredients = {{type="item", name="depleted-uranium-fuel-cell", amount=1}}
reprocessing.results = {
    {type="item", name="uranium-238", amount=1},
    {type="item", name="plutonium-239", amount=1, probability=0.25},
    {type="item", name="plutonium-240", amount=1, probability=0.25},
}
reprocessing.energy_required = 15
reprocessing.subgroup = "fuel-reprocessing"
reprocessing.order = "a"