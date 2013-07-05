# carrot.validateUser()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [function][api.type.function]
> __Library__           [carrot.*][plugin.carrot]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------


## Overview
Validate a user for Carrot, creating a new user if needed.

## Syntax

	carrot.validateUser( accessToken )

##### accessToken ~^(required)^~
_[String][api.type.String]._ A Facebook user access token retrieved from Facebook sign in.

## Examples

``````lua
local carrot = require "plugin_carrot"
local facebook = require "facebook"

-- Initialize Carrot
carrot.init("YOUR_FACEBOOK_APP_ID", "YOUR_CARROT_APP_SECRET")

-- Perform Facebook Login
facebook.login("YOUR_FACEBOOK_APP_ID", function(event)

	-- If the login was successful, pass the user token to Carrot
	if event.type == "session" and event.phase == "login" then

		-- Pass user token to Carrot for validation.
		carrot.validateUser(event.token)
	end

	-- The 'publish_actions' permission is required for Carrot functionality ('publish_stream' is a superset of 'publish_actions', but is deprecated).
end, {"publish_actions"})
``````
