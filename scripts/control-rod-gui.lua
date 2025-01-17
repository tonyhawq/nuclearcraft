local rod_gui = {}

rod_gui.root = "nc-control-rod-frame"

---@param event EventData.on_gui_closed
---@param player LuaPlayer
function rod_gui.on_close(event, player)
    if event.entity then
        return
    end
    if not event.element or not event.element.valid or event.element.name ~= rod_gui.root then
        return
    end
    rod_gui.close(player)
end

---@param player LuaPlayer
function rod_gui.close(player)
    local gui = player.gui.screen[rod_gui.root]
    if gui then gui.destroy() end
end

---@param player LuaPlayer
---@param entity LuaEntity
function rod_gui.open(player, entity)
    if not entity or entity.name ~= "control-rod" then
        return
    end
    rod_gui.close(player)
    local gui = player.gui.screen
    local rod = storage.rods[script.register_on_object_destroyed(entity)]
    local container = gui.add{
        type = "frame",
        name=rod_gui.root,
        direction = "vertical",
        tags = {id = rod.id},
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
        name = "control-rod-gui-label",
        type = "label",
        style = "frame_title",
        caption = {"nuclearcraft.control-rod-gui-label"}
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
        name = "control_rod_gui_close",
        type = "sprite-button",
        style = "close_button",
    }
    close_button.style.horizontal_align = "right"
    close_button.sprite = "utility.close"
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
        style = "semibold_label",
        caption = {"nuclearcraft.insertion"},
    }
    inside_frame.add{
        type = "progressbar",
        name = "insertion",
        style = "production_progressbar"
    }
    local checkbox_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "checkbox_flow"
    }
    local checkbox_flow_widget = checkbox_flow.add{
        type = "empty-widget",
    }
    checkbox_flow_widget.style.horizontally_stretchable = true
    local checkbox_label = checkbox_flow.add{
        type = "label",
        caption = {"nuclearcraft.use-group-controller"}
    }
    checkbox_label.style.horizontal_align = "right"
    local checkbox = checkbox_flow.add{
        type = "checkbox",
        name = "use_group_controller",
        state = rod.useg,
    }
    checkbox.style.horizontal_align = "right"
    local checkbox_info = checkbox_flow.add{
        type = "sprite",
        sprite = "info",
        tooltip = {"nuclearcraft.use-group-controller-tooltip"}
    }
    local group_flow = inside_frame.add{
        type = "flow",
        direction = "vertical",
        name = "group_flow"
    }
    player.opened = container
    rod_gui.update(player)
end

function rod_gui.create_group_flow(root)
    if root.frame.group_flow.tags.exists then
        return
    end
    local rod = storage.rods[root.tags.id]--[[@as ControlRod]]
    root.frame.group_flow.tags = {exists = true}
    local group_flow = root.frame.group_flow
    local settings_flow = group_flow.add{
        type = "flow",
        direction = "horizontal",
        name = "settings_flow",
    }
    local filler_group_widget = settings_flow.add{
        type = "empty-widget",
        style = "draggable_space",
    }
    local group_label = settings_flow.add{
        type = "label",
        style = "semibold_label",
        caption = {"nuclearcraft.specify-group"}
    }
    filler_group_widget.style.horizontally_stretchable = true
    local textbox = settings_flow.add{
        type = "textfield",
        name = "control_group_selector_textbox",
        style = "slider_value_textfield",
        lose_focus_on_confirm = true,
    }
    textbox.text = tostring(rod.group)
    textbox.style.horizontal_align = "right"
    local confirm = settings_flow.add{
        type = "sprite-button",
        name = "control_group_confirm",
        style = "item_and_count_select_confirm",
        sprite = "utility.check_mark_dark_green"
    }
    confirm.style.horizontal_align = "right"
    local no_group_flow = group_flow.add{
        type = "flow",
        direction = "horizontal",
        name = "no_group_flow"
    }
end

function rod_gui.destroy_group_flow(root)
    root.frame.group_flow.clear()
    root.frame.group_flow.tags = {exists = false}
end

---@param player LuaPlayer
function rod_gui.update(player)
    local root = player.gui.screen[rod_gui.root] --[[@as LuaGuiElement]]
    if not root then
        return
    end
    if not root or not root.tags or not root.tags.id or not storage.rods[root.tags.id] then
        rod_gui.close(player)
        return
    end
    local rod = storage.rods[root.tags.id] --[[@as ControlRod]]
    local status = root.frame.status_flow
    if not rod.reactor then
        status.status_led.sprite = "utility.status_not_working"
        status.status_label.caption = {"nuclearcraft.no-reactor"}
        root.frame.insertion.value = 0
    else
        if rod.useg then
            if rod.group and Rods.group_id_exists(rod.reactor, rod.group) then
                status.status_led.sprite = "utility.status_working"
                status.status_label.caption = {"nuclearcraft.working"}
            else
                status.status_led.sprite = "utility.status_yellow"
                status.status_label.caption = {"nuclearcraft.no-group"}
            end
        else
            status.status_led.sprite = "utility.status_working"
            status.status_label.caption = {"nuclearcraft.working"}
        end
        root.frame.insertion.value = rod.insertion
    end
    if rod.useg then
        rod_gui.create_group_flow(root)
        if not rod.group or not Rods.group_id_exists(rod.reactor, rod.group) then
            if not root.frame.group_flow.no_group_flow.no_group_label then
                local widget = root.frame.group_flow.no_group_flow.add{
                    type = "empty-widget",
                    name = "no_group_label_widget"
                }
                widget.style.horizontally_stretchable = true
                local label = root.frame.group_flow.no_group_flow.add{
                    type = "label",
                    style = "bold_red_label",
                    name = "no_group_label",
                    caption = {"nuclearcraft.no-group"}
                }
                label.style.horizontal_align = "right"
            end
        else
            if root.frame.group_flow.no_group_flow.no_group_label then
                root.frame.group_flow.no_group_flow.no_group_label.destroy()
                root.frame.group_flow.no_group_flow.no_group_label_widget.destroy()
            end
        end
    else
        rod_gui.destroy_group_flow(root)
    end
end

---@param event EventData.on_gui_click
---@param player LuaPlayer
function rod_gui.player_clicked_gui(event, player)
    local root = player.gui.screen[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "control_rod_gui_close" then
        rod_gui.close(player)
        return
    elseif event.element.name == "use_group_controller" then
        local rod = storage.rods[root.tags.id]--[[@as ControlRod]]
        if event.element.state then
            rod.useg = true
            rod_gui.create_group_flow(root)
        else
            rod.useg = false
            rod_gui.destroy_group_flow(root)
        end
    elseif event.element.name == "control_group_confirm" then
        local rod = storage.rods[root.tags.id] --[[@as ControlRod]]
        local worked = rod_gui.confirm_text(root, root.frame.group_flow.settings_flow.control_group_selector_textbox, player)
        if not worked then
            return
        end
        if not Rods.group_id_exists(rod.reactor, root.frame.group_flow.settings_flow.tags.cached_groupid) then
        end
        rod.group = root.frame.group_flow.tags.cached_groupid
        rod_gui.update(player)
    end
end

---@param root LuaGuiElement
---@param element LuaGuiElement
---@param player LuaPlayer
---@return boolean
function rod_gui.confirm_text(root, element, player)
    local rod = storage.rods[root.tags.id] --[[@as ControlRod]]
    local num = tonumber(element.text)
    if not num then
        player.play_sound{path="utility/cannot_build"}
        player.create_local_flying_text{text={"nuclearcraft.not-a-number"}, create_at_cursor=true}
        root.frame.group_flow.settings_flow.control_group_selector_textbox.text = tostring(rod.group)
        return false
    end
    if math.floor(num) ~= math.ceil(num) then
        player.play_sound{path="utility/cannot_build"}
        player.create_local_flying_text{text={"nuclearcraft.no-decimals"}, create_at_cursor=true}
        root.frame.group_flow.settings_flow.control_group_selector_textbox.text = tostring(rod.group)
        return false
    end
    root.frame.group_flow.tags = {cached_groupid = num, exists = root.frame.group_flow.tags.exists}
    return true
end

---@param event EventData.on_gui_confirmed
---@param player LuaPlayer
function rod_gui.on_gui_confirmed(event, player)
    local root = player.gui.relative[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "control_group_selector_textbox" then
        rod_gui.confirm_text(root, event.element, player)
    end
end

return rod_gui