local DanmakuPattern = {}
DanmakuPattern.__index = DanmakuPattern

function DanmakuPattern.init(danmakuFunc)
    local obj = {}

    obj.danmakuFunc = danmakuFunc
    
    obj.danmakuCo = nil
    obj.msg = ""

    return setmetatable(obj, DanmakuPattern)
end

function DanmakuPattern:update(dt)
    if self.msg == "" then
        self.danmakuCo = coroutine.create(self.danmakuFunc)
        _, self.msg = coroutine.resume(self.danmakuCo) -- start attackCo
    elseif self.msg == "delay" then
        _, self.msg = coroutine.resume(self.danmakuCo, dt) -- send dt to delay
    elseif self.msg == "end" then
        self.msg = ""
    end
end

return DanmakuPattern