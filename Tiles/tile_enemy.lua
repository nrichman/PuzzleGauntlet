require 'Tiles/tile'

tile_enemy = tile:new()
tile_enemy.name = 'enemy'
tile_enemy.image = love.graphics.newImage('resources/enemy.png')
tile_enemy.enemymatch = true

return tile_enemy
