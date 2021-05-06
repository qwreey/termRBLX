---@diagnostic disable:undefined-global

return {
    names = {"rmline","rline"};
    info = "remove last line on screen";
    exe = function (str,content,self,cmdprefix)
        local stds = content.stdioSimulate;
        local out = (string.match(string.sub(stds.outBuffer,1,-#(cmdprefix .. str)),"(.+)\n.-$") or "");
        stds.outBuffer = out; stds:updateScreen();
    end;
};
