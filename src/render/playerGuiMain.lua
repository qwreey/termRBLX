---@diagnostic disable:undefined-global

return function (env)
    local windowClass = require(script.Parent.window);
    local window = windowClass.new({
        WindowRoundSize = 8;
        WindowID = env.id or ("game.ui.TERMRBLX_" .. tostring(math.random(10000,99999)));
        WindowTitle = env.title or "Terminal | RBLX";
        WindowSize = {X = 500,Y = 320};
        WindowMinSize = {X = 220,Y = 220};
        WindowIcon = env.icon or "http://www.roblox.com/asset/?id=6031075938";
        WindowIconSize = 30;
        ShadowSize = {X = 8,T = 8,B = 12};
        ShadowIndex = -50;
        FocusedShadowTransparency = 0;
        UnfocusedShadowTransparency = 0.38;
        TopBarSizeY = 40;
        AppFont = Enum.Font.Gotham;
        CloseButtonDisabled = true;
        Resizable = true;
        Parent = env.holder;
        Colors = {
            Background = Color3.fromRGB(55, 55, 65);
            TopBar = Color3.fromRGB(55, 55, 65);
            Div = Color3.fromRGB(100,100,105);
            Text = Color3.fromRGB(255,255,255);
            Icon = Color3.fromRGB(255,255,255);
        };
    });

    -- make scroll
    local holder,customScroll = require(script.Parent.CustomScroll).new {
        DragToScrollDisabled = true;
    };
    holder.Parent = window.Holder;
    holder.Holder.Size = UDim2.fromScale(1,1);

    -- make term screen
    local termScreen = require(script.Parent.term.screen)(holder.Holder);
    termScreen.BackgroundTransparency = 1;

    -- scroll input
    termScreen.TextScreen.MouseWheelBackward:Connect(function ()
        if termScreen.TextScreen:IsFocused() then
            customScroll.WheelBackward();
        end
    end);
    termScreen.TextScreen.MouseWheelForward:Connect(function ()
        if termScreen.TextScreen:IsFocused() then
            customScroll.WheelForward();
        end
    end);

    -- set texts size
    local lastWinsizeY = math.huge;
    local function refreshScrollSize()
        local winHolderSize = window.Holder.AbsoluteSize.Y;
        local textScreenSize = termScreen.TextScreen.TextBounds.Y + 8 + termScreen.TextScreen.TextSize;
        local winsizeY = math.max(winHolderSize,textScreenSize);
        holder.Holder.Size = UDim2.new(1,0,0,winsizeY);

        -- set scroll pos
        if winHolderSize ~= winsizeY then
            local change = winsizeY - lastWinsizeY;
            if change > 0 then
                customScroll.Scroll(0,-change -6);
            end
            lastWinsizeY = winsizeY;
        end
    end
    termScreen.TextScreen:GetPropertyChangedSignal("TextBounds"):Connect(refreshScrollSize);
    holder.Holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshScrollSize);

    return {
        TextScreen = termScreen.TextScreen;
    };
end;