local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name='carrot', publisherId='REVERSE_PUBLISHER_URL' }

-------------------------------------------------------------------------------
-- BEGIN (Insert your implementation startine here)
-------------------------------------------------------------------------------

-- This sample implements the following Lua:
-- 
--    local carrot = require "plugin_carrot"
--    carrot.test()
--    
lib.test = function()
	native.showAlert( 'Hello, World!', 'carrot.test() invoked', { 'OK' } )
	print( 'Hello, World!' )
end

-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------

-- Return an instance
return lib
