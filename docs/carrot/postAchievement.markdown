# carrot.postAchievement()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [function][api.type.function]
> __Library__           [carrot.*][plugin.carrot]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------


## Overview
Post an achievement to the Carrot service.


## Syntax

	carrot.postAchievement( achievementId )

##### achievementId ~^(required)^~
_[String][api.type.String]._ The identifier of the achievement in Carrot.


## Examples

``````lua
-- User completes some action worthy of an achievement
carrot.postAchievement("ACHIEVEMENT_ID_IN_CARROT")
``````
