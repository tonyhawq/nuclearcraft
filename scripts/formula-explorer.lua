local explorer = {}

explorer.open_gui_button = "yantm-open-explorer"
explorer.root = "nc-formula-explorer"
explorer.natural_height = 900
explorer.camera_natural_height = 700
explorer.camera_minimal_height = 150

explorer.reactor_structure = {
    {"moderator-rod", {-1, -3}},
    {"fuel-rod", {-2, -3}},
    {"moderator-rod", {1, -3}},
    {"control-rod", {0, -3}},
    {"fuel-rod", {0, -4}},
    {"fuel-rod", {2, -3}},
    {"moderator-rod", {-3, -1}},
    {"fuel-rod", {-3, -2}},
    {"control-rod", {-1, -2}},
    {"control-rod", {-2, -1}},
    {"fuel-rod", {-1, -1}},
    {"control-rod", {-2, -2}},
    {"control-rod", {1, -2}},
    {"fuel-rod", {1, -1}},
    {"moderator-rod", {0, -1}},
    {"fuel-rod", {0, -2}},
    {"control-rod", {2, -1}},
    {"moderator-rod", {3, -1}},
    {"control-rod", {2, -2}},
    {"fuel-rod", {3, -2}},
    {"moderator-rod", {-3, 1}},
    {"control-rod", {-3, 0}},
    {"fuel-rod", {-4, 0}},
    {"control-rod", {-2, 1}},
    {"fuel-rod", {-1, 1}},
    {"moderator-rod", {-1, 0}},
    {"fuel-rod", {-2, 0}},
    {"fuel-rod", {1, 1}},
    {"moderator-rod", {1, 0}},
    {"moderator-rod", {0, 1}},
    {"fuel-rod", {0, 0}},
    {"control-rod", {2, 1}},
    {"moderator-rod", {3, 1}},
    {"control-rod", {3, 0}},
    {"fuel-rod", {2, 0}},
    {"fuel-rod", {4, 0}},
    {"fuel-rod", {-3, 2}},
    {"control-rod", {-1, 2}},
    {"moderator-rod", {-1, 3}},
    {"control-rod", {-2, 2}},
    {"fuel-rod", {-2, 3}},
    {"control-rod", {1, 2}},
    {"moderator-rod", {1, 3}},
    {"control-rod", {0, 3}},
    {"fuel-rod", {0, 2}},
    {"control-rod", {2, 2}},
    {"fuel-rod", {3, 2}},
    {"fuel-rod", {2, 3}},
    {"fuel-rod", {0, 4}},
}

---@param player LuaPlayer
function explorer.close(player)
    local gui = player.gui.screen[explorer.root]
    if gui then gui.destroy() end
    player.set_shortcut_toggled("control-your-rods-explorer", false)
end

---@param player LuaPlayer
function explorer.open(player)
    explorer.close(player)
    player.set_shortcut_toggled("control-your-rods-explorer", true)
    local gui = player.gui.screen
    local container = gui.add{
        type = "frame",
        name=explorer.root,
        direction = "vertical",
        style = "frame",
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
        caption = {"nuclearcraft.explorer-gui-label"}
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
        name = "explorer_gui_close_button",
        type = "sprite-button",
        style = "close_button",
    }
    close_button.style.horizontal_align = "right"
    close_button.sprite = "utility.close"
    local inside_flow = container.add{
        type = "flow",
        direction = "horizontal",
        name = "flow",
        style = "inset_frame_container_horizontal_flow"
    }
    local tab_frame = inside_flow.add{
        type = "frame",
        name = "tab_frame",
        style = "inside_shallow_frame",
    }
    local tab_flow = tab_frame.add{
        type = "flow",
        direction = "vertical",
        name = "tab_flow",
    }
    tab_flow.style.vertical_spacing = 0
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-reactors",
        caption = {"nuclearcraft.explore-reactors"},
    }.style.horizontally_stretchable = true
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-reactor-interface",
        caption = {"nuclearcraft.explore-reactor-interface"},
    }.style.horizontally_stretchable = true
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-fuel-rods",
        caption = {"nuclearcraft.explore-fuel-rods"},
    }.style.horizontally_stretchable = true
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-control-rods",
        caption = {"nuclearcraft.explore-control-rods"},
    }.style.horizontally_stretchable = true
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-moderator-rods",
        caption = {"nuclearcraft.explore-moderator-rods"},
    }.style.horizontally_stretchable = true
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-reflector-rods",
        caption = {"nuclearcraft.explore-reflector-rods"},
    }.style.horizontally_stretchable = true
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-neutron-flux",
        caption = {"nuclearcraft.explore-neutron-flux"},
    }.style.horizontally_stretchable = true
    tab_flow.add{
        type = "button",
        style = "list_box_item",
        name = "explore-formula",
        caption = {"nuclearcraft.explore-formula"},
    }.style.horizontally_stretchable = true
    for _, character in pairs(Formula.characteristics) do
        tab_flow.add{
            type = "button",
            style = "list_box_item",
            name = "explore-certain-formula-"..character.name,
            caption = {"nuclearcraft.explore-formula-"..character.name},
        }.style.horizontally_stretchable = true
    end
    tab_flow.add{
        type = "empty-widget",
        style = "entity_frame_filler"
    }.style.vertically_stretchable = true
    local inside_frame = inside_flow.add{
        type = "scroll-pane",
        name = "inside_frame",
        style = "naked_scroll_pane",
        direction = "vertical",
    }
    container.style.natural_height = explorer.natural_height
    inside_frame.style.width = 900
    inside_frame.style.maximal_height = explorer.natural_height
    inside_frame.style.natural_height = explorer.natural_height
    inside_frame.style.vertically_stretchable = true
    player.opened = container
    local welcome_frame = inside_frame.add{
        type = "frame",
        style = "inside_deep_frame",
    }
    welcome_frame.style.vertically_stretchable = true
    welcome_frame.style.horizontally_stretchable = true
    local welcome_flow = welcome_frame.add{
        type = "flow",
        direction = "vertical",
    }
    welcome_flow.style.horizontal_align = "center"
    welcome_flow.style.vertical_align = "center"
    welcome_flow.style.vertically_stretchable = true
    welcome_flow.style.horizontally_stretchable = true
    welcome_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-welcome"}
    }

end

---@param event EventData.on_gui_click
---@param player LuaPlayer
function explorer.player_clicked_gui(event, player)
    local root = player.gui.screen[explorer.root]
    local elem_name = event.element.name
    if elem_name == explorer.open_gui_button then
        explorer.open(player)
    end
    if not root then
        return
    end
    if elem_name == "explorer_gui_close_button" then
        explorer.close(player)
        return
    elseif elem_name == "explore-reactors" then
        explorer.reactor_tab(root)
    elseif elem_name == "explore-fuel-rods" then
        explorer.fuel_rod_tab(root)
    elseif elem_name == "explore-control-rods" then
        explorer.control_rod_tab(root)
    elseif elem_name == "explore-moderator-rods" then
        explorer.moderator_tab(root)
    elseif elem_name == "explore-reflector-rods" then
        explorer.reflector_tab(root)
    elseif elem_name == "explore-neutron-flux" then
        explorer.flux_tab(root)
    elseif elem_name == "explore-reactor-interface" then
        explorer.interface_tab(root)
    elseif elem_name == "explore-formula" then
        explorer.explore_formula(root)
    elseif elem_name:find("^explore%-certain%-formula%-") then
        explorer.explore_certain_formula(root, elem_name)
    elseif elem_name == "flux_cursor_up" then
        local graph = storage.graphs[event.element.parent.parent.parent.parent.tags.flux]
        Cameras.next_selected_return(graph)
    end
end

local function lbfix(element, other)
    element.style.single_line = false
    element.style.left_padding = 10
    element.style.right_padding = 5
    if other then
        for k, v in pairs(other) do
            element.style[k] = v
        end
    end
    return element
end

---@param root LuaGuiElement
---@return LuaGuiElement
function explorer.create_footer_flow(root)
    local footer = root.flow.inside_frame.add{
        type = "frame",
        name = "footer_frame",
        style = "tips_and_tricks_subfooter",
        direction = "vertical",
    }
    footer.style.vertically_stretchable = false
    local footer_inside_frame = footer.add{
        type = "frame",
        name = "footer_inside_frame",
        style = "inside_deep_frame",
        direction = "vertical",
    }
    local stretchable_widget = footer.add{
        type = "empty-widget",
    }
    stretchable_widget.style.vertically_stretchable = true
    return footer_inside_frame
end

---@param element LuaGuiElement
---@return LuaGuiElement
local function fix_camera(element)
    element.style.horizontally_stretchable = true
    element.style.vertically_stretchable = true
    element.style.natural_width = 150
    element.style.natural_height = 500
    return element
end

---@param root LuaGuiElement
function explorer.explore_formula(root)
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)
    local footer_flow = explorer.create_footer_flow(root)

    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-formula-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-formula-explanation"},
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-formula-graphs-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-formula-graphs-explanation"},
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-formula-common-formulas-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-formula-common-formulas-explanation"},
    })
end

function explorer.reset_inside_frame(inside_frame)
    inside_frame.clear()
    inside_frame.tags = {}
end

explorer.formula_specifications = {
    {"flux", 40, 1},
    {"power", 40, 1},
    {"efficiency", 2500, 3},
}

---@param root LuaGuiElement
---@param elem_name string
function explorer.explore_certain_formula(root, elem_name)
    local name = elem_name:gsub("^explore%-certain%-formula%-", "")
    local character = Formula.characteristics[name]
    if not character then
        return
    end
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)
    local subheader = inside_frame.add{
        type = "flow",
        name = "subheader-frame",
        direction = "horizontal",
    }
    subheader.add{
        type = "label",
        caption = {"nuclearcraft.character-"..character.name},
        style = "frame_title",
    }
    local tags = {}
    for _, formula in pairs(explorer.formula_specifications) do
        local using = formula[1]
        local frame = inside_frame.add{
            type = "frame",
            name = using.."_frame",
            direction = "horizontal",
            style = "inside_deep_frame"
        }
        local camera_cfg = Cameras.get_or_create_graph{
            name = "formula-explorer-"..using.."-"..character.name,
            func = character[using.."_str"],
            argc = 3,
            integration_arg = Formula.argname_to_argnum(character[using.."_significant_variable"]),
            force_regenerate = true,
            width = 500,
            height = 250,
            x_min = 0,
            x_max = formula[2],
        }
        tags[using] = camera_cfg.name
        local camera_frame = frame.add{
            type = "frame",
            direction = "vertical",
            style = "inside_shallow_frame_with_padding",
        }
        local label = camera_frame.add{
            type = "label",
            caption = {"", {"nuclearcraft."..using}},
            style = "subheader_caption_label",
        }
        label.style.top_margin = 5
        label.style.left_margin = 10
        local widget = camera_frame.add{
            type = "empty-widget",
            style = "draggable_space"
        }
        widget.style.vertically_stretchable = true
        local camera_camera_frame = camera_frame.add{
            type = "frame",
            direction = "vertical",
            style = "inside_deep_frame",
        }
        local camera = camera_camera_frame.add{
            type = "camera",
            name = using.."-formula-camera",
            position = camera_cfg.position,
            surface_index = camera_cfg.surface.index,
            zoom = camera_cfg.zoom,
        }
        camera.style.natural_width = camera_cfg.px_width
        camera.style.natural_height = camera_cfg.px_height
        local control_frame = frame.add{
            type = "frame",
            name = using.."_control_frame",
            style = "inside_shallow_frame_with_padding",
            direction = "vertical",
        }
        control_frame.add{
            type = "label",
            caption = {"nuclearcraft.integration-arg"},
        }
        local integration_arg_flow = control_frame.add{
            type = "flow",
            direction = "horizontal",
            name = using.."_integration_arg_flow",
        }
        integration_arg_flow.add{
            type = "drop-down",
            name = using.."_integration_arg",
            items = {
                {"nuclearcraft.dropdown-slow-flux"},
                {"nuclearcraft.dropdown-fast-flux"},
                {"nuclearcraft.dropdown-temperature"},
            },
            selected_index = formula[3],
        }
        control_frame.add{
            type = "label",
            caption = {"nuclearcraft.x-max-slider"},
        }
        local max_slider_flow = control_frame.add{
            type = "flow",
            direction = "horizontal",
            name = using.."_x_max_flow"
        }
        max_slider_flow.add{
            type = "slider",
            name = using.."_x_max",
            minimum_value = 1,
            maximum_value = formula[2],
            value = formula[2],
        }
        max_slider_flow.add{
            type = "textfield",
            name = using.."_x_max_textfield",
            numeric = true,
            allow_decimal = false,
            allow_negative = false,
            lose_focus_on_confirm = true,
            text = tostring(formula[2]),
            style = "slider_value_textfield",
        }
        control_frame.add{
            type = "label",
            caption = {"nuclearcraft.cursor-position"},
        }
        local cursor_pos_flow = control_frame.add{
            type = "flow",
            direction = "horizontal",
            name = using.."_cursor_flow"
        }
        cursor_pos_flow.add{
            type = "slider",
            name = using.."_cursor_slider",
            minimum_value = 0,
            maximum_value = 1,
            discrete_values = false,
            value = 0,
        }
        cursor_pos_flow.add{
            type = "textfield",
            name = using.."_cursor_textfield",
            numeric = true,
            allow_decimal = true,
            allow_negative = false,
            lose_focus_on_confirm = true,
            text = "0",
            style = "slider_value_textfield",
        }
        cursor_pos_flow.add{
            type = "sprite-button",
            name = using.."_cursor_up",
            style = "button",
            caption = {"nuclearcraft.switch-line"}
        }
        local function create_arg_modifier(modify, min, max)
            local enabled = true
            if explorer.val_to_arg_map[modify] == formula[3] then
                enabled = false
            end
            control_frame.add{
                type = "label",
                caption = {"nuclearcraft.arg-"..modify}
            }
            local flow = control_frame.add{
                type = "flow",
                name = using.."_"..modify.."_flow",
                direction = "horizontal",
            }
            local slider=flow.add{
                type = "slider",
                name = using.."_"..modify.."_autogenmodify_slider",
                minimum_value = min,
                maximum_value = max,
                value = min,
            }
            local textfield=flow.add{
                type = "textfield",
                name = using.."_"..modify.."_autogenmodify_textfield",
                numeric = true,
                allow_decimal = false,
                allow_negative = false,
                lose_focus_on_confirm = true,
                text = tostring(min),
                style = "slider_value_textfield",
            }
            slider.enabled = enabled
            textfield.enabled = enabled
        end
        create_arg_modifier("slow_flux", 0, 40)
        create_arg_modifier("fast_flux", 0, 40)
        create_arg_modifier("temperature", 0, 2500)
    end
    inside_frame.tags = tags
end

---@param elem LuaGuiElement
function explorer.on_gui_selection_state_changed(elem)
    if elem.name:find("_integration_arg$") then
        local elem_type = elem.name:gsub("_integration_arg$", "")
        local graph = storage.graphs[elem.parent.parent.parent.parent.tags[elem_type]]
        for arg_name, arg in pairs(explorer.val_to_arg_map) do
            local enabled = true
            if arg == elem.selected_index then
                enabled = false
            end
            local control_flow = elem.parent.parent.parent.parent[elem_type.."_frame"][elem_type.."_control_frame"][elem_type.."_"..arg_name.."_flow"]
            control_flow[elem_type.."_"..arg_name.."_autogenmodify_slider"].enabled = enabled
            control_flow[elem_type.."_"..arg_name.."_autogenmodify_textfield"].enabled = enabled
        end
        Cameras.set_graph_integration_arg(graph, elem.selected_index)
        local max_slider_flow = elem.parent.parent[elem_type.."_x_max_flow"]
        local slider = max_slider_flow[elem_type.."_x_max"]
        local textfield = max_slider_flow[elem_type.."_x_max_textfield"]
        local want_max = explorer.formula_specifications[elem.selected_index][2]
        local slider_name = slider.name
        local textfield_name = textfield.name
        local slider_min = slider.get_slider_minimum()
        max_slider_flow.clear()
        max_slider_flow.add{
            type = "slider",
            name = slider_name,
            minimum_value = slider_min,
            maximum_value = want_max,
            value = want_max,
        }
        max_slider_flow.add{
            type = "textfield",
            name = textfield_name,
            numeric = true,
            allow_decimal = false,
            allow_negative = false,
            lose_focus_on_confirm = true,
            text = tostring(want_max),
            style = "slider_value_textfield",
        }
        Cameras.set_graph_x_range(graph, graph.x_min, want_max)
    end
end

explorer.val_to_arg_map = {
    ["slow_flux"] = 1,
    ["fast_flux"] = 2,
    ["temperature"] = 3,
}

explorer.reverse_val_to_arg_map = {}
for k, v in pairs(explorer.val_to_arg_map) do
    explorer.reverse_val_to_arg_map[v] = k
end

---@param elem LuaGuiElement
function explorer.on_value_changed(elem)
    if elem.name:find("_x_max$") then
        local elem_type = elem.name:gsub("_x_max$", "")
        local graph = storage.graphs[elem.parent.parent.parent.parent.tags[elem_type]]
        elem.parent[elem_type.."_x_max_textfield"].text = tostring(elem.slider_value)
        Cameras.set_graph_x_range(graph, graph.x_min, elem.slider_value)
    elseif elem.name:find("_cursor_slider$") then
        local elem_type = elem.name:gsub("_cursor_slider$", "")
        local graph = storage.graphs[elem.parent.parent.parent.parent.tags[elem_type]]
        Cameras.move_graph_cursor(graph, elem.slider_value - (graph.cursor or 0))
        elem.parent[elem_type.."_cursor_textfield"].text = Cameras.format_number(Cameras.map_cursor_pos(graph, graph.cursor))
    elseif elem.name:find("_autogenmodify_slider$") then
        local elem_type = elem.name:gsub("_.-_autogenmodify_slider$", "")
        local _, _, integration_arg = elem.name:find(elem_type.."_(.-)_autogenmodify_slider$")
        local graph = storage.graphs[elem.parent.parent.parent.parent.tags[elem_type]]
        elem.parent[elem_type.."_"..integration_arg.."_autogenmodify_textfield"].text = tostring(elem.slider_value)
        graph.args[explorer.val_to_arg_map[integration_arg]] = elem.slider_value
        Cameras.generate_graph(graph)
        if graph.cursor then
            Cameras.move_graph_cursor(graph, 0)
        end
    end
end

---@param elem LuaGuiElement
---@param text string
function explorer.gui_text_changed(elem, text)
    if elem.name:find("_cursor_textfield") then
        local elem_type = elem.name:gsub("_cursor_textfield", "")
        local numized = tonumber(text)
        if numized then
            local graph = storage.graphs[elem.parent.parent.parent.parent.tags[elem_type]]
            numized = Cameras.unmap_cursor_pos(graph, numized)
            numized = math.min(math.max(numized, 0), 1)
            elem.parent[elem_type.."_cursor_slider"].slider_value = numized
            Cameras.move_graph_cursor(graph, numized - (graph.cursor or 0))
        end
    end
end

---@param root LuaGuiElement
function explorer.fuel_rod_tab(root)
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)

    local camera_frame = inside_frame.add{
        type = "frame",
        name = "camera_frame",
        direction = "vertical",
        style = "inside_deep_frame"
    }
    local camera = fix_camera(camera_frame.add{
        type = "camera",
        name = "fuel_rod_camera",
        surface_index = storage.camera_surface_index,
        position = Cameras.get_or_create("fuel-rod").position,
        zoom = Cameras.get_or_create("fuel-rod").zoom,
    })
    local footer_flow = explorer.create_footer_flow(root)

    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-explanation"},
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-stat-meltdown-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-stat-meltdown"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-stat-slow-cross-section-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-stat-slow-cross-section"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-stat-fast-cross-section-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-stat-fast-cross-section"}
    })
    footer_flow.add{
        type = "line",
    }
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-fuel-supply-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-fuel-supply-explanation"},
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-waste-removal-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-waste-removal-explanation"},
    })
    footer_flow.add{
        type = "line",
    }
end

---@param root LuaGuiElement
function explorer.control_rod_tab(root)
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)
    inside_frame.add{
        type = "label",
        name = "control-rod-label",
        caption = {"nuclearcraft.explorer-control-rod-label"},
        style = "subheader_caption_label"
    }
    local camera_frame = inside_frame.add{
        type = "frame",
        name = "camera_frame",
        style = "inside_deep_frame",
    }
    local camera = fix_camera(camera_frame.add{
        type = "camera",
        name = "control_rod_camera",
        surface_index = storage.camera_surface_index,
        position = Cameras.get_or_create("control-rod").position,
        zoom = Cameras.get_or_create("control-rod").zoom,
    })
    local footer_flow = explorer.create_footer_flow(root)
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-explanation"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-modes"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-mode-normal"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-mode-normal-explanation"}
    }, {left_padding=30})
    footer_flow.add{
        type = "line",
    }
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-mode-group"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-mode-group-explanation"}
    }, {left_padding=30})
    footer_flow.add{
        type = "line",
    }
end

---@param root LuaGuiElement
function explorer.moderator_tab(root)
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)
    inside_frame.add{
        type = "label",
        name = "moderator-rod-label",
        caption = {"nuclearcraft.explorer-moderator-rod-label"},
        style = "subheader_caption_label"
    }
    local camera_frame = inside_frame.add{
        type = "frame",
        name = "camera_frame",
        style = "inside_deep_frame",
    }
    local camera = camera_frame.add{
        type = "camera",
        name = "moderator_rod_camera",
        surface_index = storage.camera_surface_index,
        position = Cameras.get_or_create("moderator-rod").position,
        zoom = Cameras.get_or_create("moderator-rod").zoom,
    }
    camera.style.horizontally_stretchable = true
    camera.style.vertically_stretchable = true
    camera.style.natural_height = explorer.camera_natural_height
    camera.style.minimal_height = explorer.camera_minimal_height
    local footer_flow = explorer.create_footer_flow(root)
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-moderator-rod-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-moderator-rod-explanation"}
    })
    footer_flow.add{
        type = "line",
    }
end

---@param root LuaGuiElement
function explorer.reflector_tab(root)
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)
    inside_frame.add{
        type = "label",
        name = "reflector-rod-label",
        caption = {"nuclearcraft.explorer-reflector-rod-label"},
        style = "subheader_caption_label"
    }
    local camera_frame = inside_frame.add{
        type = "frame",
        name = "camera_frame",
        style = "inside_deep_frame",
    }
    local camera = camera_frame.add{
        type = "camera",
        name = "reflector_rod_camera",
        surface_index = storage.camera_surface_index,
        position = Cameras.get_or_create("reflector-rod").position,
        zoom = Cameras.get_or_create("reflector-rod").zoom,
    }
    camera.style.horizontally_stretchable = true
    camera.style.vertically_stretchable = true
    camera.style.natural_height = explorer.camera_natural_height
    camera.style.minimal_height = explorer.camera_minimal_height
    local footer_flow = explorer.create_footer_flow(root)
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reflector-rod-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reflector-rod-explanation"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reflector-rod-bounce-distance"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reflector-rod-bounce-distance-explanation"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reflector-rod-bounce-limit"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reflector-rod-bounce-limit-explanation"}
    })
    footer_flow.add{
        type = "line",
    }
end

---@param root LuaGuiElement
function explorer.reactor_tab(root)
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)
    inside_frame.add{
        type = "label",
        name = "reactor-label",
        caption = {"nuclearcraft.explorer-reactor-label"},
        style = "subheader_caption_label"
    }
    local camera_frame = inside_frame.add{
        type = "frame",
        name = "camera_frame",
        style = "inside_deep_frame",
    }
    local camera_spec = Cameras.get_or_create_structure("reactor", explorer.reactor_structure)
    local camera = camera_frame.add{
        type = "camera",
        name = "fuel_rod_camera",
        surface_index = storage.camera_surface_index,
        position = camera_spec.position,
        zoom = camera_spec.zoom,
    }
    camera.style.horizontally_stretchable = true
    camera.style.vertically_stretchable = true
    camera.style.natural_height = explorer.camera_natural_height
    camera.style.minimal_height = explorer.camera_minimal_height
    local footer_flow = explorer.create_footer_flow(root)
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reactor-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-reactor-explanation"}
    })
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-label"}
    }, {left_padding=30,font = "default-semibold"})
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-fuel-rod-label"}
    }, {left_padding=30,font = "default-semibold"})
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-control-rod-label"}
    }, {left_padding=30,font = "default-semibold"})
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-moderator-rod-label"}
    }, {left_padding=30,font = "default-semibold"})
    footer_flow.add{
        type = "line",
    }
end

---@param root LuaGuiElement
function explorer.flux_tab(root)
    local inside_frame = root.flow.inside_frame
    explorer.reset_inside_frame(inside_frame)
    inside_frame.add{
        type = "label",
        name = "neutron-flux-label",
        caption = {"nuclearcraft.explorer-neutron-flux-label"},
        style = "subheader_caption_label"
    }
    local camera_frame = inside_frame.add{
        type = "frame",
        name = "camera_frame",
        style = "inside_deep_frame",
    }
    local camera_spec = Cameras.get_or_create_structure("reactor", explorer.reactor_structure)
    local camera = camera_frame.add{
        type = "camera",
        name = "fuel_rod_camera",
        surface_index = storage.camera_surface_index,
        position = camera_spec.position,
        zoom = camera_spec.zoom,
    }
    camera.style.horizontally_stretchable = true
    camera.style.vertically_stretchable = true
    camera.style.natural_height = explorer.camera_natural_height
    camera.style.minimal_height = explorer.camera_minimal_height
    local footer_flow = explorer.create_footer_flow(root)
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-explanation"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-where-does-it-come-from"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-comes-from-fuel-rods"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-where-does-it-go"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-is-consumed"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-what-is-slow-fast"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-speed-explanation"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-how-do-i-control-it"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-neutron-flux-control-rods"}
    })
    footer_flow.add{
        type = "line",
    }
end

---@param root LuaGuiElement
function explorer.interface_tab(root)
    local inside_frame = root.flow.inside_frame
    inside_frame.style.natural_width = 900
    inside_frame.style.horizontally_squashable = true
    inside_frame.clear()
    inside_frame.add{
        type = "label",
        name = "interface-label",
        caption = {"nuclearcraft.explorer-interface-label"},
        style = "subheader_caption_label"
    }
    local camera_frame = inside_frame.add{
        type = "frame",
        name = "camera_frame",
        style = "inside_deep_frame",
    }
    local camera = camera_frame.add{
        type = "camera",
        name = "interface_camera",
        surface_index = storage.camera_surface_index,
        position = Cameras.get_or_create("reactor-interface").position,
        zoom = Cameras.get_or_create("reactor-interface").zoom,
    }
    camera.style.horizontally_stretchable = true
    camera.style.vertically_stretchable = true
    camera.style.natural_height = explorer.camera_natural_height
    camera.style.minimal_height = explorer.camera_minimal_height
    local footer_flow = explorer.create_footer_flow(root)
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-label"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-explanation"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-mode-header"},
        style = "subheader_caption_label",
    }
    footer_flow.add{
        type = "line",
    }
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-mode-input-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-mode-input-header"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-mode-output-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-mode-output-header"}
    })
    footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-mode-group-header"},
        style = "subheader_caption_label",
    }
    lbfix(footer_flow.add{
        type = "label",
        caption = {"nuclearcraft.explorer-interface-mode-group-header"}
    })
    footer_flow.add{
        type = "line",
    }
end

---@param event EventData.on_gui_closed
---@param player LuaPlayer
function explorer.on_close(event, player)
    if event.entity then
        return
    end
    if not event.element or not event.element.valid or event.element.name ~= explorer.root then
        return
    end
    explorer.close(player)
end

return explorer