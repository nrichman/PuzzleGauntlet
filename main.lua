require 'board'
require 'pieces'
require 'mouseinput'

--Initialize our board object
board = love.graphics.newImage('resources/board.png')
boardstate = Board:new()

--X goes first
turn = 'x'
winner = ''

--Load method occurs first
function love.load()
    love.filesystem.load('board.lua')()
    love.filesystem.load('mouseinput.lua')()
end

--Draw method occurs every frame
function love.draw()
    love.graphics.setColor(255,255,255,255); --Sets color to white 

    imageScaleX,imageScaleY = getScaling(board)
    love.graphics.draw(board,0,0,0,imageScaleX,imageScaleY) --Draws the board
    boardstate:draw() --Draws the pieces on the board
end

--Method occurs when mouse is pressed
function love.mousepressed(x, y, button, istouch)
    if button == 1 and winner == '' then --Left click, game hasn't ended yet
        --Check if the mousepress was viable for a new move
        if(boardstate:setToken(mousepress(),turn)) then
            winner = boardstate:checkWinner() --Check for a winner
            --Next player's turn
            if turn == 'x' then turn = 'o'
            elseif turn == 'o' then turn = 'x'
            end
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "space" then
        winner = ''
        boardstate:clear()
        turn = 'x'
    end
end