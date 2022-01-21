function createBoss()
	boss = {y = ((player.y + player.height) - 450), x = (1000 + math.random(0, (width - 400))), 
	width = 400, height = 450, health = 1000, attackedFirst = false, dead = false, dyr = 0,
	dx = 0, dy = 0, attackDmg = 25, g = true, cooldown = 5, type = "boss"}
	boss.orgx = boss.x
	boss.returny = boss.y
	boss.exit = false
end

function drawBoss()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", boss.x - 10, boss.returny + (boss.height - 25), boss.width + 20, 35)
	love.graphics.reset()
	love.graphics.draw(bossPng, boss.x, boss.y)

	love.graphics.setFont(fontSmall)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Boss:", 470, -5)

	love.graphics.setColor(240, 0, 0)
	love.graphics.rectangle("fill", 575, 10, 300, 37)

	love.graphics.setColor(0, 240, 0)
	love.graphics.rectangle("fill", 575, 10, (300*(boss.health/1000)), 37)

end

function bossMovement(dt)
	if boss.dead then
		boss.dx = (400 * dt)
		boss.x = boss.x + boss.dx
	elseif boss.g then
		math.randomseed(dt * math.random(1,6000000000))
		if boss.x > (player.x + (player.width/2)) and boss.y > (player.returny - (boss.height - player.height)) then
			boss.dx = 0 - (math.random(20, 75) * dt)
			boss.dy = 0 - (math.random(20, 75) * dt)
		elseif boss.x > (player.x + (player.width/2)) and boss.y < (player.returny - (boss.height - player.height)) then
			boss.dx = 0 - (math.random(20, 75) * dt)
			boss.dy = (math.random(20, 75) * dt)
		elseif (boss.x - boss.width) < player.x and boss.y > (player.returny - (boss.height - player.height)) then
			boss.dx = (math.random(20, 75) * dt)
			boss.dy = 0 - (math.random(20, 75) * dt)
		elseif (boss.x - boss.width) < player.x and boss.y < (player.returny - (boss.height - player.height)) then
			boss.dx = (math.random(20, 75) * dt)
			boss.dy = (math.random(20, 75) * dt)
		elseif boss.x > (player.x + player.width) then
			boss.dx = 0 - (math.random(20, 75) * dt)
		elseif (boss.x - boss.width) < player.x then
			boss.dx = (math.random(20, 75) * dt)
		elseif boss.y > (player.returny - (boss.height - player.height)) then
			boss.dy = 0 - (math.random(20, 75) * dt)
		elseif boss.y < (player.returny - (boss.height - player.height)) then
			boss.dy = (math.random(20, 75) * dt)
		else
			boss.dy = 0
			boss.dx = 0
		end

	    if camera.lx then
		 	boss.dx = boss.dx - camera.lastdx
		end

		if camera.ly then
			boss.dy = boss.dy - camera.lastdy
		end

		boss.x = boss.dx + boss.x

		boss.returny = boss.dy + boss.returny

		if boss.y >= boss.returny then
			boss.g = true
		end

		if boss.g then
			boss.y = boss.returny
		end

		boss.dy = 0
		boss.dx = 0
	elseif boss.g == false then
		boss.t = boss.t - dt
		if boss.t > 0 and 0 > (boss.y + boss.height) then
			boss.dy = (300 * dt)
			if boss.x < (player.x - ((boss.width - player.width)/2)) - 10 then
				boss.dx = (300 * dt)
			elseif boss.x > (player.x - ((boss.width - player.width)/2)) + 10 then
				boss.dx = -(300 * dt)
			end

			if (boss.returny + boss.height) < (player.y + player.height) - 10 then
				boss.dyr = (300 * dt)
			elseif (boss.returny + boss.height) > (player.y + player.height) + 10 then
				boss.dyr = -(300 * dt)
			end

			boss.dy = 0
			boss.y = 0 - boss.height - 1000 

		elseif boss.t <= 0 and firstFrame then
			boss.y = 0 - boss.height
			boss.dy = (500 * dt)
			boss.dx = 0
			boss.dyr = 0
			firstFrame = false
		elseif boss.t <= 0 then
			boss.dy = (500 * dt)
			boss.dx = 0
			boss.dyr = 0
		elseif 0 < (boss.y + boss.height) then
			boss.dy = -(500 * dt)
			boss.dx = 0
			boss.dyr = 0
		end
		if camera.lx then
			boss.dx = boss.dx - camera.lastdx
		end

		if camera.ly then
			boss.dyr = boss.dyr - camera.lastdy
			boss.dy = boss.dy - camera.lastdy
		end

		boss.x = boss.x + boss.dx
		boss.returny = boss.returny + boss.dyr
		boss.y = boss.y + boss.dy
		if boss.y >= boss.returny then
			boss.y = boss.returny
			boss.g = true
			if (player.x + player.width) >= boss.x and player.x <= (boss.x + boss.width) and (player.y + player.height) >= (boss.returny + boss.height - 20) and (player.y + player.height) <= (boss.returny + boss.height + 20) then
				player.health = player.health - boss.attackDmg
			end
		end
		boss.dx = 0
		boss.dy = 0
		boss.dyr = 0
	end
end


function bossAttack(dt)
	boss.cooldown = boss.cooldown - dt
	if boss.cooldown <= 0 and boss.g == true then
		boss.t = 4
		boss.g = false
		firstFrame = true
		boss.cooldown = 30
	end
end

function bossDead()
	playable = false
	playableEnd = false
	playableStart = false
	boss.exit = false
	if boss.x > width and player.x >= (lollipopx - player.width) - 10 and player.x <= (lollipopx - player.width) + 10  and player.y >= (lollipopy + 175) - player.height - 10 and player.y <= (lollipopy + 175) - player.height + 10 then
		player.frame = 10
		fade = true
	end
end
