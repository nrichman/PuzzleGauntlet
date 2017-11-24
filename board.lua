tile_armor = require 'Tiles/tile_armor'
tile_sword = require 'Tiles/tile_sword'

--Starting X,Y and width/height for each tile
blockX = love.graphics.getWidth()/6
blockY = love.graphics.getHeight()/10.66666

--Initialize a board
Board = {}
for i=1,6 do
    Board[i] = {}
    for j=1,6 do
        Board[i][j] = tile_sword
    end
end

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

--Method to draw the pieces on the board
function Board:draw()
    imageScaleX,imageScaleY = getScaling(tile_armor.image)    
    --Iterate over the table of the board. Keys represent spaces on the board, values represent pieces
    for i=1,6 do
        for j=1,6 do
            love.graphics.draw(Board[i][j].image,blockX * (i-1),blockY * (j+1/3),0,imageScaleX/6,imageScaleY/10.6666)       
        end
    end

    --love.graphics.draw(x_piece,0,0)
end

function Board:clear()
    for k in pairs (self) do
        self[k] = nil
    end
end

function Board:isTouched(x,y)

end

function Board:getTile(x,y)
    thisX = math.floor(x / (love.graphics.getWidth() / 6))
    thisY = math.floor((y / (love.graphics.getHeight() / 10.66666) + 1.6666))

    if thisY <= 2 or thisY >= 9 then return false end

    Board[thisX+1][thisY-2]:getType()
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