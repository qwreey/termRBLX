return function (path)
    local ins = nil;
    local deep = 0;
    for str in string.gmatch(path,"[^\\]+") do
        deep = deep + 1;
        if deep == 1 then
            if string.upper(str) == "GAME" then
                ins = game;
            elseif string.upper(str) == "NULL" then
                break;
            end
        else
            if ins == nil then
                break;
            elseif str == ".." then
                ins = ins.Parent;
            elseif str == "" then
                break;
            else
                ins = ins:FindFirstChild(str);
            end
        end
    end
    return ins;
end;