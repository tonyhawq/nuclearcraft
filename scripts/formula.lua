local formula = {}

formula.max = 1000000

---@type table<string, FuelCharacteristic>
formula.characteristics = {
    ["uranium"] = {
        flux = function (slow_flux, fast_flux, temperature)
            local output = ((slow_flux/50)^2+slow_flux/20+(fast_flux/100)^2*0.1)/math.max(temperature/1500, 0.1)-0.1
            return math.min(output * 0.1, formula.max), math.min(output * 0.9, formula.max)
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux
        end,
        efficiency = function (slow_flux, fast_flux, temperature)
            return math.max(fast_flux + temperature / 200, 1)
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
        total_fuel = 8000
    } --[[@as Fuel]]
}

return formula