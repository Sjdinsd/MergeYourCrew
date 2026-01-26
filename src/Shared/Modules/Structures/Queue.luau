local Queue = {}
Queue.__index = Queue

function Queue.new(startingSet, maxItems)
	local self = {}
	self._items = startingSet or {}
	self._maxItems = maxItems

	return setmetatable(self, Queue)
end

export type Queue = typeof(Queue.new({}, 0))

function Queue:Enqueue(element: any)
	if self._maxItems and #self._items >= self._maxItems then
		return false
	end

	table.insert(self._items, element)
	return true
end

function Queue:Dequeue()
	return table.remove(self._items, 1)
end

function Queue:BulkQueue(bulkElements: { any })
	-- for _, element in bulkElements do
	-- 	self:Enqueue(element)
	-- end
	table.move(bulkElements, 1, #bulkElements, #self._items + 1, self._items)
end

function Queue:Peek(): any
	return self._items[1]
end
function Queue:PeekLast(): any
	return self._items[#self._items]
end

function Queue:isEmpty(): boolean
	return #self._items == 0
end

function Queue:isFull(): boolean
	return self._maxItems and self._maxItems <= #self._items
end

function Queue:GetElementsInQueue(): { any }
	return table.clone(self._items)
end

function Queue:ChangeMaxItemCount(number)
	self._maxItems = number
end

function Queue:Clear(): { any }
	local oldElements = self:GetElementsInQueue()
	self._items = {}

	return oldElements
end

function Queue:Contains(element)
	return table.find(self._items, element)
end

function Queue:ForceRemove(idx)
	local element = self._items[idx]
	if not element then
		return
	end

	return table.remove(self._items, idx)
end

return Queue
