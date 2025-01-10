local rod_gui = {}

rod_gui.root = "nc-control-rod-frame"

---@param player LuaPlayer
function rod_gui.close(player)
    local gui = player.gui.relative[rod_gui.root]
    if gui then gui.destroy() end
end

---@param player LuaPlayer
---@param entity LuaEntity
function rod_gui.open(player, entity)
    if not entity or entity.name ~= "control-rod" then
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
        name = "control-rod-gui-label",
        type = "label",
        style = "frame_title",
        caption = {"nuclearcraft.control-rod-gui-label"}
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
        type = "line",
        style = "line",
    }
    inside_frame.add{
        name = "insertion",
        type = "progressbar",
        style = "production_progressbar",
        caption = "",
    }
    rod_gui.update(player)
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
    local rod = storage.rods[root.tags.id] --[[@as ControlRod]]
    local status = root.frame.status_flow
    if not rod.reactor then
        status.status_led.sprite = "utility.status_not_working"
        status.status_label.caption = {"nuclearcraft.no-reactor"}
        root.frame.insertion.value = 0
        root.frame.insertion.caption = {"nuclearcraft.insertion"}
        root.frame.insertion.tooltip = root.frame.insertion.caption
    else
        status.status_led.sprite = "utility.status_working"
        status.status_label.caption = {"nuclearcraft.working"}   
        root.frame.insertion.value = rod.insertion
        root.frame.insertion.caption = {"nuclearcraft.insertion-amount", string.format("%.2f", rod.insertion * 100)}
        root.frame.insertion.tooltip = root.frame.insertion.caption
    end
end

return rod_gui