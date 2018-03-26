job_knight = require 'Jobs/knight'

--Starting X,Y and width/height for each tile
blockX = love.graphics.getWidth()/3
blockY = love.graphics.getHeight()/5.333333

healthX = love.graphics.getWidth()/3
healthY = love.graphics.getHeight()/16
healthdamage = love.graphics.newImage('resources/health_damage.png')

--Initialize a party
Party = {job_knight,job_knight,job_knight}
function Party:new()
    tablestate = {job_knight,job_healer,job_paladin}
    self.__index = self
    return setmetatable(tablestate, self)
end

--Method to draw the pieces on the board
function Party:draw()
    skip = 0
    for i=1,3 do
        imageScaleX,imageScaleY = getScaling(healthdamage)
        love.graphics.draw(healthdamage,
            love.graphics.newQuad(0,0,
                (self[i].health_current/self[i].health_max) * healthdamage:getWidth()*imageScaleX/3,healthdamage:getHeight()*imageScaleY/16,
                healthdamage:getWidth()*imageScaleX/3,healthdamage:getHeight()*imageScaleY/16),
            healthX * (i-1),healthY * 12,0)

        imageScaleX,imageScaleY = getScaling(self[i].image)
        love.graphics.draw(self[i].image,blockX * (i-1+skip),blockY*(9 - 1/3),0,imageScaleX/3,imageScaleY/5.3333)
        skip = skip + 1 
    end
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