---@diagnostic disable:undefined-global

local module = {};

function module.new(settings)
    local TextScreen = settings.TextScreen;
    local info = settings.info;
    settings.path = settings.env.path or game;
    settings.toPath = require(script.Parent.utils.instanceToPath);
    settings.toInstance = require(script.Parent.utils.pathToInstance);

    -- new stdio simulate
    settings.stdioSimulate = settings.stdioSimulate.new {
        outBuffer = ("termRBLX (Version %s)\nmore info for : https://github.com/qwreey75/RbxTermi\n\n"):format(
            info.version
        );
        prompt = "@termRBLX $ ";
        updateFunc = function (text)
            TextScreen.Text = text;
        end;
        curPosSet = function (curPos)
            TextScreen.CursorPosition = curPos;
            TextScreen.SelectionStart = -1;
            --end);
        end;
        addCurPos = function (move)
            TextScreen.CursorPosition = TextScreen.CursorPosition + move;
            TextScreen.SelectionStart = -1;
        end
    };
    local stdioSimulate = settings.stdioSimulate;
    local block = (not settings.env.disableBlock) and require(script.blockInput).new(settings.TextScreen,stdioSimulate);
    settings.output = function (text)
        stdioSimulate:output(text);
    end;

    -- catch text changed
    local function update()
        stdioSimulate:updateBuffer(TextScreen.Text);
    end
    TextScreen:GetPropertyChangedSignal("Text"):Connect(update);
    update();

    -- load commands
    local cmds = {};
    local function loadCmd(t)
        for _,name in pairs(t.names) do
            cmds[name] = t;
        end
    end
    local customCmds = settings.cmds;
    if customCmds then
        for _,v in pairs(customCmds) do
            loadCmd(v);
        end
    end
    for _,cmdModule in pairs(script.Parent.cmds:GetChildren()) do
        loadCmd(require(cmdModule));
    end
    settings.loadCmd = loadCmd;
    settings.cmds = cmds;

    -- execute input
    local exe = require(script.exe).init(settings);

    -- catch enter
    TextScreen.FocusLost:Connect(function (enter)
        if not enter then
            return;
        end

        local input = stdioSimulate:returnInput();
        wait(); TextScreen:CaptureFocus();
        exe:run(input); return;
    end);

    return settings;
end

return module;