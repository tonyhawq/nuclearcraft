local rod_gui = {}

rod_gui.root = "nc-fuel-rod-frame"

---@param player LuaPlayer
function rod_gui.close(player)
    local gui = player.gui.relative[rod_gui.root]
    if gui then gui.destroy() end
end

---@param player LuaPlayer
---@param entity LuaEntity
function rod_gui.open(player, entity)
    if not entity or entity.name ~= "fuel-rod" then
        return
    end
    rod_gui.close(player)
    local gui = player.gui.relative
    local anchor = {gui=defines.relative_gui_type.container_gui, position=defines.relative_gui_position.right}
    local container = gui.add{
        type = "frame",
        name=rod_gui.root,
        anchor = anchor,
        direction = "vertical",
        tags = {id = script.register_on_object_destroyed(entity)},
        style = "inset_frame_container_frame"
    }
    local label_flow = container.add{
        name = "label-flow",
        type = "flow",
        direction = "horizontal",
    }
    label_flow.style.bottom_padding = 4
    label_flow.style.horizontally_stretchable = true
    label_flow.style.horizontal_spacing = 8
    local label = label_flow.add{
        name = "fuel-rod-gui-label",
        type = "label",
        style = "frame_title",
        caption = {"nuclearcraft.fuel-rod-gui-label"}
    }
    label.style.top_margin = -3
    label.style.bottom_padding = 3
    local inside_frame = container.add{
        type = "frame",
        name = "inside_frame",
        style = "entity_frame",
    }
    local fuel_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
    }
    local choose_button = fuel_flow.add{
        name = "fuel_selection_button",
        type = "choose-elem-button",
        style = "slot_button",
        elem_type = "item"
    }
    local burning_fuel = fuel_flow.add{
        name = "burning_fuel",
        type = "sprite-button",
        sprite = "item.uranium-fuel-cell",
        style = "inventory_slot",
    }
    local fuel_remaining = fuel_flow.add{
        type = "progressbar",
        style = "production_progressbar",
        name = "fuel_remaining",
        caption = {"nuclearcraft.fuel-remaining"},
    }
    fuel_remaining.style.horizontally_stretchable = true
    fuel_remaining.style.height = 40
    local burnt_fuel = fuel_flow.add{
        name = "burnt_fuel",
        type = "sprite-button",
        sprite = "item.depleted-uranium-fuel-cell",
        style = "inventory_slot"
    }
end

---@param event EventData.on_gui_click
---@param player LuaPlayer
function rod_gui.player_clicked_gui(event, player)
    local root = player.gui.relative[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "see_affectors" then
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        rendering.clear("nuclearcraft")
        local offset = 0
        for _, affector in pairs(rod.affectors) do
            offset = offset + 1
            rendering.draw_line{from={rod.entity.position.x + offset / 32, rod.entity.position.y}, to=affector.fuel_rod.entity.position, surface=rod.entity.surface,color={0, 0, 255},width=1}
            local coffset = 0
            for _, control_rod in pairs(affector.control_rods) do
                coffset = coffset + 2
                rendering.draw_line{from={affector.fuel_rod.entity.position.x + coffset / 32, affector.fuel_rod.entity.position.y + coffset / 32}, to=control_rod.entity.position, surface=affector.fuel_rod.entity.surface, color={0, 255, 0}, width=1}
            end
        end
    end
end

return rod_gui