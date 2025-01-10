local rod_gui = {}

rod_gui.root = "nc-fuel-rod-frame"
rod_gui.bar_width = 300
rod_gui.bar_min_legible_width = 50
rod_gui.bar_min_width = 20

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
    burning_fuel.enabled = false
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
    burnt_fuel.enabled = false
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
    rod_gui.update(player)
end

---@param event EventData.on_gui_elem_changed
---@param player LuaPlayer
function rod_gui.player_changed_elem(event, player)
    local root = player.gui.relative[rod_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "fuel_selection" then
        if not event.element.elem_value then
            storage.rods[root.tags.id]--[[@as FuelRod]].wants_fuel = nil
            return
        end
        local item_name = event.element.elem_value --[[@as string]]
        if not Formula.fuels[item_name] then
            game.print("no fuel with name "..tostring(item_name))
            event.element.elem_value = nil
            rod_gui.update(player)
            return
        end
        storage.rods[root.tags.id]--[[@as FuelRod]].wants_fuel = item_name
        rod_gui.update(player)
    end
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
            rendering.draw_line{from={rod.entity.position.x + offset / 32, rod.entity.position.y}, to=affector.affector.entity.position, surface=rod.entity.surface,color={0, 0, 255},width=1}
            local coffset = 0
            for _, control_rod in pairs(affector.control_rods) do
                coffset = coffset + 2
                rendering.draw_line{from={affector.affector.entity.position.x + coffset / 32, affector.affector.entity.position.y + coffset / 32}, to=control_rod.entity.position, surface=affector.affector.entity.surface, color={0, 255, 0}, width=1}
            end
        end
    elseif event.element.name == "visualize_flux" then
        local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
        local reactor = rod.reactor
        if not reactor then
            player.print("Rod must have reactor.")
            return
        end
        reactor.visualize = true
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
    local root = player.gui.relative[rod_gui.root] --[[@as LuaGuiElement]]
    if not root or not root.tags or not root.tags.id or not storage.rods[root.tags.id] then
        return
    end
    local rod = storage.rods[root.tags.id] --[[@as FuelRod]]
    local status = root.frame.status_flow
    local fuel = rod.fuel
    local fuel_flow = root.frame.fuel
    local character
    local inside_frame = root.frame
    local temperature_bar = root.frame.temperature
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
        inside_frame.efficiency.value = rod.efficiency / character.max_efficiency
        inside_frame.efficiency_penalty.value = 1 - rod.penalty_val
        if not rod.wants_fuel then
            fuel_flow.fuel_selection.elem_value = nil
        else
            fuel_flow.fuel_selection.elem_value = fuel.item
        end
    else
        if rod.wants_fuel then
            inside_frame.efficiency.value = 0
            inside_frame.efficiency_penalty.value = 1 - rod.base_efficiency
            fuel_flow.fuel_remaining.caption = {"nuclearcraft.no-fuel"}
            status.status_led.sprite = "utility.status_inactive"
            status.status_label.caption = {"nuclearcraft.no-fuel"}
            fuel_flow.burning_fuel.sprite = "item."..rod.wants_fuel
            fuel_flow.burnt_fuel.sprite = nil
            fuel_flow.fuel_selection.elem_value = rod.wants_fuel
            character = Formula.characteristics[Formula.fuels[rod.wants_fuel].character_name]
        else
            inside_frame.efficiency.value = 0
            inside_frame.efficiency_penalty.value = 1 - rod.base_efficiency
            status.status_led.sprite = "utility.status_inactive"
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
        root.frame.flux_input.total_flux.tooltip = {"nuclearcraft.number-unit-fraction", string.format("%.3f", rod.in_slow_flux + rod.in_fast_flux), "nF", string.format("%.3f", target_fast + target_slow), "nF"}
        flux_percentage_out = (rod.slow_flux + rod.fast_flux) / (character.max_slow_flux + character.max_fast_flux)
    else

    end
    rod_gui.update_flux_bars(root, rod, "in", flux_percentage_in)
    rod_gui.update_flux_bars(root, rod, "out", flux_percentage_out)
    root.frame.flux_output.total_flux.tooltip = {"nuclearcraft.number-unit", string.format("%.3f", rod.slow_flux + rod.fast_flux), "nF"}
    if rod.power > 0 then
        root.frame.power.value = rod.power / (character or {max_power = 40}).max_power
        root.frame.burnup.value = rod.power / rod.efficiency / rod.power
        local power, power_unit = select_unit(rod.power * 1000000)
        local burnup, burnup_unit = select_unit(rod.power / rod.efficiency * 1000000)
        root.frame.power.caption = {"nuclearcraft.power-number", string.format("%.1f", power), power_unit}
        root.frame.burnup.caption = {"nuclearcraft.burnup-number", string.format("%.1f", burnup), burnup_unit}
    else
        root.frame.power.value = 0
        root.frame.power.caption = {"nuclearcraft.power-production"}
        root.frame.burnup.value = 0
        root.frame.burnup.caption = {"nuclearcraft.burnup-rate"}
    end
    if not rod.reactor then
        status.status_led.sprite = "utility.status_not_working"
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
    local flux_root = root.frame["flux_"..mode.."put"]
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
            root.frame.status_flow.status_led.sprite = "utility.status_yellow"
            root.frame.status_flow.status_label.caption = {"nuclearcraft.no-flux-input"}
        end
        in_flux.fast.value = 0
        in_flux.slow.value = 0
        in_flux.fast.caption = "0%"
        in_flux.slow.caption = "0%"
        in_flux.fast.style.width = minibar_width / 2
        in_flux.slow.style.width = minibar_width / 2
    end
end

return rod_gui