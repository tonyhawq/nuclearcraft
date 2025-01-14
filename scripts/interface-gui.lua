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
    local switch_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "switch_flow",
    }
    switch_flow.add{
        type = "switch",
        name = "interface_mode",
        allow_none_state = true,
        left_label_caption = {"nuclearcraft.input-switch-state"},
        right_label_caption = {"nuclearcraft.output-switch-state"},
    }
    inside_frame.add{
        type = "line",
        style = "line",
    }
    local waste_flow = inside_frame.add{
        type = "flow",
        direction = "vertical",
        name = "waste_flow",
    }
    local circuit_flow = inside_frame.add{
        type = "flow",
        direction = "vertical",
        name = "circuit_flow"
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
    interface_gui.update(player)
end

---@param root LuaGuiElement
function interface_gui.destroy_waste_flow(root)
    root.frame.waste_flow.clear()
    root.frame.waste_flow.tags = {exists = false}
end

---@param root LuaGuiElement
function interface_gui.create_waste_flow(root)
    root.frame.waste_flow.tags = {exists = true}
    local flow = root.frame.waste_flow
    flow.add{
        type = "label",
        style = "semibold_label",
        caption = {"nuclearcraft.waste-filter"}
    }
    local waste_filter = flow.add{
        type = "choose-elem-button",
        name = "waste_filter_button",
        style = "slot_button",
        elem_type = "item",
    }
    local interface = storage.interfaces[root.tags.id] --[[@as Interface]]
    if interface.output_item then
        waste_filter.elem_value = interface.output_item
    end
end

---@param root LuaGuiElement
function interface_gui.create_circuit_flow(root)
    if root.frame.circuit_flow.tags and root.frame.circuit_flow.tags.exists then
        return
    end
    root.frame.circuit_flow.tags = {exists = true}
    local flow = root.frame.circuit_flow
    flow.add{
        type = "label",
        style = "semibold_label",
        caption = {"nuclearcraft.insertion-circuit"}
    }
    local button_flow = flow.add{
        type = "flow",
        direction = "horizontal",
        name = "buttons",
    }
    local circuit_filter = button_flow.add{
        type = "choose-elem-button",
        name = "circuit_filter_button",
        style = "slot_button",
        elem_type = "signal",
    }
    button_flow.add{
        type = "sprite",
        sprite = "info",
        tooltip = {"nuclearcraft.insertion-circuit-tooltip"}
    }
    local filler_group_widget = button_flow.add{
        type = "empty-widget",
        style = "draggable_space",
    }
    local group_label = button_flow.add{
        type = "label",
        style = "semibold_label",
        caption = {"nuclearcraft.specify-group"}
    }
    filler_group_widget.style.horizontally_stretchable = true
    local textbox = button_flow.add{
        type = "textfield",
        name = "group_selector_textbox",
        style = "slider_value_textfield",
        lose_focus_on_confirm = true,
    }
    textbox.style.horizontal_align = "right"
    local confirm = button_flow.add{
        type = "sprite-button",
        name = "group_confirm",
        style = "item_and_count_select_confirm",
        sprite = "utility.check_mark_dark_green"
    }
    confirm.style.horizontal_align = "right"
    local interface = storage.interfaces[root.tags.id] --[[@as Interface]]
    if not interface.group then
        interface.group = 0
    end
    textbox.text = tostring(interface.group)
    circuit_filter.elem_value = interface.gsig
end

---@param root LuaGuiElement
function interface_gui.destroy_circuit_flow(root)
    if not root.frame.circuit_flow.tags.exists then
        return
    end
    root.frame.circuit_flow.tags = {exists=false}
    root.frame.circuit_flow.destroy()
end

---@param player LuaPlayer
function interface_gui.update(player)
    local root = player.gui.relative[interface_gui.root] --[[@as LuaGuiElement]]
    if not root or not root.tags or not root.tags.id or not storage.interfaces[root.tags.id] then
        return
    end
    local waste_flow = root.frame.waste_flow
    local interface = storage.interfaces[root.tags.id] --[[@as Interface]]
    if interface.input then
        root.frame.switch_flow.interface_mode.switch_state = "left"
        if waste_flow.tags.exists then
            interface_gui.destroy_waste_flow(root)
        end
        if root.frame.switch_flow.is_group_controller then
            root.frame.switch_flow.is_group_controller.destroy()
            root.frame.switch_flow.group_controller_info.destroy()
            root.frame.switch_flow.widget.destroy()
            root.frame.switch_flow.label.destroy()
        end
    elseif interface.output then
        root.frame.switch_flow.interface_mode.switch_state = "right"
        if not waste_flow.tags.exists then
            interface_gui.create_waste_flow(root)
        end
        if root.frame.switch_flow.is_group_controller then
            root.frame.switch_flow.is_group_controller.destroy()
            root.frame.switch_flow.group_controller_info.destroy()
            root.frame.switch_flow.widget.destroy()
            root.frame.switch_flow.label.destroy()
        end
    else
        root.frame.switch_flow.interface_mode.switch_state = "none"
        if waste_flow.tags.exists then
            interface_gui.destroy_waste_flow(root)
        end
        if not root.frame.switch_flow.is_group_controller then
            root.frame.switch_flow.add{
                type = "empty-widget",
                style = "draggable_space",
                name = "widget",
            }.style.horizontally_stretchable = true
            root.frame.switch_flow.add{
                type = "label",
                name = "label",
                caption = "nuclearcraft.group-controller"
            }.style.horizontal_align = "right"
            root.frame.switch_flow.add{
                type = "checkbox",
                name = "is_group_controller",
                state = interface.group and true or false,
            }.style.horizontal_align = "right"
            root.frame.switch_flow.add{
                type = "sprite",
                sprite = "info",
                name = "group_controller_info",
                tooltip = {"nuclearcraft.group-controller-tooltip"}
            }.style.horizontal_align = "right"
        end
    end
    local status = root.frame.status_flow
    local reactor = interface.reactor
    if reactor then
        if interface.input then
            if reactor.need_fuel > 0 then
                status.status_led.sprite = "utility.status_working"
                status.status_label.caption = {"", {"nuclearcraft.working"}, " ("..tostring(reactor.need_fuel)..")"}
            else
                status.status_led.sprite = "utility.status_yellow"
                status.status_label.caption = {"nuclearcraft.waiting-for-fuel-request"}
            end
        elseif interface.output then
            if reactor.need_waste > 0 then
                status.status_led.sprite = "utility.status_working"
                status.status_label.caption = {"", {"nuclearcraft.working"}, " ("..tostring(reactor.need_waste)..")"}
            else
                status.status_led.sprite = "utility.status_yellow"
                status.status_label.caption = {"nuclearcraft.waiting-for-waste-request"}
            end
        else
            status.status_led.sprite = "utility.status_working"
            status.status_label.caption = {"nuclearcraft.working"}
        end
    else
        status.status_led.sprite = "utility.status_inactive"
        status.status_label.caption = {"nuclearcraft.no-reactor"}
    end
    if root.frame.circuit_flow.tags.exists then
        root.frame.circuit_flow.buttons.circuit_filter_button.elem_value = interface.gsig
    elseif root.frame.switch_flow.is_group_controller.state then
        interface_gui.create_circuit_flow(root)
    end
end

---@param event EventData.on_gui_switch_state_changed
---@param player any
function interface_gui.on_gui_switch_state_changed(event, player)
    local root = player.gui.relative[interface_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "interface_mode" then
        local interface = storage.interfaces[root.tags.id] --[[@as Interface]]
        if event.element.switch_state == "left" then
            interface.input = true
            interface.output = false
            if interface.reactor then
                interface.reactor.inputs[interface.id] = interface
                interface.reactor.outputs[interface.id] = nil
            end
            interface_gui.update(player)
        elseif event.element.switch_state == "right" then
            interface.input = false
            interface.output = true
            if interface.reactor then
                interface.reactor.inputs[interface.id] = nil
                interface.reactor.outputs[interface.id] = interface
            end
            interface_gui.update(player)
        elseif event.element.switch_state == "none" then
            interface.input = false
            interface.output = false
            if interface.reactor then
                interface.reactor.inputs[interface.id] = nil
                interface.reactor.outputs[interface.id] = nil
            end
            interface_gui.update(player)
        end
    end
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
        interface_gui.update(player)
    elseif event.element.name == "reactor-disassemble" then
        local reactor = storage.interfaces[root.tags.id]--[[@as Interface]].reactor
        if reactor then
            Rods.destroy_reactor(reactor)
        end
        interface_gui.update(player)
    elseif event.element.name == "is_group_controller" then
        local interface = storage.interfaces[root.tags.id]--[[@as Interface]]
        if event.element.state then
            interface_gui.create_circuit_flow(root)
            interface.controller = true
            Rods.set_interface_group(interface, interface.group or 0)
        else
            interface_gui.destroy_circuit_flow(root)
            Rods.unset_interface_group(interface)
        end
    end
end

---@param event EventData.on_gui_elem_changed
---@param player LuaPlayer
function interface_gui.player_changed_elem(event, player)
    local root = player.gui.relative[interface_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "waste_filter_button" then
        if not event.element.elem_value then
            storage.interfaces[root.tags.id]--[[@as Interface]].output_item = nil
            interface_gui.update(player)
            return
        end
        local item_name = event.element.elem_value --[[@as string]]
        if not Formula.burnt_items[item_name] then
            player.play_sound{path="utility/cannot_build"}
            player.create_local_flying_text{text={"nuclearcraft.not-a-waste"}, create_at_cursor=true}
            event.element.elem_value = nil
            interface_gui.update(player)
            return
        end
        local interface = storage.interfaces[root.tags.id]--[[@as Interface]]
        interface.output_item = event.element.elem_value --[[@as string]]
        interface_gui.update(player)
    elseif event.element.name == "circuit_filter_button" then
        local interface = storage.interfaces[root.tags.id] --[[@as Interface]]
        if not event.element.elem_value then
            interface.gsig = Rods.default_signal.gsig
            interface_gui.update(player)
            return
        end
        interface.gsig = event.element.elem_value --[[@as SignalID]]
        interface_gui.update(player)
    end
end

---@param root LuaGuiElement
---@param element LuaGuiElement
---@param player LuaPlayer
function interface_gui.confirm_text(root, element, player)
    local interface = storage.interfaces[root.tags.id] --[[@as Interface]]
    local num = tonumber(element.text)
    if not num then
        player.play_sound{path="utility/cannot_build"}
        player.create_local_flying_text{text={"nuclearcraft.not-a-number"}, create_at_cursor=true}
        root.frame.circuit_flow.buttons.group_selector_textbox.text = tostring(interface.group)
        return
    end
    if math.floor(num) ~= math.ceil(num) then
        player.play_sound{path="utility/cannot_build"}
        player.create_local_flying_text{text={"nuclearcraft.no-decimals"}, create_at_cursor=true}
        root.frame.circuit_flow.buttons.group_selector_textbox.text = tostring(interface.group)
        return
    end
    Rods.set_interface_group(interface, num)
end

---@param event EventData.on_gui_confirmed
---@param player LuaPlayer
function interface_gui.on_gui_confirmed(event, player)
    local root = player.gui.relative[interface_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "group_selector_textbox" then
        interface_gui.confirm_text(root, event.element, player)
    end
end

return interface_gui