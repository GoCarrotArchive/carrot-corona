# carrot.postPremiumCurrencyPurchase()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [function][api.type.function]
> __Library__           [carrot.*][plugin.carrot]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------


## Overview
Inform Carrot about a purchase of premium currency for metrics tracking.


## Syntax

	carrot.postPremiumCurrencyPurchase( amount, currency )

##### amount ~^(required)^~
_[Number][api.type.Number]._ The amount of real money spent.

##### currency ~^(required)^~
_[String][api.type.String]._ The type of real money spent (eg. USD).


## Examples

``````lua
-- User makes an in-app-purchase of $1.99
carrot.postPremiumCurrencyPurchase(1.99, "USD")
``````
