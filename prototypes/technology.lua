local nuclear_power = data.raw.technology["nuclear-power"]
table.insert(nuclear_power.effects, {type="unlock-recipe", recipe="reactor-interface"})
table.insert(nuclear_power.effects, {type="unlock-recipe", recipe="fuel-rod"})
table.insert(nuclear_power.effects, {type="unlock-recipe", recipe="control-rod"})
table.insert(nuclear_power.effects, {type="unlock-recipe", recipe="moderator-rod"})
data:extend({
    {
        prerequisites = {"nuclear-power"},
        type = "technology",
        name = "nuclearcraft-thorium",
        icons = {
            {
                icon = "__control-your-rods__/graphics/technology/thorium.png",
                icon_size = 256,
            }
        },
        unit = {
            count = 400,
            time = 30,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
            }
        },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "thorium-232",
            },
            {
                type = "unlock-recipe",
                recipe = "thorium-fuel-cycle-cell",
            },
            {
                type = "unlock-recipe",
                recipe = "thorium-fuel-cycle-cell-2",
            },
            {
                type = "unlock-recipe",
                recipe = "thorium-fuel-cell",
            },
            {
                type = "unlock-recipe",
                recipe = "thorium-fuel-cycle-cell-reprocessing",
            },
            {
                type = "unlock-recipe",
                recipe = "thorium-fuel-cell-reprocessing",
            },
        }
    },
})
data.raw.technology["nuclear-fuel-reprocessing"].prerequisites = {"nuclear-power"}
data.raw.technology["nuclear-fuel-reprocessing"].unit = {
    count = 400,
    time = 30,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
    }
}
data:extend({
    {
        prerequisites = {"nuclear-fuel-reprocessing"},
        type = "technology",
        name = "nuclearcraft-plutonium",
        icons = {
            {
                icon = "__control-your-rods__/graphics/technology/plutonium.png",
                icon_size = 256,
            }
        },
        icon_size = 256,
        unit = {
            count = 400,
            time = 30,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
            }
        },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "mox-fuel-cell",
            },
            {
                type = "unlock-recipe",
                recipe = "mox-fuel-cell-reprocessing",
            },
            {
                type = "unlock-recipe",
                recipe = "plutonium-fuel-cell",
            },
            {
                type = "unlock-recipe",
                recipe = "plutonium-fuel-cell-reprocessing",
            },
        }
    },
    {
        prerequisites = {"nuclearcraft-plutonium"},
        type = "technology",
        name = "nuclearcraft-americium",
        icons = {
            {
                icon = "__control-your-rods__/graphics/technology/americium.png",
                icon_size = 256,
            }
        },
        icon_size = 256,
        unit = {
            count = 400,
            time = 30,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
            }
        },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "americium-fuel-cell",
            },
            {
                type = "unlock-recipe",
                recipe = "americium-fuel-cell-reprocessing",
            },
        }
    },
})