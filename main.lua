require 'board'
require 'menu'
require 'party'

job_knight = require 'Jobs/knight'
job_healer = require 'Jobs/healer'
job_paladin = require 'Jobs/paladin'

local gamestate = {}
local menustate = {}

StateMachine = require "StateMachine"
--Initialize our board object
board = love.graphics.newImage('resources/Puzzle_Board.png')
MyBoard = Board:new( { job_knight, job_healer, job_paladin })
MyParty = Party:new()
MyMenu = Menu:new()

party = {}

--Load method occurs first
function love.load()
    love.filesystem.load('board.lua')()
    StateMachine.registerEvents()
    StateMachine.switch(menustate)
end

--Method occurs when mouse is pressed
function menustate:mousepressed(x, y, button, istouch)
    if Menu:ProcessInput(x,y) then
        StateMachine.switch(gamestate)
    end
end

function gamestate:mousepressed(x,y,button,istouch)
    MyBoard:tileSelected(x,y)
end

function gamestate:mousereleased(x,y,button,istouch)
    MyBoard:processMatch()
    MyBoard:handsOff()
end

function gamestate:update(dt)
    if MyBoard.matching == true then
        MyBoard:tileDrag(love.mouse.getX(),love.mouse.getY())
    end
end

function menustate:enter()
    
end
    
function menustate:update(dt)
    
end
    
function menustate:draw(dt)
    MyMenu:draw()
end

--Draw method occurs every frame
function gamestate:draw()
    love.graphics.setColor(255,255,255,255); --Sets color to white
    imageScaleX,imageScaleY = getScaling(board)
    love.graphics.draw(board,0,0,0,imageScaleX,imageScaleY) --Draws the board
    MyBoard:draw() --Draws the pieces on the board
    MyParty:draw()    
end
