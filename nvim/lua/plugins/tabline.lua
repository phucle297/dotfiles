return {
	{
		"willothy/nvim-cokeline",
		lazy = false,

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},

		init = function()
			vim.opt.termguicolors = true
			vim.opt.mouse = "a"
		end,

		config = function()
			------------------------------------------------------------
			-- COLORS
			------------------------------------------------------------

			local C = {
				fill = "#15171B",
				active = "#343A45",
				inactive = "#22262D",

				fg = "#A5ACB8",
				active_fg = "#FFFFFF",
				muted = "#707987",
				dark = "#15171B",

				green = "#9ECE6A",
				yellow = "#E0AF68",
				cyan = "#7DCFFF",
				red = "#F7768E",
			}

			------------------------------------------------------------
			-- GIT CACHE
			------------------------------------------------------------

			local git_cache = {}
			local git_pending = {}
			local git_refresh_needed = {}

			------------------------------------------------------------
			-- DIAGNOSTICS
			------------------------------------------------------------

			local function has_error(buffer)
				return buffer.diagnostics ~= nil and (buffer.diagnostics.errors or 0) > 0
			end

			------------------------------------------------------------
			-- BUFFER COLORS
			--
			-- Priority:
			-- error > staged > modified > untracked > clean
			------------------------------------------------------------

			local function buffer_bg(buffer)
				-- Error always overrides Git status.
				if has_error(buffer) then
					return C.red
				end

				local status = git_cache[buffer.number]

				if status == "untracked" then
					return C.green
				elseif status == "modified" then
					return C.yellow
				elseif status == "staged" then
					return C.cyan
				end

				return buffer.is_focused and C.active or C.inactive
			end

			local function has_status_background(buffer)
				return has_error(buffer) or git_cache[buffer.number] ~= nil
			end

			local function buffer_fg(buffer)
				if has_status_background(buffer) then
					return C.dark
				end

				return buffer.is_focused and C.active_fg or C.fg
			end

			------------------------------------------------------------
			-- HIGHLIGHTS
			------------------------------------------------------------

			vim.api.nvim_set_hl(0, "CokelineCustomFill", {
				fg = C.fg,
				bg = C.fill,
				underline = false,
				undercurl = false,
			})

			------------------------------------------------------------
			-- REDRAW
			------------------------------------------------------------

			local function redraw()
				vim.schedule(function()
					vim.cmd("redrawtabline")
				end)
			end

			------------------------------------------------------------
			-- GIT STATUS
			--
			-- untracked -> +
			-- modified  -> ~
			-- staged    -> ✓
			--
			-- Git commands run outside rendering callbacks.
			------------------------------------------------------------

			local function update_git_status(bufnr)
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end

				local path = vim.api.nvim_buf_get_name(bufnr)

				if path == "" then
					git_cache[bufnr] = nil
					redraw()
					return
				end

				if git_pending[bufnr] then
					git_refresh_needed[bufnr] = true
					return
				end

				git_pending[bufnr] = true

				vim.system({
					"git",
					"-C",
					vim.fn.fnamemodify(path, ":h"),
					"status",
					"--porcelain=v1",
					"--",
					path,
				}, { text = true }, function(result)
					vim.schedule(function()
						git_pending[bufnr] = nil

						if not vim.api.nvim_buf_is_valid(bufnr) then
							git_cache[bufnr] = nil
							git_refresh_needed[bufnr] = nil
							return
						end

						if result.code ~= 0 then
							git_cache[bufnr] = nil
						else
							local line = (result.stdout or ""):match("[^\r\n]+")

							if not line then
								git_cache[bufnr] = nil
							else
								local x = line:sub(1, 1)
								local y = line:sub(2, 2)

								local status

								if x == "?" and y == "?" then
									status = "untracked"
								elseif x ~= " " and x ~= "?" then
									-- Staged takes priority over unstaged changes.
									status = "staged"
								elseif y ~= " " then
									status = "modified"
								end

								git_cache[bufnr] = status
							end
						end

						redraw()

						if git_refresh_needed[bufnr] then
							git_refresh_needed[bufnr] = nil
							update_git_status(bufnr)
						end
					end)
				end)
			end

			local function update_all_git_status()
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if vim.bo[bufnr].buflisted then
						update_git_status(bufnr)
					end
				end
			end

			------------------------------------------------------------
			-- GIT ICON
			------------------------------------------------------------

			local function git_icon(buffer)
				local status = git_cache[buffer.number]

				if status == "untracked" then
					return "+ "
				elseif status == "modified" then
					return "~ "
				elseif status == "staged" then
					return "✓ "
				end

				return ""
			end

			------------------------------------------------------------
			-- MOUSE
			------------------------------------------------------------

			local function tab_click(_, _, button, _, buffer)
				if button == "m" then
					buffer:delete()
				elseif button == "l" then
					buffer:focus()
				end
			end

			local function close_click(_, _, button, _, buffer)
				if button == "l" or button == "m" then
					buffer:delete()
				end
			end

			------------------------------------------------------------
			-- AUTOCMDS
			------------------------------------------------------------

			local group = vim.api.nvim_create_augroup("CustomCokelineGitStatus", { clear = true })

			vim.api.nvim_create_autocmd({
				"BufReadPost",
				"BufNewFile",
				"BufEnter",
				"BufWritePost",
				"FocusGained",
				"TermClose",
			}, {
				group = group,

				callback = function(args)
					if args.event == "FocusGained" or args.event == "TermClose" then
						update_all_git_status()
					else
						update_git_status(args.buf)
					end
				end,
			})

			vim.api.nvim_create_autocmd({
				"BufDelete",
				"BufWipeout",
			}, {
				group = group,

				callback = function(args)
					git_cache[args.buf] = nil
					git_pending[args.buf] = nil
					git_refresh_needed[args.buf] = nil
				end,
			})

			------------------------------------------------------------
			-- DIAGNOSTIC REFRESH
			--
			-- Redraw immediately when LSP errors appear/disappear.
			------------------------------------------------------------

			vim.api.nvim_create_autocmd("DiagnosticChanged", {
				group = group,

				callback = function()
					redraw()
				end,
			})

			------------------------------------------------------------
			-- COKELINE
			------------------------------------------------------------

			require("cokeline").setup({
				show_if_buffers_are_at_least = 1,

				-- Hide tabpage section.
				tabs = false,

				-- No custom right-hand components.
				rhs = false,

				fill_hl = "CokelineCustomFill",

				default_hl = {
					fg = buffer_fg,
					bg = buffer_bg,
				},

				components = {
					------------------------------------------------------
					-- LEFT ROUNDED / SLOPED CORNER
					------------------------------------------------------

					{
						-- text = "",
						text = "",
						-- text = " ",
						fg = buffer_bg,
						bg = C.fill,

						on_click = tab_click,
					},

					------------------------------------------------------
					-- GIT STATUS
					------------------------------------------------------

					{
						text = function(buffer)
							local icon = git_icon(buffer)

							if icon == "" then
								return " "
							end

							return " " .. icon
						end,

						fg = buffer_fg,
						bg = buffer_bg,
						bold = true,

						on_click = tab_click,
					},

					------------------------------------------------------
					-- FILE ICON
					------------------------------------------------------

					{
						text = function(buffer)
							local indicator = buffer.is_focused and "┃ " or ""
							local icon = buffer.devicon and buffer.devicon.icon or "󰈙"

							return indicator .. icon .. " "
						end,

						fg = function(buffer)
							if has_status_background(buffer) then
								return C.dark
							end

							return buffer.devicon and buffer.devicon.color or C.fg
						end,

						bg = buffer_bg,
						on_click = tab_click,
					},

					------------------------------------------------------
					-- FILENAME
					------------------------------------------------------
					{
						text = function(buffer)
							-- local indicator = buffer.is_focused and "┃ " or ""

							-- return indicator .. buffer.filename .. " "
							return buffer.filename .. " "
						end,

						fg = buffer_fg,
						bg = buffer_bg,

						bold = function(buffer)
							return buffer.is_focused
						end,

						on_click = tab_click,
					},

					------------------------------------------------------
					-- DIAGNOSTIC ERROR
					------------------------------------------------------

					{
						text = function(buffer)
							return has_error(buffer) and "✕ " or ""
						end,

						fg = C.dark,
						bg = buffer_bg,
						bold = true,

						on_click = tab_click,
					},

					------------------------------------------------------
					-- UNSAVED BUFFER
					------------------------------------------------------

					{
						text = function(buffer)
							return buffer.is_modified and "● " or ""
						end,

						fg = function(buffer)
							if has_status_background(buffer) then
								return C.dark
							end

							return C.yellow
						end,

						bg = buffer_bg,
						on_click = tab_click,
					},

					------------------------------------------------------
					-- CLOSE BUTTON
					------------------------------------------------------

					{
						text = "× ",

						fg = function(buffer)
							if has_status_background(buffer) then
								return C.dark
							end

							return buffer.is_hovered and C.red or C.muted
						end,

						bg = buffer_bg,

						on_click = close_click,
					},

					------------------------------------------------------
					-- RIGHT ROUNDED / SLOPED CORNER
					------------------------------------------------------

					{
						-- text = "",
						text = "",
						-- text = " ",
						fg = buffer_bg,
						bg = C.fill,

						on_click = tab_click,
					},

					------------------------------------------------------
					-- GAP
					------------------------------------------------------

					-- {
					-- 	text = " ",
					--
					-- 	fg = C.fill,
					-- 	bg = C.fill,
					-- },
				},
			})

			------------------------------------------------------------
			-- INITIAL GIT STATUS
			------------------------------------------------------------

			update_all_git_status()
		end,
	},
}
