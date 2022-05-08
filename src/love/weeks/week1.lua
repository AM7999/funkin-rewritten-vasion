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

local song, difficulty

local church0_wall, church0_floor

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()

		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {175,102,206}

		
		church0_floor = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/sacredmass/church0/stageback")))
		church0_wall = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/sacredmass/church0/stagefront")))
	    
		
		curtains = graphics.newImage(love.graphics.newImage(graphics.imagePath("week1/curtains")))

		church0_wall.y = 400
		--curtains.y = -100

		enemy = love.filesystem.load("sprites/week1/daddy-dearest.lua")()

		girlfriend.x, girlfriend.y = 30, -90
		enemy.x, enemy.y = -380, -110
		boyfriend.x, boyfriend.y = 260, 100

		enemyIcon:animate("daddy dearest", false)

		self:load()
	end,

	load = function(self)
		weeks:load()
        if song == 4 then
			inst = love.audio.newSource("music/mfm/gospel/gospel_inst.ogg", "stream")
			voices = love.audio.newSource("music/mfm/gospel/gospel_voices.ogg", "stream")
		elseif song == 3 then
			inst = love.audio.newSource("music/mfm/zavodila/zavodila_inst.ogg", "stream")
			voices = love.audio.newSource("music/mfm/zavodila/zavodila_ioices.ogg", "stream")
	     elseif song == 2 then
			inst = love.audio.newSource("music/mfm/worship/worship_inst.ogg", "stream")
			voices = love.audio.newSource("music/mfm/worship/worship_voices.ogg", "stream")
		else
			inst = love.audio.newSource("music/mfm/parish/parish_inst.ogg", "stream")
			voices = love.audio.newSource("music/mfm/parish/parish_voices.ogg", "stream")
			church0_floor = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/sacredmass/church0/stageback")))
			church0_wall = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/sacredmass/church0/stagefront")))
			church0_wall:draw()
			church0_floor:draw()
		end
         
		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()
        if song == 4 then
			weeks:generateNotes(love.filesystem.load("charts/mfm/gospel" .. difficulty .. ".lua")())
		elseif song == 3 then
			weeks:generateNotes(love.filesystem.load("charts/mfm/zavodila" .. difficulty .. ".lua")())
		elseif song == 2 then
			weeks:generateNotes(love.filesystem.load("charts/mfm/worship" .. difficulty .. ".lua")())
		else
			weeks:generateNotes(love.filesystem.load("charts/mfm/parish" .. difficulty .. ".lua")())
		end
	end,

	update = function(self, dt)
		weeks:update(dt)

		if song == 1 and musicThres ~= oldMusicThres and math.fmod(absMusicTime + 500, 480000 / bpm) < 100 then
			weeks:safeAnimate(boyfriend, "hey", false, 3)
		end

		if health >= 80 then
			if enemyIcon:getAnimName() == "daddy dearest" then
				enemyIcon:animate("daddy dearest losing", false)
			end
		else
			if enemyIcon:getAnimName() == "daddy dearest losing" then
				enemyIcon:animate("daddy dearest", false)
			end
		end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
			if storyMode and song < 3 then
				song = song + 1

				self:load()
			else
				status.setLoading(true)

				graphics.fadeOut(
					0.5,
					function()
						Gamestate.switch(menu)

						status.setLoading(false)
					end
				)
			end
		end

		weeks:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)

				--stageBack:draw()
				--stageFront:draw()

				girlfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				enemy:draw()
				boyfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)

				--curtains:draw()
			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()

		weeks:drawUI()
		weeks:drawHealthBar()
	end,

	leave = function(self)
		stageBack = nil
		stageFront = nil
		curtains = nil

		weeks:leave()
	end
}
