local windowClass = require(script.Parent.window);
local window = windowClass.new({
    WindowRoundSize = 8;
    WindowID = "game.ui.TERMRBLX_" .. tostring(math.random(10000,99999));
    WindowTitle = "Terminal | RBLX";
    WindowSize = {X = 500,Y = 320};
    WindowMinSize = {X = 220,Y = 220};
    WindowIcon = "http://www.roblox.com/asset/?id=6031075938";
    WindowIconSize = 30;
    ShadowSize = {X = 8,T = 8,B = 12};
    ShadowIndex = -50;
    FocusedShadowTransparency = 0;
    UnfocusedShadowTransparency = 0.38;
    TopBarSizeY = 40;
    AppFont = Enum.Font.Gotham;
    CloseButtonDisabled = true;
    Resizable = true;
    Colors = {
        Background = Color3.fromRGB(55, 55, 65);
        TopBar = Color3.fromRGB(55, 55, 65);
        Div = Color3.fromRGB(100,100,105);
        Text = Color3.fromRGB(255,255,255);
        Icon = Color3.fromRGB(255,255,255);
    };
});

local holder,customScroll = require(script.Parent.CustomScroll).new {
    DragToScrollDisabled = true;
};
holder.Parent = window.Holder;

local termScreen = require(script.Parent.screen)(holder.Holder);
termScreen.BackgroundTransparency = 1;

return true;