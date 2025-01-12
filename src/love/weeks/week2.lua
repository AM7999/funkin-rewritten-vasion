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

local stageBack, stageFront, curtains, stageBack2

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()

		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {151,38,81}

		stageBack = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/selever/churchSelever/stage-back")))
		stageFront = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/selever/churchSelever/stage-front")))
		curtains = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/selever/churchSelever/curtains")))
        stageBack2 = graphics.newImage(love.graphics.newImage(graphics.imagePath("mfm/selever/churchSelever/stage-back2")))

		stageFront.y = 400
		curtains.y = -100

		enemy = love.filesystem.load("sprites/selever/fuckboi_sheet.lua")()

		girlfriend.x, girlfriend.y = 30, -90
		enemy.x, enemy.y = -380, -110
		boyfriend.x, boyfriend.y = 260, 100

		enemyIcon:animate("skid and pump", false)

		self:load()
	end,

	load = function(self)
		weeks:load()

			inst = love.audio.newSource("music/mfm/casanova/casanova_Inst.ogg", "stream")
			voices = love.audio.newSource("music/mfm/casanova/casanova_Voices.ogg", "stream")


		

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

			weeks:generateNotes(love.filesystem.load("charts/mfm/casanova" .. difficulty .. ".lua")())
	end,

	update = function(self, dt)
		weeks:update(dt)

		if song == 1 and musicThres ~= oldMusicThres and math.fmod(absMusicTime + 500, 480000 / bpm) < 100 then
			weeks:safeAnimate(boyfriend, "hey", false, 3)
		end

		if health >= 80 then
			if enemyIcon:getAnimName() == "skid and pump" then
				enemyIcon:animate("skid and pump losing", false)
			end
		else
			if enemyIcon:getAnimName() == "skid and pump losing" then
				enemyIcon:animate("skid and pump", false)
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

				stageBack2:draw()
				stageFront:draw()
				stageBack:draw()

				girlfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				enemy:draw()
				boyfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)

				curtains:draw(lovesize.getHeight(), lovesize.getHeight())
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
