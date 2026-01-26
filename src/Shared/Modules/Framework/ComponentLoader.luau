-- Created and managed by:
--  oooooooo8 ooooo ooooooooo  ooooo oooo   oooo oooooooo8 ooooooooo
-- 888         888   888    88o 888   8888o  88 888         888    88o
--  888oooooo  888   888    888 888   88 888o88  888oooooo  888    888
--         888 888   888    888 888   88   8888         888 888    888
-- o88oooo888  888  o888ooo88  o888o o88o    88 o88oooo888 o888ooo88
--          8o888

local CollectionService = game:GetService("CollectionService")

return function(componentDir: Folder, ...)
	for _, unloadedComponent in componentDir:GetChildren() do
		if unloadedComponent.ClassName ~= "ModuleScript" then
			continue
		end
		local success, result = pcall(require, unloadedComponent)
		if success and result.new and result.destroy then
			if result.init then
				result.init(...)
			end

			CollectionService:GetInstanceAddedSignal(result.tag):Connect(result.new)
			CollectionService:GetInstanceRemovedSignal(result.tag):Connect(result.destroy)

			for _, model in CollectionService:GetTagged(result.tag) do
				result.new(model)
			end
		elseif not success then
			warn(result)
		end
	end
end
