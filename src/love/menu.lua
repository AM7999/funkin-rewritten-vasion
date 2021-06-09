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

menu = {
	init = function()
		songNum = 0
		menuState = 0
		
		inMenu = true
		
		weekSongs = {
			{
				"Tutorial"
			},
			{
				"Bopeebo",
				"Fresh",
				"Dadbattle"
			},
			{
				"Spookeez",
				"South"
			},
			{
				"Pico",
				"Philly Nice",
				"Blammed"
			},
			{
				"Satin Panties",
				"High",
				"M.I.L.F"
			}
		}
		difficultyStrs = {
			"-easy",
			"",
			"-hard"
		}
		
		selectSound = love.audio.newSource("sounds/scrollMenu.ogg", "static")
		confirmSound = love.audio.newSource("sounds/confirmMenu.ogg", "static")
		
		titleBG = Image(love.graphics.newImage("images/titleBG.png"))
		logo = Image(love.graphics.newImage("images/logo.png"))
		
		girlfriendTitle = love.filesystem.load("sprites/girlfriend-title.lua")()
		
		logo.x, logo.y = -350, -125
		logo.sizeX, logo.sizeY = 1.25, 1.25
		
		girlfriendTitle.x, girlfriendTitle.y = 300, -75
		
		music = love.audio.newSource("music/freakyMenu.ogg", "stream")
		music:setLooping(true)
		music:play()
	end,
	
	update = function(dt)
		girlfriendTitle:update(dt)
		
		if not graphics.isFading then
			if input:pressed("left") then
				audio.playSound(selectSound)
				
				if menuState == 0 then
					weekNum = weekNum - 1
					
					if weekNum < 0 then
						weekNum = 4
					end
				elseif menuState == 1 then
					songNum = songNum - 1
					
					if songNum < 0 then
						songNum = #weekSongs[weekNum + 1]
					end
				elseif menuState == 2 then
					songDifficulty = songDifficulty - 1
					
					if songDifficulty < 1 then
						songDifficulty = 3
					end
				end
			elseif input:pressed("right") then
				audio.playSound(selectSound)
				
				if menuState == 0 then
					weekNum = weekNum + 1
					
					if weekNum > 4 then
						weekNum = 0
					end
				elseif menuState == 1 then
					songNum = songNum + 1
					
					if songNum > #weekSongs[weekNum + 1] then
						songNum = 0
					end
				elseif menuState == 2 then
					songDifficulty = songDifficulty + 1
					
					if songDifficulty > 3 then
						songDifficulty = 1
					end
				end
			elseif input:pressed("confirm") then
				audio.playSound(confirmSound)
				
				menuState = menuState + 1
				
				if menuState > 2 then
					music:stop()
					
					menuState = 2 -- So menuState isn't an "invalid" value
					
					graphics.fadeOut(
						1,
						function()
							songAppend = difficultyStrs[songDifficulty]
							
							inMenu = false
							inGame = true
							
							if songNum == 0 then
								songNum = 1
								storyMode = true
							end
							
							weeks[weekNum].init()
						end
					)
				end
			elseif input:pressed("back") then
				if menuState > 0 then -- Don't play sound if exiting the game
					audio.playSound(selectSound)
				end
				
				menuState = menuState - 1
				
				if menuState == 0 then
					songNum = 0
				elseif menuState < 0 then
					menuState = 0 -- So menuState isn't an "invalid" value
					
					graphics.fadeOut(1, love.event.quit)
				end
			end
		end
	end,
	
	draw = function()
		titleBG:draw()
		
		love.graphics.push()
			love.graphics.scale(cam.sizeX, cam.sizeY)
			
			logo:draw()
			
			girlfriendTitle:draw()
			
			love.graphics.printf("By HTV04\nv1.0.0 beta 3\n\nOriginal game by ninjamuffin99, PhantomArcade, kawaisprite, and evilsk8er, in association with Newgrounds", -525, 90, 450, "right", nil, 1, 1)
			
			graphics.setColor(1, 1, 0)
			if menuState == 0 then
				if weekNum == 0 then
					love.graphics.printf("Choose a week: < Tutorial >", -640, 285, 853, "center", nil, 1.5, 1.5)
				else
					love.graphics.printf("Choose a week: < Week " .. weekNum .. " >", -640, 285, 853, "center", nil, 1.5, 1.5)
				end
			elseif menuState == 1 then
				if songNum == 0 then
					love.graphics.printf("Choose a song: < (Story Mode) >", -640, 285, 853, "center", nil, 1.5, 1.5)
				else
					love.graphics.printf("Choose a song: < " .. weekSongs[weekNum + 1][songNum] .. " >", -640, 285, 853, "center", nil, 1.5, 1.5)
				end
			elseif menuState == 2 then
				if songDifficulty == 1 then
					love.graphics.printf("Choose a difficulty: < Easy >", -640, 285, 853, "center", nil, 1.5, 1.5)
				elseif songDifficulty == 2 then
					love.graphics.printf("Choose a difficulty: < Normal >", -640, 285, 853, "center", nil, 1.5, 1.5)
				elseif songDifficulty == 3 then
					love.graphics.printf("Choose a difficulty: < Hard >", -640, 285, 853, "center", nil, 1.5, 1.5)
				end
			end
			graphics.setColor(1, 1, 1)
			
			if menuState <= 0 then
				if input:getActiveDevice() == "joy" then
					love.graphics.printf("Left Stick/D-Pad: Select | A: Confirm | B: Exit", -640, 350, 1280, "center", nil, 1, 1)
				else
					love.graphics.printf("Arrow Keys: Select | Enter: Confirm | Escape: Exit", -640, 350, 1280, "center", nil, 1, 1)
				end
			else
				if input:getActiveDevice() == "joy" then
					love.graphics.printf("Left Stick/D-Pad: Select | A: Confirm | B: Back", -640, 350, 1280, "center", nil, 1, 1)
				else
					love.graphics.printf("Arrow Keys: Select | Enter: Confirm | Escape: Back", -640, 350, 1280, "center", nil, 1, 1)
				end
			end
		love.graphics.pop()
	end
}
