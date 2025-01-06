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
        tags = {id = script.register_on_object_destroyed(entity)}
    }
    container.add{
        type="button",
        name="create_reactor"
    }
end

---@param event EventData.on_gui_click
---@param player LuaPlayer
function interface_gui.player_clicked_gui(event, player)
    local root = player.gui.relative[interface_gui.root]
    if not root or not root.tags or not root.tags.id then
        return
    end
    if event.element.name == "create_reactor" then
        Rods.create_reactor(storage.interfaces[root.tags.id])
    end
end

return interface_gui