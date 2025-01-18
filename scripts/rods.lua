local rods = {}

rods.interface_name = "reactor-interface"
rods.heat_interface_name = "nc-fuel-rod-heat"
rods.circuit_interface_name = "nc-circuit-interface"
rods.heat_pipe_name = "nc-heat-pipe"
rods.connector_name = "nc-connector"
rods.heat_interface_capacity = 1
rods.meltdown_temperature = 2500
local heat_interface_capacity = rods.heat_interface_capacity
local meltdown_temperature = rods.meltdown_temperature

local function first(tabl)
    local _, v = next(tabl)
    return v
end

rods.default_signal = {
    temperature = {type="virtual", name="signal-temp",quality="normal"},
    power = {type="virtual", name="signal-kW",quality="normal"},
    efficiency = {type="virtual", name="signal-E",quality="normal"},
    fuel = {type="virtual", name="signal-fuel",quality="normal"},
    slow_flux = {type="virtual", name="signal-nFs",quality="normal"},
    fast_flux = {type="virtual", name="signal-nFf",quality="normal"},
    delta_flux = {type="virtual", name="signal-deltanF", quality="normal"},
    group_controller = {type="virtual", name="signal-S", quality="normal"},
}
rods.default_signal.tsig = rods.default_signal.temperature
rods.default_signal.psig = rods.default_signal.power
rods.default_signal.esig = rods.default_signal.efficiency
rods.default_signal.fsig = rods.default_signal.fuel
rods.default_signal.sfsig = rods.default_signal.slow_flux
rods.default_signal.ffsig = rods.default_signal.fast_flux
rods.default_signal.dfsig = rods.default_signal.delta_flux
rods.default_signal.gsig = rods.default_signal.group_controller

rods.restricted_signal = {
    ["signal-everything"] = "signal-everything",
    ["signal-any"] = "signal-any",
    ["signal-each"] = "signal-each",
    
}

function rods.setup()
    storage.rods = storage.rods or {} --[[@as table<FuelRod>]]
    storage.reflectors = storage.reflectors or {} --[[@as table<Reflector>]]
    storage.interfaces = storage.interfaces or {} --[[@as table<Interface>]]
    storage.connectors = storage.connectors or {} --[[@as table<Connector>]]
    storage.moderators = storage.moderators or {} --[[@as table<Moderator>]]
    storage.reactors = storage.reactors or {} --[[@as table<Reactor>]]
    storage.controllers = storage.controllers or {} --[[@as table<Controller>]]
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

function rods.on_controller_built(entity)
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for fuel rod "..tostring(entity.name))
    end
    local id = script.register_on_object_destroyed(entity)
    local controller = {
        id = id,
        type = "controller",
        entity = entity,
        group = nil,
        connector = connector,
    } --[[@as Controller]]
    storage.controllers[id] = controller
    rods.create_connector(connector, controller)
end

---@param entity LuaEntity
function rods.on_fuel_rod_built(entity)
    local connector = entity.surface.create_entity{name=rods.connector_name, position=entity.position, force=entity.force}
    if not connector then
        error("Could not construct connector for fuel rod "..tostring(entity.name))
    end
    local interface = entity.surface.create_entity{name=rods.heat_interface_name, position=entity.position, force=entity.force}
    local behaviour = (entity--[[@as LuaEntity]]).get_control_behavior() --[[@as LuaConstantCombinatorControlBehavior]]
    while behaviour.sections_count > 0 do
        behaviour.remove_section(1)
    end
    local section = behaviour.add_section()
    local id = script.register_on_object_destroyed(entity)
    local fuel_rod = {
        fuel = nil,
        type = "fuel",
        power = 0,
        fast_coeff = 0.5,
        slow_coeff = 0.5,
        cslow = 0,
        cfast = 0,
        fast_flux = 0,
        slow_flux = 0,
        in_slow_flux = 0,
        in_fast_flux = 0,
        affects = {},
        base_efficiency = 1,
        efficiency = 1,
        temperature = 0,
        entity = entity,
        interface = interface,
        csection = section,
        connector = connector,
        reactor = nil,
        id = id,
        base_fast_flux = 0,
        base_slow_flux = 0,
        wants_fuel = nil,
        affectable_distance = 10,
        delta_flux = 0,
        requested = false,
        requested_waste = false,
        tsig = Rods.default_signal.tsig,
        psig = Rods.default_signal.psig,
        esig = Rods.default_signal.esig,
        fsig = Rods.default_signal.fsig,
        sfsig = Rods.default_signal.sfsig,
        ffsig = Rods.default_signal.ffsig,
        dfsig = Rods.default_signal.dfsig,
        networked = false,
    } --[[@as FuelRod]]
    storage.rods[id] = fuel_rod
    rods.create_connector(connector, fuel_rod)
end

---@param interface Interface
---@param group number
---@return boolean
function rods.group_id_in_use(interface, group)
    local reactor = interface.reactor
    if not reactor then
        return false
    end
    if reactor.insertions[group] then
        local last_value = reactor.insertions[group].owners[interface.id]
        reactor.insertions[group].owners[interface.id] = nil
        if first(reactor.insertions[group].owners) then
            reactor.insertions[group].owners[interface.id] = last_value
            return true
        end
        reactor.insertions[group].owners[interface.id] = last_value
        return false
    end
    return false
end

---@param reactor Reactor
---@param group number
---@return boolean
function rods.group_id_exists(reactor, group)
    if not reactor then
        return false
    end
    if reactor.insertions[group] then
        return true
    end
    return false
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
        group = nil,
        useg = false,
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
        output = false,
        entity = entity,
        connector = connector,
        reactor = nil,
        id = id,
        controller = false,
        gsig = Rods.default_signal.gsig,
        insertion = 0,
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
    ["reactor-controller"] = rods.on_controller_built,
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
        if rod.interface and rod.interface.valid then
            rod.interface.destroy()
        end
        if rod.connector and rod.connector.valid then
            rod.connector.destroy()
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
        if reflector.connector and reflector.connector.valid  then
            reflector.connector.destroy()
        end
        if reflector.heat_pipe and reflector.heat_pipe.valid then
            reflector.heat_pipe.destroy()
        end
        storage.reflectors[id] = nil
    elseif storage.moderators[id] then
        local moderator = storage.moderators[id] --[[@as Moderator]]
        if moderator.reactor then
            rods.destroy_reactor(moderator.reactor)
        end
        if moderator.connector and moderator.connector.valid  then
            moderator.connector.destroy()
        end
        if moderator.heat_pipe and moderator.heat_pipe.valid then
            moderator.heat_pipe.destroy()
        end
        storage.moderators[id] = nil
    elseif storage.interfaces[id] then
        local interface = storage.interfaces[id] --[[@as Interface]]
        if interface.reactor then
            rods.destroy_reactor(interface.reactor)
        end
        if interface.connector and interface.connector.valid then
            interface.connector.destroy()
        end
        storage.interfaces[id] = nil
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

---@return number
function rods.new_reactor_id()
    storage.last_reactor_id = storage.last_reactor_id + 1
    return storage.last_reactor_id
end

---@param rod ControlRod
function rods.update_control_rod(rod)
    if rod.useg and rod.group then
        local group = rod.reactor.insertions[rod.group]
        if not group then
            rod.insertion = 0
            return
        end
        rod.insertion = group.val
        return
    end
    local target = rod.entity.get_signal({type="virtual", name="signal-S"}, defines.wire_connector_id.circuit_green)
    rod.insertion = math.max(math.min(target / 1000, 1), 0.1)
end

---@param rod FuelRod
---@param reactor Reactor
function rods.unrequest(rod, reactor)
    if rod.requested then
        rod.requested = false
        reactor.need_fuel = reactor.need_fuel - 1
    end
end

---@param rod FuelRod
---@param memo_name string
---@param buffered_in number
---@param buffered_out number
function rods.create_fuel_from_memo(rod, memo_name, buffered_in, buffered_out)
    local memo = Formula.fuels[memo_name]
    if not memo then
        error("No fuel exists with name "..tostring(memo_name))
        return
    end
    rod.fuel = {
        item = memo.item,
        burnt_item = memo.burnt_item,
        character_name = memo.character_name,
        fuel_remaining = memo.fuel_remaining,
        total_fuel = memo.total_fuel,
        buffered = buffered_in,
        buffered_out = buffered_out,
    }
    rods.unrequest(rod, rod.reactor)
end

---@param rod FuelRod
---@param reactor Reactor
function rods.update_fuel_rod_fuel(rod, reactor)
    local wants_min = rod.wants_min
    local wants_max = rod.wants_max
    local want_fuel = reactor.fuels[rod.wants_fuel --[[@as string]]]
    if not want_fuel or want_fuel.count <= 0 then
        return
    end
    if rod.fuel then
        local fuel = rod.fuel
        ---@cast fuel Fuel
        local count = math.min(want_fuel.count, rod.wants_max - rod.fuel.buffered)
        want_fuel.inventory.remove{name=rod.wants_fuel, count=count}
        want_fuel.count = want_fuel.count - count
        fuel.buffered = fuel.buffered + count
    else
        local count = math.min(want_fuel.count, rod.wants_max + 1)
        want_fuel.inventory.remove{name=rod.wants_fuel, count=count}
        want_fuel.count = want_fuel.count - count
        local memo = Formula.fuels[rod.wants_fuel]
        rod.fuel = {
            item = memo.item,
            burnt_item = memo.burnt_item,
            character_name = memo.character_name,
            fuel_remaining = memo.fuel_remaining,
            total_fuel = memo.total_fuel,
            buffered = count - 1,
            buffered_out = 0,
        }
    end
    rods.unrequest(rod, rod.reactor)
end

---@param rod FuelRod
---@param val string
---@param min number?
---@param max number?
function rods.set_fuel_request(rod, val, min, max)
    rod.wants_fuel = val
    if val then
        rod.wants_min = min or rod.wants_min or 0
        rod.wants_max = max or rod.wants_max or 0
    else
        rod.wants_min = min or rod.wants_min
        rod.wants_max = max or rod.wants_max
        if rod.requested then
            rod.requested = false
            if rod.reactor then
                rod.reactor.need_fuel = rod.reactor.need_fuel - 1
            end
        end
    end
    if rod.wants_min <= 0 then
        if rod.requested then
            rod.requested = false
            if rod.reactor then
                rod.reactor.need_fuel = rod.reactor.need_fuel - 1
            end
        end
    end
end

---@param rod FuelRod
function rods.clear_circuits(rod)
    if not rod.csection.valid then
        rod.csection = rod.entity.get_control_behavior()--[[@as LuaConstantCombinatorControlBehavior]].add_section()
    end
    local section = rod.csection --[[@as LuaLogisticSection]]
    section.set_slot(1, {value={type="item", name="fuel-rod", quality="normal"}, min=0})
    section.set_slot(2, {value=rod.tsig, min=0}) ---@diagnostic disable-line
    section.set_slot(3, {value=rod.psig, min=0}) ---@diagnostic disable-line
    section.set_slot(4, {value=rod.esig, min=0}) ---@diagnostic disable-line
    section.set_slot(5, {value=rod.fsig, min=0}) ---@diagnostic disable-line
    section.set_slot(6, {value=rod.sfsig, min=0}) ---@diagnostic disable-line
    section.set_slot(7, {value=rod.ffsig, min=0}) ---@diagnostic disable-line
    section.set_slot(8, {value=rod.dfsig, min=0}) ---@diagnostic disable-line
end

---@param rod FuelRod
local function pause_rod(rod)
    rod.slow_flux = 0
    rod.fast_flux = 0
    rod.in_slow_flux = 0
    rod.in_fast_flux = 0
    rod.efficiency = 0
    rod.power = 0
    rod.interface.set_heat_setting{mode="add", temperature=0}
    rods.clear_circuits(rod)
end

---@param rod FuelRod
---@param sig string
---@param value SignalID
function rods.set_signal(rod, sig, value)
    value.quality = "normal"
    rod[sig] = value
end

---@param rod FuelRod
function rods.meltdown(rod)
    if rod.reactor then
        if not rod.reactor.melting_down then
            local fuel_rods = rod.reactor.fuel_rods
            rod.reactor.melting_down = true
            rods.destroy_reactor(rod.reactor)
            for _, fuel_rod in pairs(fuel_rods) do
                rods.meltdown(fuel_rod)
            end
        end
    end
    rod.entity.destroy()
end

---@param rod FuelRod
function rods.update_fuel_rod(rod)
    local reactor = rod.reactor --[[@as Reactor]]
    local fuel = rod.fuel
    local temperature = rod.interface.temperature --[[@as number]]
    local in_slow = rod.cslow + rod.base_slow_flux
    local in_fast = rod.cfast + rod.base_fast_flux
    rod.cslow = 0
    rod.cfast = 0
    if temperature > meltdown_temperature then
        rods.meltdown(rod)
        return
    end
    if not fuel then
        if rod.wants_fuel and (rod.wants_min or 0) > 0 then
            if not rod.requested then
                reactor.need_fuel = reactor.need_fuel + 1
                rod.requested = true
            end
            rods.update_fuel_rod_fuel(rod, reactor)
        end
        if rod.fuel then
            fuel = rod.fuel
            goto skip
        end
        pause_rod(rod)
        return
    elseif (rod.wants_min or 0) > 0 and fuel.buffered < rod.wants_min then
        if not rod.requested then
            rod.requested = true
            reactor.need_fuel = reactor.need_fuel + 1
        end
        rods.update_fuel_rod_fuel(rod, reactor)
    end
    ::skip::
    if fuel.fuel_remaining <= 0 then
        if fuel.buffered > 0 then
            fuel.buffered = fuel.buffered - 1
            fuel.fuel_remaining = fuel.total_fuel
            fuel.buffered_out = fuel.buffered_out + 1
            if not rod.requested_waste then
                rod.requested_waste = true
                reactor.need_waste = reactor.need_waste + 1
            end
        elseif fuel.buffered_out <= 0 then
            rod.fuel = nil
            if rod.wants_min and rod.wants_min > 0 then
                rods.update_fuel_rod_fuel(rod, reactor)
                if not rod.fuel then    
                    pause_rod(rod)
                    return
                end
            end
        else
            if not rod.requested_waste then
                rod.requested_waste = true
                reactor.need_waste = reactor.need_waste + 1
            end
            pause_rod(rod)
            return
        end
    end
    if fuel.buffered_out > 0 then
        if not rod.requested_waste then
            rod.requested_waste = true
            reactor.need_waste = reactor.need_waste + 1
        end
    end
    if rod.requested_waste then
        if fuel.buffered_out <= 0 then
            rod.requested_waste = false
            rod.reactor.need_waste = rod.reactor.need_waste - 1
        end
        local waste_product = fuel.burnt_item
        local output = reactor.dumps[waste_product]
        if output and output.count > 0 then
            local insertable = math.min(output.count, fuel.buffered_out)
            fuel.buffered_out = fuel.buffered_out - insertable
            output.inventory.insert{name=waste_product, count=insertable}
            output.count = output.count - insertable
            if rod.requested_waste then
                rod.requested_waste = false
                rod.reactor.need_waste = rod.reactor.need_waste - 1
            end
        end
    end
    rod.in_slow_flux = in_slow
    rod.in_fast_flux = in_fast
    local character = Formula.characteristics[rod.fuel.character_name]
    local out_slow, out_fast = character.flux(in_slow, in_fast, temperature)
    local power = character.power(out_slow, out_fast, temperature)
    local efficiency = character.efficiency(out_slow, out_fast, temperature)
    rod.slow_flux = out_slow
    rod.fast_flux = out_fast
    rod.power = power
    rod.efficiency = efficiency
    fuel.fuel_remaining = fuel.fuel_remaining - power / efficiency
    rod.interface.set_heat_setting{type="add", temperature=power / heat_interface_capacity / 60}
    if fuel.fuel_remaining < 0 then
        fuel.fuel_remaining = 0
    end
    for _, dir in pairs(rod.affects) do
        local sf = out_slow / 4
        local ff = out_fast / 4
        for _, affects in pairs(dir) do
            local factor = 1
            for _, crod in pairs(affects.control_rods) do
                factor = factor * (1-crod.insertion)
                if factor == 0 then
                    goto fullbreak
                end
            end
            ---@cast affects Affects
            sf = (sf + ff * affects.conversion) * factor
            ff = (ff * (1-affects.conversion)) * factor
            local arod = affects.affects
            local slow_coeff = arod.slow_coeff
            local fast_coeff = arod.fast_coeff
            arod.cslow = arod.cslow + slow_coeff * sf
            arod.cfast = arod.cfast + fast_coeff * ff
            sf = sf - sf * slow_coeff
            ff = ff - ff * fast_coeff
        end
        ::fullbreak::
    end
    if rod.networked and rod.csection then
        if not rod.csection.valid then
            rod.csection = rod.entity.get_control_behavior()--[[@as LuaConstantCombinatorControlBehavior]].add_section()
        end
        local section = rod.csection --[[@as LuaLogisticSection]]
        section.set_slot(1, {value={type="item", name="fuel-rod", quality="normal"}, min=1})
        section.set_slot(2, {value=rod.tsig, min=math.min(temperature, 1000000)}) ---@diagnostic disable-line
        section.set_slot(3, {value=rod.psig, min=math.min(rod.power * 1000, 1000000)}) ---@diagnostic disable-line
        section.set_slot(4, {value=rod.esig, min=math.min(rod.efficiency * 100, 1000000)}) ---@diagnostic disable-line
        section.set_slot(5, {value=rod.fsig, min=math.min(rod.fuel.fuel_remaining, 1000000)}) ---@diagnostic disable-line
        section.set_slot(6, {value=rod.sfsig, min=math.min(rod.slow_flux * 1000, 1000000)}) ---@diagnostic disable-line
        section.set_slot(7, {value=rod.ffsig, min=math.min(rod.fast_flux * 1000, 1000000)}) ---@diagnostic disable-line
        section.set_slot(8, {value=rod.dfsig, min=math.min(rod.delta_flux * 1000, 1000000)}) ---@diagnostic disable-line
    end
end

---@param interface Interface
function rods.get_available_fuels_from(interface)
    local inventory = interface.entity.get_inventory(defines.inventory.chest) --[[@as LuaInventory]]
    local contents = inventory.get_contents()
    for _, item in pairs(contents) do
        if Formula.fuels[item.name] then
            interface.reactor.fuels[item.name] = {from=interface, count=item.count, inventory=inventory}
        end
    end
end

---@param interface Interface
function rods.get_available_dumps_from(interface)
    if not interface.output_item then
        return
    end
    local inventory = interface.entity.get_inventory(defines.inventory.chest) --[[@as LuaInventory]]
    local slots = inventory.get_insertable_count(interface.output_item --[[@as string]])
    if slots > 0 then
        interface.reactor.dumps[interface.output_item] = {from=interface, count=slots, inventory=inventory}
    end
end

---@param reactor Reactor
function rods.get_available_fuels(reactor)
    for _, input in pairs(reactor.inputs) do
        rods.get_available_fuels_from(input)
    end
end

---@param reactor Reactor
function rods.get_available_dumps(reactor)
    for _, output in pairs(reactor.outputs) do
        rods.get_available_dumps_from(output)
    end
end

---@param interface Interface
function rods.update_controller(interface)
    interface.insertion = interface.entity.get_signal(interface.gsig, defines.wire_connector_id.circuit_green)
    interface.reactor--[[@as Reactor]].insertions[interface.group].val = math.min(math.max(interface.insertion / 1000, 0), 1)
end

---@param reactor Reactor
function rods.update_reactor(reactor)
    reactor.fuels = {}
    reactor.dumps = {}
    if reactor.need_fuel > 0 and first(reactor.inputs) then
        rods.get_available_fuels(reactor)
    end
    if reactor.need_waste > 0 and first(reactor.outputs) then
        rods.get_available_dumps(reactor)
    end
    if reactor.group_controllers then
        for _, controller in pairs(reactor.controllers) do
            controller.insertion = controller.entity.get_signal(controller.gsig, defines.wire_connector_id.circuit_green)
            reactor.insertions[controller.group].val = math.min(math.max(controller.insertion / 1000, 0), 1)
        end
    end
    local fuel_rods = reactor.fuel_rods
    for _, rod in pairs(fuel_rods) do
        rods.update_fuel_rod(rod)
        if reactor.melting_down then
            break
        end
    end
    for _, control_rod in pairs(reactor.control_rods) do
        rods.update_control_rod(control_rod)
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
        elseif interface.output then
            reactor.outputs[interface.id] = interface
        end
        if interface.controller and interface.group then
            reactor.controllers[interface.id] = interface
            reactor.group_controllers = true
            Rods.set_interface_group(interface, interface.group)
        end
        reactor.interfaces[interface.id] = interface
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

---@param interface Interface
---@param group number?
function rods.set_interface_group(interface, group)
    local last_group_id = interface.group
    interface.group = group
    if interface.reactor then
        if group then
            local reactor = interface.reactor --[[@as Reactor]]
            reactor.group_controllers = true
            reactor.controllers[interface.id] = interface
            if last_group_id and reactor.insertions[last_group_id] then
                local last_group = reactor.insertions[last_group_id]
                last_group.owners[interface.id] = nil
                if not first(last_group.owners) then
                    reactor.insertions[last_group_id] = nil
                end
            end
            reactor.insertions[group] = interface.reactor.insertions[group] or {owners={}, val=0}
            reactor.insertions[group].owners[interface.id] = true
            reactor.add_iscore = math.max(table_size(reactor.controllers), 1) / 60
            reactor.ik = nil
            reactor.iscore = 0
        else
            interface.reactor.controllers[interface.id] = nil
            if not first(interface.reactor.controllers) then
                interface.reactor.group_controllers = false
            end
            if last_group_id and interface.reactor.insertions[last_group_id] then
                local last_group = interface.reactor.insertions[last_group_id]
                last_group.owners[interface.id] = nil
                if not first(last_group.owners) then
                    interface.reactor.insertions[last_group_id] = nil 
                end
            end
            interface.reactor.add_iscore = math.max(table_size(interface.reactor.controllers), 1) / 60
            interface.reactor.ik = nil
            interface.reactor.iscore = 0
        end
    end
end

---@param interface Interface
function rods.unset_interface_group(interface)
    interface.controller = false
    local reactor = interface.reactor
    local group = interface.group
    if reactor then
        reactor.controllers[interface.id] = nil
        if not first(reactor.controllers) then
            reactor.group_controllers = false
        end
        if group then
            local igroup = reactor.insertions[group]
            igroup.owners[interface.id] = nil
            if not first(igroup.owners) then
                reactor.insertions[group] = nil
            end
        end
    end
end

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
        have_spent = {},
        fuels = {},
        need_fuel = 0,
        need_waste = 0,
        dumps = {},
        controllers = {},
        group_controllers = false,
        insertions = {},
        interfaces = {},
        score = 0,
        add_score = 0,
        cscore = 0,
        add_cscore = 0,
        iscore = 0,
        add_iscore = 0,
    } --[[@as Reactor]]
    rods.add_connector_to_reactor[source.type](storage.connectors[source.connector.unit_number], reactor)
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
    local fuel_rods = table_size(reactor.fuel_rods)
    local control_rods = table_size(reactor.control_rods)
    reactor.add_score = math.max(fuel_rods, 1) / 60
    reactor.add_cscore = math.max(control_rods, 1) / 60
    reactor.add_iscore = math.max(table_size(reactor.controllers), 1) / 60
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
        value = value * (1-mod.conversion)
    end
    return (1 - value)
end

---@param p1 MapPosition
---@param p2 MapPosition
---@return number
local function distance_sqr(p1, p2)
    return (p1.x - p2.x)^2+(p1.y - p2.y)^2
end

---@param p1 MapPosition
---@param p2 MapPosition
---@return number
local function distance(p1,p2)
    return math.sqrt((p1.x - p2.x)^2+(p1.y - p2.y)^2)
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
        rod.affects = {}
        for i = 1, 4 do
            rod.affects[i] = {}
            local visited_control_rods = {}
            local visited_moderators = {}
            local affects = rod.affects[i]
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
                    if distance(owner.entity.position, rod.entity.position) <= owner.affectable_distance then
                        table.insert(affects, {affects=owner, control_rods=visited_control_rods, conversion=rods.get_moderation_from_moderators(visited_moderators)}--[[@as Affects]])
                        visited_control_rods = {}
                    end
                elseif owner.type == "control" then
                    ---@cast owner ControlRod
                    table.insert(visited_control_rods, owner)
                elseif owner.type == "mod" then
                    ---@cast owner Moderator
                    table.insert(visited_moderators, owner)
                elseif owner.type == "source" then
                    ---@cast owner Source
                    if distance_sqr(owner.entity.position, rod.entity.position) <= 1 then
                        rod.base_slow_flux = rod.base_slow_flux + owner.slow_flux
                        rod.base_fast_flux = rod.base_fast_flux + owner.fast_flux
                    end
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
    if rod.interface and rod.interface.valid then
        rod.interface.set_heat_setting{mode="add",temperature=0}
    end
    rod.slow_flux = 0
    rod.fast_flux = 0
    rod.cslow = 0
    rod.cfast = 0
    rod.in_slow_flux = 0
    rod.in_fast_flux = 0
    if rod.requested then
        rod.requested = false
        if rod.reactor then
            rod.reactor.need_fuel = rod.reactor.need_fuel - 1
        end
    end
    if rod.requested_waste then
        rod.requested_waste = false
        if rod.reactor then
            rod.reactor.need_waste = rod.reactor.need_waste - 1
        end
    end
    rods.clear_circuits(rod)
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
    for _, interface in pairs(reactor.interfaces) do
        interface.reactor = nil
    end
    for _, controller in pairs(reactor.controllers) do
        controller.reactor = nil
    end
    reactor.fuel_rods = {}
    reactor.control_rods = {}
    reactor.inputs = {}
    reactor.outputs = {}
    reactor.interfaces = {}
    reactor.controllers = {}
    reactor.group_controllers = false
    storage.reactors[reactor.id] = nil
end

---@param from FuelRod
---@param to Interface
function rods.on_paste_from_rod_to_interface(from, to)
    if not to.output then
        return
    end
    if not from.fuel then
        return
    end
    to.output_item = from.fuel.burnt_item
end

---@param from Interface
---@param to Interface
function rods.on_paste_interface(from, to)
    if from.output then
        if to.reactor then
            to.reactor.inputs[to.id] = nil
            to.reactor.outputs[to.id] = to
        end
        to.input = false
        to.output = true
    elseif from.input then
        if to.reactor then
            to.reactor.outputs[to.id] = nil
            to.reactor.inputs[to.id] = to
        end
        to.input = true
        to.output = false
    else
        to.input = false
        to.output = false
        if to.reactor then
            to.reactor.outputs[to.id] = nil
            to.reactor.inputs[to.id] = nil
        end
    end
end

---@param from Interface
---@param to ControlRod
function rods.on_paste_from_interface_to_control_rod(from, to)
    if from.group then
        to.useg = true
        to.group = from.group
    end
end

---@param from FuelRod
---@param to FuelRod
function rods.on_paste_rod(from, to)
    to.wants_fuel = from.wants_fuel
    to.wants_min = from.wants_min
    to.wants_max = from.wants_max
    local behaviour = to.entity.get_control_behavior() --[[@as LuaConstantCombinatorControlBehavior]]
    while behaviour.sections_count > 0 do
        behaviour.remove_section(1)
    end
    behaviour.add_section()
    local choose_signal_buttons = RodGUI.choose_signal_buttons
    local choose_signal_button_count = RodGUI.signal_button_count
    for i = 1, choose_signal_button_count do
        to[choose_signal_buttons[i][3]] = from[choose_signal_buttons[i][3]]
    end
    to.networked = from.networked
end

---@param from_ent LuaEntity
---@param to_ent LuaEntity
function rods.on_paste(from_ent, to_ent)
    -- TODO: FIX THIS
    local from_id = script.register_on_object_destroyed(from_ent)
    local to_id = script.register_on_object_destroyed(to_ent)
    local from = storage.rods[from_id] or storage.interfaces[from_id]
    local to = storage.rods[to_id] or storage.interfaces[to_id]
    if not from or not to then
        return
    end
    if from.type == "interface" and to.type == "interface" then
        rods.on_paste_from_rod_to_interface(from, to)
    elseif from.type == "interface" and to.type == "control" then
        rods.on_paste_from_interface_to_control_rod(from, to)
    elseif from.type == "fuel" and to.type == "interface" then
        rods.on_paste_interface(from, to)
    elseif from.type == "fuel" and to.type == "fuel" then
        rods.on_paste_rod(from, to)
    end
end

return rods