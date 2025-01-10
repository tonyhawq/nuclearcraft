local rods = {}

rods.interface_name = "reactor-interface"
rods.heat_interface_name = "nc-fuel-rod-heat"
rods.circuit_interface_name = "nc-circuit-interface"
rods.heat_pipe_name = "nc-heat-pipe"
rods.connector_name = "nc-connector"
rods.heat_interface_capacity = 1
rods.meltdown_temperature = 2500
local heat_interface_capacity = rods.heat_interface_capacity

function rods.setup()
    storage.rods = storage.rods or {} --[[@as table<FuelRod>]]
    storage.reflectors = storage.reflectors or {} --[[@as table<Reflector>]]
    storage.interfaces = storage.interfaces or {} --[[@as table<Interface>]]
    storage.connectors = storage.connectors or {} --[[@as table<Connector>]]
    storage.moderators = storage.moderators or {} --[[@as table<Moderator>]]
    storage.reactors = storage.reactors or {} --[[@as table<Reactor>]]
    storage.last_reactor_id = storage.last_reactor_id or 0
end

---@param connector LuaEntity
---@param owner FuelRod|ControlRod|Interface|Source|Reflector|Moderator
function rods.create_connector(connector, owner)
    storage.connectors[connector.unit_number] = {
        entity = connector,
        owner = owner
    } --[[@as Connector]]
end

---@param entity LuaEntity
function rods.on_fuel_rod_built(entity)
    local interface = entity.surface.create_entity{name=rods.heat_interface_name, position=entity.position, force=entity.force}
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for fuel rod "..tostring(entity.name))
    end
    local circuit = entity.surface.create_entity{name=rods.circuit_interface_name, position=entity.position, force=entity.force}
    local section = ((circuit--[[@as LuaEntity]]).get_control_behavior() --[[@as LuaConstantCombinatorControlBehavior]]).get_section(1)
    entity.get_wire_connector(defines.wire_connector_id.circuit_green, true).connect_to((circuit --[[@as LuaEntity]]).get_wire_connector(defines.wire_connector_id.circuit_green, true))
    entity.get_wire_connector(defines.wire_connector_id.circuit_red, true).connect_to((circuit --[[@as LuaEntity]]).get_wire_connector(defines.wire_connector_id.circuit_red, true))
    local id = script.register_on_object_destroyed(entity)
    local fuel_rod = {
        fuel = nil,
        type = "fuel",
        affectors = {},
        power = 0,
        fast_flux = 0,
        slow_flux = 0,
        in_slow_flux = 0,
        in_fast_flux = 0,
        efficiency = 1,
        temperature = 0,
        interface = interface,
        entity = entity,
        circuit = circuit,
        csection = section,
        connector = connector,
        reactor = nil,
        id = id,
        base_fast_flux = 0,
        base_slow_flux = 0,
        wants_fuel = nil,
        base_efficiency = 1,
        basic_sources = {},
        unpenalized = 1,
        penalty_val = 1,
        affectable_distance = 10,
    } --[[@as FuelRod]]
    storage.rods[id] = fuel_rod
    rods.create_connector(connector, fuel_rod)
end

---@param entity LuaEntity
function rods.on_control_rod_built(entity)
    local pipe = entity.surface.create_entity{name=rods.heat_pipe_name, position=entity.position, force=entity.force}
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for control rod "..tostring(entity.name))
    end
    local circuit = entity.surface.create_entity{name=rods.circuit_interface_name, position=entity.position, force=entity.force}
    entity.get_wire_connector(defines.wire_connector_id.circuit_green, true).connect_to((circuit --[[@as LuaEntity]]).get_wire_connector(defines.wire_connector_id.circuit_green, true))
    entity.get_wire_connector(defines.wire_connector_id.circuit_red, true).connect_to((circuit --[[@as LuaEntity]]).get_wire_connector(defines.wire_connector_id.circuit_red, true))
    local section = ((circuit--[[@as LuaEntity]]).get_control_behavior() --[[@as LuaConstantCombinatorControlBehavior]]).get_section(1)
    local id = script.register_on_object_destroyed(entity)
    local control_rod = {
        type = "control",
        insertion = 0,
        heat_pipe = pipe,
        entity = entity,
        connector = connector,
        circuit = circuit,
        csection = section,
        reactor = nil,
        id = id,
    } --[[@as ControlRod]]
    storage.rods[id] = control_rod
    rods.create_connector(connector, control_rod)
end

---@param entity LuaEntity
function rods.on_interface_built(entity)
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for control rod "..tostring(entity.name))
    end
    local id = script.register_on_object_destroyed(entity)
    local interface = {
        type = "interface",
        input = false,
        entity = entity,
        connector = connector,
        reactor = nil,
        id = id,
    } --[[@as Interface]]
    storage.interfaces[id] = interface
    rods.create_connector(connector, interface)
end

---@param entity LuaEntity
function rods.on_source_built(entity)
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for control rod "..tostring(entity.name))
    end
    local id = script.register_on_object_destroyed(entity)
    local source = {
        type = "source",
        entity = entity,
        connector = connector,
        reactor = nil,
        id = id,
        slow_flux = 6,
        fast_flux = 0,
        range = 3,
        penalty = 0.5,
    } --[[@as Source]]
    storage.rods[id] = source
    rods.create_connector(connector, source)
end

---@param entity LuaEntity
function rods.on_reflector_built(entity)
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for control rod "..tostring(entity.name))
    end
    local pipe = entity.surface.create_entity{name=rods.heat_pipe_name, position=entity.position, force=entity.force}
    local id = script.register_on_object_destroyed(entity)
    local reflector = {
        type = "reflector",
        entity = entity,
        heat_pipe = pipe,
        connector = connector,
        id = id,
        reflection_distance = 5,
        bounce_limit = 2,
    } --[[@as Reflector]]
    storage.reflectors[id] = reflector
    rods.create_connector(connector, reflector)
end

---@param entity LuaEntity
function rods.on_moderator_built(entity)
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for control rod "..tostring(entity.name))
    end
    local pipe = entity.surface.create_entity{name=rods.heat_pipe_name, position=entity.position, force=entity.force}
    local id = script.register_on_object_destroyed(entity)
    local moderator = {
        type = "mod",
        entity = entity,
        connector = connector,
        heat_pipe = pipe,
        id = id,
        conversion = 0.8,
    } --[[@as Moderator]]
    storage.moderators[id] = moderator
    rods.create_connector(connector, moderator)
end

rods.on_built_by_name = {
    ["fuel-rod"] = rods.on_fuel_rod_built,
    ["control-rod"] = rods.on_control_rod_built,
    ["source-rod"] = rods.on_source_built,
    ["reflector-rod"] = rods.on_reflector_built,
    ["reactor-interface"] = rods.on_interface_built,
    ["moderator-rod"] = rods.on_moderator_built,
}

rods.void = {}
local void_mt = {__call = function() end}
setmetatable(rods.void, void_mt)

---@param entity LuaEntity
function rods.on_built(entity)
    (rods.on_built_by_name[entity.name] or rods.void)(entity)
end

---@param event EventData.on_object_destroyed
function rods.on_destroyed(event)
    local id = event.registration_number
    if storage.rods[id] then
        local rod = storage.rods[id] --[[@as FuelRod|ControlRod|Source]]
        if rod.reactor then
            rods.destroy_reactor(rod.reactor)
        end
        if rod.circuit and rod.circuit.valid then
            rod.circuit.destroy()
        end
        if rod.connector.valid then
            rod.connector.destroy()
        end
        if rod.interface and rod.interface.valid then
            rod.interface.destroy()
        end
        if rod.heat_pipe and rod.heat_pipe.valid then
            rod.heat_pipe.destroy()
        end
        storage.rods[id] = nil
    elseif storage.reflectors[id] then
        local reflector = storage.reflectors[id] --[[@as Reflector]]
        if reflector.reactor then
            rods.destroy_reactor(reflector.reactor)
        end
        if reflector.connector.valid  then
            reflector.connector.destroy()
        end
        if reflector.heat_pipe and reflector.heat_pipe.valid then
            reflector.heat_pipe.destroy()
        end
    elseif storage.moderators[id] then
        local moderator = storage.moderators[id] --[[@as Moderator]]
        if moderator.reactor then
            rods.destroy_reactor(moderator.reactor)
        end
        if moderator.connector.valid  then
            moderator.connector.destroy()
        end
        if moderator.heat_pipe and moderator.heat_pipe.valid then
            moderator.heat_pipe.destroy()
        end
    elseif storage.interfaces[id] then
        local interface = storage.interfaces[id] --[[@as Interface]]
        if interface.reactor then
            rods.destroy_reactor(interface.reactor)
        end
        if interface.connector and interface.connector.valid then
            interface.connector.destroy()
        end
    end
end

---@param entity LuaEntity
---@return LuaEntity[]
function rods.get_neighbors(entity)
    local north = entity.surface.find_entities_filtered{position = {entity.position.x, entity.position.y - 1}, name=rods.connector_name}[1]
    local south = entity.surface.find_entities_filtered{position = {entity.position.x, entity.position.y + 1}, name=rods.connector_name}[1]
    local east = entity.surface.find_entities_filtered{position = {entity.position.x + 1, entity.position.y}, name=rods.connector_name}[1]
    local west = entity.surface.find_entities_filtered{position = {entity.position.x - 1, entity.position.y}, name=rods.connector_name}[1]
    return {north, south, east, west}
end

local function first(tabl)
    local _, v = next(tabl)
    return v
end

---@return number
function rods.new_reactor_id()
    storage.last_reactor_id = storage.last_reactor_id + 1
    return storage.last_reactor_id
end

---@param rod ControlRod
function rods.update_control_rod(rod)

end

---@param rod FuelRod
function rods.update_fuel_rod_fuel(rod)
    local inventory = rod.entity.get_inventory(defines.inventory.chest) --[[@as LuaInventory]]
    local items = inventory.get_contents()
    local item
    local wants = rod.wants_fuel
    for _, exists in pairs(items) do
        if wants == exists.name then
            item = exists
            break
        end
    end
    if not item then
        rod.fuel = nil
        return
    end
    local memo = Formula.fuels[item.name]
    rod.fuel = {
        item = memo.item,
        burnt_item = memo.burnt_item,
        character_name = memo.character_name,
        fuel_remaining = memo.fuel_remaining,
        total_fuel = memo.total_fuel,
    }
    inventory.remove{name=item.name, count=1}
end

function rods.fake_update_fuel_rod(rod)
    local slow_flux = rod.base_slow_flux
    local fast_flux = rod.base_fast_flux
    local temperature = rod.temperature
    local penalty = 1
    for _, affector in pairs(rod.affectors) do
        local affector_rod = affector.affector
        local insertion = 1
        for _, control_rod in pairs(affector.control_rods) do
            insertion = insertion * control_rod.insertion
        end
        insertion = 1 - insertion
        slow_flux = slow_flux + insertion * (affector_rod.slow_flux + affector_rod.fast_flux * affector.moderation)
        fast_flux = fast_flux + insertion * (affector_rod.fast_flux * (1 - affector.moderation))
        if affector_rod.penalty then
            penalty = penalty * affector_rod.penalty
        end
    end
    rod.penalty_val = penalty * rod.base_efficiency
    rod.in_slow_flux = slow_flux
    rod.in_fast_flux = fast_flux
    rod.temperature = rod.interface.temperature
end

---@param rod FuelRod
function rods.update_fuel_rod(rod)
    if not rod.fuel then
        if rod.wants_fuel then
            rods.update_fuel_rod_fuel(rod)
        end
        if rod.fuel then
            goto skip
        end
        rod.slow_flux = 0
        rod.fast_flux = 0
        rod.in_slow_flux = 0
        rod.in_fast_flux = 0
        rod.efficiency = 0
        rod.power = 0
        rod.interface.set_heat_setting{mode="add", temperature=0} ---@diagnostic disable-line
        return
    end
    ::skip::
    local slow_flux = rod.base_slow_flux
    local fast_flux = rod.base_fast_flux
    local temperature = rod.temperature
    local penalty = 1
    for _, affector in pairs(rod.affectors) do
        local affector_rod = affector.affector
        local insertion = 1
        local crods = false
        for _, control_rod in pairs(affector.control_rods) do
            crods = true
            insertion = insertion * control_rod.insertion
        end
        if crods then
            insertion = 1 - insertion
        end
        slow_flux = slow_flux + insertion * (affector_rod.slow_flux + affector_rod.fast_flux * affector.moderation)
        fast_flux = fast_flux + insertion * (affector_rod.fast_flux * (1 - affector.moderation))
        if affector_rod.penalty then
            penalty = penalty * affector_rod.penalty
        end
    end
    local character = Formula.characteristics[rod.fuel.character_name]
    slow_flux = math.max(slow_flux, 0)
    fast_flux = math.max(fast_flux, 0)
    local out_slow, out_fast = character.flux(slow_flux, fast_flux, temperature)
    rod.slow_flux = math.max(out_slow, 0)
    rod.fast_flux = math.max(out_fast, 0)
    rod.power = character.power(slow_flux, fast_flux, temperature)
    local norm_eff = character.efficiency(slow_flux, fast_flux, temperature)
    rod.efficiency = norm_eff * penalty * rod.base_efficiency
    rod.penalty_val = penalty * rod.base_efficiency
    rod.unpenalized = norm_eff
    rod.in_slow_flux = slow_flux
    rod.in_fast_flux = fast_flux
    rod.interface.set_heat_setting{mode="add", temperature=rod.power / heat_interface_capacity / 60}
    rod.temperature = rod.interface.temperature
    local fuel = rod.fuel --[[@as Fuel]]
    fuel.fuel_remaining = fuel.fuel_remaining - rod.power / rod.efficiency
    if fuel.fuel_remaining <= 0 then
        rods.update_fuel_rod_fuel(rod)
    end
    if rod.csection then
        local section = rod.csection --[[@as LuaLogisticSection]]
        section.set_slot(1, {value={type="item", name="fuel-rod", quality="normal"}, min=1})
        section.set_slot(2, {value={type="virtual", name="signal-T", quality="normal"}, min=math.min(temperature, 1000000)})
        section.set_slot(3, {value={type="virtual", name="signal-P", quality="normal"}, min=math.min(rod.power * 1000, 1000000)})
        section.set_slot(4, {value={type="virtual", name="signal-E", quality="normal"}, min=math.min(rod.efficiency * 100, 1000000)})
        section.set_slot(4, {value={type="virtual", name="signal-F", quality="normal"}, min=math.min(rod.fuel.fuel_remaining, 1000000)})
    end
end

---@param reactor Reactor
function rods.update_reactor(reactor)
    for _, rod in pairs(reactor.fuel_rods) do
        rods.update_fuel_rod(rod)
    end
    for _, control_rod in pairs(reactor.control_rods) do
        rods.update_control_rod(control_rod)
    end
    if reactor.visualize then
        rendering.clear("nuclearcraft")
        for _, rod in pairs(reactor.fuel_rods) do

        end
    end
end

---@class (exact) AddConnectorToReactorParam
---@field interface fun(connector: Connector, reactor: Reactor)
---@field control fun(connector: Connector, reactor: Reactor)
---@field fuel fun(connector: Connector, reactor: Reactor)
---@field source fun(connector: Connector, reactor: Reactor)
---@field reflector fun(connector: Connector, reactor: Reactor)
---@field mod fun(connector: Connector, reactor: Reactor)

---@type AddConnectorToReactorParam
rods.add_connector_to_reactor = {
    interface = function (connector, reactor)
        local interface = connector.owner
        ---@cast interface Interface
        interface.reactor = reactor
        if interface.input then
            reactor.inputs[interface.id] = interface
        else
            reactor.outputs[interface.id] = interface
        end
    end,
    control = function (connector, reactor)
        connector.owner.reactor = reactor
        reactor.control_rods[connector.owner--[[@as ControlRod]].id] = connector.owner --[[@as ControlRod]]
    end,
    fuel = function (connector, reactor)
        connector.owner.reactor = reactor
        reactor.fuel_rods[connector.owner--[[@as FuelRod]].id] = connector.owner --[[@as FuelRod]]
    end,
    source = function (connector, reactor)
        connector.owner.reactor = reactor
        reactor.sources[connector.owner--[[@as Source]].id] = connector.owner --[[@as Source]]
    end,
    reflector = function (connector, reactor)
        connector.owner.reactor = reactor
        reactor.reflectors[connector.owner--[[@as Reflector]].id] = connector.owner --[[@as Reflector]]
    end,
    mod = function (connector, reactor)
        connector.owner.reactor = reactor
        reactor.moderators[connector.owner --[[@as Moderator]].id] = connector.owner --[[@as Moderator]]
    end,
}

---@param source Interface
function rods.create_reactor(source)
    game.print("Creating reactor...")
    if source.reactor then
        rods.destroy_reactor(source.reactor)
    end
    local neighbors = {[source.entity.unit_number] = source.connector}
    local working = {source.entity}
    local antispam = 0
    local as = 0
    while first(working) do
        as = as + 1
        game.print(as)
        local k, v = next(working)
        working[k] = nil
        game.print("getting neighbors of "..tostring(v.unit_number).." "..tostring(as)..tostring(serpent.line(working)))
        local found_neighbors = rods.get_neighbors(v)
        for _, neighbor in pairs(found_neighbors) do
            if not neighbors[neighbor.unit_number] then
                table.insert(working, neighbor)
                neighbors[neighbor.unit_number] = neighbor
                antispam = antispam + 1
                game.print("Found new neighbor "..tostring(antispam))
            end
        end
    end
    -- neighbors should now include every connected reactor connector
    local reactor = {
        id = rods.new_reactor_id(),
        fuel_rods = {},
        control_rods = {},
        enabled = false,
        outputs = {},
        inputs = {},
        sources = {},
        reflectors = {},
        moderators = {},
        need_fuel = {},
        have_spent = {},
    } --[[@as Reactor]]
    local is_valid_reactor = true
    for _, neighbor in pairs(neighbors) do
        ---@type Connector
        local connector = storage.connectors[neighbor.unit_number]
        if not connector then
            is_valid_reactor = false
            neighbor.destroy()
        end
        if not is_valid_reactor then
            goto continue
        end
        rods.add_connector_to_reactor[connector.owner.type](connector, reactor)
        ::continue::
    end
    if not is_valid_reactor then
        return rods.create_reactor(source)
    end
    rods.create_affectors(reactor)
    storage.reactors[reactor.id] = reactor
end

---@param entity LuaEntity
---@return Reflector?
function rods.owns_reflector(entity)
    local con = storage.connectors[entity.unit_number]
    if con and con.owner and con.owner.type == "reflector" then
        return con.owner
    end
end

---@param config table
---@return table<integer, Connector>
function rods.find_in_line(config)
    game.print("Finding in line... "..math.random())
    local source = config.source --[[@as LuaEntity]]
    local surface = source.surface
    local pos = source.position
    local angle = config.angle --[[@as number]]
    local dx = math.sin(angle)
    local dy = math.cos(angle)
    local x = pos.x
    local y = pos.y
    local found = {}
    local bounces = 0
    for i = 1, config.length --[[@as integer]] do
        x = x + dx
        y = y + dy
        local position = {x,y}
        game.print("[gps="..position[1]..","..position[2].."] "..math.random())
        local entities = surface.find_entities_filtered{position=position, name=rods.connector_name}
        local entity = entities[1]
        if entity then
            if config.condition and config.condition(entity) then
                break
            end
            local reflector = rods.owns_reflector(entity)
            if reflector then
                if bounces >= reflector.bounce_limit then
                    break
                end
                game.print("reflecting...")
                angle = angle + math.pi
                dx = math.sin(angle)
                dy = math.cos(angle)
                config.length = math.min(config.length, reflector.reflection_distance + i)
                bounces = bounces + 1
            else
                found[i] = storage.connectors[entities[1].unit_number]
            end
        else
            break
        end
    end
    return found
end

function rods.shallow_copy(tabl)
    local out = {}
    for k, v in pairs(tabl) do
        out[k] = v
    end
    return out
end

---@param moderators Moderator[]
---@return number
function rods.get_moderation_from_moderators(moderators)
    local value = 1
    for _, mod in pairs(moderators) do
        value = value * mod.conversion
    end
    return (1 - value)
end

---@param p1 MapPosition
---@param p2 MapPosition
---@return number
local function distance_sqr(p1, p2)
    return (p1.x - p2.x)^2+(p1.y - p2.y)^2
end

---@param reactor Reactor
function rods.create_affectors(reactor)
    local function matches_reactor_filter(entity)
        local owner_reactor = storage.connectors[entity.unit_number] --[[@as Connector]].owner.reactor
        if not owner_reactor or owner_reactor ~= reactor then
            return true
        end
    end
    for _, rod in pairs(reactor.fuel_rods) do
        rod.base_fast_flux = 0
        rod.base_slow_flux = 0
        rod.base_efficiency = 1
        rod.penalty_val = 1
        rod.affectors = {}
        rod.basic_sources = {}
        for i = 1, 4 do
            local visited_moderators = {}
            local visited_control_rods = {}
            local control_rod_count = 0
            local connectors = rods.find_in_line{source=rod.entity, angle=i * math.pi / 2, length=rod.affectable_distance, condition=matches_reactor_filter}
            for _, connector in pairs(connectors) do
                local owner = connector.owner
                if not owner.reactor or owner.reactor ~= reactor then
                    goto continue
                end
                if owner.type == "interface" then
                    goto continue
                end
                if owner.type == "fuel" then
                    ---@cast owner FuelRod
                    table.insert(rod.affectors, {control_rods = rods.shallow_copy(visited_control_rods), affector=owner, moderation=rods.get_moderation_from_moderators(visited_moderators)} --[[@as Affector]])
                elseif owner.type == "control" then
                    ---@cast owner ControlRod
                    control_rod_count = control_rod_count + 1
                    table.insert(visited_control_rods, owner)
                elseif owner.type == "source" then
                    ---@cast owner Source
                    if distance_sqr(connector.entity.position, rod.entity.position) <= (owner.range ^ 2) then
                        if control_rod_count == 0 then
                            local moderation = rods.get_moderation_from_moderators(visited_moderators)
                            rod.base_slow_flux = rod.base_slow_flux + moderation * owner.fast_flux + owner.slow_flux
                            rod.base_fast_flux = rod.base_fast_flux + owner.fast_flux * (1-moderation)
                            rod.base_efficiency = rod.base_efficiency * owner.penalty
                            table.insert(rod.basic_sources, owner)
                        else
                            table.insert(rod.affectors, {control_rods = rods.shallow_copy(visited_control_rods), affector=owner, moderation=rods.get_moderation_from_moderators(visited_moderators)})
                        end
                    end
                elseif owner.type == "mod" then
                    ---@cast owner Moderator
                    table.insert(visited_moderators, owner)
                end
                ::continue::
            end
        end
    end
end

---@param rod FuelRod
function rods.deactivate_fuel_rod(rod)
    rod.power = 0
    rod.efficiency = 1
    rod.base_efficiency = 1
    rod.penalty_val = 1
    rod.interface.set_heat_setting{mode="add",temperature=0}
    rod.slow_flux = 0
    rod.fast_flux = 0
    rod.in_slow_flux = 0
    rod.in_fast_flux = 0
end

---@param reactor Reactor
function rods.destroy_reactor(reactor)
    for _, rod in pairs(reactor.fuel_rods) do
        rod.reactor = nil
        rods.deactivate_fuel_rod(rod)
    end
    for _, rod in pairs(reactor.control_rods) do
        rod.reactor = nil
    end
    for _, source in pairs(reactor.sources) do
        source.reactor = nil
    end
    for _, moderator in pairs(reactor.moderators) do
        moderator.reactor = nil
    end
    for _, reflector in pairs(reactor.reflectors) do
        reflector.reactor = nil
    end
    for _, interface in pairs(reactor.inputs) do
        interface.reactor = nil
    end
    for _, interface in pairs(reactor.outputs) do
        interface.reactor = nil
    end
    reactor.fuel_rods = {}
    reactor.control_rods = {}
    reactor.inputs = {}
    reactor.outputs = {}
    storage.reactors[reactor.id] = nil
end

---@param from_ent LuaEntity
---@param to_ent LuaEntity
function rods.on_paste(from_ent, to_ent)
    -- TODO: FIX THIS
    local from_id = script.register_on_object_destroyed(from_ent)
    if not storage.rods[from_id] then
        return
    end
    local to_id = script.register_on_object_destroyed(to_ent)
    if not storage.rods[to_id] then
        return
    end
    local from = storage.rods[from_id] --[[@as FuelRod]]
    local to = storage.rods[to_id] --[[@as FuelRod]]
    if from.type ~= "fuel" or to.type ~= "fuel" then
        return
    end
    to.wants_fuel = from.wants_fuel
end

return rods