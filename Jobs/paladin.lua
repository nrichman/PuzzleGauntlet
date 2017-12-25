require 'Jobs/job'

job_paladin = job:new()
job_paladin.primary = 'armor'
job_paladin.name = 'paladin'
job_paladin.image = love.graphics.newImage('resources/rogue.png')

return job_paladin