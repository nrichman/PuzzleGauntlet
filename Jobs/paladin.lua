require 'Jobs/job'

job_paladin = job:new()
job_paladin.primary = 'armor'
job_paladin.name = 'paladin'
job_paladin.image = love.graphics.newImage('resources/rogue.png')
job_paladin.health_max = 300
job_paladin.health_current = 300

return job_paladin