require 'board'
require 'pieces'
require 'mouseinput'

local gamestate = {}
local menustate = {}

StateMachine = require "StateMachine"
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
    StateMachine.registerEvents()
    StateMachine.switch(menustate)
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

function menustate:enter()
    
end
    
function menustate:update(dt)
    
end
    
function menustate:draw()
    
end

--Draw method occurs every frame
function gamestate:draw()
    love.graphics.setColor(255,255,255,255); --Sets color to white 

    imageScaleX,imageScaleY = getScaling(board)
    love.graphics.draw(board,0,0,0,imageScaleX,imageScaleY) --Draws the board
    boardstate:draw() --Draws the pieces on the board
end