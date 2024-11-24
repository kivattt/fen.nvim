local M = {}

local util = require("fen.util")

M.check = function ()
	vim.health.start("fen installed? (required)")
	if vim.fn.executable("fen") ~= 1 then
		vim.health.error("fen not installed, see: https://github.com/kivattt/fen")
	else
		if not util.isFenVersionSupported() then
			local version = util.fenVersion()
			if not util.isFenVersionValid(version) then
				vim.health.error("improper fen installation? invalid version text found")
			else
				vim.health.error("fen version " .. util.fenVersion() .. " is too old!")
			end
		end
		vim.health.ok("fen installed")
	end
end

return M
