menu = love.graphics.newImage('resources/Menu.png')
playbutton = love.graphics.newImage('resources/PlayButton.png')

Menu = {} 

--Initialize the board (object orientation style)
function Menu:new()
    tablestate = {}
    self.__index = self
    return setmetatable(tablestate, self)
end

--Method to draw the pieces on the board
function Menu:draw()
    imageScaleX,imageScaleY = getScaling(menu)    
    love.graphics.draw(menu, 0, 0,0,imageScaleX,imageScaleY) 

    imageScaleX,imageScaleY = getScaling(playbutton)
    love.graphics.draw(playbutton,love.graphics.getWidth()/4,love.graphics.getHeight()/2,0,imageScaleX/4,imageScaleY/8)
end

function Menu:ProcessInput(x,y)
    imageScaleX,imageScaleY = getScaling(playbutton)    
    buttonStartX = love.graphics.getWidth()/4
    buttonEndX = love.graphics.getWidth()/4 + (imageScaleX/4) * playbutton:getWidth()
    buttonStartY = love.graphics.getHeight()/2
    buttonEndY = love.graphics.getHeight()/2 + imageScaleY/8 * playbutton:getHeight()
    print (buttonStartY .. ' ' .. buttonEndY .. ' ' .. y)
    if x < buttonEndX and x > buttonStartX and y < buttonEndY and y > buttonStartY then
        return true
    end
    return false
end

function getScaling(drawable,canvas)
	local canvas = canvas or nil

	local drawW = drawable:getWidth()
	local drawH = drawable:getHeight()

	local canvasW = 0
	local canvasH = 0
		
	if canvas then
		canvasW = canvas:getWidth()
		canvasH = canvas:getHeight()
	else
		canvasW = love.graphics.getWidth()
		canvasH = love.graphics.getHeight()
	end

	local scaleX = canvasW / drawW
	local scaleY = canvasH / drawH

	return scaleX, scaleY
end