-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

local carrot = require "plugin_carrot"
local facebook = require "facebook"

local fbAppID = "280914862014150"
local carrotAppSecret = "aa37313c6062762980f95a0711af0537"

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	carrot.postAction("enjoy", "Testobj")
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Test Event",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125

	-- Carrot status text
	local carrotStatusText = display.newText("Carrot Status: UNKNOWN", 0,0, nil, 14);
	carrotStatusText:setReferencePoint(display.TopLeftReferencePoint);
	carrotStatusText.x = 0;
	
	-- all display objects must be inserted into group
	group:insert( playBtn )
	group:insert( carrotStatusText )

	-- Carrot
	carrot.init(fbAppID, carrotAppSecret)
	carrot.setStatusCallback(function(status)
		carrotStatusText.text = "Carrot Status: "..status
		carrotStatusText:setReferencePoint(display.TopLeftReferencePoint);
		carrotStatusText.x = 0;
	end)

	--[[if system.getInfo("environment") == "device" then
		facebook.login(fbAppID, function(event)
			if event.type == "session" and event.phase == "login" then
				carrot.validateUser(event.token)
			end
		end, {"publish_actions"})
	else]]
		local debugUserToken = "BAADZCfZAaPZCsYBALzwK2Vl6FJ1DHLzZAQVk5aZATGZAtk6aQfjVWXcU9ZAhx5hfJkZChFr5542RAVTC64blUV5aD6YoT7FOoVcHvDes3fzTbjdkgiCZCMDAoUaSRzuTACie7jAcHMDGRAN5ZC2elU1PC2clZCC5Jxw5zRgZBW4G13oRwIaiYuPgKlkTnllZAwuQlUqZBgf0w5ZBZBk8LqaPzNvUMBO1a892BWmW3CYZD"
		carrot.validateUser(debugUserToken)
	--end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene