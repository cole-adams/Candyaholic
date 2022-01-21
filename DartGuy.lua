function createDartGuys(level)
	for i = 1, level do
		dartguys[i] = {}
		dartguys[i].y, dartguys[i].x = math.random((410 - dartguystats.height), (height - dartguystats.height)), (math.random(0, width) + 1000)
		dartguys[i].orgx = dartguys[i].x
		dartguys[i].health = dartguystats.health
		dartguys[i].returny = dartguys[i].y
		dartguys[i].attacked = false
		dartguys[i].attackedFirst = false
		dartguys[i].dx = 0
		dartguys[i].dy = 0
		dartguys[i].attackDmg = 5
		dartguys[i].g = true
		dartguys[i].fired = false
		dartguys[i].cooldown = 0
		dartguys[i].type = "dartguy"
		dartguys[i].lastdx = "left"
		dartguys[i].scale = 1
		dartguys[i].drawx = dartguys[i].x
		bullets[i] = { width = 15, height = 5, x = dartguys[i].x + dartguystats.width,
				y = dartguys[i].y + ((dartguystats.height/2) + width), dx = 300}
	end
end


function drawDartGuy()
	love.graphics.setColor(1, 1, 61)
	for i = 1, #dartguys do

		if dartguys[i].facing == "left" then
			dartguys[i].scale = -1
			dartguys[i].drawx = dartguys[i].x + dartguystats.width
			if fired then
				bullets[i].scale = -1
				bullets[i].drawx = bullets[i].x +  bullets[i].width
			end
		else
			dartguys[i].scale = 1
			dartguys[i].drawx = dartguys[i].x
			if fired then
				bullets[i].scale = 1
				bullets[i].drawx = bullets[i].x
			end
		end

		love.graphics.setColor(0, 0, 0, 100)
		love.graphics.rectangle("fill", dartguys[i].x - 10, dartguys[i].returny + (dartguystats.height - 25), dartguystats.width + 20, 35)
		love.graphics.reset()

		love.graphics.draw(dartguyPng, dartguys[i].drawx, dartguys[i].y, 0, dartguys[i].scale, 1)

		if dartguys[i].fired then
			love.graphics.draw(dart, bullets[i].x, bullets[i].y, 0, dartguys[i].scale, 1)
		end
		love.graphics.setColor(240, 0, 0)
		love.graphics.rectangle("fill", dartguys[i].x, (dartguys[i].y - 20), 100, 10)

		love.graphics.setColor(0, 240, 0)
		love.graphics.rectangle("fill", dartguys[i].x, (dartguys[i].y - 20), (100 * (dartguys[i].health/30)), 10)
	end
end

function dartGuyMovement(dt)
	for i = 1, #dartguys do
		if dartguys[i].attacked == false and dartguys[i].fired == false then
			math.randomseed(dt * math.random(1,6000000000))
			if dartguys[i].x > (player.x + (player.width/2)) and dartguys[i].y > (player.returny - (dartguystats.height - player.height)) then
				dartguys[i].dx = 0 - (math.random(20, 75) * dt)
				dartguys[i].dy = 0 - (math.random(40, 150) * dt)
			elseif dartguys[i].x > (player.x + (player.width/2)) and dartguys[i].y < (player.returny - (dartguystats.height - player.height)) then
				dartguys[i].dx = 0 - (math.random(20, 75) * dt)
				dartguys[i].dy = (math.random(40, 150) * dt)
			elseif (dartguys[i].x - dartguystats.width) < player.x and dartguys[i].y > (player.returny - (dartguystats.height - player.height)) then
				dartguys[i].dx = (math.random(20, 75) * dt)
				dartguys[i].dy = 0 - (math.random(40, 150) * dt)
			elseif (dartguys[i].x - dartguystats.width) < player.x and dartguys[i].y < (player.returny - (dartguystats.height - player.height)) then
				dartguys[i].dx = (math.random(20, 75) * dt)
				dartguys[i].dy = (math.random(40, 150) * dt)
			elseif dartguys[i].x > (player.x + player.width) then
				dartguys[i].dx = 0 - (math.random(20, 75) * dt)
			elseif (dartguys[i].x - dartguystats.width) < player.x then
				dartguys[i].dx = (math.random(20, 75) * dt)
			elseif dartguys[i].y > (player.returny - (dartguystats.height - player.height)) then
				dartguys[i].dy = 0 - (math.random(40, 150) * dt)
			elseif dartguys[i].y < (player.returny - (dartguystats.height - player.height)) then
				dartguys[i].dy = (math.random(40, 150) * dt)
			else
				dartguys[i].dy = 0
				dartguys[i].dx = 0
			end
		elseif dartguys[i].attackedFirst then
			dartguys[i].dy = (dartguys[i].dy * dt)
			dartguys[i].dx = (dartguys[i].dx * dt)
			dartguys[i].attackedFirst = false
		elseif dartguys[i].jumpP and dartguys[i].fired == false then
			dartguys[i].dx = (200 * dt)
		elseif dartguys[i].jumpP == false and dartguys[i].fired == false then
			dartguys[i].dx = (-200 * dt)
		end

		if dartguys[i].g == false then
			if dartguys[i].dy ~= 0 then
				 if dartguys[i].returny < height - dartguys[i].height and dartguys[i].returny > (height * 0.25) - (dartguystats.height - 25) then
				elseif dartguys[i].returny == (height * 0.25) - (dartguystats.height - 25) and dartguys[i].dy > 0 then
		
				elseif dartguys[i].returny == (height - dartguys[i].height) and dartguys[i].dy < 0 then
		
				else
					dartguys[i].dy = 0
				end
			end

			dartguys[i].returny = dartguys[i].returny + dartguys[i].dy
			dartguys[i].dy = dartguys[i].dy - (dartguys[i].jumpv * dt)
			dartguys[i].dy = dartguys[i].dy - 10
			dartguys[i].jumpv = dartguys[i].jumpv - 10
		end

	    if camera.lx then
		 	dartguys[i].dx = dartguys[i].dx - camera.lastdx
		end

		if camera.ly then
			dartguys[i].dy = dartguys[i].dy - camera.lastdy
		end

		dartguys[i].x = dartguys[i].dx + dartguys[i].x

		dartguys[i].y = dartguys[i].dy + dartguys[i].y
		if dartguys[i].g then
			dartguys[i].returny = dartguys[i].dy + dartguys[i].returny
		end

		if dartguys[i].g then
		elseif dartguys[i].y > (height - dartguystats.height) and dartguys[i].g then
		 	dartguys[i].y = height - dartguystats.height
		end

		if dartguys[i].y >= dartguys[i].returny then
			dartguys[i].g = true
			dartguys[i].attacked = false
		end

		if dartguys[i].g then
			dartguys[i].y = dartguys[i].returny
		end

		if dartguys[i].dx > 0 then
			dartguys[i].facing = "right"
		elseif dartguys[i].dx < 0 then
			dartguys[i].facing = "left"
		end

		dartguys[i].dy = 0
		dartguys[i].dx = 0
	end
end

function dartGuyJump(i)
	dartguys[i].g = false
	dartguys[i].jumpv = -200
	dartguys[i].returny = dartguys[i].y
end

function dartGuyAttack(dt)
	for i = 1, #dartguys do
		if dartguys[i].fired then
			bullets[i].x = bullets[i].x + ((bullets[i].dx * dt) - camera.lastdx)
			bullets[i].y = bullets[i].y - camera.lastdy
			if (bullets[i].x + bullets[i].width) >= player.x and bullets[i].x <= (player.x + player.width) and (bullets[i].y + bullets[i].height) >= player.y and bullets[i].y <= (player.y + player.height) then
				if dartguys[i].facing == "right" then
					player.dx = 200
					player.jumpP = true
				elseif dartguys[i].facing == "left" then
					player.dx = -200
					player.jumpP = false
				end
				player.health = player.health - dartguys[i].attackDmg
				player.attacked = true
				player.attackedFirst = true
				playerJump()
				bullets[i] = { width = 15, height = 5, x = dartguys[i].x + dartguystats.width,
				y = dartguys[i].y + ((dartguystats.height/2) + width), dx = 300}
				dartguys[i].fired = false
			elseif bullets[i].x <= 0 or (bullets[i].x >= width) then
				bullets[i] = { width = 15, height = 5, x = dartguys[i].x + dartguystats.width,
				y = dartguys[i].y + ((dartguystats.height/2) + width), dx = 300}
				dartguys[i].fired = false
			end
		elseif dartguys[i].fired == false and (dartguys[i].y + dartguystats.height) >= ((player.y + player.height) - 10) and (dartguys[i].y + dartguystats.height) <= ((player.y + player.height) + 10) and dartguys[i].cooldown < 0 then
			bullets[i].width = 15
			bullets[i].height = 5
			dartguys[i].fired = true
			dartguys[i].cooldown = 3
			if dartguys[i].facing == "right" then 
				bullets[i].x = dartguys[i].x + dartguystats.width
				bullets[i].y = dartguys[i].y + ((dartguystats.height/2) + bullets[i].width)
				bullets[i].dx = 300
			else
				bullets[i].x = dartguys[i].x - bullets[i].width
				bullets[i].y = dartguys[i].y + ((dartguystats.height/2) + bullets[i].width)
				bullets[i].dx = -300
			end
		end
	end
end
