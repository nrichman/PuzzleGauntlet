job = {}
job.type = 'none'
job.name = 'none'
job.pos = 1
job.selected = false

function job:new()
    newObj = {}
    self.__index = self
    return setmetatable(newObj, self)
end
