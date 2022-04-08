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

local dialogueBox, senpaiPortrait, bfPortrait
local school, sky, street, trees, treesBack, petals, freaks, spiritPortait, angrySenpaiBox, scaryDialogueBox

return {
	enter = function(self, from, songNum, songAppend)
		cam.sizeX, cam.sizeY = 0.78, 0.78
		camScale.x, camScale.y = 0.78, 0.78
		weeks:pixelEnter()
		
		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {255,170,111}

		if storyMode then
			doingDialogue = true
			dialogueBox = love.filesystem.load("sprites/week6/dialogueBox.lua")()
			senpaiPortrait = love.filesystem.load("sprites/week6/senpaiPortrait.lua")()
			bfPortrait = love.filesystem.load("sprites/week6/bfPortrait.lua")()

			dialogueBox:animate("anim", false)
			bfPortrait:animate("anim", false)
			senpaiPortrait:animate("anim", false)

			dialogueBox.sizeX, dialogueBox.sizeY = 6, 6
			senpaiPortrait.sizeX, senpaiPortrait.sizeY = 6, 6
			bfPortrait.sizeX, bfPortrait.sizeY = 6, 6

			dialogueBox.x, dialogueBox.y = 650, 375
			bfPortrait.x, bfPortrait.y = 650, 375
			senpaiPortrait.x, senpaiPortrait.y = 650, 375
			if song ~= 3 then
				dialogueMusic = love.audio.newSource("music/pixel/Lunchbox.ogg", "static")
				dialogueMusic:setLooping(true)

				dialogueMusic:play()
			else
				dialogueMusic = love.audio.newSource("music/pixel/LunchboxScary.ogg", "static")
				dialogueMusic:setLooping(true)
				dialogueMusic:play()
			end
		end

		if song ~= 3 then
			sky = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/sky")))
			school = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/school")))
			street = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/street")))
			treesBack = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/trees-back")))

			trees = love.filesystem.load("sprites/week6/trees.lua")()
			petals = love.filesystem.load("sprites/week6/petals.lua")()
			freaks = love.filesystem.load("sprites/week6/freaks.lua")()

			enemyIcon:animate("senpai", false)
		end

		girlfriend.x, girlfriend.y = 30, -50
		boyfriend.x, boyfriend.y = 300, 190
		fakeBoyfriend.x, fakeBoyfriend.y = 300, 190

		self:load()
	end,

	load = function(self)
		if storyMode then
			doingDialogue = true
		else
			doingDialogue = false
		end
		if song == 3 then
			school = love.filesystem.load("sprites/week6/evil-school.lua")()
			enemy = love.filesystem.load("sprites/week6/spirit.lua")()

			scaryDialogueBox = love.filesystem.load("sprites/week6/scaryDialogueBox.lua")()
			spiritPortait = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/spiritFaceForward")))
			if storyMode then
				dialogueMusic = love.audio.newSource("music/pixel/LunchboxScary.ogg", "static")
				dialogueMusic:setLooping(true)
				dialogueMusic:play()
			end

			spiritPortait.sizeX, spiritPortait.sizeY = 6, 6
			scaryDialogueBox.sizeX, scaryDialogueBox.sizeY = 6, 6

			spiritPortait.x, spiritPortait.y = 400, 250
			scaryDialogueBox.x, scaryDialogueBox.y = 650, 375

			setDialogue(
				{
					"Direct contact with real humans, after being trapped in here for so long...",
					"and HER of all people.",
					"I'll make her father pay for what he's done to me and all the others,,,,",
					"I'll beat you and make you take my place.",
					"You don't mind your bodies being borrowed right? It's only fair..."
				}
			)
			enemyIcon:animate("spirit", false)

			healthBarColorEnemy = {255,60,110}
		elseif song == 2 then
			enemy = love.filesystem.load("sprites/week6/senpai-angry.lua")()

			angrySenpaiBox = love.filesystem.load("sprites/week6/angrySenpaiBox.lua")()
			angrySenpaiBox.x, angrySenpaiBox.y = 650, 375

			angrySenpaiBox.sizeX, angrySenpaiBox.sizeY = 6, 6

			setDialogue(
				{
					"Not bad for an ugly worm.",
					"But this time I'll rip your nuts off right after your girlfriend finishes gargling mine.",
					"Bop beep be be skdoo bep"
				}
			)
			if storyMode then
				angry_text_box = love.audio.newSource("sounds/pixel/ANGRY_TEXT_BOX.ogg", "static")
				angry_text_box:play()
			end

			freaks:animate("dissuaded", true)
		else
			enemy = love.filesystem.load("sprites/week6/senpai.lua")()
			setDialogue(
				{
					"Ah, a new fair maiden has come in search of true love!",
					"A serenade between gentlemen shall decide where her beautiful heart shall reside.",
					"Beep bo bop"
				}
			)
		end

		enemy.x, enemy.y = -340, -20

		weeks:load()

		if song == 3 then
			inst = love.audio.newSource("music/week6/thorns-inst.ogg", "stream")
			voices = love.audio.newSource("music/week6/thorns-voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("music/week6/roses-inst.ogg", "stream")
			voices = love.audio.newSource("music/week6/roses-voices.ogg", "stream")
		else
			inst = love.audio.newSource("music/week6/senpai-inst.ogg", "stream")
			voices = love.audio.newSource("music/week6/senpai-voices.ogg", "stream")
		end


		if storyMode then
			if song ~= 2 then
				dialogueMusic:play()
			end
		end
		self:initUI()
		if not storyMode then
			weeks:setupCountdown()
		end
	end,

	initUI = function(self)
		weeks:pixelInitUI()

		if song == 3 then
			weeks:generateNotes(love.filesystem.load("charts/week6/thorns" .. difficulty .. ".lua")())
		elseif song == 2 then
			weeks:generateNotes(love.filesystem.load("charts/week6/roses" .. difficulty .. ".lua")())
		else
			weeks:generateNotes(love.filesystem.load("charts/week6/senpai" .. difficulty .. ".lua")())
		end
	end,

	update = function(self, dt)
		weeks:update(dt)

		if song ~= 3 then
			petals:update(dt)
			trees:update(dt)
			freaks:update(dt)
		else
			school:update(dt)
		end

		if doingDialogue then
			weeks:doDialogue(dt)
			if song == 1 then
				senpaiPortrait:update(dt)
			elseif song == 2 then
				angrySenpaiBox:update(dt)
			elseif song == 3 then
				scaryDialogueBox:update(dt)
			end
			bfPortrait:update(dt)
			dialogueBox:update(dt)
			if input:pressed("confirm") then
				if not isDone then
					weeks:advanceDialogue()
				end
			end
			if isDone then
				if song ~= 2 then
					dialogueMusic:stop()
				end
				doingDialogue = false
				weeks:setupCountdown()
			end
		end

		if not doingDialogue and not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
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
		love.graphics.setFont(font)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)

				if song ~= 3 then
					sky:udraw()
				end

				school:udraw()
				if song ~= 3 then
					street:udraw()
					treesBack:udraw()

					trees:udraw()
					petals:udraw()
					freaks:udraw()
				end
				girlfriend:udraw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				enemy:udraw()
				boyfriend:udraw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)

			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()
		if doingDialogue then -- Doing this cuz i'm stupid as shit
			if song == 1 then
				dialogueBox:draw()
				if curDialogue ~= 3 then
					senpaiPortrait:draw()
				else
					bfPortrait:draw()
				end
			elseif song == 2 then
				if curDialogue ~= 3 then
					angrySenpaiBox:draw()
				else
					dialogueBox:draw()
					bfPortrait:draw()
				end
			elseif song == 3 then
				scaryDialogueBox:draw()
				spiritPortait:draw()
			end
			weeks:drawDialogue()
		end
		if not doingDialogue then
			weeks:drawUI()
			weeks:drawHealthBar()
		end
	end,

	leave = function(self)
		stageBack = nil
		stageFront = nil
		curtains = nil
		pixel = false
		font = love.graphics.newFont("fonts/vcr.ttf", 24)

		love.graphics.setDefaultFilter("linear")

		weeks:leave()
	end
}
