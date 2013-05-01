# carrot.setStatusCallback()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [function][api.type.function]
> __Library__           [carrot.*][plugin.carrot]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------


## Overview
Assign a callback function which will get triggered each time the user status changes.


## Syntax

	carrot.setStatusCallback( callback )

##### callback ~^(required)^~
_[function][api.type.function]._ A function which takes one argument that will be called when a user status changes.

## Examples

``````lua
local carrot = require "plugin_carrot"

-- Listen for changes in user status
carrot.setStatusCallback(function(status)
	-- Print user status to the terminal
	print("Carrot Status: "..status)
end)
``````
