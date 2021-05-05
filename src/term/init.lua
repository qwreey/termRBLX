---@diagnostic disable:undefined-global

local module = {};

function module.new(settings)
    local TextScreen = settings.TextScreen;
    local info = settings.info;

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
            spawn(function ()
                wait();
                TextScreen.CursorPosition = curPos;
                TextScreen.SelectionStart = -1;
            end);
        end;
    };
    local stdioSimulate = settings.stdioSimulate;
    local block = (not settings.env.disableBlock) and require(script.blockInput).new(settings.TextScreen,settings.stdioSimulate);

    -- catch text changed
    local function update()
        stdioSimulate:updateBuffer(TextScreen.Text);
    end
    TextScreen:GetPropertyChangedSignal("Text"):Connect(update);
    update();

    -- execute input
    local function exe(input)
        print(input)
    end

    -- catch enter
    TextScreen.FocusLost:Connect(function (enter)
        if not enter then
            return;
        end

        local input = stdioSimulate:returnInput();
        wait(); TextScreen:CaptureFocus();
        exe(input); return;
    end);
end

return module;