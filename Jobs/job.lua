job = {}
job.type = 'none'
job.name = 'none'
job.pos = 1

function job:new()
    newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end
