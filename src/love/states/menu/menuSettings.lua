--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

-- This file doesn't need to be messed with unless you are adding a new setting

local selectSound = love.audio.newSource("sounds/menu/select.ogg", "static")
local confirmSound = love.audio.newSource("sounds/menu/confirm.ogg", "static")
local menuBG = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/title-bg")))

newlinesMoment = {
    "",
    "\n\n",
    "\n\n\n\n",
    "\n\n\n\n\n\n",
    "\n\n\n\n\n\n\n\n",
    "\n\n\n\n\n\n\n\n\n\n\n"
}

settingsDescriptions1 = { -- The big spaces are so it lines up lol
    "Downscroll:" ..
    "\n      \"Downscroll\" makes arrows scroll down instead of up, and also\n      moves some aspects of the UI around",

    "Middlescroll:" ..
    "\n      \"Middlescroll\" Puts your notes in the middle",

    "Ghost Tapping:" ..
    "\n       \"Ghost Tapping\" disables anti-spam, but counts \"Shit\" inputs as\n       misses" ..
    "\n\n       NOTE: Currently unfinished, some aspects of this input mode\n       still need to be implemented, like mash violations",

    "Side Judgements" ..
    "\n       \"Side Judgements\" Shows your Sicks/Goods/Bads/Shits on the left\n       side of the screen." ..
    "\n\n       ONLY FOR WEEKS 1-5",

    "Bot Play" ..
    "\n       \"Bot Play\" Sit back and relax. Let the bot do all the playing\n       for you."
}
settingsDescriptions2 = {

    "Hardware Compression:" ..
    "\n       \"Hardware Compression\" Use hardware-compressed image formats\n       to save RAM, disabling this will make the game eat your RAM\n       for breakfast (and increase load times)" ..
    "\n\n       WARNING: Don't disable this on 32-bit versions of the game,\n       or the game will quickly run out of memory and crash (thanks\n       to the 2 GB RAM cap)",

    "Show Debug" ..
    "\n       \"Show Debug\" Shows debug info on the screen" ..
    "\n\n       \"fps\" ONLY shows your FPS" ..
    "\n\n       \"detailed\" shows things for debugging. (E.g. Music time,\n       Health, etc)"
}

local function switchMenu(menu)
end

return {
	enter = function(self, previous)

        function saveSettings()
            if settings.hardwareCompression ~= data.saveSettingsMoment.hardwareCompression then
                data = {}
                if settings.hardwareCompression then
                    imageTyppe = "dds" 
                else
                    imageTyppe = "png"
                end
                data.saveSettingsMoment = {
                    hardwareCompression = settings.hardwareCompression,
                    downscroll = settings.downscroll,
                    ghostTapping = settings.ghostTapping,
                    showDebug = settings.showDebug,
                    setImageType = imageTyppe,
                    sideJudgements = settings.sideJudgements,
                    botPlay = settings.botPlay,
                    middleScroll = settings.middleScroll,
                    settingsVer = settingsVer
                }
                serialized = lume.serialize(data)
                love.filesystem.write("settings", serialized)
                love.window.showMessageBox("Settings Saved!", "Settings saved. Funkin Vasion will now restart to make sure your settings saved")
                love.event.quit("restart")
            else
                data = {}
                if settings.hardwareCompression then
                    imageTyppe = "dds" 
                else
                    imageTyppe = "png"
                end
                data.saveSettingsMoment = {
                    hardwareCompression = settings.hardwareCompression,
                    downscroll = settings.downscroll,
                    ghostTapping = settings.ghostTapping,
                    showDebug = settings.showDebug,
                    setImageType = imageTyppe,
                    sideJudgements = settings.sideJudgements,
                    botPlay = settings.botPlay,
                    middleScroll = settings.middleScroll,
                    settingsVer = settingsVer
                }
                serialized = lume.serialize(data)
                love.filesystem.write("settings", serialized)
                graphics.fadeOut(
                    0.3,
                    function()
                        Gamestate.switch(menuSelect)
                        status.setLoading(false)
                    end
                )
            end
        end

		songNum = 0
        settingSelect = 1
        settingsMenuState = 0

		cam.sizeX, cam.sizeY = 0.9, 0.9
		camScale.x, camScale.y = 0.9, 0.9

		switchMenu(1)

		graphics.setFade(0)
		graphics.fadeIn(0.5)

		if useDiscordRPC then
			presence = {
				state = "Changing Settings",
				details = "In the Settings Menu",
				largeImageKey = "logo",
				startTimestamp = now,
			}
			nextPresenceUpdate = 0
		end
	end,

	update = function(self, dt)
		if not graphics.isFading() then
			if input:pressed("confirm") then
                function confirmFunc()
                    if settingsMenuState == 0 then
                        if settingSelect == 1 then
                            settingsMenuState = 1 
                        elseif settingSelect == 2 then
                            settingsMenuState = 2
                        elseif settingSelect == 3 then
                            saveSettings()
                        end
                    elseif settingsMenuState == 1 then
                        if settingSelect == 1 then
                            if settings.downscroll then
                                settings.downscroll = false
                            else
                                settings.downscroll = true
                            end
                        elseif settingSelect == 2 then
                            if settings.middleScroll then
                                settings.middleScroll = false
                            else
                                settings.middleScroll = true
                            end
                        elseif settingSelect == 3 then
                            if settings.ghostTapping then
                                settings.ghostTapping = false
                            else
                                settings.ghostTapping = true
                            end
                        elseif settingSelect == 4 then
                            if not settings.sideJudgements then
                                settings.sideJudgements = true
                            else
                                settings.sideJudgements = false
                            end
                        elseif settingSelect == 5 then
                            if not settings.botPlay then
                                settings.botPlay = true
                            else
                                settings.botPlay = false
                            end
                        end
                    elseif settingsMenuState == 2 then
                        if settingSelect == 1 then
                            if settings.hardwareCompression then
                                settings.hardwareCompression = false
                            else
                                settings.hardwareCompression = true
                            end
                        elseif settingSelect == 2 then
                            if not settings.showDebug then
                                settings.showDebug = "fps"
                            elseif settings.showDebug == "fps" then
                                settings.showDebug = "detailed" 
                            elseif settings.showDebug == "detailed" then
                                settings.showDebug = false
                            end
                        end
                    end
                end
				audio.playSound(confirmSound)

                confirmFunc()
			elseif input:pressed("back") then
				audio.playSound(selectSound)

                if settingsMenuState == 0 then
			    	saveSettings()
                else
                    settingsMenuState = 0
                    settingSelect = 1
                end
            elseif input:pressed("up") then
                if settingsMenuState == 0 then
                    if settingSelect ~= 1 then
                        settingSelect = settingSelect - 1
                    else
                        settingSelect = 3
                    end
                elseif settingsMenuState == 1 then
                    if settingSelect ~= 1 then
                        settingSelect = settingSelect - 1
                    else
                        settingSelect = 5
                    end
                elseif settingsMenuState == 2 then
                    if settingSelect ~= 1 then
                        settingSelect = settingSelect - 1
                    else
                        settingSelect = 2
                    end
                end
            elseif input:pressed("down") then
                if settingsMenuState == 0 then
                    if settingSelect ~= 4 then
                        settingSelect = settingSelect + 1
                    else
                        settingSelect = 1
                    end
                elseif settingsMenuState == 1 then
                    if settingSelect ~= 5 then
                        settingSelect = settingSelect + 1
                    else
                        settingSelect = 1
                    end
                elseif settingsMenuState == 2 then
                    if settingSelect ~= 2 then
                        settingSelect = settingSelect + 1
                    else
                        settingSelect = 1
                    end
                end
			end
		end
        if settings.hardwareCompression ~= data.saveSettingsMoment.hardwareCompression then
            isRestartNeeded = "(RESTART REQUIRED)"
        else
            isRestartNeeded = ""
        end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			love.graphics.push()
                menuBG:draw()

                graphics.setColor(1,1,0)
                if settingsMenuState == 0 then
                    love.graphics.print("Gameplay", -628, -100)
                    love.graphics.print("\n\nMisc.", -628, -100)
                    if settings.hardwareCompression ~= data.saveSettingsMoment.hardwareCompression then
                        love.graphics.print("\n\n\n\nSave settings & Restart", -628, -100)
                    else
                        love.graphics.print("\n\n\n\nSave settings", -628, -100)
                    end
                elseif settingsMenuState == 1 then
                    love.graphics.print("Downscroll = " .. tostring(settings.downscroll), -628, -100)
                    love.graphics.print("\n\nMiddlescroll = " .. tostring(settings.middleScroll), -628, -100)
                    love.graphics.print("\n\n\n\nGhost Tapping = " .. tostring(settings.ghostTapping), -628, -100)
                    love.graphics.print("\n\n\n\n\n\nSide Judgements = " .. tostring(settings.sideJudgements), -628, -100)
                    love.graphics.print("\n\n\n\n\n\n\n\nBot Play = " .. tostring(settings.botPlay), -628, -100)
                elseif settingsMenuState == 2 then
                    love.graphics.print("Hardware Compression = " .. tostring(settings.hardwareCompression) .. " " .. isRestartNeeded, -628, -100) 
                    love.graphics.print("\n\nShow Debug = " .. tostring(settings.showDebug), -628, -100)
                end
                love.graphics.print(newlinesMoment[settingSelect] .. ">", -640, -100)
                

                if settingsMenuState ~= 0 then
                    love.graphics.setColor(0,0,0,0.4)
                    love.graphics.rectangle("fill", -400, 175, 800, 300)
                    love.graphics.setColor(1,1,1)
                    if settingsMenuState == 1 then
                        love.graphics.printf(settingsDescriptions1[settingSelect], -390, 185, 1000, "left", nil, 0.8, 0.8)
                    elseif settingsMenuState == 2 then
                        love.graphics.printf(settingsDescriptions2[settingSelect], -390, 185, 1000, "left", nil, 0.8, 0.8)
                    end
                end

				love.graphics.scale(cam.sizeX, cam.sizeY)

				love.graphics.pop()
		love.graphics.pop()
	end,

	leave = function(self)
		

		Timer.clear()
	end
}
