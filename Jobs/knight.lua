require 'Jobs/job'

job_knight = job:new()
job_knight.primary = 'sword'
job_knight.name = 'knight'
job_knight.image = love.graphics.newImage('resources/rogue.png')

return job_knight