require 'Tiles/tile'

tile_armor = tile:new()
tile_armor.name = 'armor'
tile_armor.image = love.graphics.newImage('resources/armor.png')
tile_armor.enemymatch = false

return tile_armor
