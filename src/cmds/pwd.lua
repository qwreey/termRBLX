---@diagnostic disable:undefined-global

return {
    names = {"pwd","pdir","pd"};
    exe = function (str,content)
        content.output(content.toPath(content.path) .. "\n\n");
    end;
};
