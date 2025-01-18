require("util")

---@class add_fuel_config
---@field name string
---@field burnt_result string
---@field fuel_value string
---@field character_name string

local function assert_arg(arg, want_type, message)
    if type(arg) ~= want_type then
        error(message)
    end
end

if not remote.interfaces["g2_nuclear"] then
    remote.add_interface("g2_nuclear",
    {
        ---@param cfg add_fuel_config
        add_fuel = function (cfg)
            assert_arg(cfg.name, "string", "No item name specified in add_fuel.")
            assert_arg(cfg.burnt_result, "string", "No burnt result specified in add_fuel.")
            assert_arg(cfg.fuel_value, "string", "No fuel value specified in add_fuel.")
            assert_arg(cfg.character_name, "string", "No fuel characteristic specified in add_fuel.")
            if not Formula.characteristics[cfg.character_name] then
                error("No fuel characteristic exists with name \""..cfg.character_name.."\"")
            end
            local fuel_value = util.parse_energy(cfg.fuel_value)
            if not fuel_value then
                error("Malformed energy passed as \"fuel_value\"")
            end
            fuel_value = fuel_value / 1000 / 1000
            Formula.fuels[cfg.name] = {
                item = cfg.name,
                burnt_item = cfg.burnt_result,
                character_name = cfg.character_name,
                fuel_remaining = fuel_value,
                total_fuel = fuel_value,
                buffered = 0,
                buffered_out = 0,
            }
        end,
        ---@param cfg FuelCharacteristic
        add_character = function (cfg)
            assert_arg(cfg.name, "must specify name.")
            assert_arg(cfg.power, "func".."tion", "power must be a func".."tion.")
            assert_arg(cfg.efficiency, "func".."tion", "efficiency must be a func".."tion.")
            assert_arg(cfg.flux, "func".."tion", "flux must be a func".."tion.")
            assert_arg(cfg.max_efficiency, "number", "must specify max_efficiency.")
            assert_arg(cfg.max_fast_flux, "number", "must specify max_fast_flux.")
            assert_arg(cfg.max_slow_flux, "number", "must specify max_slow_flux.")
            assert_arg(cfg.max_power, "number", "must specify max_power.")
            assert_arg(cfg.target_fast_flux, "func".."tion", "must specify target_fast_flux as a func".."tion.")
            assert_arg(cfg.target_slow_flux, "func".."tion", "must specify target_slow_flux as a func".."tion.")
            Formula.characteristics[cfg.name] = table.deepcopy(cfg)
        end
    })
end