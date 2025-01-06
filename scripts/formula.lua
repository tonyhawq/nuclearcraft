local formula = {}

---@type table<string, FuelCharacteristic>
formula.characteristics = {
    ["uranium"] = {
        flux = function (slow_flux, fast_flux, temperature)
            local output = ((slow_flux/50)^2+(fast_flux/100)^2*0.1)/math.max(temperature/1500, 0.1)-0.1
            return output * 0.1, output * 0.9
        end,
        power = function (slow_flux, fast_flux)
            return slow_flux
        end,
        efficiency = function (slow_flux, fast_flux, temperature)
            return math.max(fast_flux + temperature / 200, 1)
        end,
    }
}

return formula