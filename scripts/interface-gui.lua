local interface_gui = {}

interface_gui.root = "nc-reactor-interface"

---@param player LuaPlayer
function interface_gui.close(player)
    local gui = player.gui.relative[interface_gui.root]
    if gui then gui.destroy() end
end

---@param player LuaPlayer
---@param entity LuaEntity
function interface_gui.open(player, entity)
    if not entity or entity.name ~= Rods.interface_name then
        return
    end
    interface_gui.close(player)
    local gui = player.gui.relative
    local anchor = {gui=defines.relative_gui_type.container_gui, position=defines.relative_gui_position.right}
    local container = gui.add{
        type = "frame",
        name=interface_gui.root,
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
        name = "interface-gui-label",
        type = "label",
        style = "frame_title",
        caption = {"nuclearcraft.interface-gui-label-output"}
    }
    label.style.top_margin = -3
    label.style.bottom_padding = 3
    local inside_frame = container.add{
        type = "frame",
        name = "frame",
        style = "entity_frame",
        direction = "vertical"
    }
    local status_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "status_flow",
    }
    status_flow.add{
        type = "sprite",
        name = "status_led",
        sprite = "utility.status_inactive"
    }
    status_flow.add{
        type = "label",
        name = "status_label",
        style = "label",
        caption = {"nuclearcraft.no-reactor"}
    }
    inside_frame.add{
        type = "label",
        name = "mode-switch-label",
        caption = {"nuclearcraft.interface-switch-label"},
        style = "semibold_label"
    }
    inside_frame.add{
        type = "switch",
        name = "mode",
        allow_none_state = true,
        left_label_caption = {"nuclearcraft.input-switch-state"},
        right_label_caption = {"nuclearcraft.output-switch-state"},
    }
    inside_frame.add{
        type = "line",
        style = "line",
    }
    local button_flow = inside_frame.add{
        type = "flow",
        name = "button_flow",
        direction = "horizontal",
    }
    button_flow.add{
        type = "button",
        name = "reactor-disassemble",
        style = "red_button",
        caption = {"nuclearcraft.reactor-disassemble"},
    }.style.horizontal_align = "left"
    button_flow.add{
        type = "button",
        name = "reactor-assemble",
        style = "green_button",
        caption = {"nuclearcraft.reactor-assemble"},
    }.style.horizontal_align = "right"
end

---@param event EventData.on_gui_click
---@param player LuaPlayer
function interface_gui.player_clicked_gui(event, player)
    local root = player.gui.relative[interface_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "reactor-assemble" then
        Rods.create_reactor(storage.interfaces[root.tags.id])
    elseif event.element.name == "reactor-disassemble" then
        local reactor = storage.interfaces[root.tags.id]--[[@as Interface]].reactor
        if reactor then
            Rods.destroy_reactor(reactor)
        end
    end
end

return interface_gui