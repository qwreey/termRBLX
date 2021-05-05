local stdioMeta = {};
local void = (function() end);
local emptyStr = "";
local strLen = string.len;--utf8.len;
local module = {};

function stdioMeta:updateScreen()
    local new = self.outBuffer .. (self.lockInput and "" or self.prompt) .. self.tmpInput;
    self.lastScreen = new;
    self.updateFunc(new);
end

function stdioMeta:clearInput()
    self.tmpInput = emptyStr;
    self:updateScreen();
end

-- check lines count and clear old lines
function stdioMeta:lineCheck()
--    self.
end

-- enter key function, return input and clear input and eat line
function stdioMeta:returnInput()
    if self.lockInput then return end

    local lastInput = self.tmpInput;
    self.outBuffer = self.lastScreen .. "\n";
    self.tmpInput = emptyStr;
    self:updateScreen();

    return lastInput;
end

-- update in buffer by screen buffer
-- (read screen and catches input)
function stdioMeta:updateBuffer(screenBuffer)
    local screenBufferLen = strLen(screenBuffer);
    local lenNoInput = strLen(self.outBuffer) + strLen(self.prompt);
    if screenBuffer == self.lastScreen then -- nothing changed
        return;
    elseif screenBuffer == (self.outBuffer .. self.prompt) then -- no input
        self.tmpInput = emptyStr;
        self.lastScreen = screenBuffer;
        return;
    elseif screenBufferLen < lenNoInput then -- overflow input to output
        self:clearInput();
        self.curPosSet(lenNoInput + 1);
        return;
    elseif self.lockInput then -- locked
        self:clearInput();
        return;
    end

    if string.sub(screenBuffer,1,lenNoInput) ~= (self.outBuffer .. self.prompt) then -- input and output is mixed
        local changedLen = screenBufferLen - strLen(self.lastScreen);
        if changedLen < 0 then -- remove on output
            self.tmpInput = string.sub(screenBuffer,lenNoInput + changedLen + 1,-1);
        end

        self:updateScreen();
        self.curPosSet(lenNoInput + 1);
        return;
    end

    local input = string.sub(screenBuffer,lenNoInput + 1,-1);
    if input == emptyStr then -- nothing found
        return self:clearInput();
    end
    self.tmpInput = input;
    self.lastScreen = screenBuffer;
end

function stdioMeta:setLockInput(lock)
    self.lockInput = lock;
    self:updateScreen();
end

function stdioMeta:output(str)
    self:stackLine(str);
    self.outBuffer = self.outBuffer .. str;

--    self:
end

stdioMeta.__index = stdioMeta;

function module.new(option)
    local class = {};

    class.outBuffer = option.outBuffer or ""; ---@deprecated -- output string
    class.tmpInput = option.tmpInput or ""; ---@deprecated -- for handle input
    class.lastScreen = option.lastScreen or ""; ---@deprecated -- save last screen
    class.prompt = option.prompt or ""; ---@deprecated -- save last input

    class.maxLines = option.maxLines or 12; --516; ---@deprecated -- max lines
    class.lineBuffer = option.lineBuffer or {}; ---@deprecated -- for handle lines

    class.lockInput = option.lockInput or false; ---@deprecated -- input is locked?
    class.updateFunc = option.updateFunc or void; ---@deprecated -- when updated, call this func
    class.curPosSet = option.curPosSet or void; ---@deprecated -- update cursor pos func

    setmetatable(class,stdioMeta);
    return class;
end

return module;
