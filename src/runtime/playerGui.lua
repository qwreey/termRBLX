local uiHost = require(script.Parent.Parent.render.playerGuiMain)(); -- setup uiHost
local TextScreen = uiHost.TextScreen; -- get text screen

-- setup std in/out put host
local stdioSimulate = require(script.Parent.Parent.stdioSimulate).new {
    outBuffer = "termRBLX (Version 0.11.8)\nmore info for : https://github.com/qwreey75/RbxTermi\n\n@termRBLX $";
    prompt = "@termRBLX $";
};

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