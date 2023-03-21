return {
    enter = function()
        stageImages = {
            ["Dream City"] = graphics.newImage(graphics.imagePath("week1/ReggieBG")) -- stage-back
        }

        enemy = love.filesystem.load("sprites/week1/Reggie2.lua")()

        girlfriend.x, girlfriend.y = -5, 14
        enemy.x, enemy.y = -530, 64
        boyfriend.x, boyfriend.y = 568, 254
    end,

    load = function()

    end,

    update = function(self, dt)
    end,

    draw = function()
        love.graphics.push()
			love.graphics.translate(camera.x * 0.9, camera.y * 0.9)
            love.graphics.translate(camera.ex * 0.9, camera.ey * 0.9)

			stageImages["Dream City"]:draw()

			girlfriend:draw()
		love.graphics.pop()
		love.graphics.push()
			love.graphics.translate(camera.x, camera.y)
            love.graphics.translate(camera.ex, camera.ey)
			enemy:draw()
			boyfriend:draw()
            graphics.setColor(1,1,1)
            
		love.graphics.pop()
		love.graphics.push()
			love.graphics.translate(camera.x * 1.1, camera.y * 1.1)
            love.graphics.translate(camera.ex * 1.1, camera.ey * 1.1)

		love.graphics.pop()
    end,

    leave = function()
        stageImages[1] = nil
        stageImages[2] = nil
        stageImages[3] = nil
    end
}