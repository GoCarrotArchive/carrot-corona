# carrot.*

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [library][api.type.library]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          carrot
> __Sample code__       [Available in the Carrot Docs for Corona](https://gocarrot.com/docs/corona)
> __See also__          [Carrot website](https://www.gocarrot.com/)
> __Availability__      Starter, Pro, Enterprise
> --------------------- ------------------------------------------------------------------------------------------

## Overview

Carrot gives app developers the tools they need to make viral user acquisition a part of their growth strategy. Our social backend provides distribution through the best viral growth channels (such as Facebook's 'custom actions'), and identifies ways to make viral content more effective.

Our dashboard shows developers what virals get the most impressions, clicks and installs, and our WYSIWYG web tools allow rapid iteration on viral campaigns, without any code changes.

This plugin enables Corona developers to post viral actions to the Carrot service.

## Sign Up

To use the Carrot service, please [sign up](https://gocarrot.com/developers/sign_up?referrer=corona) for an account.

## Platforms

The following platforms are supported:

* Android
* iOS

## Syntax

	local carrot = require "plugin.carrot"

## Functions

#### [carrot.init()][plugin.carrot.init]

#### [carrot.validateUser()][plugin.carrot.validateUser]

#### [carrot.getStatus()][plugin.carrot.getStatus]

#### [carrot.setStatusCallback()][plugin.carrot.setStatusCallback]

#### [carrot.postAchievement()][plugin.carrot.postAchievement]

#### [carrot.postHighScore()][plugin.carrot.postHighScore]

#### [carrot.postAction()][plugin.carrot.postAction]

#### [carrot.postPremiumCurrencyPurchase()][plugin.carrot.postPremiumCurrencyPurchase]

## Properties

#### [carrot.logTag][plugin.carrot.logTag]

#### [carrot.tag][plugin.carrot.tag]

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
			publisherId = "com.gocarrot",
		},
	},
}
``````

### Enterprise

TBD

## Sample Code

You can access sample code [here](https://gocarrot.com/docs/corona).

## Support

More support is available from the Carrot team:

* [E-mail](mailto://pat@gocarrot.com)
* [Forum](http://forums.coronalabs.com/forum/607-carrot/)
* [Plugin Publisher](http://gocarrot.com)
