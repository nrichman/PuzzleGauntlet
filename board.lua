
Board = {} 
x_piece = love.graphics.newImage('resources/x_piece.png')
o_piece = love.graphics.newImage('resources/o_piece.png')

--[[

#############
# 1 # 4 # 7 #
#############
# 2 # 5 # 8 #
#############
# 3 # 6 # 9 #
#############

]]--

--Initialize the board (object orientation style)
function Board:new()
    tablestate = {}
    self.__index = self
    return setmetatable(tablestate, self)
end

--Set a piece on the board. Returns true if successful
function Board:setToken(n, turn)
    if n == nil then return false end
    if self[n] ~= nil then return false end
    
    if turn == 'x' then
        self[n] = x_piece
    else 
        self[n] = o_piece
    end

    return true
end

function Board:checkWinner()
    if self[1] ~= nil then
        if (self[1] == self[2] and self[1] == self[3]) or 
            (self[1] == self[4] and self[1] == self[7]) or 
            (self[1] == self[5] and self[1] == self[9]) 
            then return turn 
        end
    end
    if self[9] ~= nil then
        if (self[9] == self[8] and self[9] == self[7]) or 
            (self[9] == self[6] and self[9] == self[3])
            then return turn 
        end
    end
    if self[5] ~= nil then
        if (self[2] == self[5] and self[5] == self[8]) or
            (self[4] == self[5] and self[5] == self[6]) or
            (self[3] == self[5] and self[5] == self[7])
            then return turn
        end
    end

    if self[1] ~= nil and
        self[2] ~= nil and
        self[3] ~= nil and 
        self[4] ~= nil and
        self[5] ~= nil and
        self[6] ~= nil and
        self[7] ~= nil and 
        self[8] ~= nil and
        self[9] ~= nil then
        return 'tie'
    end
    return '' 
end

--Method to draw the pieces on the board
function Board:draw()
    --Iterate over the table of the board. Keys represent spaces on the board, values represent pieces
    for key,value in pairs(self) do
        xpos = 0
        ypos = 0

        --Pretty ugly. Uses the chart above to draw our pieces at whatever coords
        if key == 2 or key == 5 or key == 8 then ypos = ypos + love.graphics.getHeight()/3 end
        if key == 3 or key == 6 or key == 9 then ypos = ypos + love.graphics.getHeight() * 2 / 3 end

        if key == 4 or key == 5 or key == 6 then xpos = xpos + love.graphics.getWidth()/3 end
        if key == 7 or key == 8 or key == 9 then xpos = xpos + love.graphics.getWidth() * 2 / 3 end

        imageScaleX,imageScaleY = getScaling(value)
        love.graphics.draw(value, xpos, ypos,0,imageScaleX/3,imageScaleY/3) 
    end
    --love.graphics.draw(x_piece,0,0)
end

function Board:clear()
    for k in pairs (self) do
        self[k] = nil
    end
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