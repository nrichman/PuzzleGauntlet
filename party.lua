job_knight = require 'Jobs/knight'

--Starting X,Y and width/height for each tile
blockX = love.graphics.getWidth()/6
blockY = love.graphics.getHeight()/10.66666

--Initialize a party
Party = {job_knight,job_knight,job_knight}
function Party:new()
    tablestate = {job_knight,job_healer,job_knight}
    self.__index = self
    return setmetatable(tablestate, self)
end

--Method to draw the pieces on the board
function Party:draw()
    --print (self[1].type)
    --imageScaleX,imageScaleY = getScaling(tile_armor.image)
    
    --Iterate over the table of the board. Keys represent spaces on the board, values represent pieces
end

function getScaling(drawable)
	local drawW = drawable:getWidth()
    local drawH = drawable:getHeight()
    
	canvasW = love.graphics.getWidth()
	canvasH = love.graphics.getHeight()

	local scaleX = canvasW / drawW
	local scaleY = canvasH / drawH

	return scaleX, scaleY
end