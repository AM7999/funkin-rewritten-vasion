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

local difficulty

local stageBack, stageFront, curtains

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()
		stages["reggieHouse"]:enter()

		song = songNum
		difficulty = songAppend

		enemyIcon:animate("mommy mearest", false)

		self:load()
	end,

	load = function(self)
		weeks:load()
		stages["reggieHouse"]:load()

		if song == 3 then
			inst = love.audio.newSource("songs/week1/dadbattle/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/week1/dadbattle/Voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("songs/week1/fresh/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/week1/fresh/Voices.ogg", "stream")
		else
			inst = love.audio.newSource("songs/week1/guys/Inst.ogg", "stream")
			voices = love.audio.newSource("songs/week1/guys/Voices.ogg", "stream")
		end

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		if song == 3 then
			weeks:generateNotes("data/week1/dadbattle/dadbattle" .. difficulty .. ".json")
		elseif song == 2 then
			weeks:generateNotes("data/week1/fresh/fresh" .. difficulty .. ".json")
		else
			weeks:generateNotes("data/week1/guys/guys" .. difficulty .. ".json")
		end
	end,

	update = function(self, dt)
		weeks:update(dt)
		stages["reggieHouse"]:update(dt)

		if health >= 1.595 then
            if enemyIcon:getAnimName() == "mommy mearest" then
                enemyIcon:animate("mommy mearest losing")
            end
        else
            if enemyIcon:getAnimName() == "mommy mearest losing" or enemyIcon:getAnimName() == "monika winning" then
                enemyIcon:animate("mommy mearest")
            end
        end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) and not paused then
			if storyMode and song < 3 then
				song = song + 1

				self:load()
			else
				status.setLoading(true)

				graphics:fadeOutWipe(
					0.7,
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
			love.graphics.scale(camera.zoom, camera.zoom)

			stages["reggieHouse"]:draw()
		love.graphics.pop()

		weeks:drawUI()
	end,

	leave = function(self)
		stages["reggieHouse"]:leave()

		enemy = nil
		boyfriend = nil
		girlfriend = nil

		graphics.clearCache()

		weeks:leave()
	end
}