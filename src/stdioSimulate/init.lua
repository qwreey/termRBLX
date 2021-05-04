local stdioMeta = {};
local void = (function() end);
local module = {};

function stdioMeta:updateScreen()
    self.updateFunc();
end

function stdioMeta:stackLine(str)

end

function stdioMeta:updateInBuffer(screenBuffer)
    
end

function stdioMeta:setLockInput(lock)
    self.lockInput = lock;
    return 1;
end

function stdioMeta:output(str)
    self:stackLine(str);
    outBuffer = outBuffer .. str;

    self:
    return 1;
end

function module.new(option)
    local class = {};

    class.outBuffer = option.outBuffer or ""; ---@deprecated -- output string
    class.tmpInput = option.tmpInput or ""; ---@deprecated -- for handle input
    class.lastScreen = option.lastScreen or ""; ---@deprecated -- save last screen

    class.maxLines = option.maxLines or 1024; ---@deprecated -- max lines
    class.lineBuffer = option.lineBuffer or {}; ---@deprecated -- for handle lines

    class.lockInput = option.lockInput or false; ---@deprecated -- input is locked?
    class.updateFunc = option.updateFunc or void; ---@deprecated -- when updated, call this func

    setmetatable(class,stdioMeta);
    return class;
end

return module;
