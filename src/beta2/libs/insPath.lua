local module = {};

do
	local WORD = {
		"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"1","2","3","4","5","6","7","8","9","0"
	};
	local lenWORD = #WORD;
	function module.makeId()
		local str = "";
		for _=1,16 do
			str = str .. WORD[math.random(1,lenWORD)];
		end
		return str;
	end
end

function module:escape(name)
	name = name:gsub("\\","\\\\");
	name = name:gsub(" ","\\ ");
	name = name:gsub("/","\\/");
	name = name:gsub("\"","\\\"");
	name = name:gsub("'","\\'");
	if name:match("[^%a]") then
		return ("\"%s\""):format(name)
	end
	return name;
end

function module:unescape(name)
	local escape,str = false,"";
	name:gsub(".",function (this)
		if this == "\\" and (not escape) then
			escape = true;
		elseif escape then
			if this == "\\" then
				str = str .. "\\";
			elseif this == "\"" then
				str = str .. "\"";
			elseif this == "'" then
				str = str .. "'";
			elseif this == "/" then
				str = str .. "/";
			elseif this == "n" then
				str = str .. "\n";
			elseif this == "b" then
				str = str .. "\b";
			elseif this == "r" then
				str = str .. "\t";
			elseif this == "t" then
				str = str .. "\t";
			elseif this == "f" then
				str = str .. "\f";
			elseif this == "a" then
				str = str .. "\a";
			elseif this == "z" then
				str = str .. "\z";
			elseif this == "v" then
				str = str .. "\v";
			else
				str = str .. this;
			end
			escape = false;
		else
			str = str .. this;
		end
	end);

	name = name:gsub("\\ "," ");
	name = name:gsub("/","\\/");
	name = name:gsub("\"","\\\"");
	name = name:gsub("'","\\'");
	if name:match("[^%a]") then
		return ("\"%s\""):format(name)
	end
	return name;
end

function module:toPath(ins)
	local path = "";
	local lastIns;

	if not ins then
		return "/null";
	end

	while true do
		if not ins then
			local index = self.null[lastIns];
			if not index then
				index = self.makeId();
				self.null[lastIns] = index;
			end
			return ("/null/%s/"):format(index) .. path:sub(1,-2);
		elseif ins == game then
			return "~/" .. path;
		end
		path = self:escape(ins.Name) .. "/" .. path;
		lastIns = ins;
		ins = ins.Parent;
	end

	return path;
end

function module:toIns(path)
	path
end

function module.new(content)
	local new = {};

	new.maxindex = content.maxindex or 128;
	new.env = content.env or {}; -- $SOMETHING
	new.null = content.null or {}; -- handler for nil parent object
	new.root = content.root or {};
	setmetatable(new,module);

	return new;
end

return module;
