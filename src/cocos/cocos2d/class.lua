
function class(classname, super)
	local tp = type(super)
	local self = {__cname = classname}
	if tp == "function" then
	    function self.new(...)
			local obj = super(...)
			local t = tolua.getpeer(obj)
		    if not t then
		        t = {}
		        tolua.setpeer(obj, t)
		    end
		    -- 把父类中的特有元素复制给子类，实现重载
	    	local oldMetatable = getmetatable(t)
	    	if oldMetatable then
		    	for k, v in pairs(oldMetatable) do
		    		if self[k] == nil then 
		    			self[k] = v
		    		end
		    	end
		    end
	    	self.__index = self
	    	setmetatable(t, self)
	    	return obj
	    end
	end
	return self
end
