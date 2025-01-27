---@alias NeutronOutputFormula fun(slow_flux: number, fast_flux: number, temperature: number): number, number
---@alias PowerOutputFormula fun(slow_flux: number, fast_flux: number, temperature: number): number
---@alias EfficiencyFormula fun(slow_flux: number, fast_flux: number, temperature: number): number
---@alias GenericFormula fun(slow_flux: number, fast_flux: number, temperature: number): number

---@class (exact) FuelCharacteristic
---@field flux NeutronOutputFormula
---@field power PowerOutputFormula
---@field efficiency EfficiencyFormula
---@field target_slow_flux GenericFormula
---@field target_fast_flux GenericFormula
---@field max_slow_flux number
---@field max_fast_flux number
---@field max_efficiency number
---@field max_power number
---@field name string
---@field self_starting boolean

---@class (exact) Connector
---@field entity LuaEntity
---@field owner ControlRod|FuelRod|Interface|Source|Reflector|Moderator|Controller

---@class (exact) Affector
---@field control_rods ControlRod[]
---@field affector FuelRod|Source
---@field moderation number

---@class (exact) Affects
---@field control_rods ControlRod
---@field affects FuelRod
---@field conversion number

---@class (exact) Fuel
---@field item string
---@field burnt_item string
---@field character_name string
---@field fuel_remaining number
---@field total_fuel number
---@field buffered number
---@field buffered_out number

---@class (exact) BurntFuel
---@field from string[]
---@field item string


---@class (exact) OpenFuelRod
---@field id integer
---@field entity LuaEntity
---@field smoke_source LuaEntity?

---@class (exact) FuelRod
---@field smoke_source LuaEntity?
---@field force LuaForce
---@field position MapPosition
---@field surface LuaSurface
---@field melted_down boolean?
---@field wants_fuel string?
---@field wants_min number?
---@field wants_max number?
---@field type "fuel"
---@field fuel Fuel?
---@field affects Affects[][]
---@field power number
---@field fast_coeff number
---@field slow_coeff number
---@field fast_flux number
---@field slow_flux number
---@field cslow number
---@field cfast number
---@field in_slow_flux number
---@field in_fast_flux number
---@field base_fast_flux number
---@field base_slow_flux number
---@field entity LuaEntity
---@field connector LuaEntity
---@field reactor Reactor?
---@field id integer
---@field temperature number
---@field base_efficiency number
---@field efficiency number
---@field affectable_distance number
---@field interface LuaEntity?
---@field csection LuaLogisticSection?
---@field delta_flux number
---@field requested boolean
---@field requested_waste boolean
---@field tsig SignalID
---@field psig SignalID
---@field esig SignalID
---@field fsig SignalID
---@field sfsig SignalID
---@field ffsig SignalID
---@field dfsig SignalID
---@field networked boolean

---@class (exact) Controller
---@field type "controller"
---@field connector LuaEntity?
---@field reactor Reactor?
---@field id number
---@field entity LuaEntity
---@field group number?

---@class (exact) ControlRod
---@field type "control"
---@field insertion number
---@field heat_pipe LuaEntity?
---@field entity LuaEntity
---@field connector LuaEntity
---@field reactor Reactor?
---@field id integer
---@field circuit LuaEntity?
---@field csection LuaLogisticSection?
---@field useg boolean
---@field group number?

---@class (exact) Moderator
---@field type "mod"
---@field conversion number
---@field heat_pipe LuaEntity?
---@field connector LuaEntity?
---@field entity LuaEntity
---@field reactor Reactor?
---@field id integer

---@class (exact) Source
---@field type "source"
---@field connector LuaEntity?
---@field entity LuaEntity
---@field reactor Reactor?
---@field id integer
---@field slow_flux number
---@field fast_flux number
---@field penalty number
---@field range number

---@class (exact) Reflector
---@field type "reflector"
---@field id integer
---@field entity LuaEntity
---@field connector LuaEntity?
---@field reactor Reactor?
---@field heat_pipe LuaEntity?
---@field reflection_distance number
---@field bounce_limit number

---@class (exact) Interface
---@field type "interface"
---@field input boolean
---@field output boolean
---@field entity LuaEntity
---@field connector LuaEntity
---@field reactor Reactor?
---@field output_item string?
---@field group number?
---@field csection LuaLogisticSection?
---@field controller boolean
---@field gsig SignalID
---@field insertion number
---@field id integer

---@class (exact) GroupInsertion
---@field owners table<integer>
---@field val number

---@class (exact) ProviderFuel
---@field from Interface
---@field count number
---@field inventory LuaInventory

---@class (exact) DumpFuel
---@field from Interface
---@field count number
---@field inventory LuaInventory

---@class (exact) Reactor
---@field fuel_rods FuelRod[]
---@field control_rods ControlRod[]
---@field moderators Moderator[]
---@field sources Source[]
---@field reflectors Reflector[]
---@field enabled boolean
---@field id number
---@field outputs Interface[]
---@field inputs Interface[]
---@field visualize boolean?
---@field have_spent FuelRod[]
---@field fuels table<string, ProviderFuel>
---@field need_fuel number
---@field need_waste number
---@field dumps table<string, DumpFuel>
---@field insertions GroupInsertion[]
---@field interfaces Interface[]
---@field controllers Interface[]
---@field group_controllers boolean
---@field melting_down boolean?
---@field score number
---@field cscore number
---@field iscore number
---@field add_score number
---@field add_cscore number
---@field add_iscore number
---@field k number?
---@field ck number?
---@field ik number?
---@field surface LuaSurface
---@field queued_spawns table[]
---@field meltdown_source_pos MapPosition?

---@class Debris
---@field sprite SpritePath
---@field rotation number
---@field rotation_speed number
---@field x number
---@field xv number
---@field y number
---@field yv number
---@field z number
---@field zv number
---@field landed_entity string?
---@field force (string|LuaForce)?
---@field render LuaRenderObject
---@field surface LuaSurface
---@field ttl number

---@class (exact) CoolingTower
---@field id number
---@field entity LuaEntity
---@field smoke LuaEntity?

---@class (exact) Spec.FuelRod
---@field name string
---@field slow_cross_section number
---@field fast_cross_section number
---@field affectable_distance number

---@class (exact) Spec.Moderator
---@field name string
---@field conversion number

---@class (exact) Spec.Reflector
---@field reflection_distance number
---@field bounce_limit number
---@field scattering number

---@class (exact) Spec.Source
---@field efficiency_penalty number
---@field slow_flux number
---@field fast_flux number
