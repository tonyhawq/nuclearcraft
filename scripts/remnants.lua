local remnants = {}

function remnants.setup()
    storage.debris = storage.debris or {}
end

function remnants.update()
    for idx, debris in pairs(storage.debris) do
        ---@cast debris Debris
        debris.x = debris.x + debris.xv
        debris.y = debris.y + debris.yv
        debris.z = debris.z + debris.zv
        debris.rotation = debris.rotation + debris.rotation_speed
        debris.xv = debris.xv * 0.99
        debris.yv = debris.yv * 0.99
        debris.zv = debris.zv - 0.0102083333
        debris.rotation_speed = debris.rotation_speed * 0.99
        if debris.z < 0 then
            storage.debris[idx] = nil
            debris.render.destroy()
            if debris.landed_entity then
                debris.surface.create_entity{
                    name = debris.landed_entity,
                    position = {debris.x, debris.y},
                    force = debris.force,
                }
            end
        else
            debris.render.target = {x=debris.x, y=debris.y - debris.z}
            debris.render.orientation = debris.rotation
        end
    end
end

---@param sprite SpritePath
---@param x number
---@param y number
---@param xv number
---@param yv number
---@param zv number
---@param rot number
---@param rotv number
---@param landed_entity string?
---@param force LuaForce?
---@param surface LuaSurface
---@param other table?
function remnants.spawn(surface, sprite, x, y, xv, yv, zv, rot, rotv, landed_entity, force, other)
    if not other then
        other = {}
    end
    local render_object = rendering.draw_sprite{
        sprite = sprite,
        orientation = rot,
        target = {x=x,y=y},
        surface = surface,
        x_scale = other.x_scale,
        y_scale = other.y_scale,
    }
    local debris = {
        sprite = sprite,
        x = x,
        y = y,
        z = 1,
        xv = xv,
        yv = yv,
        zv = zv,
        rotation = rot,
        rotation_speed = rotv,
        landed_entity = landed_entity,
        force = force,
        ttl = 6000,
        render = render_object,
        surface = surface,
    } --[[@as Debris]]
    storage.debris[render_object.id] = debris
    return render_object.id
end

remnants.cap_remnants = {
    "rail-chain-signal-remnants",
    "wall-remnants",
    "lamp-remnants"
}

remnants.cap_remnants_count = 3

---@param entity LuaEntity
function remnants.on_cap_land(entity)
    local surface = entity.surface
    local position = entity.position
    surface.create_entity{
        name = remnants.cap_remnants[math.random(1, remnants.cap_remnants_count)],
        position = position,
    }
    surface.create_entity{
        name = "nuclear-smouldering-smoke-source",
        position = position,
    }
end

return remnants