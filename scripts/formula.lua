local formula = {}

formula.max = 1000000

local max = math.max
local min = math.min
local sqrt= math.sqrt
local pow = math.pow

---@type table<string, FuelCharacteristic>
formula.characteristics = {
    ["uranium"] = {
        flux = function (slow_flux, fast_flux, temperature)
            local output = slow_flux / 2 + ((slow_flux/100)^2)/sqrt(temperature+1)+fast_flux/200
            return math.min(output * 0.1, formula.max), math.min(output * 0.9, formula.max)
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux
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
    }
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
    } --[[@as Fuel]],
    ["copper-cable"] = {
        item = "copper-cable",
        burnt_item = "copper-plate",
        character_name = "uranium",
        fuel_remaining = 8000,
        total_fuel = 8000,
        buffered = 0,
        buffered_out = 0,
    } --[[@as Fuel]],
}

---@type table<string, BurntFuel>
formula.burnt_items = {
    ["depleted-uranium-fuel-cell"] = {
        item = "depleted-uranium-fuel-cell",
        from = {"uranium-fuel-cell"},
    },
    ["copper-plate"] = {
        item = "copper-plate",
        from = {"copper-cable"},
    }
}

return formula