local formula = {}

formula.max = 1000000

local fmax = formula.max
local max = math.max
local min = math.min
local sqrt= math.sqrt
local pow = math.pow
local mlog = math.log

---@type table<string, FuelCharacteristic>
formula.characteristics = {
    ["uranium"] = {
        flux = function (s, f, t)
            local output = 2*s
            return min(output * 0.1, fmax), min(output * 0.9, fmax)
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux + fast_flux
        end,
        efficiency = function (slow_flux, fast_flux, temperature)
            return min(max(fast_flux + temperature / 200, 1), 15)
        end,
        target_fast_flux = function (slow_flux, fast_flux, temperature)
            return 0
        end,
        target_slow_flux = function (slow_flux, fast_flux, temperature)
            return temperature * 0.025
        end,
        max_fast_flux = 0,
        max_slow_flux = 40,
        max_efficiency = 15,
        max_power = 40,
        name = "uranium",
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
}

---@type table<string, BurntFuel>
formula.burnt_items = {
    ["depleted-uranium-fuel-cell"] = {
        item = "depleted-uranium-fuel-cell",
        from = {"uranium-fuel-cell"},
    },
}

return formula