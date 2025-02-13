local cooling = {}

cooling.smoke = "cooling-tower-smoke-source"

function cooling.setup()
    storage.coolers = storage.coolers or {}
end

---@param entity LuaEntity
function cooling.on_built(entity)
    if entity.name ~= "cooling-tower" then
        return
    end
    local id = script.register_on_object_destroyed(entity)
    local cooler = {
        id = id,
        entity = entity,
        smoke = nil,
    } --[[@as CoolingTower]]
    storage.coolers[id] = cooler
end

function cooling.update()
    local coolk, cooler = next(storage.coolers, storage.coolk)
    if not coolk then
        storage.coolk = nil
        return
    end
    ---@cast cooler CoolingTower
    storage.coolk = coolk
    local smoke = cooler.smoke --[[@as LuaEntity?]]
    local entity = cooler.entity --[[@as LuaEntity]]
    if not entity then
        return
    end
    if smoke and not smoke.valid then
        cooler.smoke = nil
    end
    if smoke then
        if not entity.is_crafting() then
            smoke.destroy()
            cooler.smoke = nil
        end
    else
        if entity.is_crafting() then
            cooler.smoke = entity.surface.create_entity{name=cooling.smoke, position={entity.position.x, entity.position.y - 2}}
        end
    end
end

---@param event EventData.on_object_destroyed
function cooling.on_destroyed(event)
    local id = event.registration_number
    if storage.coolers[id] then
        local cooler = storage.coolers[id]
        if cooler.smoke and cooler.smoke.valid then
            cooler.smoke.destroy()
        end
        storage.coolers[id] = nil
    end
end

return cooling