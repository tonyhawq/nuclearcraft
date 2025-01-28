NUCLEARCRAFT_ALLOWED_FUELS = NUCLEARCRAFT_ALLOWED_FUELS or {}

local fuel_rod = data.raw["constant-combinator"]["fuel-rod"]
local desc = {
    "",
    {"entity-description.fuel-rod"},
    "\n",
    {"nuclearcraft.accepted-fuels-label"}
}
local working = desc
for k, fuel in pairs(NUCLEARCRAFT_ALLOWED_FUELS) do
    local size = #working
    if size >= 20 then
        table.insert(working, {""})
        working = working[#working] --[[@as table]]
    end
    table.insert(working, "[item="..tostring(fuel).."]")
    if next(NUCLEARCRAFT_ALLOWED_FUELS, k) then
        table.insert(working, "\n")
    end
end

fuel_rod.localised_description = desc