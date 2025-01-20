

local explosion_animations = require("__base__.prototypes.entity.explosion-animations")
local sounds = require("__base__.prototypes.entity.sounds")

---lamp remnants
---rail chain signal remnants
---wall remnants

data:extend({
    {
        type = "explosion",
        name = "rod-meltdown-explosion",
        localised_name = {"entity-name.rod-meltdown-explosion"},
        icons =
        {
            {icon = "__base__/graphics/icons/explosion.png"},
        },
        order = "a-c-b",
        flags = {"not-on-map", "placeable-off-grid"},
        hidden = true,
        subgroup = "explosions",
        animations = explosion_animations.big_explosion(),
        sound = sounds.large_explosion(1.0),
        created_effect = {
            type = "direct",
            action_delivery =
            {
                type = "instant",
                target_effects =
                {
                    {
                        type = "create-entity",
                        entity_name = "big-explosion"
                    },
                    {
                        type = "create-entity",
                        entity_name = "crash-site-fire-smoke"
                    },
                    {
                        type = "nested-result",
                        action =
                        {
                            type = "area",
                            radius = 4,
                            action_delivery =
                            {
                                type = "instant",
                                target_effects =
                                {
                                    {
                                        type = "damage",
                                        damage = {amount = 2000, type = "explosion"}
                                    },
                                    {
                                        type = "create-entity",
                                        entity_name = "explosion"
                                    }
                                }
                            }
                        }
                    },
                    {
                        type = "script",
                        effect_id = "rod-meltdown",
                    },
                    {
                        type = "create-entity",
                        entity_name = "medium-scorchmark-tintable",
                        check_buildability = true
                    },
                    {
                        type = "invoke-tile-trigger",
                        repeat_count = 1
                    },
                    {
                        type = "destroy-decoratives",
                        from_render_layer = "decorative",
                        to_render_layer = "object",
                        include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
                        include_decals = false,
                        invoke_decorative_trigger = true,
                        decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
                        radius = 2 -- large radius for demostrative purposes
                    }
                }
            }
        }
    },
})
data:extend({
    {
        type = "explosion",
        name = "cap-landed-explosion",
        localised_name = {"entity-name.cap-landed-explosion"},
        icons =
        {
            {icon = "__base__/graphics/icons/explosion.png"},
        },
        order = "a-c-b",
        flags = {"not-on-map", "placeable-off-grid"},
        hidden = true,
        subgroup = "explosions",
        animations = explosion_animations.big_explosion(),
        sound = sounds.large_explosion(1.0),
        created_effect = {
            type = "direct",
            action_delivery =
            {
                type = "instant",
                target_effects =
                {
                    {
                        type = "create-entity",
                        entity_name = "medium-explosion"
                    },
                    {
                        type = "create-entity",
                        entity_name = "crash-site-fire-smoke"
                    },
                    {
                        type = "nested-result",
                        action =
                        {
                            type = "area",
                            radius = 4,
                            action_delivery =
                            {
                                type = "instant",
                                target_effects =
                                {
                                    {
                                        type = "damage",
                                        damage = {amount = 2000, type = "explosion"}
                                    },
                                    {
                                        type = "create-entity",
                                        entity_name = "explosion"
                                    }
                                }
                            }
                        }
                    },
                    {
                        type = "script",
                        effect_id = "cap-land",
                    },
                    {
                        type = "create-entity",
                        entity_name = "medium-scorchmark-tintable",
                        check_buildability = true
                    },
                    {
                        type = "invoke-tile-trigger",
                        repeat_count = 1
                    },
                    {
                        type = "destroy-decoratives",
                        from_render_layer = "decorative",
                        to_render_layer = "object",
                        include_soft_decoratives = true, -- soft decoratives are decoratives with grows_through_rail_path = true
                        include_decals = false,
                        invoke_decorative_trigger = true,
                        decoratives_with_trigger_only = false, -- if true, destroys only decoratives that have trigger_effect set
                        radius = 2 -- large radius for demostrative purposes
                    }
                }
            }
        }
    },
})
local long_lasting_smoke_source = table.deepcopy(data.raw["particle-source"]["nuclear-smouldering-smoke-source"])
long_lasting_smoke_source.name = "nuclear-long-lasting-smoke-source"
long_lasting_smoke_source.time_to_live = 60 * 60 * 20
long_lasting_smoke_source.smoke[1].name = "long-nuclear-fire-smoke"
local long_nuclear_fire_smoke = table.deepcopy(data.raw["trivial-smoke"]["fire-smoke"])
long_nuclear_fire_smoke.name = "long-nuclear-fire-smoke"
long_nuclear_fire_smoke.duration = 60 * 45
long_nuclear_fire_smoke.fade_away_duration = 60 * 10
long_nuclear_fire_smoke.spread_duration = 60 * 25
long_nuclear_fire_smoke.end_scale = 2
data:extend({long_lasting_smoke_source, long_nuclear_fire_smoke})