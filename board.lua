tile_armor = require 'Tiles/tile_armor'
tile_sword = require 'Tiles/tile_sword'

--Starting X,Y and width/height for each tile
blockX = love.graphics.getWidth()/6
blockY = love.graphics.getHeight()/10.66666

function randomTile()
    random = love.math.random(1,2)
    if random == 1 then
        return tile_sword:new()
    end
    return tile_armor:new()
end

--Initialize a board
Board = {}
for i=1,6 do
    Board[i] = {}
    for j=1,6 do
        --if i % 2 == 0 then
            Board[i][j] = randomTile()
            Board[i][j].x = i
            Board[i][j].y = j
            Board[i][j].dropfrom = j
        --else Board[i][j] = tile_armor:new()
        --end
    end
end

--Initialize the board (object orientation style)
function Board:new()
    tablestate = {}
    self.__index = self
    self.matching = false
    self.matched = 'base'
    self.matchlist = {}
    self.prevpos = {x = 0, y = 0}
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
            if self[i][j] == nil then goto continue end

            if self[i][j].dropfrom ~= j then
                dt = 5 * love.timer.getDelta()
                print(dt)
                love.graphics.draw(self[i][j].image,blockX * (i-1),blockY * (self[i][j].dropfrom+(1/3)),0,imageScaleX/6,imageScaleY/10.6666)
                self[i][j].dropfrom = self[i][j].dropfrom + dt

                if self[i][j].dropfrom > j then
                    self[i][j].dropfrom = j
                end
                goto continue
            end

            if self[i][j].faded == true then love.graphics.setColor(43,43,43)
            else love.graphics.setColor(255,255,255) end
            love.graphics.draw(self[i][j].image,blockX * (i-1),blockY * (j+1/3),0,imageScaleX/6,imageScaleY/10.6666) 
            ::continue::     
        end
    end
    --love.graphics.draw(x_piece,0,0)
end

function Board:clear()
    for k in pairs (self) do
        self[k] = nil
    end
end

--Checks if the tiles are adjancent
function Board:proximityMatch(thisX,thisY)
    for i=-1,1 do
        for j=-1,1 do
            if thisX+i == self.prevpos.x and thisY+j == self.prevpos.y and self[thisX][thisY].faded == false then return true end
        end
    end
    return false
end

--Drag the match to another tile
function Board:tileDrag(x,y)
    widthval = x / (love.graphics.getWidth() / 6)
    heightval = y / (love.graphics.getHeight() / 10.66666) + 1.666666

    thisX = math.floor(widthval)
    thisY = math.floor(heightval)

    --Lower hitboxes a bit to make diagonal swipes easier
    if widthval - thisX > 0.85 then return end
    if heightval - thisY > 0.85 then return end
    if widthval - thisX < 0.15 then return end
    if heightval - thisY < 0.15 then return end

    --If we're out of bounds, cancel the matching
    if thisY <= 2 or thisY >= 9 then self:handsOff() return end

    --If we're hovering another tile and it's adjacent, highlight and add it to the list
    if self[thisX+1][thisY-2].name == self.matched and self:proximityMatch(thisX+1,thisY-2) then
        self.matchlist[#self.matchlist + 1] = self[thisX+1][thisY-2]
        self[thisX+1][thisY-2].faded = true
        self.prevpos.x = thisX+1
        self.prevpos.y = thisY-2
        --self.matched = self[thisX+1][thisY-2]
    end
end

--Selected the first tile
function Board:tileSelected(x,y)
    thisX = math.floor(x / (love.graphics.getWidth() / 6))
    thisY = math.floor((y / (love.graphics.getHeight() / 10.66666) + 1.6666))
    if thisY <= 2 or thisY >= 9 then return false end

    self.matching = true
    self[thisX+1][thisY-2].faded = true
    self.matched = self[thisX+1][thisY-2].name
    self.matchlist[#self.matchlist + 1] = self[thisX+1][thisY-2]
    self.prevpos.x = thisX+1
    self.prevpos.y = thisY-2
end

function Board:processMatch()
    if #self.matchlist < 3 then
        self:handsOff()
        return
    end

    --For each element in the list of matches, get its x and y position on the board and remove it
    for i=1,#self.matchlist do
        print(self.matchlist[i].x  .. ' ' .. self.matchlist[i].y)
        self[self.matchlist[i].x][self.matchlist[i].y] = nil
    end
    --self:generateTiles()
    self:dropTiles()
    return 
end

function Board:handsOff()
    self.matching = false
    self.matched = 'base'
    self.matchlist = {}
    for i=1,6 do
        for j=1,6 do
            if self[i][j] == nil then goto continue end
                self[i][j].faded = false
            ::continue::
        end
    end
end

--Generates all of the tiles
function Board:generateTiles()
    for i=1,6 do
        for j=1,6 do
            if self[i][j] == nil then
                --The empty tile is on the top row
                if i == 1 then
                    self:createTile(i,j)
                else
                    self:createTile(i,j)
                end
            end
        end
    end
end

--Randomly creates a tile 
function Board:createTile(i,j,drop)
    random = love.math.random(1,2)
    if random == 1 then
        self[i][j] = tile_sword:new()
    else
        self[i][j] = tile_armor:new()
    end
    self[i][j].x = i
    self[i][j].y = j
    self[i][j].dropfrom = drop
end

--Moves all tiles down if there is an empty space below them
function Board:dropTiles()
    --Drops all tiles down to their lowest points
    ::restart::
    for i=1,6,1 do
        --Check to see if we've finished dropping everything
        dropped = false
        for j=1,6,1 do
            if self[i][j] == nil then
                if self[i][j-1] ~= nil then
                    dropped = true
                    self[i][j] = self[i][j-1]
                    --If we need it to be dropped from a higher position
                    if j-1 < self[i][j-1].dropfrom then
                        self[i][j].dropfrom = j-1
                    end      
                    self[i][j].y = j
                    self[i][j-1] = nil
                end
                --If we haven't finished dropping something, restart
                if dropped then
                    goto restart
                end
            end
        end
    end

    for i=1,6 do
        todrop = 0
        for j=6,1,-1 do
            if self[i][j] == nil then
                self:createTile(i,j,todrop)
                todrop = todrop - 1
            end
        end
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