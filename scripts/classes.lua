---@alias NeutronOutputFormula fun(slow_flux: number, fast_flux: number, temperature: number): number, number
---@alias PowerOutputFormula fun(slow_flux: number, fast_flux: number, temperature: number): number
---@alias EfficiencyFormula fun(slow_flux: number, fast_flux: number, temperature: number): number

---@class (exact) FuelCharacteristic
---@field flux NeutronOutputFormula
---@field power PowerOutputFormula
---@field efficiency EfficiencyFormula

---@class (exact) Connector
---@field entity LuaEntity
---@field owner ControlRod|FuelRod|Interface

---@class (exact) Affector
---@field control_rods ControlRod[]
---@field fuel_rod FuelRod
---@field moderation number

---@class (exact) Fuel
---@field item string
---@field burnt_item string
---@field character_name string
---@field character FuelCharacteristic
---@field fuel_remaining number

---@class (exact) FuelRod
---@field type "fuel"
---@field fuel Fuel?
---@field affectors Affector[]
---@field power number
---@field fast_flux number
---@field slow_flux number
---@field in_slow_flux number
---@field in_fast_flux number
---@field base_fast_flux number
---@field base_slow_flux number
---@field efficiency number
---@field interface LuaEntity?
---@field entity LuaEntity
---@field connector LuaEntity
---@field reactor Reactor?
---@field id integer
---@field temperature number

---@class (exact) ControlRod
---@field type "control"
---@field insertion number
---@field heat_pipe LuaEntity?
---@field entity LuaEntity
---@field connector LuaEntity
---@field reactor Reactor?
---@field id integer

---@class (exact) Moderator
---@field type "mod"
---@field conversion number
---@field heat_pipe LuaEntity?
---@field connector LuaEntity?
---@field entity LuaEntity
---@field reactor Reactor?
---@field id integer

---@class (exact) Interface
---@field type "interface"
---@field input boolean
---@field entity LuaEntity
---@field connector LuaEntity
---@field reactor Reactor?
---@field id integer

---@class (exact) Reactor
---@field fuel_rods FuelRod[]
---@field control_rods ControlRod[]
---@field enabled boolean
---@field id number
---@field outputs Interface[]
---@field inputs Interface[]