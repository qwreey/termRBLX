local stdioMeta = {};
local void = (function() end);
local emptyStr = "";
local strLen = utf8.len();
local module = {};

function stdioMeta:updateScreen()
    self.updateFunc(self.outBuffer .. self.tmpInput);
end

function stdioMeta:clearInput()
    self.tmpInput = emptyStr;
    self:updateScreen();
end

-- check lines count and clear old lines
--function stdioMeta:lineCheck()
--    self.
--end

-- enter key function, return input and clear input and eat line
function stdioMeta:returnInput()
    if self.lockInput then return end

    local lastInput = self.lastInput;
    self.outBuffer = self.outBuffer .. lastInput .. "\n";
    self.lastInput = emptyStr;
    self:updateScreen();

    return lastInput;
end

-- update in buffer by screen buffer
-- (read screen and catches input)
function stdioMeta:updateInBuffer(screenBuffer)
    if screenBuffer == self.lastScreen then -- nothing changed
        return;
    elseif screenBuffer == self.outBuffer then -- no input
        return;
    elseif strLen(screenBuffer) < strLen(self.outBuffer) then -- overflow input
        return self:clearInput();
    elseif self.lockInput then -- locked
        return self:clearInput();
    end

    local input = string.sub(screenBuffer,strLen(self.outBuffer) + 1,-1)
    if input == emptyStr then -- nothing found
        return self:clearInput();
    end

end

function stdioMeta:setLockInput(lock)
    self.lockInput = lock;
    return 1;
end

function stdioMeta:output(str)
    self:stackLine(str);
    self.outBuffer = self.outBuffer .. str;

--    self:
    return 1;
end

stdioMeta.__index = stdioMeta;

function module.new(option)
    local class = {};

    class.outBuffer = option.outBuffer or ""; ---@deprecated -- output string
    class.tmpInput = option.tmpInput or ""; ---@deprecated -- for handle input
    class.lastScreen = option.lastScreen or ""; ---@deprecated -- save last screen
    class.lastInput = option.lastInput or ""; ---@deprecated -- save last input

    class.maxLines = option.maxLines or 1024; ---@deprecated -- max lines
    class.lineBuffer = option.lineBuffer or {}; ---@deprecated -- for handle lines

    class.lockInput = option.lockInput or false; ---@deprecated -- input is locked?
    class.updateFunc = option.updateFunc or void; ---@deprecated -- when updated, call this func

    setmetatable(class,stdioMeta);
    return class;
end

return module;
