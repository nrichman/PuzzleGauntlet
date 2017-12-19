tile = {}
tile.name = 'base'
tile.faded = false

--Used for positioning of all tiles on the board
tile.x = -1
tile.y = -1
tile.from = 7


--Used only for the management tiles
tile.matched = 0


function tile:new()
    newObj = {sound = 'woof'}
    self.__index = self
    return setmetatable(newObj, self)
end

function tile:canMatch(other_tile)
    if other_tile.name == self.name then
        return true
    end
    return false
end