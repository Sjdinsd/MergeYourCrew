local VFX = {}

function VFX.init()
	for _, module in script:GetChildren() do
		VFX[module.Name] = require(module)
	end
end

return VFX
