job = {}
job.type = 'none'
job.name = 'none'
job.pos = 1

function job:new()
    tablestate = {}
    self.__index = self
    return setmetatable(stablestate, self)
end
