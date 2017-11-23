tile = {}
tile.name = 'base'

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
