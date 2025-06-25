#  Ocean Breeze
#set -U fish_color_normal normal
#set -U fish_color_command 98C1D9 # dusty blue
#set -U fish_color_param A7D3A6 # sage green
#set -U fish_color_quote D1B3C4 # dusty rose
#set -U fish_color_comment B5C2C7 # gray blue
#set -U fish_color_operator C2CFB2 # olive green
#set -U fish_color_error E8B4BC # muted pink
#set -U fish_color_escape BCE8D4 # mint
#set -U fish_color_autosuggestion 8FA3AD

# Atom One Dark inspired theme for Fish
set -U fish_color_normal normal
set -U fish_color_command 61afef # light blue - for commands
set -U fish_color_param abb2bf # white/gray - for parameters
set -U fish_color_quote 98c379 # green - for quotes
set -U fish_color_comment 5c6370 # gray - for comments
set -U fish_color_operator c678dd # purple - for operators
set -U fish_color_error e06c75 # red - for errors
set -U fish_color_escape 56b6c2 # cyan - for escape sequences
set -U fish_color_autosuggestion 4b5263 # dark gray - for autosuggestions
set -U fish_color_valid_path --underline
set -U fish_color_redirection d19a66 # orange - for redirections
set -U fish_color_end c678dd # purple - for process separators
set -U fish_color_search_match --background=282c34
set -U fish_pager_color_prefix e5c07b # yellow - for prefix matches
set -U fish_pager_color_completion normal
set -U fish_pager_color_description 5c6370
set -U fish_pager_color_selected_background --background=282c34

export PATH="$HOME/.local/share/uv/tools/vectorcode/bin:$PATH"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
