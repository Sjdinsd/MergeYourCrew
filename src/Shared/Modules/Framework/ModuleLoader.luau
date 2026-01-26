-- Created and managed by:
--  oooooooo8 ooooo ooooooooo  ooooo oooo   oooo oooooooo8 ooooooooo
-- 888         888   888    88o 888   8888o  88 888         888    88o
--  888oooooo  888   888    888 888   88 888o88  888oooooo  888    888
--         888 888   888    888 888   88   8888         888 888    888
-- o88oooo888  888  o888ooo88  o888o o88o    88 o88oooo888 o888ooo88
--          8o888

local function init(unloadedModule, ...)
	local success, result = pcall(require, unloadedModule)
	if success and result.init and type(result.init) == "function" then
		result.init(...)
		return result
	elseif not success then
		warn(`{unloadedModule:GetFullName()}:\n\t- {result}`)
		return
	end
	return
end

return function(moduleOrFolder: Instance, ...)
	if moduleOrFolder:IsA("Folder") then
		local requiredModules = {}
		for _, unloadedModule in moduleOrFolder:GetChildren() do
			if unloadedModule.ClassName == "Folder" then
				return require(script)(unloadedModule)
			end
			requiredModules[unloadedModule.Name] = init(unloadedModule, ...)
		end

		return moduleOrFolder.Name, requiredModules
	else
		return moduleOrFolder.Name, init(moduleOrFolder, ...)
	end
end
