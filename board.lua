tile_armor = require 'Tiles/tile_armor'
tile_sword = require 'Tiles/tile_sword'
tile_staff = require 'Tiles/tile_staff'
tile_enemy = require 'Tiles/tile_enemy'

--Starting X,Y and width/height for each tile
blockX = love.graphics.getWidth()/6
blockY = love.graphics.getHeight()/10.66666

match_forwardslash = love.graphics.newImage('resources/match_forwardslash.png')
match_backslash = love.graphics.newImage('resources/match_backslash.png')
match_updown = love.graphics.newImage('resources/match_updown.png')
match_leftright = love.graphics.newImage('resources/match_leftright.png')
match_endpoint = love.graphics.newImage('resources/match_endpoint.png')


--self.tileList = { [tile_sword:new().name]=0 , [tile_armor:new().name]=0, [tile_staff:new().name]=0 }

--Initialize the board
Board = {}
function Board:new(party)
    tablestate = {}
    self.__index = self
    self.matching = false
    self.matched = 'base'
    self.matchlist = {}
    self.prevpos = {x = 0, y = 0}
    self.combatmatch = false
    self.tileList = {} --List of tiles on the board
    self.tileMatchList = {} --Count of each tile on a match
    self.party = party
    self.dropping = false

    --Populates lists
    for i=1,#party do
        if party[i].primary == 'sword' then
            self.tileMatchList[i] = tile_sword
            self.tileList[tile_sword:new().name]=0
        elseif party[i].primary == 'armor' then
            self.tileMatchList[i] = tile_armor
            self.tileList[tile_armor:new().name]=0
        elseif party[i].primary == 'staff' then
            self.tileMatchList[i] = tile_staff
            self.tileList[tile_staff:new().name]=0 
        end
    end

    self.tileMatchList[#party + 1] = tile_enemy
    self.tileList[tile_enemy:new().name]=0

    --Populates tiles
    for i=1,6 do
        self[i] = {}
        for j=1,6 do
            random = love.math.random(1,#self.tileMatchList)            
            self[i][j] = self.tileMatchList[random]:new()
            self[i][j].x = i
            self[i][j].y = j
            self[i][j].dropfrom = j
        end
    end
    return setmetatable(tablestate, self)
end

--Method to draw the pieces on the board
function Board:draw()
    imageScaleX,imageScaleY = getScaling(tile_armor.image)    
    --Iterate over the table of the board. Keys represent spaces on the board, values represent pieces
    drop_count = 0
    for i=1,6 do
        for j=1,6 do
            if self[i][j] == nil then goto continue end

            if self[i][j].dropfrom ~= j then
                drop_count = drop_count + 1
                dt = 5 * love.timer.getDelta()
                love.graphics.draw(self[i][j].image,blockX * (i-1),blockY * (self[i][j].dropfrom+(1/3)),0,imageScaleX/6,imageScaleY/10.6666)
                self[i][j].dropfrom = self[i][j].dropfrom + dt

                if self[i][j].dropfrom > j then
                    self[i][j].dropfrom = j
                end
                goto continue
            end

            self.dropping = true and drop_count > 0 or false
            print (self.dropping)

            if self[i][j].faded == true then love.graphics.setColor(43,43,43)
            else love.graphics.setColor(255,255,255) end
            love.graphics.draw(self[i][j].image,blockX * (i-1),blockY * (j+1/3),0,imageScaleX/6,imageScaleY/10.6666) 
            love.graphics.setColor(255,255,255)
            ::continue::     
        end
    end

    for i=1,#self.matchlist do
        love.graphics.draw(match_endpoint,blockX * (self.matchlist[i].x-1), blockY * (self.matchlist[i].y + (1/3)), 0,imageScaleX/6,imageScaleY/10.666)        
    end

    --Draw lines inbetween matched tiles
    for i=2,#self.matchlist do
        offset = 0
        prev = self.matchlist[i-1]
        slopex,slopey = prev.x - self.matchlist[i].x, prev.y - self.matchlist[i].y
            
        --Line that goes up and down
        if slopex == 0 then
            if slopey < 0 then offset = 1 end
            love.graphics.draw(match_updown,blockX * (self.matchlist[i].x-1), blockY * (self.matchlist[i].y + (1/3) - offset), 0,imageScaleX/6,imageScaleY/10.666)
        --Line that goes left to right     
        elseif slopey == 0 then
            if slopex > 0 then offset = 1 end
            love.graphics.draw(match_leftright,blockX * (self.matchlist[i].x-2 + offset), blockY * (self.matchlist[i].y + (1/3)), 0,imageScaleX/6,imageScaleY/10.666)                    
        --Diagnols
        elseif slopex == 1 and slopey == 1 then
            love.graphics.draw(match_backslash,blockX * (self.matchlist[i].x-2 + offset+1), blockY * (self.matchlist[i].y + (1/3)), 0,imageScaleX/6,imageScaleY/10.666)                     
        elseif slopex == -1 and slopey == -1 then
            love.graphics.draw(match_backslash,blockX * (self.matchlist[i].x-2 + offset), blockY * (self.matchlist[i].y + (1/3)-1), 0,imageScaleX/6,imageScaleY/10.666)                                     
        elseif slopex == -1 and slopey == 1 then
            love.graphics.draw(match_forwardslash,blockX * (self.matchlist[i].x-2), blockY * (self.matchlist[i].y + (1/3)), 0,imageScaleX/6,imageScaleY/10.666)                     
        elseif slopex == 1 and slopey == -1 then
            love.graphics.draw(match_forwardslash,blockX * (self.matchlist[i].x-2+1), blockY * (self.matchlist[i].y + (1/3)-1), 0,imageScaleX/6,imageScaleY/10.666)                     
        end
    end
end

function Board:clear()
    for k in pairs (self) do
        self[k] = nil
    end
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

    --If we move backwards, remove the tip
    if #self.matchlist > 1 and self.matchlist[#self.matchlist - 1].x == thisX+1 and self.matchlist[#self.matchlist - 1].y == thisY-2 then
        self[self.matchlist[#self.matchlist].x][self.matchlist[#self.matchlist].y].matched = false
        table.remove(self.matchlist,#self.matchlist) 
    end

    --If we're hovering another tile and it's adjacent, highlight and add it to the list
    if self:canMatch(thisX+1,thisY-2)then
        self.matchlist[#self.matchlist + 1] = self[thisX+1][thisY-2]
        self[thisX+1][thisY-2].matched = true
    end
end

function Board:canMatch(thisX,thisY)
    --If we're doing a combat match then tiles don't need the same name
    if self.combatmatch and self[thisX][thisY].enemymatch then --do nothing
    --If we aren't doing a comabt match then tiles need the same name
    elseif self[thisX][thisY].name ~= self.matched then return false end
    --Finally, check if we're in proximity
    for i=-1,1 do
        for j=-1,1 do
            if thisX+i == self.matchlist[#self.matchlist].x and thisY+j == self.matchlist[#self.matchlist].y and self[thisX][thisY].matched == false then return true end
        end
    end
    return false
end

--Selected the first tile
function Board:tileSelected(x,y)
    if self.dropping then return false end
    thisX = math.floor(x / (love.graphics.getWidth() / 6))
    thisY = math.floor((y / (love.graphics.getHeight() / 10.66666) + 1.6666))
    if thisY <= 2 or thisY >= 9 then return false end

    self.matching = true
    self[thisX+1][thisY-2].matched = true
    self.matched = self[thisX+1][thisY-2].name
    self.matchlist[#self.matchlist + 1] = self[thisX+1][thisY-2]
    
    --If we're starting a combat match
    if self[thisX+1][thisY-2].enemymatch then 
        self.combatmatch = true
        --Fade tiles that can't be matched
        for i=1,6 do
            for j=1,6 do
                if not self[i][j].enemymatch then self[i][j].faded = true end
            end
        end
    else
        --Fade tiles that can't be matched
        for i=1,6 do
            for j=1,6 do
                if self.matched ~= self[i][j].name then self[i][j].faded = true end
            end
        end
    end
end

--After a match has been completed, decipher it
function Board:processMatch()
    if #self.matchlist < 3 then
        self:handsOff()
        return
    end

    --For each element in the list of matches, get its x and y position on the board and remove it
    for i=1,#self.matchlist do
        self[self.matchlist[i].x][self.matchlist[i].y] = nil
        self.tileList[self.matchlist[i].name] = self.tileList[self.matchlist[i].name] + 1
    end

    --Clear list of matches
    for k,v in pairs(self.tileList) do
        self.tileList[k] = 0
    end

    --Generate new tiles and drop some more 
    self:dropTiles()
    return 
end

--Ends a match with nothing exciting
function Board:handsOff()
    self.matching = false
    self.combatmatch = false
    self.matched = 'base'
    self.matchlist = {}
    for i=1,6 do
        for j=1,6 do
            if self[i][j] == nil then goto continue end
                self[i][j].faded = false
                self[i][j].matched = false
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
    random = love.math.random(1,#self.tileMatchList)
    self[i][j] = self.tileMatchList[random]:new()
    self[i][j].x = i
    self[i][j].y = j
    self[i][j].dropfrom = drop
end

--Moves all tiles down if there is an empty space below them
function Board:dropTiles()
    --Drops all tiles down to their lowest points
    ::restart::
    for i=1,6,1 do
        --Drop things in each column until we're done
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

    --Once we've finished dropping tiles, create new ones above them
    for i=1,6 do
        todrop = 0
        for j=6,1,-1 do
            if self[i][j] == nil then
                self:createTile(i,j,todrop)
                todrop = todrop - 1
            end
        end
    end

    print 'yo'
end

--Used to get scaling for all resolutions
function getScaling(drawable)
	local drawW = drawable:getWidth()
    local drawH = drawable:getHeight()
    
	canvasW = love.graphics.getWidth()
	canvasH = love.graphics.getHeight()

	local scaleX = canvasW / drawW
	local scaleY = canvasH / drawH

	return scaleX, scaleY
end