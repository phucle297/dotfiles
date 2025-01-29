local M = {}

M.ascii = {
  "██████╗ ███████╗██████╗ ███╗   ███╗███████╗███████╗███████╗",
  "██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝██╔════╝██╔════╝",
  "██████╔╝█████╗  ██████╔╝██╔████╔██║█████╗  █████╗  ███████╗",
  "██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██╔══╝  ╚════██║",
  "██║     ███████╗██║  ██║██║ ╚═╝ ██║███████╗███████╗███████║",
  "╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝",
}

M.buttons = {
  { "  Find File", "Spc f f", "Telescope find_files" },
  { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
  { "  Find Word", "Spc f w", "Telescope live_grep" },
  { "  Bookmarks", "Spc m a", "Telescope marks" },
  { "  Themes", "Spc t h", "Telescope themes" },
}

M.header = {
  type = "text",
  align = "center",
  fold_section = false,
  title = "header",
  margin = 5,
  content = M.ascii,
  highlight = "Statement",
}

M.buttons_section = {
  type = "group",
  align = "center",
  fold_section = false,
  title = "buttons",
  margin = 5,
  content = M.buttons,
}

return M
