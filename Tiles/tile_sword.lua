require 'Tiles/tile'

tile_sword = tile:new()
tile_sword.name = 'sword'
tile_sword.image = love.graphics.newImage('resources/sword.png')
tile_sword.enemymatch = true
return tile_sword