local log = hs.logger.new('init', 'debug')

-- Helpers
local function downloadFile(url, outDir, callback)
	local fileName = hs.http.urlParts(url).lastPathComponent
	local filePath = outDir .. "/" .. fileName;
	log.i("Downloading '" .. fileName .. "'...")
	hs.http.asyncGet(url, nil, function(status, body)
		if status == 200 and body then
			if not hs.fs.attributes(outDir) then
				hs.fs.mkdir(outDir)
			end
			local file = io.open(filePath, "wb")
			if file then
				file:write(body)
				file:close()
				callback(filePath)
				return
			end
		end
		log.e("Unable to download file '" .. fileName .. "'. [HTTP " .. tostring(status) .. "]")
	end)
end

local function unzipFile(zipPath, outDir, callback)
	log.i("Unzipping '" .. zipPath .. "'...")
	hs.task.new("/usr/bin/unzip", function(exitCode)
		os.remove(zipPath)
		if exitCode ~= 0 then
			log.e("Unable to unzip file " .. "'" .. zipPath "'.")
		end
		callback()
	end, { "-q", "-o", zipPath, "-d", outDir }):start()
end

local function loadSpoonInstall()
	---@class spoon.SpoonInstall
	local SpoonInstall = hs.loadSpoon("SpoonInstall")

	SpoonInstall:asyncUpdateRepo("default", function(repo, success)
		SpoonInstall:andUse("EmmyLua")
	end)
end

local function setupSpoonInstall()
	local spoonsDir = hs.configdir .. "/Spoons"
	local spoonInstallDir = spoonsDir .. "/SpoonInstall.spoon"
	local downloadUrl = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip"

	if not hs.fs.attributes(spoonInstallDir) then
		downloadFile(downloadUrl, spoonsDir, function(filePath)
			unzipFile(filePath, spoonsDir, loadSpoonInstall)
		end)
	else
		loadSpoonInstall()
	end
end

-- Configuration
setupSpoonInstall()

-- Change scroll direction when using mouse
ScrollWheelInverter = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel }, function(event)
	local isTrackpad = event:getProperty(hs.eventtap.event.properties.scrollWheelEventIsContinuous)
	if isTrackpad == 1 then
		return false
	end
	for _, axis in ipairs({ "scrollWheelEventDeltaAxis1", "scrollWheelEventDeltaAxis2" }) do
		local propertyId = hs.eventtap.event.properties[axis]
		event:setProperty(propertyId, -event:getProperty(propertyId))
	end
	return false
end):start()
