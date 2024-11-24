local M = {}

-- Returns the "1.7.18" part of `fen --version`
function M.fenVersion()
	local version = vim.fn.system("fen --version")
	--return version:sub(5, -2) -- "fen v"
	--return version:sub(6, -2) -- "fen v"
	return version:sub(6, -2) -- "fen v"
end

local function isDigit(c)
	return c >= '0' and c <= '9'
end

-- Returns true is the input only contains digits and '.' characters
function M.isFenVersionValid(version)
	for i = 1, #version do
		local c = version:sub(i,i)
		if c ~= '.' and not isDigit(c) then
			return false
		end
	end

	return true
end

-- Returns true if the installed fen version is v1.7.18 or higher (except if the major version changed)
function M.isFenVersionSupported()
	local version = M.fenVersion()

	local major = ""
	local minor = ""
	local patch = ""
	local versionSectionIdx = 1
	for i = 1, #version do
		local c = version:sub(i,i)
		if c == '.' then
			versionSectionIdx = versionSectionIdx + 1
			goto continue
		end

		if not isDigit(c) then
			return false
		end

		if versionSectionIdx == 1 then
			major = major .. c
		elseif versionSectionIdx == 2 then
			minor = minor .. c
		elseif versionSectionIdx == 3 then
			patch = patch .. c
		else
			return false
		end

	    ::continue::
	end

	local majorNum = tonumber(major)
	local minorNum = tonumber(minor)
	local patchNum = tonumber(patch)

	if majorNum ~= 1 then
		return false -- Should not happen, unless fen has a v2.x.x release at some point
	end

	if minorNum ~= 7 then
		return minorNum > 7
	end

	if patchNum < 18 then
		return false
	end

	return true
end

return M
