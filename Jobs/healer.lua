require 'Jobs/job'

job_healer = tile:new()
job_healer.type = 'SUP'
job_healer.name = 'healer'
job_healer.image = love.graphics.newImage('resources/rogue.png')

return job_healer