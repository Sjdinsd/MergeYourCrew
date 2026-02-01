local ReplicatedStorage = game:GetService("ReplicatedStorage")

local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable

local ComponentSets = require(ReplicatedStorage.Source.Features.App.Modules.ComponentSets)
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)

local UIController = {}

function UIController.init(self: UIController)
	self.shownComponents = ComponentSets.IniitalComponents
	self.shownMenu = nil
	self:updateComponents()
end

function UIController.updateComponents(self: UIController)
	UISlice.shownComponents(table.clone(self.shownComponents))
end

function UIController.toggleComponent(self: UIController, component)
	local idx = table.find(self.shownComponents, component)
	if idx then
		table.remove(self.shownComponents, idx)
	else
		table.insert(self.shownComponents, component)
	end
	self:updateComponents()
end

function UIController.showComponent(self: UIController, component)
	if not table.find(self.shownComponents, component) then
		table.insert(self.shownComponents, component)
		UISlice.shownComponents(table.clone(self.shownComponents))
	end
end
function UIController.bulkShowComponents(self: UIController, components: { string })
	for _, component in components do
		if not table.find(self.shownComponents, component) then
			table.insert(self.shownComponents, component)
		end
	end
	UISlice.shownComponents(table.clone(self.shownComponents))
end

function UIController.hideComponent(self: UIController, component)
	local idx = table.find(self.shownComponents, component)
	if idx then
		table.remove(self.shownComponents, idx)
		UISlice.shownComponents(table.clone(self.shownComponents))
	end
end
function UIController.bulkHideComponent(self: UIController, components: { string })
	for _, component in components do
		local idx = table.find(self.shownComponents, component)
		if idx then
			table.remove(self.shownComponents, idx)
		end
	end
	UISlice.shownComponents(table.clone(self.shownComponents))
end

function UIController.clearComponents(self: UIController)
	self.shownComponents = {}
	UISlice.shownComponents(self.shownComponents)
end

function UIController.toggleMenu(self: UIController, menu)
	local currentMenu = self.shownMenu
	if currentMenu == menu then
		UISlice.shownMenu(nil)
	else
		UISlice.shownMenu(menu)
	end
	self.shownMenu = UISlice.shownMenu()
end

export type UIController = typeof(UIController) & {
	shownComponents: { string },
	shownMenu: string?,
}

return UIController :: UIController
--[[
-- Focuses:
- # Troop selection UI
- Equipping troops server sided
- Spawning enemies,
- Connecting Troops to heartbeat to fight back against enemies
]]
