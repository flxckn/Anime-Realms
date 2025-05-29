local KeyHandler = {}

local isTesting = true
local keyVersion = -9
local isStudio = game["Run Service"]:IsStudio()

function KeyHandler:GetKey()
	local key
	if isTesting then
		if isStudio then
			key = "STUDIO_TESTING_VERSION_" .. keyVersion
		else
			key = "GAME_TESTING_VERSION_" .. keyVersion
		end
	else
		if isStudio then
			key = "STUDIO_MAIN_VERSION_" .. keyVersion
		else
			key = "GAME_MAIN_VERSION_" .. keyVersion
		end
	end
	
	print("\n\nVersion: \n[ " .. key .. " ]\n\n")
	return key
end

return KeyHandler