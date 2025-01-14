local controller_gui = {}

controller_gui.root = "nc-reactor-controller"

---@param player LuaPlayer
function controller_gui.close(player)
    local gui = player.gui.screen[controller_gui.root]
    if gui then gui.destroy() end
end

---@param player LuaPlayer
---@param entity LuaEntity
function controller_gui.open(player, entity)
    if not entity or entity.name ~= "reactor-controller" then
        return
    end
    controller_gui.close(player)
    local gui = player.gui.screen
    local controller = storage.controllers[script.register_on_object_destroyed(entity)]
    local container = gui.add{
        type = "frame",
        name=controller_gui.root,
        direction = "vertical",
        tags = {id = controller.id},
        style = "inset_frame_container_frame",
    }
    container.auto_center = true
    local label_flow = container.add{
        name = "label-flow",
        type = "flow",
        direction = "horizontal",
    }
    label_flow.style.bottom_padding = 1
    label_flow.style.horizontally_stretchable = true
    label_flow.style.horizontal_spacing = 8
    local label = label_flow.add{
        name = "controller-gui-label",
        type = "label",
        style = "frame_title",
        caption = {"nuclearcraft.controller-gui-label"}
    }
    label.style.top_margin = -3
    label.style.bottom_padding = 3
    local widget = label_flow.add{
        type = "empty-widget",
        style = "draggable_space",
    }
    widget.drag_target = container
    widget.style.height = 24
    widget.style.horizontally_stretchable = true
    local close_button = label_flow.add{
        name = "controller_gui_close",
        type = "sprite-button",
        style = "close_button",
    }
    close_button.style.horizontal_align = "right"
    close_button.sprite = "utility.close"
    local inside_flow = container.add{
        type = "flow",
        direction = "horizontal",
        name = "flow",
    }
    local inside_frame = inside_flow.add{
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
    status_flow.style.horizontally_stretchable = true
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
    local group_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "group_flow",
    }
    local group_label = group_flow.add{
        type = "label",
        style = "semibold_label",
        caption = {"nuclearcraft.specify-group"}
    }
    local filler_group_widget = group_flow.add{
        type = "empty-widget",
        style = "draggable_space",
    }
    filler_group_widget.style.horizontally_stretchable = true
    local textbox = group_flow.add{
        type = "textfield",
        name = "group_selector_textbox",
        style = "slider_value_textfield",
        lose_focus_on_confirm = true,
    }
    textbox.style.horizontal_align = "right"
    local confirm = group_flow.add{
        type = "sprite-button",
        name = "group_confirm",
        style = "item_and_count_select_confirm",
        sprite = "utility.check_mark_dark_green"
    }
    confirm.style.horizontal_align = "right"
    inside_frame.add{
        type = "line",
    }
    local slots_frame = inside_frame.add{
        type = "frame",
        name = "slot_frame",
        style = "subheader_frame",
        direction = "vertical"
    }
    player.opened = container
    controller_gui.update(player)
end

---@param player LuaPlayer
function controller_gui.update(player)
    local root = player.gui.screen[controller_gui.root]
    if not root or not root.tags or not root.tags.id or not storage.controllers[root.tags.id] then
        return
    end
    local controller = storage.controllers[root.tags.id] --[[@as Controller]]
    local status_flow = root.flow.frame.status_flow
    if controller.reactor then
        if not controller.group then
            status_flow.status_led.sprite = "utility.status_not_working"
            status_flow.status_label.caption = {"nuclearcraft.no-group"}
        else
            status_flow.status_led.sprite = "utility.status_working"
            status_flow.status_label.caption = {"nuclearcraft.working"}
        end
    else
        status_flow.status_led.sprite = "utility.status_inactive"
        status_flow.status_label.caption = {"nuclearcraft.no-reactor"}
    end
end

---@param event EventData.on_gui_closed
---@param player LuaPlayer
function controller_gui.on_close(event, player)
    if event.entity then
        return
    end
    if not event.element or not event.element.valid or event.element.name ~= controller_gui.root then
        return
    end
    controller_gui.close(player)
end

---@param event EventData.on_gui_click
---@param player LuaPlayer
function controller_gui.player_clicked_gui(event, player)
    local root = player.gui.screen[controller_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "controller_gui_close" then
        controller_gui.close(player)
        return
    end
end

---@param event EventData.on_gui_confirmed
---@param player LuaPlayer
function controller_gui.on_gui_confirmed(event, player)
    local root = player.gui.screen[controller_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "group_selector_textbox" then
        if not tonumber(event.element.text) then
            return
        end
    end
end

return controller_gui