local csurf = {}

csurf.graph_colors = {
    {255, 0, 0},
    {0, 255, 0},
    {0, 128, 255},
}

csurf.structure_increment = 50
csurf.graph_y_pos = 100

function csurf.create_camera_surface()
    if storage.camera_surface then
        if not storage.camera_surface_index then
            storage.camera_surface_index = storage.camera_surface.index
        end
        return
    end
    local already_made = game.get_surface("camera-surface")
    if already_made then
        storage.camera_surface = already_made
        storage.camera_surface_index = storage.camera_surface.index
        return
    end
    storage.camera_surface = game.create_surface("camera-surface")
    storage.camera_surface.generate_with_lab_tiles = true
    storage.camera_surface.show_clouds = false
    storage.camera_surface.freeze_daytime = true
    storage.camera_surface.daytime = 0
    storage.camera_surface.clear(true)
    storage.camera_surface_index = storage.camera_surface.index
end

function csurf.setup()
    if not storage.camera_surface_index then
        csurf.create_camera_surface()
    end
    storage.cameras_by_entity = storage.cameras_by_entity or {}
    storage.cameras_by_structure = storage.cameras_by_structure or {}
    storage.graphs = storage.graphs or {}
    storage.current_camera_x = storage.current_camera_x or 0
    storage.current_graph_camera_x = storage.current_graph_camera_x or 0
end

csurf.functions_by_graph_name = {}

function csurf.on_load()
    for name, graph in pairs(storage.graphs) do
        csurf.functions_by_graph_name[name] = load(graph.func)()
    end
end

function csurf.render_graph_axis_numbers(graph)
    local ghosts = {
        "x_axis_min",
        "x_axis_max",
        "y_axis_min",
        "y_axis_max",
    }
    for _, ghost in pairs(ghosts) do
        if graph.rendered[ghost] then
            graph.rendered[ghost].destroy()
            graph.rendered[ghost] = nil
        end
    end
    graph.rendered.x_axis_min = rendering.draw_text{
        surface=graph.surface,
        color = {255, 255, 255},
        target = {graph.origin.x, graph.origin.y},
        vertical_alignment = "top",
        alignment = "left",
        text = csurf.format_number(graph.x_min),
        scale = 4
    }
    graph.rendered.x_axis_max = rendering.draw_text{
        surface=graph.surface,
        color = {255, 255, 255},
        target = {graph.base.x + graph.width, graph.origin.y},
        vertical_alignment = "top",
        alignment = "right",
        text = csurf.format_number(graph.x_max),
        scale = 4
    }
    local y_min = graph.last_calculated_y_min or 0
    local y_max = graph.last_calculated_y_max or 1
    if y_min == y_max then
        y_min = y_min - 1
        y_max = y_max + 1
    end
    graph.rendered.y_axis_min = rendering.draw_text{
        surface=graph.surface,
        color = {255, 255, 255},
        target = {graph.origin.x, graph.origin.y},
        vertical_alignment = "bottom",
        alignment = "right",
        text = csurf.format_number(y_min),
        scale = 4
    }
    graph.rendered.y_axis_max = rendering.draw_text{
        surface=graph.surface,
        color = {255, 255, 255},
        target = {graph.origin.x, graph.base.y - graph.height},
        vertical_alignment = "top",
        alignment = "right",
        text = csurf.format_number(y_max),
        scale = 4
    }
end

function csurf.set_graph_x_range(graph, min, max)
    graph.x_min = min
    graph.x_max = max
    csurf.generate_graph(graph)
    if graph.cursor then
        csurf.move_graph_cursor(graph, 0)
    end
    csurf.render_graph_axis_numbers(graph)
end

function csurf.generate_graph(graph)
    for _, obj in pairs(graph.graph) do
        obj.destroy()
    end
    graph.graph = {}
    if not graph.integration_arg then
        return
    end
    local range = graph.x_max - graph.x_min
    local substep = 100 / range
    local func = csurf.functions_by_graph_name[graph.name]
    local base = graph.base
    local origin = graph.origin
    local real_width = graph.width - (origin.x - base.x)
    local real_height = graph.height - (base.y - origin.y)
    local xy_pairs = {}
    local xy_length = 0
    local y_range = 0
    local y_min = nil
    local y_max = nil
    for i = graph.x_min * substep, graph.x_max * substep do
        local x = i / substep
        graph.args[graph.integration_arg] = x
        local vals = {func(table.unpack(graph.args))}
        for k, v in pairs(vals) do
            xy_pairs[k] = xy_pairs[k] or {n=0}
            local pos = {x=x, y=v}
            table.insert(xy_pairs[k], {x=pos.x, y=pos.y})
            xy_pairs[k].n = xy_pairs[k].n + 1
            if not y_min then
                y_min = pos.y
            else
                y_min = math.min(y_min, pos.y)
            end
            if not y_max then
                y_max = pos.y
            else
                y_max = math.max(y_max, pos.y)
            end
        end
    end
    y_max = graph.y_max or y_max
    y_min = graph.y_min or y_min
    graph.last_calculated_y_max = y_max
    graph.last_calculated_y_min = y_min
    y_range = y_max - y_min
    if y_range == 0 then
        y_range = 1
        y_min = y_min - 0.5
    end
    local origin_offset = {x=origin.x - base.x, y=base.y - origin.y}
    for k, xy in pairs(xy_pairs) do
        for i = 2, xy.n do
            local pos = xy[i]
            local last_pos = xy[i - 1]
            local from_pos = {x=last_pos.x / range * real_width + graph.origin.x, y=( - (last_pos.y - y_min)) / y_range * (real_height) + graph.base.y - origin_offset.y}
            local to_pos = {x=pos.x / range * real_width + graph.origin.x, y=( - (pos.y - y_min)) / y_range * (real_height) + graph.base.y - origin_offset.y}
            table.insert(graph.graph, rendering.draw_line{
                surface=graph.surface,
                from=from_pos,
                to=to_pos,
                color = csurf.graph_colors[k],
                width = graph.line_width,
            })
            table.insert(graph.graph, rendering.draw_circle{
                surface = graph.surface,
                target=from_pos,
                color=csurf.graph_colors[k],
                radius = graph.line_width / (64),
                filled = true,
            })
            table.insert(graph.graph, rendering.draw_circle{
                surface = graph.surface,
                target=to_pos,
                color=csurf.graph_colors[k],
                radius = graph.line_width / (64),
                filled = true,
            })
        end
    end
    csurf.render_graph_axis_numbers(graph)
end

function csurf.destroy_graph(graph)
    for _, obj in pairs(graph.graph) do
        obj.destroy()
    end
    for _, obj in pairs(graph.rendered) do
        obj.destroy()
    end
    graph.graph = {}
    graph.rendered = {}
    storage.graphs[graph.name] = nil
end

function csurf.get_or_create_graph(cfg)
    local name = cfg.name
    if not storage.graphs[name] or cfg.force_regenerate then
        local spawn_position = storage.current_graph_camera_x + 0.5
        if storage.graphs[name] then
            spawn_position = storage.graphs[name].base.x
            csurf.destroy_graph(storage.graphs[name])
        end
        local x_axis_name = cfg.x_axis or "X"
        local y_axis_name = cfg.y_axis or "Y"
        local xscale = cfg.xscale or cfg.scale or 1
        local yscale = cfg.yscale or cfg.scale or 1
        local x_min = cfg.x_min or 0
        local x_max = cfg.x_max or 1
        local func = cfg.func
        local argc = cfg.argc or 1
        local integration_arg = cfg.integration_arg
        local args = {}
        local width = cfg.width or 900
        local height = cfg.height or 500
        local px_width = width
        local px_height = height
        local aspect_ratio = width / height
        width = 50
        height = 50 / aspect_ratio
        local line_width = 16
        for i = 1, argc do
            table.insert(args, 0)
        end
        local base = {x=spawn_position, y=csurf.graph_y_pos + 0.5}
        local origin_offset = {x=width / 10, y=width / 10}
        local origin = {x=base.x + origin_offset.x, y=base.y - origin_offset.y}
        local surf = storage.camera_surface
        storage.camera_surface.request_to_generate_chunks(base, 5)
        local zoom
        if height > width then
            zoom = px_height / (height * 32)
        else
            zoom = px_width / (width * 32)
        end
        local return_count = table_size({load(func)()(table.unpack(args))})
        local x_axis_line = rendering.draw_line{surface=surf, from={origin.x-0.1,origin.y}, to={x=base.x+width, y=origin.y}, color={255, 255, 255}, width=line_width}
        local y_axis_line = rendering.draw_line{surface=surf, from={origin.x,origin.y+0.1}, to={x=origin.x, y=base.y-height}, color={255, 255, 255}, width=line_width}
        storage.graphs[name] = {
            name = name,
            args = args,
            func = func,
            return_count = return_count,
            selected_return = 0,
            x_scale = xscale,
            y_scale = yscale,
            integration_arg = integration_arg,
            x_min = x_min,
            x_max = x_max,
            y_min = cfg.y_min,
            y_max = cfg.y_max,
            width = width,
            height = height,
            origin = origin,
            return_labels = cfg.return_labels,
            base = base,
            surface = surf,
            line_width = line_width,
            rendered = {
                x_axis_line = x_axis_line,
                y_axis_line = y_axis_line,
            },
            graph = {},
            position = {x=base.x + width / 2, y=base.y - height / 2},
            zoom = zoom,
            px_width = px_width,
            px_height = px_height,
        }
        csurf.rename_graph_axis(storage.graphs[name], {x=x_axis_name, y=y_axis_name})
        csurf.functions_by_graph_name[name] = load(func)()
        csurf.generate_graph(storage.graphs[name])
        storage.current_graph_camera_x = storage.current_graph_camera_x + 100
    end
    return storage.graphs[name]
end

function csurf.rename_graph_axis(graph, cfg)
    local new_x = cfg.x_axis or cfg.x
    local new_y = cfg.y_axis or cfg.y
    local origin_offset = {x=graph.origin.x - graph.base.x, y=graph.base.y - graph.origin.y}
    if new_x then
        local x_axis_label = rendering.draw_text{
            surface=graph.surface,
            alignment="center",
            vertical_alignment="bottom",
            target={
                graph.base.x + origin_offset.x + (graph.width - origin_offset.x) / 2,
                graph.base.y - 0.5
            },
            text=new_x,
            color={255, 255, 255},
            scale=4}
        if graph.rendered.x_axis_label then
            graph.rendered.x_axis_label.destroy()
            graph.rendered.x_axis_label = nil
        end
        graph.rendered.x_axis_label = x_axis_label
    end
    if new_y then
        local y_axis_label = rendering.draw_text{
            surface=graph.surface,
            alignment="center",
            vertical_alignment="middle",
            target={
                graph.base.x + (origin_offset.x / 2),
                graph.origin.y - (graph.height - origin_offset.y) / 2
            },
            text=new_y,
            color={255, 255, 255},
            scale=4}
        if graph.rendered.y_axis_label then
            graph.rendered.y_axis_label.destroy()
            graph.rendered.y_axis_label = nil
        end
        graph.rendered.y_axis_label = y_axis_label
    end
end

function csurf.destroy_cursor(graph)
    graph.cursor = nil
    local to_destroy = {
        "cursor",
        "cursor_left",
        "cursor_right",
        "cursor_up",
        "cursor_down",
        "cursor_text",
        "cursor_return_text"
    }
    for _, destroy in pairs(to_destroy) do
        if graph.rendered[destroy] then
            graph.rendered[destroy].destroy()
            graph.rendered[destroy] = nil
        end
    end
end

function csurf.set_graph_integration_arg(graph, index)
    if not index then
        graph.integration_arg = nil
        for k, _ in pairs(graph.args) do
            graph.args[k] = 0
        end
        csurf.generate_graph(graph)
        csurf.destroy_cursor(graph)
    end
    if index > #graph.args then
        error("Set integration arg ("..tostring(index)..") is outside range (1 - "..tostring(#graph.args)..")")
    end
    for k, _ in pairs(graph.args) do
        graph.args[k] = 0
    end
    graph.integration_arg = index
    csurf.generate_graph(graph)
    if graph.cursor then
        csurf.move_graph_cursor(graph, 0)
    end
end

function csurf.next_selected_return(graph)
    if graph.return_count <= 1 then
        return
    end
    graph.selected_return = ((graph.selected_return + 1) % graph.return_count)
    if graph.cursor then
        csurf.move_graph_cursor(graph, 0)
    end
end

function csurf.move_graph_cursor(graph, by)
    if not graph.cursor then
        graph.cursor = 0
    else
        local val = graph.cursor
        csurf.destroy_cursor(graph)
        graph.cursor = val
    end
    if not by then
        by = -graph.cursor
    end
    local args = table.deepcopy(graph.args)
    graph.cursor = graph.cursor + by
    local range = graph.x_max - graph.x_min
    local x_value = graph.cursor * range
    args[graph.integration_arg] = x_value
    local y_value = {csurf.functions_by_graph_name[graph.name](table.unpack(args))}
    y_value = y_value[graph.selected_return + 1]
    local y_min = graph.last_calculated_y_min or graph.y_min or 0
    local y_max = graph.last_calculated_y_max or graph.y_max or 0
    local y_range = y_max - y_min
    local is_flat = false
    if y_range == 0 then
        is_flat = true
        y_range = 1
        y_min = y_min - 0.5
    end
    local origin_offset = {x=graph.origin.x - graph.base.x, y=graph.base.y - graph.origin.y}
    local real_height = graph.height - (graph.base.y - graph.origin.y)
    local real_width = graph.width - (graph.origin.x - graph.base.x)
    local graph_cursor_x = graph.cursor * real_width + graph.origin.x
    local graph_cursor_y = ( - (y_value - y_min)) / y_range * (real_height) + graph.base.y - origin_offset.y
    graph.rendered.cursor = rendering.draw_circle{
        color={255, 255, 255},
        radius=0.5,
        target={graph_cursor_x, graph_cursor_y},
        surface = graph.surface,
        filled = false,
        width = 8,
    }
    if not is_flat then
        graph.rendered.cursor_left = rendering.draw_line{
            color={255, 255, 255},
            from = {graph_cursor_x - 0.5, graph_cursor_y},
            to = {graph.origin.x, graph_cursor_y},
            width = 8,
            surface = graph.surface
        }
        graph.rendered.cursor_right = rendering.draw_line{
            color={255, 255, 255},
            from = {graph_cursor_x + 0.5, graph_cursor_y},
            to = {graph.base.x + graph.width, graph_cursor_y},
            width = 8,
            surface = graph.surface
        }
    end
    graph.rendered.cursor_up = rendering.draw_line{
        color={255, 255, 255},
        from = {graph_cursor_x, graph_cursor_y - 0.5},
        to = {graph_cursor_x, graph_cursor_y - graph.height},
        width = 8,
        surface = graph.surface
    }
    graph.rendered.cursor_down = rendering.draw_line{
        color={255, 255, 255},
        from = {graph_cursor_x, graph_cursor_y + 0.5},
        to = {graph_cursor_x, graph.origin.y},
        width = 8,
        surface = graph.surface
    }
    local text_to_render = csurf.format_number(x_value)..", "..csurf.format_number(y_value)
    local offset = 1
    local anchor = "left"
    if text_to_render:len() + graph_cursor_x > (graph.base.x + graph.width) then
        offset = -1
        anchor = "right"
    end
    local vertical_offset = 1
    local vertical_anchor = "top"
    if graph_cursor_y > graph.origin.y - 3 then
        vertical_offset = -1
        vertical_anchor = "bottom"
    end
    graph.rendered.cursor_text = rendering.draw_text{
        color = {255, 255, 255},
        surface = graph.surface,
        target = {graph_cursor_x + offset, graph_cursor_y + vertical_offset},
        text = text_to_render,
        alignment = anchor,
        vertical_alignment = vertical_anchor,
        scale = 4,
    }
    if graph.return_count > 1 and graph.return_labels and graph.return_labels[graph.selected_return + 1] then
        graph.rendered.cursor_return_text = rendering.draw_text{
            color = {255, 255, 255},
            surface = graph.surface,
            target = {graph_cursor_x + offset, graph_cursor_y + vertical_offset + 2 * vertical_offset},
            text = graph.return_labels[graph.selected_return + 1],
            alignment = anchor,
            vertical_alignment = vertical_anchor,
            scale = 4,
        }
    end
end

function csurf.map_cursor_pos(graph, val)
    return ((graph.x_max or 1) - (graph.x_min or 0)) * val
end

function csurf.unmap_cursor_pos(graph, val)
    return val / ((graph.x_max or 1) - (graph.x_min or 0))
end

function csurf.format_number(number)
    local digits = math.ceil(math.log(math.abs(number), 10))
    return string.format("%."..tostring(math.max(math.min(-digits + 4, 4), 1)).."f", number)
end

---@param entity LuaEntity|string
function csurf.get_or_create(entity)
    local name
    if type(entity) == "string" then
        name = entity
    else
        name = entity.name
    end
    if not storage.cameras_by_entity[name] then
        local pos = {x=storage.current_camera_x, y=0}
        local created = storage.camera_surface.create_entity{name=name, position=pos, force="neutral"}
        if not created then
            return {position={x=0,y=0}, zoom=1.5, entity=nil}
        end
        created.active = false
        local width = math.ceil(created.selection_box.right_bottom.x - created.selection_box.left_top.x)
        local height = created.selection_box.right_bottom.y - created.selection_box.left_top.y
        storage.cameras_by_entity[name] = {position={pos.x + 0.5, pos.y + 0.5}, entity=created, zoom=1.5 / (width ^ 0.5)}
        storage.current_camera_x = storage.current_camera_x + csurf.structure_increment
        storage.camera_surface.request_to_generate_chunks({storage.current_camera_x, 0}, 2)
    end
    return storage.cameras_by_entity[name]
end

function csurf.get_or_create_structure(structure_name, structure)
    if not storage.cameras_by_structure[structure_name] and not structure then
        return {position={x=0,y=0}, zoom=1.5}
    end
    if not storage.cameras_by_structure[structure] then
        local minx = 0
        local maxx = 0
        local miny = 0
        local maxy = 0
        for _, obj in pairs(structure) do
            local opos = (obj.position or obj[2])
            minx = math.min(minx, opos.x or opos[1])
            maxx = math.max(maxx, opos.x or opos[1])
            miny = math.min(miny, opos.y or opos[2])
            maxy = math.max(maxy, opos.y or opos[2])
        end
        local width = maxx - minx
        local height = maxy - miny
        local pos = {x=storage.current_camera_x + math.abs(minx), y=0}
        local surf = storage.camera_surface
        local entities = {}
        for _, obj in pairs(structure) do
            local opos = (obj.position or obj[2])
            table.insert(entities, surf.create_entity{position={pos.x + (opos.x or opos[1]), pos.y + (opos.y or opos[2])}, name=obj.name or obj[1], force="neutral"})
        end
        storage.cameras_by_structure[structure] = {position={pos.x + 0.5, pos.y + 0.5}, entities = entities, zoom=1.5 / (width ^ 0.5)}
        storage.current_camera_x = storage.current_camera_x + math.abs(minx) + csurf.structure_increment
        storage.camera_surface.request_to_generate_chunks({storage.current_camera_x, 0}, 2)
    end
    return storage.cameras_by_structure[structure]
end

return csurf