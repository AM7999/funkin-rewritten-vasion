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

local upFunc, downFunc, confirmFunc, backFunc, drawFunc, musicStop

local menuState

local menuNum = 1

local weekNum = 1
local songNum, songAppend
local songDifficulty = 2

local selectSound = love.audio.newSource("sounds/menu/select.ogg", "static")
local confirmSound = love.audio.newSource("sounds/menu/confirm.ogg", "static")

local music = love.audio.newSource("music/menu/menu.ogg", "stream")

local function switchMenu(menu)
	function backFunc()
		graphics.fadeOut(0.5, love.event.quit)
	end

	menuState = 1
end

music:setLooping(true)

return {
	enter = function(self, previous)
		logo = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/logo"))) 

		girlfriendTitle = love.filesystem.load("sprites/menu/girlfriend-title.lua")()
		titleEnter = love.filesystem.load("sprites/menu/titleEnter.lua")()
        titleEnter:animate("anim", true)
		logo.x, logo.y = -350, -125

		girlfriendTitle.x, girlfriendTitle.y = 325, 65

		titleEnter.x, titleEnter.y = 225, 350
		songNum = 0

		cam.sizeX, cam.sizeY = 0.9, 0.9
		camScale.x, camScale.y = 0.9, 0.9

		switchMenu(1)

		graphics.setFade(0)
		graphics.fadeIn(0.5)

		if useDiscordRPC then
			presence = {
				state = "Press Enter",
				details = "In the Menu",
				largeImageKey = "logo",
				startTimestamp = now,
			}
			nextPresenceUpdate = 0
		end

		music:play()
	end,

	musicStop = function(self)
		music:stop()
	end,

	musicVolumeLower = function(self)
		music:setVolume(0.4)
	end,

	update = function(self, dt)
		girlfriendTitle:update(dt)
		titleEnter:update(dt)
		--titleEnter:animate("anim", true)

		if not graphics.isFading() then
			if input:pressed("confirm") then
				audio.playSound(confirmSound)

				titleEnter:animate("pressed", true)
				Timer.after(0.6, 
					function()
						graphics.fadeOut(
							0.3,
							function()
								Gamestate.switch(menuSelect)
								status.setLoading(false)
							end
						)
					end
				)	
			elseif input:pressed("back") then
				audio.playSound(selectSound)

				backFunc()
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			love.graphics.push()
				love.graphics.scale(cam.sizeX, cam.sizeY)

				logo:draw()

				girlfriendTitle:draw()
				titleEnter:draw()

				love.graphics.pop()
		love.graphics.pop()
	end,

	leave = function(self)
		girlfriendTitle = nil
		titleEnter = nil
		logo = nil

		Timer.clear()
	end
}
