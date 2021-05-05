---@diagnostic disable:undefined-global

return {
    names = {"cd","cdir","cwd","chdir","chd","chwd"};
    exe = function (str,content)
        str = string.match(str,"^%s+(.+)");

        local tmp,sum = "",nil;
        for sp in string.gmatch(str,"[^$s]+") do
            if not sum then
                sum = sp;
            else
                local epos = string.find(sp,"\\");
                if epos then
                    
                else
                    tmp = tmp .. "\32" .. sp;
                end
            end
        end

        local path;
        if string.sub(str,1,2) == ".\\" then
            path = content.path;
            str = string.sub(str,3,-1);
        elseif string.upper(string.sub(str,1,5)) == "\\GAME" then
            path = game;
            str = string.sub(str,6,-1);
        elseif string.upper(string.sub(str,1,5)) == "\\NULL" then
            path = nil;
            str = string.sub(str,6,-1);
        elseif string.sub(str,1,1) == "\\" then
            path = nil;
            str = string.sub(str,2,-1);
        else
            path = content.path;
        end
        str = "\\" .. str;
        content.path = content.toInstance(content.toPath(path) .. str);
        content.output(content.toPath(content.path) .. "\n\n");
    end;
};
