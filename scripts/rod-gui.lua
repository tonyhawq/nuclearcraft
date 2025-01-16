local rod_gui = {}

rod_gui.root = "nc-fuel-rod-frame"
rod_gui.bar_width = 300
rod_gui.bar_min_legible_width = 50
rod_gui.bar_min_width = 20

rod_gui.choose_signal_buttons = {
    {"choose_signal_temperature", {"nuclearcraft.tooltip-temperature"}, "tsig"},
    {"choose_signal_power", {"nuclearcraft.tooltip-power"}, "psig"},
    {"choose_signal_efficiency", {"nuclearcraft.tooltip-efficiency"}, "esig"},
    {"choose_signal_fuel", {"nuclearcraft.tooltip-fuel"}, "fsig"},
    {"choose_signal_slow_flux", {"nuclearcraft.tooltip-slow"}, "sfsig"},
    {"choose_signal_fast_flux", {"nuclearcraft.tooltip-fast"}, "ffsig"},
    {"choose_signal_delta_flux", {"nuclearcraft.tooltip-delta"}, "dfsig"},
}

rod_gui.signal_button_count = #rod_gui.choose_signal_buttons

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
    if not entity or entity.name ~= "fuel-rod" then
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
        name = "fuel-rod-gui-label",
        type = "label",
        style = "frame_title",
        caption = {"nuclearcraft.fuel-rod-gui-label"}
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
        name = "fuel_rod_gui_close",
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
    local circuit_frame = inside_flow.add{
        type = "frame",
        name = "circuit_frame",
        style = "entity_frame",
        direction = "vertical",
    }
    local circuit_status_flow = circuit_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "status_flow",
    }
    circuit_status_flow.add{
        type = "sprite",
        name = "status_led",
        sprite = "utility.status_inactive"
    }
    circuit_status_flow.add{
        type = "label",
        name = "status_label",
        style = "label",
        caption = {"nuclearcraft.circuit-network-disabled"}
    }
    circuit_frame.add{
        type = "label",
        name = "circuit_network_label",
        style = "semibold_label",
        caption = {"nuclearcraft.enable-circuit-network"},
    }
    circuit_frame.add{
        type = "switch",
        name = "rod_gui_circuit_network_switch",
        switch_state = "left",
        left_label_caption = {"gui.off"},
        right_label_caption = {"gui.on"},
    }
    circuit_frame.add{
        type = "line",
        style = "line",
    }
    circuit_frame.add{
        type = "label",
        style = "semibold_label",
        caption = {"nuclearcraft.select-circuits"}
    }
    local slot_frame = circuit_frame.add{
        type = "frame",
        name = "slot_frame",
        style = "subheader_frame",
        direction = "vertical"
    }
    slot_frame.style.height = 90
    local slot_flow = slot_frame.add{
        type = "flow",
        name = "slot_flow",
        direction = "horizontal",
    }
    slot_flow.style.horizontal_spacing = 1
    local spacer = slot_flow.add{
        type = "empty-widget",
    }
    spacer.style.horizontally_stretchable = true
    spacer.style.natural_width = 0
    for i = 1, rod_gui.signal_button_count do
        local button = slot_flow.add{
            type = "choose-elem-button",
            style = "slot_button",
            elem_type = "signal",
            name = rod_gui.choose_signal_buttons[i][1],
            tooltip = rod_gui.choose_signal_buttons[i][2],
            
        }
        button.elem_value = rod[rod_gui.choose_signal_buttons[i][3]] --[[@as SignalID]]
        local info = slot_flow.add{
            type = "sprite",
            sprite = "info",
            name = rod_gui.choose_signal_buttons[i][1].."-info",
            tooltip = rod_gui.choose_signal_buttons[i][2]
        }
    end
    local spacer2 = slot_flow.add{
        type = "empty-widget",
    }
    spacer2.style.horizontally_stretchable = true
    spacer2.style.natural_width = 0
    slot_frame.add{
        type = "line",
        style = "line"
    }
    local circuit_confirm = slot_frame.add{
        type = "button",
        name = "reset_circuit_filters",
        style = "red_button",
        caption = {"nuclearcraft.reset-circuits"}
    }
    circuit_confirm.style.horizontally_stretchable = true
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
    local fuel_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "fuel",
    }
    local choose_button = fuel_flow.add{
        name = "fuel_selection",
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
    burning_fuel.enabled = true
    burning_fuel.number = 0
    local fuel_remaining = fuel_flow.add{
        type = "progressbar",
        style = "production_progressbar",
        name = "fuel_remaining",
        caption = {"nuclearcraft.fuel-remaining"},
    }
    fuel_remaining.style.horizontally_stretchable = true
    fuel_remaining.style.color = {1, 0.1, 0.1}
    local burnt_fuel = fuel_flow.add{
        name = "burnt_fuel",
        type = "sprite-button",
        sprite = "item.depleted-uranium-fuel-cell",
        style = "inventory_slot"
    }
    burnt_fuel.number = 0
    burnt_fuel.enabled = true
    local min_slider_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "minimum_slider_flow",
    }
    local max_slider_flow = inside_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "maximum_slider_flow",
    }
    inside_frame.add{
        type = "line",
        style = "line",
    }
    local power = inside_frame.add{
        type = "progressbar",
        name = "power",
        style = "production_progressbar",
        caption = {"nuclearcraft.power-production"}
    }
    local fuel_burnup = inside_frame.add{
        type = "progressbar",
        name = "burnup",
        style = "production_progressbar",
        caption = {"nuclearcraft.burnup"}
    }
    local temp = inside_frame.add{
        type = "progressbar",
        name = "temperature",
        style = "production_progressbar",
        caption = {"nuclearcraft.temperature"}
    }
    temp.style.horizontally_stretchable = true
    power.style.horizontally_stretchable = true
    fuel_burnup.style.horizontally_stretchable = true
    inside_frame.add{
        type = "line",
        style = "line",
    }
    inside_frame.add{
        type = "label",
        name = "flux-output-label",
        style = "bold_label",
        caption = {"nuclearcraft.flux-output"},
    }
    local out_frame = inside_frame.add{
        type = "flow",
        direction = "vertical",
        name = "flux_output",
    }
    out_frame.style.vertical_spacing = 0
    local out_total = out_frame.add{
        type = "progressbar",
        name = "total_flux",
        style = "production_progressbar",
        caption = {"nuclearcraft.number-unit", 0, "Nf"}
    }
    out_total.style.width = rod_gui.bar_width
    local out_fast_slow_frame = out_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "fast_slow",
    }
    out_fast_slow_frame.style.horizontal_spacing = 0
    local fast_out = out_fast_slow_frame.add{
        name = "fast",
        type = "progressbar",
        style = "production_progressbar",
        caption = "0%",
    }
    fast_out.style.font = "default-bold"
    fast_out.tooltip = {"nuclearcraft.fast-flux"}
    local slow_out = out_fast_slow_frame.add{
        name = "slow",
        type = "progressbar",
        style = "production_progressbar",
        caption = "0%",
    }
    slow_out.style.font = "default-bold"
    slow_out.tooltip = {"nuclearcraft.slow-flux"}
    inside_frame.add{
        type = "line",
        style = "line",
    }
    inside_frame.add{
        type = "label",
        name = "flux-input-label",
        style = "bold_label",
        caption = {"nuclearcraft.flux-input"},
    }
    local in_frame = inside_frame.add{
        type = "flow",
        direction = "vertical",
        name = "flux_input",
    }
    in_frame.style.vertical_spacing = 0
    local in_total = in_frame.add{
        type = "progressbar",
        name = "total_flux",
        style = "production_progressbar",
        caption = {"nuclearcraft.number-unit", 0, "Nf"}
    }
    in_total.style.width = rod_gui.bar_width
    local in_fast_slow_frame = in_frame.add{
        type = "flow",
        direction = "horizontal",
        name = "fast_slow",
    }
    in_fast_slow_frame.style.horizontal_spacing = 0
    local fast_in = in_fast_slow_frame.add{
        name = "fast",
        type = "progressbar",
        style = "production_progressbar",
        caption = "0%",
    }
    fast_in.style.font = "default-bold"
    fast_in.tooltip = {"nuclearcraft.fast-flux"}
    local slow_in = in_fast_slow_frame.add{
        name = "slow",
        type = "progressbar",
        style = "production_progressbar",
        caption = "0%",
    }
    slow_in.style.font = "default-bold"
    slow_in.tooltip = {"nuclearcraft.slow-flux"}
    inside_frame.add{
        type = "line",
        style = "line",
    }
    inside_frame.add{
        type = "label",
        name = "efficiency-label",
        style = "bold_label",
        caption = {"nuclearcraft.efficiency"},
    }
    local efficiency = inside_frame.add{
        name = "efficiency",
        type = "progressbar",
        style = "production_progressbar",
        caption = {"nuclearcraft.efficiency"},
    }
    inside_frame.add{
        type = "label",
        name = "penalty-label",
        style = "bold_label",
        caption = {"nuclearcraft.efficiency-penalty"},
    }
    local penalty = inside_frame.add{
        name = "efficiency_penalty",
        type = "progressbar",
        style = "production_progressbar",
        caption = {"nuclearcraft.efficiency-penalty"},
    }
    efficiency.style.horizontally_stretchable = true
    penalty.style.horizontally_stretchable = true
    inside_frame.add{
        type = "button",
        name = "see_affectors",
        style = "button",
        caption = {"nuclearcraft.see-affectors"}
    }
    inside_frame.add{
        type = "button",
        name = "visualize_flux",
        style = "button",
        caption = {"nuclearcraft.visualize-flux"}
    }
    container.flow.frame["minimum_slider_flow"].tags = {value = storage.rods[container.tags.id].wants_min or 0}
    container.flow.frame["maximum_slider_flow"].tags = {value = storage.rods[container.tags.id].wants_max or 0}
    rod_gui.create_slider_flow("min", container, 0, 5, container.flow.frame.maximum_slider_flow.tags.value --[[@as number]])
    rod_gui.create_slider_flow("max", container, container.flow.frame.minimum_slider_flow.tags.value --[[@as number]], math.max(container.flow.frame.minimum_slider_flow.tags.value + 2 --[[@as number]], 5), container.flow.frame.minimum_slider_flow.tags.value --[[@as number]])
    rod_gui.update_slider_textboxes(container)
    player.opened = container
    rod_gui.update(player)
end

---@param event EventData.on_gui_elem_changed
---@param player LuaPlayer
function rod_gui.player_changed_elem(event, player)
    local root = player.gui.screen[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    local names_to_values = {
        choose_signal_temperature = "tsig",
        choose_signal_power = "psig",
        choose_signal_efficiency = "esig",
        choose_signal_fuel = "fsig",
        choose_signal_fast_flux = "ffsig",
        choose_signal_slow_flux = "sfsig",
        choose_signal_delta_flux = "dfsig",
    }
    if event.element.name == "fuel_selection" then
        if not event.element.elem_value then
            storage.rods[root.tags.id]--[[@as FuelRod]].wants_fuel = nil
            return
        end
        local item_name = event.element.elem_value --[[@as string]]
        if not Formula.fuels[item_name] then
            player.play_sound{path="utility/cannot_build"}
            player.create_local_flying_text{text={"nuclearcraft.not-a-fuel"}, create_at_cursor=true}
            event.element.elem_value = nil
            rod_gui.update(player)
            return
        end
        local rod = storage.rods[root.tags.id]--[[@as FuelRod]]
        Rods.set_fuel_request(rod, item_name)
        rod_gui.update(player)
    elseif names_to_values[event.element.name] then
        local rod = storage.rods[root.tags.id]--[[@as FuelRod]]
        if event.element.elem_value == nil then
            if rod_gui.signal_present(rod, Rods.default_signal[names_to_values[event.element.name]]) then
                event.element.elem_value = rod[names_to_values[event.element.name]]
                player.play_sound{path="utility/cannot_build"}
                player.create_local_flying_text{text={"nuclearcraft.cannot-reset-signal-present"}, create_at_cursor=true}
                return
            end
            event.element.elem_value = Rods.default_signal[names_to_values[event.element.name]]
        end
        if rod_gui.signal_present(rod, event.element.elem_value --[[@as SignalID]]) then
            event.element.elem_value = rod[names_to_values[event.element.name]]
            player.play_sound{path="utility/cannot_build"}
            player.create_local_flying_text{text={"nuclearcraft.signal-present"}, create_at_cursor=true}
            return
        end
        Rods.set_signal(rod, names_to_values[event.element.name], event.element.elem_value--[[@as SignalID]])
        rod_gui.update(player)
    end
end

---@param as "min"|"max"
---@param root LuaGuiElement
---@param minimum number
---@param maximum number
---@param value number?
---@param step_size number?
function rod_gui.create_slider_flow(as, root, minimum, maximum, value, step_size)
    root.flow.frame[as.."imum_slider_flow"].add{
        type = "label",
        name = "slider-"..as.."-label",
        style = "semibold_label",
        caption = {"nuclearcraft."..as},
    }
    root.flow.frame[as.."imum_slider_flow"].add{
        type = "slider",
        name = as.."imum_fuel_request_slider",
        minimum_value = minimum,
        maximum_value = maximum,
        value = value,
        value_step = step_size,
    }
    root.flow.frame[as.."imum_slider_flow"].add{
        type = "textfield",
        name = as.."imum_fuel_request_slider_textbox",
        style = "slider_value_textfield",
        lose_focus_on_confirm = true,
    }
    if as == "max" then
        root.flow.frame[as.."imum_slider_flow"].add{            
            type = "button",
            name = "set_fuel_sliders_button",
            style = "green_button",
            caption = {"nuclearcraft.confirm"},
        }
    else
        root.flow.frame[as.."imum_slider_flow"].add{
            type = "button",
            name = "reset_sliders_button",
            caption = {"nuclearcraft.reset-sliders"},
        }
    end
end

function rod_gui.update_slider_textboxes(root)
    root.flow.frame.minimum_slider_flow.minimum_fuel_request_slider_textbox.text = tostring(root.flow.frame.minimum_slider_flow.tags.value)
    root.flow.frame.maximum_slider_flow.maximum_fuel_request_slider_textbox.text = tostring(root.flow.frame.maximum_slider_flow.tags.value)
end

function rod_gui.update_minimum_slider(root)
    local value = root.flow.frame.minimum_slider_flow.tags.value
    local max_slider = root.flow.frame.maximum_slider_flow.maximum_fuel_request_slider --[[@as LuaGuiElement]]
    if value >= max_slider.get_slider_minimum() then
        local max_value = max_slider.get_slider_maximum()
        if value >= (max_value - 1) then
            max_value = value + 2
        end
        local tag_value = root.flow.frame.maximum_slider_flow.tags.value
        if value > root.flow.frame.maximum_slider_flow.tags.value then
            tag_value = value
        end
        root.flow.frame.maximum_slider_flow.clear()
        rod_gui.create_slider_flow("max", root, value, max_value, tag_value)
        root.flow.frame.maximum_slider_flow.tags = {value=tag_value}
    elseif value < max_slider.get_slider_minimum() then
        if value > 0 then
            local max_slider_slider_value = root.flow.frame.maximum_slider_flow.tags.value
            local max_slider_slider_maximum = max_slider.get_slider_maximum()
            root.flow.frame.maximum_slider_flow.clear()
            rod_gui.create_slider_flow("max", root, value, max_slider_slider_maximum, max_slider_slider_value)
        end
    end
end

---@param event EventData.on_gui_value_changed
---@param player LuaPlayer
function rod_gui.value_changed(event, player)
    local root = player.gui.screen[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "minimum_fuel_request_slider" then
        root.flow.frame.minimum_slider_flow.tags = {value=event.element.slider_value}
        rod_gui.update_minimum_slider(root)
        rod_gui.update_slider_textboxes(root)
    elseif event.element.name == "maximum_fuel_request_slider" then
        root.flow.frame.maximum_slider_flow.tags = {value=event.element.slider_value}
        rod_gui.update_slider_textboxes(root)
    end
end

---@param event EventData.on_gui_confirmed
---@param player LuaPlayer
function rod_gui.on_gui_confirmed(event, player)
    local root = player.gui.screen[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "minimum_fuel_request_slider_textbox" then
        if not tonumber(event.element.text) then
            return
        end
        local num = math.floor(tonumber(event.element.text) --[[@as number]])
        local min_slider = root.flow.frame.minimum_slider_flow.minimum_fuel_request_slider --[[@as LuaGuiElement]]
        local min_slider_min = min_slider.get_slider_minimum()
        local min_slider_max = min_slider.get_slider_maximum()
        root.flow.frame.minimum_slider_flow.tags = {value=math.max(num, 0)}
        if num > min_slider.get_slider_maximum() then
            rod_gui.update_minimum_slider(root)
            root.flow.frame.minimum_slider_flow.clear()
            rod_gui.create_slider_flow("min", root, 0, min_slider_max, min_slider_max)
            rod_gui.update_slider_textboxes(root)
        elseif num < 0 then
            num = 0
            min_slider.slider_value = 0
            rod_gui.update_minimum_slider(root)
            root.flow.frame.minimum_slider_flow.clear()
            rod_gui.create_slider_flow("min", root, 0, 5, 0)
        else
            min_slider.slider_value = num
            local min_min = min_slider.get_slider_minimum()
            local min_max = min_slider.get_slider_maximum()
            rod_gui.update_minimum_slider(root)
            root.flow.frame.minimum_slider_flow.clear()
            rod_gui.create_slider_flow("min", root, min_min, min_max, num)
            rod_gui.update_slider_textboxes(root)
        end
    elseif event.element.name == "maximum_fuel_request_slider_textbox" then
        if not tonumber(event.element.text) then
            return
        end
        local num = math.max(math.floor(tonumber(event.element.text) --[[@as number]]), 0)
        local max_slider = root.flow.frame.maximum_slider_flow.maximum_fuel_request_slider --[[@as LuaGuiElement]]
        local max_slider_min = max_slider.get_slider_minimum()
        local max_slider_max = max_slider.get_slider_maximum()
        if num > max_slider.get_slider_maximum() then
            root.flow.frame.maximum_slider_flow.clear()
            root.flow.frame.maximum_slider_flow.tags = {value=num}
            rod_gui.create_slider_flow("max", root, max_slider_min, num, num)
            rod_gui.update_slider_textboxes(root)
        elseif num < max_slider.get_slider_minimum() then
            root.flow.frame.maximum_slider_flow.clear()
            root.flow.frame.maximum_slider_flow.tags = {value=max_slider_min}
            rod_gui.create_slider_flow("max", root, max_slider_min, max_slider_max, max_slider_min)
            rod_gui.update_slider_textboxes(root)
        else
            root.flow.frame.maximum_slider_flow.clear()
            root.flow.frame.maximum_slider_flow.tags = {value=num}
            rod_gui.create_slider_flow("max", root, max_slider_min, max_slider_max, num)
            rod_gui.update_slider_textboxes(root)
        end
    end
end

---@param event EventData.on_gui_click
---@param player LuaPlayer
function rod_gui.player_clicked_gui(event, player)
    local root = player.gui.screen[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "see_affectors" then
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        rendering.clear("nuclearcraft")
        local offset = 0
        for _, affector in pairs(rod.affectors) do
            offset = offset + 1
            rendering.draw_line{from={rod.entity.position.x + offset / 32, rod.entity.position.y}, to=affector.affector.entity.position, surface=rod.entity.surface,color={0, 0, 255},width=1}
            local coffset = 0
            for _, control_rod in pairs(affector.control_rods) do
                coffset = coffset + 2
                rendering.draw_line{from={affector.affector.entity.position.x + coffset / 32, affector.affector.entity.position.y + coffset / 32}, to=control_rod.entity.position, surface=affector.affector.entity.surface, color={0, 255, 0}, width=1}
            end
        end
    elseif event.element.name == "reset_circuit_filters" then
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        local slot_flow = root.flow.circuit_frame.slot_frame.slot_flow
        for i = 1, rod_gui.signal_button_count do
            local name = rod_gui.choose_signal_buttons[i][1]
            slot_flow[name].elem_value = Rods.default_signal[rod_gui.choose_signal_buttons[i][3]]
            Rods.set_signal(rod, rod_gui.choose_signal_buttons[i][3], slot_flow[name].elem_value)
        end
    elseif event.element.name == "visualize_flux" then
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        local reactor = rod.reactor
        if not reactor then
            player.print("Rod must have reactor.")
            return
        end
        reactor.visualize = true
    elseif event.element.name == "set_fuel_sliders_button" then
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        Rods.set_fuel_request(rod, rod.wants_fuel, root.flow.frame.minimum_slider_flow.tags.value, root.flow.frame.maximum_slider_flow.tags.value)
        rod_gui.update(player)
    elseif event.element.name == "reset_sliders_button" then
        root.flow.frame.minimum_slider_flow.clear()
        root.flow.frame.maximum_slider_flow.clear()
        root.flow.frame.minimum_slider_flow.tags = {value=0}
        root.flow.frame.maximum_slider_flow.tags = {value=0}
        rod_gui.create_slider_flow("min", root, 0, 5, 0)
        rod_gui.create_slider_flow("max", root, 0, 5, 0)
        rod_gui.update_slider_textboxes(root)
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        Rods.set_fuel_request(rod, rod.wants_fuel, 0, 0)
        rod_gui.update(player)
    elseif event.element.name == "burning_fuel" then
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        local fuel = rod.fuel
        if not fuel then
            if not player.is_cursor_empty() then
                local cursor_stack = player.cursor_stack
                if cursor_stack and cursor_stack.name and cursor_stack.name == rod.wants_fuel then
                    local memo = Formula.fuels[rod.wants_fuel]
                    rod.fuel = {
                        item = rod.wants_fuel,
                        burnt_item = memo.burnt_item,
                        character_name = memo.character_name,
                        fuel_remaining = memo.fuel_remaining,
                        total_fuel = memo.total_fuel,
                        buffered = cursor_stack.count - 1,
                        buffered_out = 0,
                    }
                    cursor_stack.clear()
                    rod_gui.update(player)
                end
            end
            return
        end
        if not player.is_cursor_empty() then
            local cursor_stack = player.cursor_stack
            if cursor_stack and cursor_stack.name and cursor_stack.name == fuel.item then
                fuel.buffered = fuel.buffered + cursor_stack.count
                player.cursor_stack.clear()
                rod_gui.update(player)
            end
            return
        end
        if fuel.buffered == 0 then
            return
        end
        local item_prototype = prototypes.item[fuel.item]
        local to_remove = math.min(item_prototype.stack_size, fuel.buffered)
        if to_remove == 0 then
            return
        end
        player.cursor_stack.set_stack{name=fuel.item, count=to_remove}
        fuel.buffered = fuel.buffered - to_remove
        rod_gui.update(player)
    elseif event.element.name == "fuel_rod_gui_close" then
        rod_gui.close(player)
        return
    end
end

---@param value number
---@param postfix "W"|"J"?
---@return number, string
local function select_unit(value, postfix)
    if value > 1000000000 then
        return value / 1000000000, "G"..(postfix or "W")
    elseif value > 1000000 then
        return value / 1000000, "M"..(postfix or "W")
    elseif value > 1000 then
        return value / 1000, "k"..(postfix or "W")
    else
        return value, (postfix or "W")
    end
end

---@param player LuaPlayer
function rod_gui.update(player)
    local root = player.gui.screen[rod_gui.root] --[[@as LuaGuiElement]]
    if not root or not root.tags or not root.tags.id or not storage.rods[root.tags.id] then
        rod_gui.close(player)
        return
    end
    local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
    local status = root.flow.frame.status_flow
    local fuel = rod.fuel
    local circuit_frame = root.flow.circuit_frame
    local circuit_status_flow = circuit_frame.status_flow
    local slot_flow = circuit_frame.slot_frame.slot_flow
    if rod.networked then
        circuit_frame.rod_gui_circuit_network_switch.switch_state = "right"
        if not slot_flow[rod_gui.choose_signal_buttons[1][1]].enabled then
            for i = 1, rod_gui.signal_button_count do
                slot_flow[rod_gui.choose_signal_buttons[i][1]].enabled = true
            end
        end
        if rod.reactor then
            circuit_status_flow.status_led.sprite = "utility.status_working"
            circuit_status_flow.status_label.caption = {"nuclearcraft.working"}
        else
            circuit_status_flow.status_led.sprite = "utility.status_yellow"
            circuit_status_flow.status_label.caption = {"nuclearcraft.no-reactor"}
        end
    else
        circuit_status_flow.status_led.sprite = "utility.status_inactive"
        circuit_status_flow.status_label.caption = {"nuclearcraft.circuit-network-disabled"}
        circuit_frame.rod_gui_circuit_network_switch.switch_state = "left"
        if slot_flow[rod_gui.choose_signal_buttons[1][1]].enabled then
            for i = 1, rod_gui.signal_button_count do
                slot_flow[rod_gui.choose_signal_buttons[i][1]].enabled = false
            end
        end
    end
    local fuel_flow = root.flow.frame.fuel
    local character
    local inside_frame = root.flow.frame
    local temperature_bar = root.flow.frame.temperature
    local temperature = rod.interface.temperature --[[@as number]]
    temperature_bar.value = temperature / Rods.meltdown_temperature
    temperature_bar.caption = {"nuclearcraft.number-unit", tostring(math.ceil(temperature)),"c"}
    if fuel then
        status.status_led.sprite = "utility.status_working"
        status.status_label.caption = {"nuclearcraft.working"}
        fuel_flow.fuel_remaining.value = fuel.fuel_remaining / fuel.total_fuel
        local fuel_number, fuel_unit = select_unit(fuel.fuel_remaining * 1000000, "J")
        fuel_flow.fuel_remaining.caption = {"nuclearcraft.number-unit", string.format("%.1f", fuel_number), fuel_unit}
        character = Formula.characteristics[fuel.character_name]
        fuel_flow.burning_fuel.sprite = "item."..fuel.item
        fuel_flow.burnt_fuel.sprite = "item."..fuel.burnt_item
        fuel_flow.burning_fuel.number = fuel.buffered
        fuel_flow.burnt_fuel.number = fuel.buffered_out
        inside_frame.efficiency.value = rod.efficiency / character.max_efficiency
        inside_frame.efficiency_penalty.value = 1
        if not rod.wants_fuel then
            fuel_flow.fuel_selection.elem_value = nil
        else
            fuel_flow.fuel_selection.elem_value = rod.wants_fuel
        end
    else
        if rod.wants_fuel then
            inside_frame.efficiency.value = 0
            inside_frame.efficiency_penalty.value = 1 - rod.base_efficiency
            status.status_led.sprite = "utility.status_not_working"
            if rod.wants_min == 0 then
                fuel_flow.fuel_remaining.caption = {"nuclearcraft.no-fuel-requested"}
                status.status_label.caption = {"nuclearcraft.no-fuel-requested"}
            else
                fuel_flow.fuel_remaining.caption = {"nuclearcraft.no-fuel"}
                status.status_label.caption = {"nuclearcraft.no-fuel"}    
            end
            fuel_flow.burning_fuel.sprite = "item."..rod.wants_fuel
            fuel_flow.burnt_fuel.sprite = nil
            fuel_flow.fuel_selection.elem_value = rod.wants_fuel
            character = Formula.characteristics[Formula.fuels[rod.wants_fuel].character_name]
        else
            inside_frame.efficiency.value = 0
            inside_frame.efficiency_penalty.value = 1 - rod.base_efficiency
            status.status_led.sprite = "utility.status_not_working"
            status.status_label.caption = {"nuclearcraft.no-fuel-selected"}
            fuel_flow.burning_fuel.sprite = nil
            fuel_flow.burnt_fuel.sprite = nil
            fuel_flow.fuel_selection.elem_value = nil
        end
    end
    inside_frame.efficiency.caption = string.format("%.0f%%", rod.efficiency * 100)
    inside_frame.efficiency_penalty.caption = string.format("%.0f%%", inside_frame.efficiency_penalty.value * 100)
    local flux_percentage_in = 1
    local flux_percentage_out = 1
    if character then
        local target_fast = character.target_fast_flux(rod.in_slow_flux, rod.in_fast_flux, rod.temperature)
        local target_slow = character.target_slow_flux(rod.in_slow_flux, rod.in_fast_flux, rod.temperature) 
        flux_percentage_in = ((rod.in_slow_flux + rod.in_fast_flux) / math.max(
            target_fast +
            target_slow, 1)
        )
        root.flow.frame.flux_input.total_flux.tooltip = {"nuclearcraft.number-unit-fraction", string.format("%.3f", rod.in_slow_flux + rod.in_fast_flux), "nF", string.format("%.3f", target_fast + target_slow), "nF"}
        flux_percentage_out = (rod.slow_flux + rod.fast_flux) / (character.max_slow_flux + character.max_fast_flux)
    else

    end
    rod_gui.update_flux_bars(root, rod, "in", flux_percentage_in)
    rod_gui.update_flux_bars(root, rod, "out", flux_percentage_out)
    root.flow.frame.flux_output.total_flux.tooltip = {"nuclearcraft.number-unit", string.format("%.3f", rod.slow_flux + rod.fast_flux), "nF"}
    if rod.power > 0 then
        root.flow.frame.power.value = rod.power / (character or {max_power = 40}).max_power
        root.flow.frame.burnup.value = rod.power / rod.efficiency / rod.power
        local power, power_unit = select_unit(rod.power * 1000000)
        local burnup, burnup_unit = select_unit(rod.power / rod.efficiency * 1000000)
        root.flow.frame.power.caption = {"nuclearcraft.power-number", string.format("%.1f", power), power_unit}
        root.flow.frame.burnup.caption = {"nuclearcraft.burnup-number", string.format("%.1f", burnup), burnup_unit}
    else
        root.flow.frame.power.value = 0
        root.flow.frame.power.caption = {"nuclearcraft.power-production"}
        root.flow.frame.burnup.value = 0
        root.flow.frame.burnup.caption = {"nuclearcraft.burnup-rate"}
    end
    if not rod.reactor then
        status.status_led.sprite = "utility.status_inactive"
        status.status_label.caption = {"nuclearcraft.no-reactor"}
    end
end

---@param root LuaGuiElement
---@param rod FuelRod
---@param mode "in"|"out"
---@param flux_percentage number
function rod_gui.update_flux_bars(root, rod, mode, flux_percentage)
    local minibar_width = rod_gui.bar_width
    local min_width = rod_gui.bar_min_width
    local flux_root = root.flow.frame["flux_"..mode.."put"]
    local in_flux = flux_root.fast_slow
    local real_flux_percentage = 1
    local slow_flux
    local fast_flux
    if mode == "in" then
        slow_flux = rod[mode.."_slow_flux"]
        fast_flux = rod[mode.."_fast_flux"]
    else
        slow_flux = rod.slow_flux
        fast_flux = rod.fast_flux
    end
    flux_root.total_flux.value = 0
    flux_root.total_flux.caption = {"nuclearcraft.number-unit", string.format("%.3f", fast_flux + slow_flux), "nF"}
    if fast_flux + slow_flux > 0 then
        local total_flux = fast_flux + slow_flux
        if flux_percentage then
            real_flux_percentage = flux_percentage
            minibar_width = math.max(math.min(rod_gui.bar_width * real_flux_percentage, rod_gui.bar_width), min_width)
        end
        flux_root.total_flux.value = real_flux_percentage
        flux_root.total_flux.caption = {"nuclearcraft.number-unit", string.format("%.3f", fast_flux + slow_flux), "nF"}
        local total = fast_flux + slow_flux
        in_flux.fast.value = 1
        in_flux.slow.value = 1
        local fast_percent = (fast_flux / total)
        local slow_percent = (slow_flux / total)
        in_flux.fast.style.width = math.max(minibar_width * fast_percent, min_width)
        in_flux.slow.style.width = math.max(minibar_width * slow_percent, min_width)
        local slow_style = in_flux.slow.style
        local fast_style = in_flux.fast.style
        slow_style.color = {0, (math.min(slow_percent, 1) + 0.5) / 1.5, 0}
        fast_style.color = {0, (math.min(fast_percent, 1) + 0.5) / 1.5, 0}
        in_flux.fast.caption = string.format("%.2f%%",fast_percent * 100)
        in_flux.slow.caption = string.format("%.2f%%",slow_percent * 100)
        in_flux.fast.tooltip = {"nuclearcraft.number-unit", string.format("%.2f%%",fast_percent * 100), {"nuclearcraft.fast-flux"}}
        in_flux.slow.tooltip = {"nuclearcraft.number-unit", string.format("%.2f%%",slow_percent * 100), {"nuclearcraft.slow-flux"}}
        if minibar_width > min_width * 2 then
            if slow_style.minimal_width + fast_style.minimal_width > minibar_width then
                if fast_style.minimal_width == min_width then
                    slow_style.width = minibar_width - min_width
                    in_flux.fast.caption = ""
                elseif slow_style.minimal_width == min_width then
                    fast_style.width = minibar_width - min_width
                    in_flux.slow.caption = ""
                end
            end
        else
            slow_style.width = min_width
            fast_style.width = min_width
        end
        if slow_style.minimal_width < rod_gui.bar_min_legible_width then
            in_flux.slow.caption = ""
        end
        if fast_style.minimal_width < rod_gui.bar_min_legible_width then
            in_flux.fast.caption = ""
        end
    else
        if rod.fuel and mode == "in" then
            root.flow.frame.status_flow.status_led.sprite = "utility.status_yellow"
            root.flow.frame.status_flow.status_label.caption = {"nuclearcraft.no-flux-input"}
        end
        in_flux.fast.value = 0
        in_flux.slow.value = 0
        in_flux.fast.caption = "0%"
        in_flux.slow.caption = "0%"
        in_flux.fast.style.width = minibar_width / 2
        in_flux.slow.style.width = minibar_width / 2
    end
end

---@param event EventData.on_gui_switch_state_changed
---@param player any
function rod_gui.on_gui_switch_state_changed(event, player)
    local root = player.gui.screen[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "rod_gui_circuit_network_switch" then
        if event.element.switch_state == "left" then
            local slot_flow = root.flow.circuit_frame.slot_frame.slot_flow
            for i = 1, rod_gui.signal_button_count do
                local button = slot_flow[rod_gui.choose_signal_buttons[i][1]]
                button.enabled = false
            end
            storage.rods[root.tags.id]--[[@as FuelRod]].networked = false
            rod_gui.update(player)
        else
            local slot_flow = root.flow.circuit_frame.slot_frame.slot_flow
            for i = 1, rod_gui.signal_button_count do
                local button = slot_flow[rod_gui.choose_signal_buttons[i][1]]
                button.enabled = true
            end
            storage.rods[root.tags.id]--[[@as FuelRod]].networked = true
            rod_gui.update(player)
        end
    end
end

---@param rod FuelRod
---@param value SignalID
function rod_gui.signal_present(rod, value)
    return rod.tsig.name == value.name or
    rod.psig.name == value.name or
    rod.esig.name == value.name or
    rod.fsig.name == value.name or
    rod.ffsig.name == value.name or
    rod.sfsig.name == value.name or
    rod.dfsig.name == value.name
end

return rod_gui