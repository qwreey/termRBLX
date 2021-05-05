---@diagnostic disable:undefined-global
return function (env)
    local info = require(script.Parent.Parent.info); -- get termRBLX info
    local uiHost = require(script.Parent.Parent.render.playerGuiMain)(env); -- setup uiHost
    local TextScreen = uiHost.TextScreen; -- get text screen

    -- setup std in/out put host
    local stdioSimulate = require(script.Parent.Parent.stdioSimulate);

    -- setup terminal host and return term env
    return require(script.Parent.Parent.term).new {
        stdioSimulate = stdioSimulate;
        uiHost = uiHost;
        TextScreen = TextScreen;
        info = info;
        env = env;
    };
end;
