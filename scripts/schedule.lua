local schedule = {}

function schedule.setup()
    storage.for_next_tick = storage.for_next_tick or {}
end

---@param func function
function schedule.for_next_tick(func)
    table.insert(storage.for_next_tick, func)
end

return schedule