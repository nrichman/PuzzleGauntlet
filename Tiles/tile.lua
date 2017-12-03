tile = {}
tile.name = 'base'
tile.faded = false
tile.x = -1
tile.y = -1
tile.from = 7

function tile:new()
    newObj = {sound = 'woof'}
    self.__index = self
    return setmetatable(newObj, self)
end

function tile:getType()
    print(self.name)
end

function tile:canMatch(other_tile)
    if other_tile.name == self.name then
        return true
    end
    return false
end
