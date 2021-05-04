local info = require(script.Parent.Parent.info); -- get termRBLX info
local uiHost = require(script.Parent.Parent.render.playerGuiMain)(); -- setup uiHost
local TextScreen = uiHost.TextScreen; -- get text screen

-- setup std in/out put host
local stdioSimulate = require(script.Parent.Parent.stdioSimulate).new {
    outBuffer = ("termRBLX (Version %s)\nmore info for : https://github.com/qwreey75/RbxTermi\n\n"):format(
        info.version
    );
    prompt = "@termRBLX $ ";
    updateFunc = function (text)
        TextScreen.Text = text;
    end;
    curPosFunc = function (curPos)
        TextScreen.CursorPosition = curPos;
        TextScreen.SelectionStart = -1;
    end;
};

-- catch text changed
local function update()
    stdioSimulate:updateBuffer(TextScreen.Text);
end
TextScreen:GetPropertyChangedSignal("Text"):Connect(update);
update();

-- setup terminal host
local termHost = require(script.Parent.Parent.term).new {
    stdioSimulate = stdioSimulate;
    uiHost = uiHost;
    TextScreen = TextScreen;
};

-- return term env
return {
    uiHost = uiHost;
    stdioSimulate = stdioSimulate;
    termHost = termHost;
};