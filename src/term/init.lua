local module = {};

function module.new(settings)
    local blockInput = require(script.blockInput).new(settings.TextScreen,settings.stdioSimulate);
end

return module;