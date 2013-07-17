# carrot.postAction()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [function][api.type.function]
> __Library__           [carrot.*][plugin.carrot]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          
> __Sample code__       
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------


## Overview
Post a viral action to the Carrot service.


## Syntax

	carrot.postAction( actionId, objectInstanceId [, actionProperties] )

##### actionId ~^(required)^~
_[String][api.type.String]._ The identifier for the action in Carrot.

##### objectInstanceId ~^(optional)^~
_[String][api.type.String]._ The identifier of the object instance in Carrot, the identifier of the dynamic object to create/reuse, or nil for a one-time use dynamic ojbect.

##### actionProperties ~^(optional)^~
_[Table][api.type.Table]._ Properties to be sent along with the action, or nil.

##### objectProperties ~^(optional)^~
_[Table][api.type.Table]._ Properties used for creating a dynamic object. This must contain 'object_type', 'title', 'description', and 'image_url'.

## Examples

``````lua
-- User has completed level 2 in your game.

-- There has been configured a 'complete' action in carrot, tied to a 'level' object.
-- The level object id in Carrot is 'level_2'
carrot.postAction('complete', 'level_2')
``````
