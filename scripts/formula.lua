local formula = {}

formula.max = 1000000

local fmax = formula.max
local max = math.max
local min = math.min
local sqrt= math.sqrt
local pow = math.pow
local mlog = math.log

local placeholder = 1

---@type table<string, FuelCharacteristic>
formula.characteristics = {
    ["uranium"] = {
        flux = function (s, f, t)
            local output = max(2.5*s, 0.1)
            return min(output * 0.1, fmax), min(output * 0.9, fmax)
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux + fast_flux
        end,
        efficiency = function (slow_flux, fast_flux, temperature)
            return min(max(fast_flux + temperature / 200, 1), 15)
        end,
        target_fast_flux = function (slow_flux, fast_flux, temperature)
            return placeholder
        end,
        target_slow_flux = function (slow_flux, fast_flux, temperature)
            return placeholder
        end,
        max_fast_flux = placeholder,
        max_slow_flux = placeholder,
        max_efficiency = 15,
        max_power = 40,
        name = "uranium",
        self_starting = true,
    },
    ["thorium"] = {
        flux = function (s, f, t)
            if s < 0.5 then
                return 0, 0
            end
            local output = 2.5*s
            return min(output * 0.1, fmax), min(output * 0.9, fmax)
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux + fast_flux
        end,
        efficiency = function (slow_flux, fast_flux, temperature)
            return max(1000/max(temperature - 200, 41.65) + 1, 1)
        end,
        target_fast_flux = function (slow_flux, fast_flux, temperature)
            return placeholder
        end,
        target_slow_flux = function (slow_flux, fast_flux, temperature)
            return placeholder
        end,
        max_fast_flux = placeholder,
        max_slow_flux = placeholder,
        max_efficiency = placeholder,
        max_power = placeholder,
        name = "thorium",
        self_starting = false,
    },
    ["thorium-cycle"] = {
        flux = function (s, f, t)
            if s < 0.5 then
                return 0, 0
            end
            local output = 2.5*s
            return min(output * 0.1, fmax), min(output * 0.9, fmax)
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux + fast_flux
        end,
        efficiency = function (slow_flux, fast_flux, temperature)
            return max(2000/max(temperature - 200, 41.65) + 1, 1)
        end,
        target_fast_flux = function (slow_flux, fast_flux, temperature)
            return placeholder
        end,
        target_slow_flux = function (slow_flux, fast_flux, temperature)
            return placeholder
        end,
        max_fast_flux = placeholder,
        max_slow_flux = placeholder,
        max_efficiency = placeholder,
        max_power = placeholder,
        name = "thorium-cycle",
        self_starting = false,
    },
    ["americium"] = {
        flux = function (s, f, t)
            return 5 + t / 100, 5 + t / 100
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux + fast_flux
        end,
        efficiency = function (slow_flux, fast_flux, temperature)
            return 1
        end,
        target_fast_flux = function (slow_flux, fast_flux, temperature)
            return 0
        end,
        target_slow_flux = function (slow_flux, fast_flux, temperature)
            return temperature * 0.025
        end,
        max_fast_flux = placeholder,
        max_slow_flux = placeholder,
        max_efficiency = 1,
        max_power = 60,
        name = "americium",
        self_starting = true,
    },
    ["plutonium"] = {
        flux = function (s, f, t)
            return 0, max(2.5*s, 0.1)
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux + fast_flux
        end,
        efficiency = function (s, f, t)
            return max(-f/(s+0.1) + 15, 0.5)
        end,
        target_fast_flux = function (slow_flux, fast_flux, temperature)
            return 0
        end,
        target_slow_flux = function (slow_flux, fast_flux, temperature)
            return temperature * 0.025
        end,
        max_fast_flux = placeholder,
        max_slow_flux = placeholder,
        max_efficiency = placeholder,
        max_power = placeholder,
        name = "plutonium",
        self_starting = true,
    },
    ["mox"] = {
        flux = function (s, f, t)
            local output = max(1.5*(s+f), 0.1)
            return output / 2, output / 2
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux + fast_flux
        end,
        efficiency = function (s, f, t)
            return max(-s/(f+0.1) + 15, 0.5)
        end,
        target_fast_flux = function (slow_flux, fast_flux, temperature)
            return 0
        end,
        target_slow_flux = function (slow_flux, fast_flux, temperature)
            return temperature * 0.025
        end,
        max_fast_flux = placeholder,
        max_slow_flux = placeholder,
        max_efficiency = placeholder,
        max_power = placeholder,
        name = "mox",
        self_starting = true,
    },
}

---@type table<string, Fuel>
formula.fuels = {
    ["uranium-fuel-cell"] = {
        item = "uranium-fuel-cell",
        burnt_item = "depleted-uranium-fuel-cell",
        character_name = "uranium",
        fuel_remaining = 8000,
        total_fuel = 8000,
        buffered = 0,
        buffered_out = 0,
    },
    ["thorium-fuel-cell"] = {
        item = "thorium-fuel-cell",
        burnt_item = "depleted-thorium-fuel-cell",
        character_name = "thorium",
        fuel_remaining = 12000,
        total_fuel = 12000,
        buffered = 0,
        buffered_out = 0,
    },
    ["thorium-fuel-cycle-cell"] = {
        item = "thorium-fuel-cycle-cell",
        burnt_item = "depleted-thorium-fuel-cycle-cell",
        character_name = "thorium-cycle",
        fuel_remaining = 12000,
        total_fuel = 12000,
        buffered = 0,
        buffered_out = 0,
    },
    ["americium-fuel-cell"] = {
        item = "americium-fuel-cell",
        burnt_item = "depleted-americium-fuel-cell",
        character_name = "americium",
        fuel_remaining = 5000,
        total_fuel = 5000,
        buffered = 0,
        buffered_out = 0,
    },
    ["plutonium-fuel-cell"] = {
        item = "plutonium-fuel-cell",
        burnt_item = "depleted-plutonium-fuel-cell",
        character_name = "plutonium",
        fuel_remaining = 5000,
        total_fuel = 5000,
        buffered = 0,
        buffered_out = 0,
    },
    ["mox-fuel-cell"] = {
        item = "mox-fuel-cell",
        burnt_item = "depleted-mox-fuel-cell",
        character_name = "mox",
        fuel_remaining = 5000,
        total_fuel = 5000,
        buffered = 0,
        buffered_out = 0,
    },
}

---@type table<string, BurntFuel>
formula.burnt_items = {
    ["depleted-uranium-fuel-cell"] = {
        item = "depleted-uranium-fuel-cell",
        from = {"uranium-fuel-cell"},
    },
    ["depleted-thorium-fuel-cell"] = {
        item = "depleted-thorium-fuel-cell",
        from = {"thorium-fuel-cell"},
    },
    ["depleted-thorium-fuel-cycle-cell"] = {
        item = "depleted-thorium-fuel-cycle-cell",
        from = {"thorium-fuel-cell"},
    },
    ["depleted-americium-fuel-cell"] = {
        item = "depleted-americium-fuel-cell",
        from = {"americium-fuel-cell"},
    },
    ["depleted-plutonium-fuel-cell"] = {
        item = "depleted-plutonium-fuel-cell",
        from = {"plutonium-fuel-cell"},
    },
    ["depleted-mox-fuel-cell"] = {
        item = "depleted-mox-fuel-cell",
        from = {"mox-fuel-cell"},
    },
}

return formula