require 'Jobs/job'

job_healer = job:new()
job_healer.primary = 'staff'
job_healer.name = 'healer'
job_healer.image = love.graphics.newImage('resources/rogue.png')

return job_healer