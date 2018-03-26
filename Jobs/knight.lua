require 'Jobs/job'

job_knight = job:new()
job_knight.primary = 'sword'
job_knight.name = 'knight'
job_knight.image = love.graphics.newImage('resources/rogue.png')
job_knight.health_max = 300
job_knight.health_current = 100

return job_knight