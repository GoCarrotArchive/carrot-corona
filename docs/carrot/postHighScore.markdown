# carrot.postHighScore()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [function][api.type.function]
> __Library__           [carrot.*][plugin.carrot]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------


## Overview
Post a high score to the Carrot service.


## Syntax

	carrot.postHighScore( score )

##### score ~^(required)^~
_[Number][api.type.Number]._ The score the user has attained. Only the highest score attained will be reported to Facebook.


## Examples

``````lua
-- User has completed a level, with score value in a variable named 'some_score'
carrot.postHighScore(some_score)
``````
