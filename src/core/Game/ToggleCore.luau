-- Created and managed by:
--  oooooooo8 ooooo ooooooooo  ooooo oooo   oooo oooooooo8 ooooooooo
-- 888         888   888    88o 888   8888o  88 888         888    88o
--  888oooooo  888   888    888 888   88 888o88  888oooooo  888    888
--         888 888   888    888 888   88   8888         888 888    888
-- o88oooo888  888  o888ooo88  o888o o88o    88 o88oooo888 o888ooo88
--          8o888

local StarterGui = game:GetService("StarterGui")

return function(coreGuiType: Enum.CoreGuiType, enabled: boolean)
	StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
end
