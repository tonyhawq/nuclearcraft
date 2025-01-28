data:extend({
    {
        type = "technology",
        name = "nuclearcraft-reactors",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/technology/reactors.png"
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
                recipe = "fuel-rod",
            },
            {
                type = "unlock-recipe",
                recipe = "control-rod",
            },
            {
                type = "unlock-recipe",
                recipe = "moderator-rod",
            },
        }
    },
    {
        type = "technology",
        name = "nuclearcraft-thorium",
        icons = {
            {
                icon = "__nuclearcraft__/graphics/technology/thorium.png"
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