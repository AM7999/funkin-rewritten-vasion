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

local walls, escalator, christmasTree, snow

local topBop, bottomBop, santa

local scaryIntro = false

week5Playing = true

return {
	enter = function(self, from, songNum, songAppend)
		cam.sizeX, cam.sizeY = 0.7, 0.7
		camScale.x, camScale.y = 0.7, 0.7

		week = 5

		--PAUSE MENU IMAGES
		resume = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/resume"))) -- USE THIS FUNCTION
		resumeH = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/resumeHover")))
		restart = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/restart")))
		restartH = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/restartHover")))
		exit = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/exit")))
		exitH = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/exitHover")))
		options = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/options")))
		optionsH = graphics.newImage(love.graphics.newImage(graphics.imagePath("pause/optionsHover")))
								
		resume.x, resume.y = 400, 120
		resumeH.x, resumeH.y = resume.x, resume.y
		restart.x, restart.y = 400, 295
		restartH.x, restartH.y = restart.x, restart.y 
		exit.x, exit.y = 400, 470
		exitH.x, exitH.y = exit.x, exit.y 
		options.x, options.y = 400, 645
		optionsH.x, optionsH.y = options.x, options.y

		missCounter = 0
		noteCounter = 0
		altScore = 0
		uiTextColour = {0,0,0} -- Changed the UI colour to black

		week5Playing = true

		bpm = 100
		useAltAnims = false

		enemyFrameTimer = 0
		boyfriendFrameTimer = 0

		sounds = { -- Since week5 doesn't use weeks:load, all of the load stuff was added here
			countdown = {
				three = love.audio.newSource("sounds/countdown-3.ogg", "static"),
				two = love.audio.newSource("sounds/countdown-2.ogg", "static"),
				one = love.audio.newSource("sounds/countdown-1.ogg", "static"),
				go = love.audio.newSource("sounds/countdown-go.ogg", "static")
			},
			miss = {
				love.audio.newSource("sounds/miss1.ogg", "static"),
				love.audio.newSource("sounds/miss2.ogg", "static"),
				love.audio.newSource("sounds/miss3.ogg", "static")
			},
			hitsounds = {
				left = love.audio.newSource("sounds/hitSound.ogg", "static"),  -- THERE IS A REAL REASON FOR THIS, IF YOU ONLY USE ONE SOUND THEN PRESSING MORE THAN ONE KEY AT THE SAME TIME WILL ONLY PLAY ONE SOUND
				right = love.audio.newSource("sounds/hitSound.ogg", "static"),
				up = love.audio.newSource("sounds/hitSound.ogg", "static"),
				down = love.audio.newSource("sounds/hitSound.ogg", "static")
			},
			death = love.audio.newSource("sounds/death.ogg", "static"),
			lightsOff = love.audio.newSource("sounds/week5/lights-off.ogg", "static"),
			lightsOn = love.audio.newSource("sounds/week5/lights-on.ogg", "static"),
			breakfast = love.audio.newSource("songs/misc/breakfast.ogg", "stream"),
			["text"] = love.audio.newSource("sounds/pixel/text.ogg", "static"),
			["continue"] = love.audio.newSource("sounds/pixel/continue-text.ogg", "static"),
		}

		images = {
			icons = love.graphics.newImage(graphics.imagePath("icons")),
			notes = love.graphics.newImage(graphics.imagePath("notes")),
			notesplashes = love.graphics.newImage(graphics.imagePath("noteSplashes")),
			numbers = love.graphics.newImage(graphics.imagePath("numbers"))
		}

		sprites = {
			icons = love.filesystem.load("sprites/icons.lua"),
			numbers = love.filesystem.load("sprites/numbers.lua")
		}

		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {175,102,206}
		healthBarColorPlayer = {49,176,209}

		leftArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()
		downArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()
		upArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()
		rightArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()

		if song ~= 3 then
			walls = graphics.newImage(love.graphics.newImage(graphics.imagePath("week5/walls")))
			escalator = graphics.newImage(love.graphics.newImage(graphics.imagePath("week5/escalator")))
			christmasTree = graphics.newImage(love.graphics.newImage(graphics.imagePath("week5/christmas-tree")))
			snow = graphics.newImage(love.graphics.newImage(graphics.imagePath("week5/snow")))

			escalator.x = 125
			christmasTree.x = 75
			snow.y = 850
			snow.sizeX, snow.sizeY = 2, 2

			topBop = love.filesystem.load("sprites/week5/top-bop.lua")()
			bottomBop = love.filesystem.load("sprites/week5/bottom-bop.lua")()
			santa = love.filesystem.load("sprites/week5/santa.lua")()

			topBop.x, topBop.y = 60, -250
			bottomBop.x, bottomBop.y = -75, 375
			santa.x, santa.y = -1350, 410
		end

		girlfriend = love.filesystem.load("sprites/week5/girlfriend.lua")()
		enemy = love.filesystem.load("sprites/week5/dearest-duo.lua")()
		boyfriend = love.filesystem.load("sprites/week5/boyfriend.lua")()
		fakeBoyfriend = love.filesystem.load("sprites/boyfriend.lua")() -- Used for game over

		rating = love.filesystem.load("sprites/rating.lua")()

		girlfriend.x, girlfriend.y = -50, 410
		enemy.x, enemy.y = -780, 410
		boyfriend.x, boyfriend.y = 300, 620
		fakeBoyfriend.x, fakeBoyfriend.y = 300, 620

		rating.sizeX, rating.sizeY = 0.75, 0.75
		numbers = {}
		for i = 1, 3 do
			numbers[i] = sprites.numbers()

			numbers[i].sizeX, numbers[i].sizeY = 0.5, 0.5
		end

		enemyIcon = sprites.icons()
		boyfriendIcon = sprites.icons()

		if settings.downscroll then
			enemyIcon.y = -400
			boyfriendIcon.y = -400
		else
			enemyIcon.y = 350
			boyfriendIcon.y = 350
		end
		enemyIcon.sizeX, enemyIcon.sizeY = 1.5, 1.5
		boyfriendIcon.sizeX, boyfriendIcon.sizeY = -1.5, 1.5

		countdownFade = {}
		countdown = love.filesystem.load("sprites/countdown.lua")()

		enemyIcon:animate("dearest duo", false)

		self:load()
	end,

	load = function(self)
		weeks:load()

		if song == 3 then
			camScale.x, camScale.y = 0.9, 0.9

			if scaryIntro then
				cam.x, cam.y = -150, 750
				cam.sizeX, cam.sizeY = 2.5, 2.5

				graphics.setFade(1)
			else
				cam.sizeX, cam.sizeY = 0.9, 0.9
			end

			walls = graphics.newImage(love.graphics.newImage(graphics.imagePath("week5/evil-bg")))
			christmasTree = graphics.newImage(love.graphics.newImage(graphics.imagePath("week5/evil-tree")))
			snow = graphics.newImage(love.graphics.newImage(graphics.imagePath("week5/evil-snow")))

			walls.y = -250
			christmasTree.x = 75
			christmasTree.sizeX, christmasTree.sizeY = 0.5, 0.5
			snow.x, snow.y = -50, 770

			enemy = love.filesystem.load("sprites/week5/monster.lua")()

			enemy.x, enemy.y = -780, 420

			enemyIcon:animate("monster", false)

			inst = love.audio.newSource("songs/week5/winter-horrorland/inst.ogg", "stream")
			voices = love.audio.newSource("songs/week5/winter-horrorland/voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("songs/week5/eggnog/inst.ogg", "stream")
			voices = love.audio.newSource("songs/week5/eggnog/voices.ogg", "stream")
		else
			inst = love.audio.newSource("songs/week5/cocoa/inst.ogg", "stream")
			voices = love.audio.newSource("songs/week5/cocoa/voices.ogg", "stream")
		end

		self:initUI()

		if scaryIntro then
			Timer.after(
				5,
				function()
					scaryIntro = false

					camTimer = Timer.tween(2, cam, {x = -boyfriend.x + 100, y = -boyfriend.y + 75, sizeX = 0.9, sizeY = 0.9}, "out-quad")

					weeks:setupCountdown()
				end
			)

			audio.playSound(sounds.lightsOn)
		else
			weeks:setupCountdown()
		end
	end,

	initUI = function(self)
		weeks:initUI()

		if song == 3 then
			weeks:generateNotes(love.filesystem.load("songs/week5/winter-horrorland/" .. difficulty .. ".lua")())
		elseif song == 2 then
			weeks:generateNotes(love.filesystem.load("songs/week5/eggnog/" .. difficulty .. ".lua")())
		else
			weeks:generateNotes(love.filesystem.load("songs/week5/cocoa/" .. difficulty .. ".lua")())
		end
	end,

	update = function(self, dt)
		if not scaryIntro then
			weeks:update(dt)

			if song ~= 3 then
				topBop:update(dt)
				bottomBop:update(dt)
				santa:update(dt)

				if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 60000 / bpm) < 100 then
					topBop:animate("anim", false)
					bottomBop:animate("anim", false)
					santa:animate("anim", false)
				end
			end

			if song == 3 then
				if health >= 80 then
					if enemyIcon:getAnimName() == "monster" then
						enemyIcon:animate("monster losing", false)
					end
				else
					if enemyIcon:getAnimName() == "monster losing" then
						enemyIcon:animate("monster", false)
					end
				end
			else
				if health >= 80 then
					if enemyIcon:getAnimName() == "dearest duo" then
						enemyIcon:animate("dearest duo losing", false)
					end
				else
					if enemyIcon:getAnimName() == "dearest duo losing" then
						enemyIcon:animate("dearest duo", false)
					end
				end
			end

			if not (scaryIntro or countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) and not paused then
				if storyMode and song < 3 then
					song = song + 1

					-- Winter Horrorland setup
					if song == 3 then
						scaryIntro = true

						audio.playSound(sounds.lightsOff)

						graphics.setFade(0)

						Timer.after(3, function() self:load() end)
					else
						self:load()
					end
				else
					status.setLoading(true)

					graphics.fadeOut(
						0.5,
						function()
							if storyMode then
								Gamestate.switch(menuWeek)
							else
								Gamestate.switch(menuFreeplay)
							end

							status.setLoading(false)
						end
					)
				end
			end

			weeks:updateUI(dt)
			
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
				love.graphics.translate(cam.x * 0.5, cam.y * 0.5)

				walls:draw()
				if song ~= 3 then
					topBop:draw()
					escalator:draw()
				end
				christmasTree:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)

				if song ~= 3 then
					bottomBop:draw()
				end

				snow:draw()

				girlfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				if song ~= 3 then
					santa:draw()
				end
				enemy:draw()
				boyfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)
			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()

		if not scaryIntro then
			love.graphics.push()
				love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
				love.graphics.scale(0.7, 0.7)

				for i = 1, 4 do
					if enemyArrows[i]:getAnimName() == "off" then
						graphics.setColor(0.6, 0.6, 0.6)
					end
					if settings.middleScroll then
						love.graphics.setColor(0.6,0.6,0.6,0.3)
					end
					enemyArrows[i]:draw()
					graphics.setColor(1, 1, 1)
					boyfriendArrows[i]:draw()

					if hitSick then
						if input:pressed("gameLeft") then
							leftArrowSplash:animate("left")
						elseif input:pressed("gameRight") then
							rightArrowSplash:animate("right")
						elseif input:pressed("gameUp") then
							upArrowSplash:animate("up")
						elseif input:pressed("gameDown") then
							downArrowSplash:animate("down")
						end
					end
					if leftArrowSplash:isAnimated() then
						leftArrowSplash:draw()
					elseif rightArrowSplash:isAnimated() then
						rightArrowSplash:draw()
					elseif upArrowSplash:isAnimated() then
						upArrowSplash:draw()
					elseif downArrowSplash:isAnimated() then
						downArrowSplash:draw()
					end

					love.graphics.push()
						love.graphics.translate(0, -musicPos)

						for j = #enemyNotes[i], 1, -1 do
							if (not settings.downscroll and enemyNotes[i][j].y - musicPos <= 560) or (settings.downscroll and enemyNotes[i][j].y - musicPos >= -560) then
								local animName = enemyNotes[i][j]:getAnimName()

								if animName == "hold" or animName == "end" then
									graphics.setColor(1, 1, 1, 0.5)
								end
								if settings.middleScroll then
									love.graphics.setColor(1,1,1,0.3)
								end
								enemyNotes[i][j]:draw()
								graphics.setColor(1, 1, 1)
							end
						end
						for j = #boyfriendNotes[i], 1, -1 do
							if (not settings.downscroll and boyfriendNotes[i][j].y - musicPos <= 560) or (settings.downscroll and boyfriendNotes[i][j].y - musicPos >= -560) then
								local animName = boyfriendNotes[i][j]:getAnimName()

								if settings.downscroll then
									if animName == "hold" or animName == "end" then
										graphics.setColor(1, 1, 1, math.min(0.5, (500 - (boyfriendNotes[i][j].y - musicPos)) / 150))
									else
										graphics.setColor(1, 1, 1, math.min(1, (500 - (boyfriendNotes[i][j].y - musicPos)) / 75))
									end
								else
									if animName == "hold" or animName == "end" then
										graphics.setColor(1, 1, 1, math.min(0.5, (500 + (boyfriendNotes[i][j].y - musicPos)) / 150))
									else
										graphics.setColor(1, 1, 1, math.min(1, (500 + (boyfriendNotes[i][j].y - musicPos)) / 75))
									end
								end
								boyfriendNotes[i][j]:draw()
							end
						end
						graphics.setColor(1, 1, 1)
					love.graphics.pop()
				end

				boyfriendIcon:draw()
				enemyIcon:draw()

				weeks:drawHealthBar()

				graphics.setColor(1, 1, 1, countdownFade[1])
				countdown:draw()
				graphics.setColor(1, 1, 1)
			love.graphics.pop()
		end
	end,

	leave = function()
		walls = nil
		escalator = nil
		topBop = nil
		bottomBop = nil
		christmasTree = nil
		santa = nil
		snow = nil
		

		week5Playing = false

		uiTextColour = {1,1,1}

		weeks:leave()
	end
}
