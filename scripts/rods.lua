local rods = {}

rods.interface_name = "reactor-interface"
rods.heat_interface_name = "nc-fuel-rod-heat"
rods.heat_pipe_name = "nc-heat-pipe"
rods.connector_name = "nc-connector"
rods.heat_interface_capacity = 1
rods.meltdown_temperature = 2500
local heat_interface_capacity = rods.heat_interface_capacity

function rods.setup()
    storage.rods = storage.rods or {} --[[@as table<FuelRod>]]
    storage.interfaces = storage.interfaces or {} --[[@as table<Interface>]]
    storage.connectors = storage.connectors or {} --[[@as table<Connector>]]
    storage.reactors = storage.reactors or {} --[[@as table<Reactor>]]
    storage.last_reactor_id = storage.last_reactor_id or 0
end

---@param connector LuaEntity
---@param owner FuelRod|ControlRod|Interface
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
        connector = connector,
        reactor = nil,
        id = id,
        base_fast_flux = 0,
        base_slow_flux = 0,
        wants_fuel = nil,
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
    local id = script.register_on_object_destroyed(entity)
    local control_rod = {
        type = "control",
        insertion = 0,
        heat_pipe = pipe,
        entity = entity,
        connector = connector,
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
        slow = 5,
        fast = 0,
    } --[[@as Source]]
    storage.rods[id] = source
    rods.create_connector(connector, source)
end

rods.on_built_by_name = {
    ["fuel-rod"] = rods.on_fuel_rod_built,
    ["control-rod"] = rods.on_control_rod_built,
    ["source-rod"] = rods.on_source_built,
    ["reactor-interface"] = rods.on_interface_built,
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
        return
    end
    rod.fuel = rods.shallow_copy(Formula.fuels[wants] --[[@as Fuel]]) --[[@as Fuel]]
    inventory.remove{name=item.name, count=1}
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
        rod.interface.set_heat_setting{mode="add", temperature=0} ---@diagnostic disable-line
        return
    end
    ::skip::
    local slow_flux = rod.base_slow_flux
    local fast_flux = rod.base_fast_flux
    local temperature = rod.temperature
    for _, affector in pairs(rod.affectors) do
        local affector_rod = affector.fuel_rod
        local insertion = 1
        for _, control_rod in pairs(affector.control_rods) do
            insertion = insertion * control_rod.insertion
        end
        insertion = 1 - insertion
        slow_flux = slow_flux + insertion * (affector_rod.slow_flux + affector_rod.fast_flux * affector.moderation)
        fast_flux = fast_flux + insertion * (affector_rod.fast_flux * (1 - insertion))
    end
    local character = Formula.characteristics[rod.fuel.character_name]
    local out_slow, out_fast = character.flux(slow_flux, fast_flux, temperature)
    rod.slow_flux = out_slow
    rod.fast_flux = out_fast
    rod.power = character.power(slow_flux, fast_flux, temperature)
    rod.efficiency = character.efficiency(slow_flux, fast_flux, temperature)
    rod.in_slow_flux = slow_flux
    rod.in_fast_flux = fast_flux
    rod.interface.set_heat_setting{mode="add", temperature=rod.power / heat_interface_capacity / 60}
    rod.temperature = rod.interface.temperature
    local fuel = rod.fuel --[[@as Fuel]]
    fuel.fuel_remaining = fuel.fuel_remaining - rod.power / rod.efficiency
    if fuel.fuel_remaining <= 0 then
        rods.update_fuel_rod_fuel(rod)
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

rods.add_connector_to_reactor = {
    ---@param connector Connector
    ---@param reactor Reactor
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
    ---@param connector Connector
    ---@param reactor Reactor
    control = function (connector, reactor)
        connector.owner.reactor = reactor
        reactor.control_rods[connector.owner--[[@as ControlRod]].id] = connector.owner --[[@as ControlRod]]
    end,
    ---@param connector Connector
    ---@param reactor Reactor
    fuel = function (connector, reactor)
        connector.owner.reactor = reactor
        reactor.fuel_rods[connector.owner--[[@as FuelRod]].id] = connector.owner --[[@as FuelRod]]
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

---@param config table
---@return table<integer, Connector>
function rods.find_in_line(config)
    local source = config.source --[[@as LuaEntity]]
    local surface = source.surface
    local pos = source.position
    local dx = math.sin(config.angle --[[@as number]])
    local dy = math.cos(config.angle --[[@as number]])
    local found = {}
    for i = 1, config.length --[[@as integer]] do
        local position = {pos.x + dx * i, pos.y + dy * i}
        local entities = surface.find_entities_filtered{position=position, name=rods.connector_name}
        if entities[1] then
            found[i] = storage.connectors[entities[1].unit_number]
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

---@param reactor Reactor
function rods.create_affectors(reactor)
    for _, rod in pairs(reactor.fuel_rods) do
        rod.affectors = {}
        for i = 1, 4 do
            local visited_moderators = {}
            local visited_control_rods = {}
            local connectors = rods.find_in_line{source=rod.entity, angle=i * math.pi / 2, length=8}
            for _, connector in pairs(connectors) do
                local owner = connector.owner
                if not owner.reactor or owner.reactor ~= reactor then
                    goto continue
                end
                if owner.type == "interface" then
                    goto continue
                end
                if owner.type == "fuel" then
                    table.insert(rod.affectors, {control_rods = rods.shallow_copy(visited_control_rods), fuel_rod=owner, moderation=rods.get_moderation_from_moderators(visited_moderators)} --[[@as Affector]])
                elseif owner.type == "control" then
                    table.insert(visited_control_rods, owner)
                end
                ::continue::
            end
        end
    end
end

---@param reactor Reactor
function rods.destroy_reactor(reactor)
    for _, rod in pairs(reactor.fuel_rods) do
        rod.reactor = nil
    end
    for _, rod in pairs(reactor.control_rods) do
        rod.reactor = nil
    end
    for _, source in pairs(reactor.sources) do
        source.reactor = nil
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

return rods