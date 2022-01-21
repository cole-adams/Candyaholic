function createZooKeepers(level)
	for i = 1, level do
		zookeepers[i] = {}
		zookeepers[i].y, zookeepers[i].x = math.random((410 - zookeeperstats.height), (height - zookeeperstats.height)), (1000 + math.random(0, width))
		zookeepers[i].orgx = zookeepers[i].x
		zookeepers[i].health = zookeeperstats.health
		zookeepers[i].returny = zookeepers[i].y
		zookeepers[i].attacked = false
		zookeepers[i].attackedFirst = false
		zookeepers[i].dx = 0
		zookeepers[i].dy = 0
		zookeepers[i].attackDmg = 5
		zookeepers[i].g = true
		zookeepers[i].cooldown = 0
		zookeepers[i].type = "zookeeper"
		zookeepers[i].lastdx = "left"
		zookeepers[i].scale = 1
		zookeepers[i].drawx = zookeepers[i].x
	end
end


function drawZooKeeper()
	love.graphics.setColor(1, 1, 61)
	for i = 1, #zookeepers do
		if zookeepers[i].lastdx == "left" then
			zookeepers[i].scale = -1
			zookeepers[i].drawx = zookeepers[i].x + zookeeperstats.width
		else
			zookeepers[i].scale = 1
			zookeepers[i].drawx = zookeepers[i].x
		end


		love.graphics.setColor(0, 0, 0, 100)
		love.graphics.rectangle("fill", zookeepers[i].x - 10, zookeepers[i].returny + (zookeeperstats.height - 25), zookeeperstats.width + 20, 35)
		love.graphics.reset()
		love.graphics.draw(zookeeperPng, zookeepers[i].drawx, zookeepers[i].y, 0, zookeepers[i].scale, 1)

		love.graphics.setColor(240, 0, 0)
		love.graphics.rectangle("fill", zookeepers[i].x, (zookeepers[i].y - 20), 100, 10)

		love.graphics.setColor(0, 240, 0)
		love.graphics.rectangle("fill", zookeepers[i].x, (zookeepers[i].y - 20), (100 * (zookeepers[i].health/50)), 10)
	end
end

function zooKeeperMovement(dt)
	for i = 1, #zookeepers do
		if zookeepers[i].attacked == false then
			math.randomseed(dt * math.random(1,6000000000))
			if zookeepers[i].x > (player.x + (player.width/2)) and zookeepers[i].y > (player.returny - (zookeeperstats.height - player.height)) then
				zookeepers[i].dx = 0 - (math.random(40, 150) * dt)
				zookeepers[i].dy = 0 - (math.random(40, 150) * dt)
			elseif zookeepers[i].x > (player.x + (player.width/2)) and zookeepers[i].y < (player.returny - (zookeeperstats.height - player.height)) then
				zookeepers[i].dx = 0 - (math.random(40, 150) * dt)
				zookeepers[i].dy = (math.random(40, 150) * dt)
			elseif (zookeepers[i].x - zookeeperstats.width) < player.x and zookeepers[i].y > (player.returny - (zookeeperstats.height - player.height)) then
				zookeepers[i].dx = (math.random(40, 150) * dt)
				zookeepers[i].dy = 0 - (math.random(40, 150) * dt)
			elseif (zookeepers[i].x - zookeeperstats.width) < player.x and zookeepers[i].y < (player.returny - (zookeeperstats.height - player.height)) then
				zookeepers[i].dx = (math.random(40, 150) * dt)
				zookeepers[i].dy = (math.random(40, 150) * dt)
			elseif zookeepers[i].x > (player.x + player.width) then
				zookeepers[i].dx = 0 - (math.random(60, 100) * dt)
			elseif (zookeepers[i].x - zookeeperstats.width) < player.x then
				zookeepers[i].dx = (math.random(60, 100) * dt)
			elseif zookeepers[i].y > (player.returny - (zookeeperstats.height - player.height)) then
				zookeepers[i].dy = 0 - (math.random(60, 100) * dt)
			elseif zookeepers[i].y < (player.returny - (zookeeperstats.height - player.height)) then
				zookeepers[i].dy = (math.random(60, 100) * dt)
			else
				zookeepers[i].dy = 0
				zookeepers[i].dx = 0
			end
		elseif zookeepers[i].attackedFirst then
			zookeepers[i].dy = (zookeepers[i].dy * dt)
			zookeepers[i].dx = (zookeepers[i].dx * dt)
			zookeepers[i].attackedFirst = false
		elseif zookeepers[i].jumpP then
			zookeepers[i].dx = (200 * dt)
		elseif zookeepers[i].jumpP == false then
			zookeepers[i].dx = (-200 * dt)
		end

		if zookeepers[i].g == false then
			if zookeepers[i].dy ~= 0 then
				 if zookeepers[i].returny < height - zookeepers[i].height and zookeepers[i].returny > (height * 0.25) - (zookeeperstats.height - 25) then
				elseif zookeepers[i].returny == (height * 0.25) - (zookeeperstats.height - 25) and zookeepers[i].dy > 0 then
		
				elseif zookeepers[i].returny == (height - zookeepers[i].height) and zookeepers[i].dy < 0 then
		
				else
					zookeepers[i].dy = 0
				end
			end

			zookeepers[i].returny = zookeepers[i].returny + zookeepers[i].dy
			zookeepers[i].dy = zookeepers[i].dy - (zookeepers[i].jumpv * dt)
			zookeepers[i].dy = zookeepers[i].dy - 10
			zookeepers[i].jumpv = zookeepers[i].jumpv - 10
		end

	    if camera.lx then
		 	zookeepers[i].dx = zookeepers[i].dx - camera.lastdx
		end

		if camera.ly then
			zookeepers[i].dy = zookeepers[i].dy - camera.lastdy
		end

		zookeepers[i].x = zookeepers[i].dx + zookeepers[i].x


		zookeepers[i].y = zookeepers[i].dy + zookeepers[i].y

		if zookeepers[i].g then
			zookeepers[i].returny = zookeepers[i].dy + zookeepers[i].returny
		end

		if zookeepers[i].y >= zookeepers[i].returny then
			zookeepers[i].g = true
			zookeepers[i].attacked = false
		end

		if zookeepers[i].g then
			zookeepers[i].y = zookeepers[i].returny
		end

		if zookeepers[i].dx > 0 then
			zookeepers[i].lastdx = "right"
		elseif zookeepers[i].dx < 0 then
			zookeepers[i].lastdx = "left"
		end

		zookeepers[i].dy = 0
		zookeepers[i].dx = 0
	end
end

function enemyJump(i)
	enemies[i].g = false
	enemies[i].jumpv = -200
	enemies[i].returny = enemies[i].y
end

function zookeeperAttack()
	for i = 1, #zookeepers do
		if zookeepers[i].cooldown < 0 then
			if (zookeepers[i].x + zookeeperstats.width) > player.x and (zookeepers[i].x + zookeeperstats.width) <= (player.x + (player.width/2)) and (zookeepers[i].y + zookeeperstats.height) > ((player.y + player.height) - 10) and (zookeepers[i].y + zookeeperstats.height) < ((player.y + player.height) + 10) and player.attacked == false and player.g == true then
				zookeepers[i].cooldown = 5
				player.attacked = true
				player.health = player.health - player.attackDmg
				player.dx = 200
				player.attackedFirst = true
				player.jumpP = true
				playerJump()
				break
			elseif zookeepers[i].x >= (player.x + (player.width/2)) and zookeepers[i].x < (player.x + player.width) and (zookeepers[i].y + zookeeperstats.height) > ((player.y + player.height) - 10) and (zookeepers[i].y + zookeeperstats.height) < ((player.y + player.height) + 10) and player.attacked == false and player.g == true then
				zookeepers[i].cooldown = 2
				player.attacked = true
				player.health = player.health - player.attackDmg
				player.dx = -200
				player.attackedFirst = true
				player.jumpP = false
				playerJump()
				break
			end
		end
	end
end

