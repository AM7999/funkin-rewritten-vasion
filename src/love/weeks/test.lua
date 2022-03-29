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

local stageBack, stageFront, curtains

return {
	enter = function(self, from, songNum, songAppend)
		weeks_test:enter()

		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {49,176,209}

		stageBack = graphics.newImage(love.graphics.newImage(graphics.imagePath("week1/stage-back")))
		stageFront = graphics.newImage(love.graphics.newImage(graphics.imagePath("week1/stage-front")))
		curtains = graphics.newImage(love.graphics.newImage(graphics.imagePath("week1/curtains")))

		stageFront.y = 400
		curtains.y = -100

        love.graphics.setDefaultFilter("nearest")
		enemy = love.filesystem.load("sprites/pixel/test/boyfriend.lua")()
        love.graphics.setDefaultFilter("linear")

		girlfriend.x, girlfriend.y = 30, -90
		enemy.x, enemy.y = -380, -210
		boyfriend.x, boyfriend.y = 260, 100

		enemyIcon:animate("boyfriend (pixel)", false)

		self:load()
	end,

	load = function(self)
		weeks_test:load()

		inst = love.audio.newSource("music/test/test-inst.ogg", "stream")
		voices = love.audio.newSource("music/test/test-voices.ogg", "stream")

		self:initUI()

		weeks_test:setupCountdown()
	end,

	initUI = function(self)
		weeks_test:initUI()

		weeks_test:generateNotes(love.filesystem.load("charts/test/test.lua")())
	end,

	update = function(self, dt)
		weeks_test:update(dt)

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
			status.setLoading(true)

			graphics.fadeOut(
				0.5,
				function()
					Gamestate.switch(menu)

					status.setLoading(false)
				end
			)
		end

		weeks_test:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)

				stageBack:draw()
				stageFront:draw()

				girlfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				enemy:udraw(-7,7)
				boyfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)

				curtains:draw()
			love.graphics.pop()
			weeks_test:drawRating(0.9)
		love.graphics.pop()

		weeks_test:drawUI()
	end,

	leave = function(self)
		stageBack = nil
		stageFront = nil
		curtains = nil

		weeks_test:leave()
	end
}
