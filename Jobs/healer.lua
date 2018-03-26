require 'Jobs/job'

job_healer = job:new()
job_healer.primary = 'staff'
job_healer.name = 'healer'
job_healer.image = love.graphics.newImage('resources/rogue.png')
job_healer.health_max = 300
job_healer.health_current = 200

return job_healer