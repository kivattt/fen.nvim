local M = {}

local util = require("fen.util")

local border = "rounded"
local noWrite = true

function M.setup(options)
	border = options.border or "rounded"
	noWrite = options.no_write or true
end

function M.show()
	local currentBufName = vim.api.nvim_buf_get_name(0)
	local tempFile = vim.fn.tempname()

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
	vim.api.nvim_set_option_value("modifiable", false, {buf = buf})

	local height = math.ceil(vim.o.lines * 0.8)
	local width = math.ceil(vim.o.columns * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = math.ceil((vim.o.lines) / 2),
		col = math.ceil((vim.o.columns) / 2),
		border = border,
	})

	vim.api.nvim_set_current_win(win)
	--vim.api.nvim_set_hl(0, 'Terminal', {})

	if not util.isFenVersionSupported() then
		vim.cmd("quit")

		local version = util.fenVersion()
		if not util.isFenVersionValid(version) then
			print("improper fen installation? invalid version text found")
		else
			print("fen version v" .. util.fenVersion() .. " is too old!")
		end
	else
		vim.cmd.startinsert()
		local noWriteArg = "--no-write"
		if not noWrite then
			noWriteArg = ""
		end
		vim.fn.termopen("fen " .. noWriteArg .. " --close-on-escape --terminal-title=false --print-path-on-open " .. currentBufName .. " > " .. tempFile, {
			on_exit = function (_, exitCode, _)
				vim.cmd("quit")

				if exitCode ~= 0 then
					print("fen closed with a non-zero exit code")
					os.remove(tempFile)
					return
				end

				for line in io.lines(tempFile) do
					vim.cmd("tabnew " .. line)
				end

				os.remove(tempFile)

				if vim.api.nvim_win_is_valid(win) then
					vim.api_nvim_win_close(win, true)
				end
			end
		})
	end
end

return M
