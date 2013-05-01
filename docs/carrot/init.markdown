# carrot.FUNCTION()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [function][api.type.function]
> __Library__           [carrot.*][plugin.carrot]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          carrot
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------


## Overview
Initialize Carrot. This function must be called prior to any other calls to Carrot.

## Syntax

	carrot.init( appId, appSecret )

##### appId ~^(required)^~
_[String][api.type.String]._ Facebook Application Id.

##### appSecret ~^(required)^~
_[String][api.type.String]._ Carrot App Secret.


## Examples

``````lua
local carrot = require "plugin_carrot"

carrot.init("YOUR_FACEBOOK_APP_ID", "YOUR_CARROT_APP_SECRET")
``````
