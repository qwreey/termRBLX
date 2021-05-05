return function (ins)
    local path = "";

    while true do
        if not ins then
            path = "\\NULL" .. path;
            break;
        elseif ins == game then
            path = "\\GAME" .. path;
            break;
        end
        path = "\\" .. ins.Name .. path;
        ins = ins.Parent;
    end

    return path;
end;