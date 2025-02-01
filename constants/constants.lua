return {
    fuel_rods = {
        ["fuel-rod"] = {
            name = "fuel-rod",
            slow_cross_section = 0.5,
            fast_cross_section = 0.5,
            affectable_distance = 10,
            -- base_efficiency = 1,
        },
    },
    control_rods = {
        ["control-rod"] = {
            name = "control-rod",
        }
    },
    moderator_rods = {
        ["moderator-rod"] = {
            name = "moderator-rod",
            conversion = 0.8,
        }
    },
    reflector_rods = {
        ["reflector-rod"] = {
            name = "reflector-rod",
            reflection_distance = 5,
            bounce_limit = 2,
            scattering = 0.9,
        }
    },
    source_rods = {
        ["source-rod"] = {
            name = "source-rod",
            efficiency_penalty = 0.5,
            slow_flux = 5,
            fast_flux = 5,
        }
    }
}