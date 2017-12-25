require 'Tiles/tile'

tile_staff = tile:new()
tile_staff.name = 'staff'
tile_staff.image = love.graphics.newImage('resources/staff.png')
tile_staff.enemymatch = false

return tile_staff
