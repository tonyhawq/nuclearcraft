

data:extend({
    {
        type = "recipe",
        name = "fuel-rod",
        enabled = true,
        main_product = "fuel-rod",
        ingredients = {
            {type="item", name="steel-plate", amount=100},
            {type="item", name="concrete", amount=100},
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
            {type="item", name="electric-engine-unit", amount=100},
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
            {type="item", name="coal", amount=100},
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
    
})