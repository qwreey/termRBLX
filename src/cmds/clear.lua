---@diagnostic disable:undefined-global

return {
    names = {"clear","cls"};
    exe = function (str,content)
        content.stdioSimulate.outBuffer = "";
        content.stdioSimulate:updateScreen();
    end;
};
