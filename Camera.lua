function drawCamera()
	love.graphics.push()
	love.graphics.translate(- (camera.x * 0.5) , 0)
	love.graphics.setColor(0, 255, 251)
	love.graphics.rectangle("fill", 0, 0, 29000, height)
	love.graphics.pop()
	love.graphics.push()
	love.graphics.reset()

	love.graphics.translate(-camera.x, -camera.y)
	for i = 1, 29 do
		love.graphics.draw(streetpng, (1000 * (i-1)), (height/2) + 4)
	end
	love.graphics.pop()
end


function cameraAdjust(dt)
	camera.l = false

	if player.x >= ((width/2) - (player.width/2)) and camera.lpr and camera.dx > 0 then
		player.x = ((width/2) - (player.width/2))
		camera.lx = true
	elseif player.x <= ((width/2) - (player.width/2)) and camera.lpl and camera.dx < 0 then
		player.x = ((width/2) - (player.width/2))
		camera.lx = true
	end

	if player.returny >= ((height/2) - ((player.height/2))) and camera.lpd and camera.dy > 0 and player.g then
		player.returny = ((height/2) - (player.height/2))
		camera.ly = true
	elseif player.returny <= ((height/2) - ((player.height/2))) and camera.lpu and camera.dy < 0 and player.g then
		player.returny = ((height/2) - (player.height/2))
		camera.ly = true
	elseif player.returny >= ((height/2) - ((player.height/2))) and camera.lpd and camera.dy > 0 then
		camera.ly = true
		player.returny = ((height/2) - ((player.height/2)))
	elseif player.returny <= ((height/2) - ((player.height/2))) and camera.lpu and camera.dy < 0 then
		camera.ly = true
		player.returny = ((height/2) - ((player.height/2)))
	end

	camera.lpl = false
	camera.lpr = false
	camera.lpd = false
	camera.lpu = false

	if camera.x <= currentStart and camera.dx < 0 then
		camera.lx = false
	elseif camera.x > currentStart then
		camera.lpl = true
	end

	if camera.y <= 0 and camera.dy < 0 then
		camera.ly = false
	elseif camera.y > 0 then
		camera.lpu = true
	end

	if (camera.x + width) >= currentEnd and camera.dx > 0 then
		camera.lx = false
	elseif (camera.x + width) < currentEnd then
		camera.lpr = true
	end

	if (camera.y + height) >= 1152 and camera.dy > 0 then
		camera.ly = false
	elseif (camera.y + height) < 1152 then
		camera.lpd = true
	end


	if camera.lx then
		camera.x = camera.x + camera.dx
	else
		camera.dx = 0
	end

	if camera.ly then
		camera.y = camera.y + camera.dy
	else
		camera.dy = 0
	end

	camera.lastdy = camera.dy
	camera.lastdx = camera.dx
	camera.dy = 0
	camera.dx = 0
end