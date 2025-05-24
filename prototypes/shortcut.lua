data:extend({
  {
    type = "shortcut",
    name = "control-your-rods-explorer",
    order = "c[toggles]",
    action = "lua",
    localised_name = {"shortcut.control-your-rods-explorer"},
    icon = "__control-your-rods__/graphics/icons/shortcut.png",
    icon_size = 56,
    small_icon = "__control-your-rods__/graphics/icons/shortcut-large-white.png",
    small_icon_size = 56,
    toggleable = true,
  },
})

local function add_hidden_shortcut(name)
  data:extend({
  {
    type = "shortcut",
    name = name,
    order = "zzz",
    action = "lua",
    localised_name = {"shortcut.control-your-rods-explorer"},
    icon = "__control-your-rods__/graphics/icons/shortcut.png",
    icon_size = 56,
    small_icon = "__control-your-rods__/graphics/icons/shortcut-large-white.png",
    small_icon_size = 56,
    toggleable = true,
    hidden = true,
  },
})
end

add_hidden_shortcut("cyr-explorer-shortcut-fuel-rod")
add_hidden_shortcut("cyr-explorer-shortcut-control-rod")
add_hidden_shortcut("cyr-explorer-shortcut-moderator-rod")
add_hidden_shortcut("cyr-explorer-shortcut-reflector-rod")
add_hidden_shortcut("cyr-explorer-shortcut-reactor-interface")
add_hidden_shortcut("cyr-explorer-shortcut-formula-uranium")
add_hidden_shortcut("cyr-explorer-shortcut-formula-thorium")
add_hidden_shortcut("cyr-explorer-shortcut-formula-thorium-cycle")
add_hidden_shortcut("cyr-explorer-shortcut-formula-americium")
add_hidden_shortcut("cyr-explorer-shortcut-formula-plutonium")
add_hidden_shortcut("cyr-explorer-shortcut-formula-mox")
