-- draw custom cursor

local render = require(script.Parent.render);
local AdvancedTween = require(script.Parent.AdvancedTween);
local TextService = game:GetService("TextService");
local FrameEl = render.Import("Frame");
return function update(box)
    local selCur,posCur,str = box.CursorPosition,box.SelectionStart,box.Text;
    local posStart,posEnd = math.max(selCur,posCur),math.min(selCur,posCur);
    
    local curStart = box:FindFirstChild("curStart") or FrameEl ("curStart") {
        Parent = box;
        ZIndex = 2;
        BackgroundColor = Color3.fromRGB(255,255,255);
        Size = UDim2.fromOffset(0,0);
        BackgroundTransparency = 0.6;
    };
    local curEnd = box:FindFirstChild("curEnd") or FrameEl ("curEnd") {
        Parent = box;
        ZIndex = 2;
        BackgroundColor = Color3.fromRGB(255,255,255);
        Size = UDim2.fromOffset(0,0);
        BackgroundTransparency = 0.6;
    };
    local curMid = box:FindFirstChild("curMid") or FrameEl ("curMid") {
        Parent = box;
        ZIndex = 2;
        BackgroundColor = Color3.fromRGB(255,255,255);
        Size = UDim2.fromOffset(0,0);
        BackgroundTransparency = 0.6;
    };
    local cur = box:FindFirstChild("curMid") or FrameEl ("curMid") {
        Parent = box;
        ZIndex = 3;
        BackgroundColor = Color3.fromRGB(82,139,255);
        Size = UDim2.fromOffset(0,0);
        BackgroundTransparency = 0.1;
    };

    if posCur == -1 then -- hide
        curStart.Visible = false;
        curEnd.Visible = false;
        curMid.Visible = false;
        cur.Visible = false;
    else
        local strFront = string.sub(str,1,posCur);

        -- set point cur pos
        local curUDim2 = UDim2.fromOffset()
        if cur.Visible then
            AdvancedTween:RunTween(cur,{
                Time = 0.3;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                Position = curUDim2;
            });
        else
            cur.Position = curUDim2;
        end
        cur.Visible = true;

        cur.Size = UDim2.fromOffset(box.TextSize,2);
        if selCur == -1 then
            curStart.Visible = false;
            curEnd.Visible = false;
            curMid.Visible = false;
        end
    end
end