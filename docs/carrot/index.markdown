# carrot.*

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [library][api.type.library]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          carrot
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------

## Overview

The carrot plugin enables X.

## Sign Up

To use the SERVICE_NAME service, please [sign up](CORONA_REFERRAL_URL) for an account.

## Platforms

The following platforms are supported:

* Android
* iOS

## Syntax

	local carrot = require "plugin.carrot"

## Functions

#### [carrot.FUNCTION()][plugin.carrot.FUNCTION]

#### [carrot.PROPERTY][plugin.carrot.PROPERTY]

## Project Settings

### SDK

When you build using the Corona Simulator, the server automatically takes care of integrating the plugin into your project. 

All you need to do is add an entry into a `plugins` table of your `build.settings`. The following is an example of a minimal `build.settings` file:

``````
settings =
{
	plugins =
	{
		-- key is the name passed to Lua's 'require()'
		["plugin.carrot"] =
		{
			-- required
			publisherId = "REVERSE_PUBLISHER_URL",
		},
	},		
}
``````

### Enterprise

TBD

## Sample Code

You can access sample code [here](SAMPLE_CODE_URL).

## Support

More support is available from the PUBLISHER_NAME team:

* [E-mail](mailto://PUBLISHER_CONTACT@PUBLISHER_URL)
* [Forum](http://forum.coronalabs.com/plugin/carrot)
* [Plugin Publisher](http://PUBLISHER_URL)
