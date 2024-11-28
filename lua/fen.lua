local M = {}

local util = require("fen.util")

local defaultBorder = "rounded"
local defaultTitle = "FEN"
local defaultHeightMultiplier = 0.8
local defaultWidthMultiplier = 0.8
local defaultDisableNoWrite = false

local border = defaultBorder
local title = defaultTitle
local heightMultiplier = defaultHeightMultiplier
local widthMultiplier = defaultWidthMultiplier
local disableNoWrite = defaultDisableNoWrite

function M.setup(options)
	border = options.border or defaultBorder
	title = options.title or defaultTitle
	widthMultiplier = options.width or defaultWidthMultiplier
	heightMultiplier = options.height or defaultHeightMultiplier
	disableNoWrite = options.disable_no_write
end

function M.show()
	local currentBufName = vim.api.nvim_buf_get_name(0)
	local tempFile = vim.fn.tempname()

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("bufhidden", "wipe", {buf = buf})
	vim.api.nvim_set_option_value("modifiable", false, {buf = buf})
	vim.api.nvim_create_autocmd({"TermOpen"}, {
		buffer = buf,
		callback = function()
			vim.api.nvim_buf_set_name(buf, title)
		end
	})

	local win
	local resizeAutocmdId

	local function open_window()
		local height = math.floor(vim.o.lines * heightMultiplier)
		local width = math.floor(vim.o.columns * widthMultiplier)

		local winOpts = {
			style = "minimal",
			relative = "editor",
			width = width,
			height = height,
			row = math.floor((vim.o.lines - height) / 2),
			col = math.floor((vim.o.columns - width) / 2),
			border = border,
		}

		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_set_config(win, winOpts)
		else
			win = vim.api.nvim_open_win(buf, true, winOpts)
			if not win or win == 0 then
				print("fen.nvim: failed to open window")
				return
			end
		end

		vim.api.nvim_set_current_win(win)
	end

	open_window()

	resizeAutocmdId = vim.api.nvim_create_autocmd({"VimResized"}, {
		callback = function ()
			open_window()
		end
	})

	local function close_window()
		if resizeAutocmdId then
			vim.api.nvim_del_autocmd(resizeAutocmdId)
			resizeAutocmdId = nil
		end

		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

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
		if disableNoWrite then
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

				close_window()
			end
		})
	end
end

return M
