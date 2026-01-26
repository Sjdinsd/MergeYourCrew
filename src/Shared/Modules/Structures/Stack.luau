local Stack = {}
Stack.__index = Stack

-- Uses tail of table in compliance with luau table library
function Stack.new()
	local self = {}
	self._items = {}

	return setmetatable(self, Stack)
end

function Stack:GetItems(): { any }
	return table.clone(self._items)
end

function Stack:Push(element)
	table.insert(self._items, element)
end

function Stack:Pop()
	return table.remove(self._items)
end

function Stack:Peek()
	return self._items[#self._items]
end

function Stack:isEmpty()
	return #self._items == 0
end

function Stack:Size()
	return #self._items
end

function Stack:ForceRemove(idx: number)
	return table.remove(self._items, idx)
end

function Stack:FindFirstInstance(element: any)
	for i = #self._items, 1, -1 do
		if i == element or typeof(i) == typeof(element) then
			return i
		end
	end
	return nil
end

return Stack
