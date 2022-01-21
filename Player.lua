function drawPlayer()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", player.x - 10, player.returny + (player.height - 25), player.width + 20, 35)

	if cooldown > 0.01 or player.frame == 10 then
		lionDraw = lionAnim[6]
	elseif player.frame == 0 then
		lionDraw = lionAnim[1]
	elseif player.frame == 1 then
		lionDraw = lionAnim[2]
	elseif player.frame == 2 then
		lionDraw = lionAnim[3]
	elseif player.frame == 4 then
		lionDraw = lionAnim[2]
	elseif player.frame == 5 then
		lionDraw = lionAnim[1]
	elseif player.frame == 6 then
		lionDraw = lionAnim[4]
	elseif player.frame == 7 then
		lionDraw = lionAnim[5]
	elseif player.frame == 8 then
		lionDraw = lionAnim[4]
	elseif player.frame == 9 then
		lionDraw = lionAnim[1]
		player.frame = 0
	end

	if player.scale < 0 then
		player.drawx = player.x + player.width
	else
		player.drawx = player.x
	end

	if player.cheese < 0 then
		player.drawy = player.y + player.height
	else
		player.drawy = player.y
	end

	love.graphics.reset()

	love.graphics.draw(lion,lionDraw, player.drawx, player.drawy, 0, player.scale, player.cheese)

	love.graphics.setFont(fontSmall)
	love.graphics.print("Health:", 10, -5)

	love.graphics.setColor(240, 0, 0)
	love.graphics.rectangle("fill", 160, 10, 300, 37)

	love.graphics.setColor(0, 240, 0)
	love.graphics.rectangle("fill", 160, 10, (300*(player.health/100)), 37)


	if player.dead or fade then
		if darken < 255 then
			darken = darken + 1
		end
		love.graphics.setColor(0, 0, 0, darken)
		love.graphics.rectangle("fill", 0, 0, width, height)
	end
end


function playerMovement(dt)

	if player.attacked == false and cooldown < 0 and playable then
		if love.keyboard.isDown("up") and love.keyboard.isDown("right") then
			player.dy = 0 - (player.v * dt)
			player.dx = (player.v * dt)
		elseif love.keyboard.isDown("down") and love.keyboard.isDown("right") then
			player.dy = (player.v * dt)
			player.dx = (player.v * dt)
		elseif love.keyboard.isDown("up") and love.keyboard.isDown("left") then
			player.dy = 0 - (player.v * dt)
			player.dx = 0 - (player.v * dt)
	 	elseif love.keyboard.isDown("down") and love.keyboard.isDown("left") then
			player.dy = (player.v * dt)
			player.dx = 0 - (player.v * dt)
		elseif love.keyboard.isDown("up") then
			player.dy = 0 - (player.v * dt)
		elseif love.keyboard.isDown("down") then
			player.dy = (player.v * dt)
		elseif love.keyboard.isDown("left") then
			player.dx = 0 - (player.v * dt)
	 	elseif love.keyboard.isDown("right") then
			player.dx = (player.v * dt)
		else
			player.dx = 0
			player.dy = 0
		end

		player.frameCooldown = player.frameCooldown - dt

		if player.dx > 0 and player.frameCooldown < 0 then
			player.frame = player.frame + 1
			player.scale = 1
			player.frameCooldown = 0.1
		elseif player.dx < 0 and player.frameCooldown < 0 then
			player.frame = player.frame + 1
			player.scale = -1
			player.frameCooldown = 0.1
		elseif player.dy > 0 and player.frameCooldown < 0 then
			player.frame = player.frame + 1
			player.scale = 1
			player.frameCooldown = 0.1
		elseif player.dy < 0 and player.frameCooldown < 0 then
			player.frame = player.frame + 1
			player.scale = -1
			player.frameCooldown = 0.1
		elseif player.dx == 0 and player.dy == 0 then
			player.frame = 0
		end

	elseif player.attackedFirst then
		player.dy = (player.dy * dt)
		player.dx = (player.dx * dt)
		player.attackedFirst = false
	elseif player.jumpP and player.attacked then
		player.dx = (200 * dt)
	elseif player.jumpP == false and player.attacked then
		player.dx = (-200 * dt)
	end

	if player.g == false then
		player.frame = 1
		if player.dy ~= 0 then
			 if player.returny < height - player.height and player.returny > (310 - player.dy) then
			elseif player.returny == 310 and player.dy > 0 then
	
			elseif player.returny == (height - player.height) and player.dy < 0 then
	
			else
				player.dy = 0
			end
		end
		camera.dy = player.dy
		player.returny = player.returny + player.dy
		if camera.ly then
			player.dy = - (player.jumpv * dt)
		else
			player.dy = player.dy - (player.jumpv * dt)
		end
		player.dy = player.dy - 10
		player.jumpv = player.jumpv - 10
	end

	camera.dx = player.dx

	if player.g then
		camera.dy = player.dy
	end

	if camera.lx and player.dead == false then
		player.dx = 0
	end

	if camera.ly and player.g and player.dead == false then
		player.dy = 0
	end

	if player.x < (width - player.width) and player.x > 0 then
		player.x = player.dx + player.x
		if player.x < 0 then
			player.x = 0
		elseif player.x >= (width - player.width) then
			player.x = (width - player.width)
		end
	elseif player.x == 0 and player.dx > 0 then
		player.x = player.dx + player.x
	elseif player.x == (width - player.width) and player.dx < 0 then
		player.x = player.dx + player.x
	end

	if player.y < height - player.height and player.y > 310 and player.g then
		player.y = player.dy + player.y
		player.returny = player.dy + player.returny
	elseif player.y == 310 and player.dy > 0 then
		player.y = player.dy + player.y
	elseif player.y == (height - player.height) and player.dy < 0 then
		player.y = player.dy + player.y
	elseif player.g == false then
		player.y = player.dy + player.y
	end

	if player.y < 310 and player.g then
		player.returny = 310 + 1
	elseif player.y >= (height - player.height) and player.g then
		player.returny = height - player.height - 1
	end

	if player.y >= player.returny and player.g == false then
		player.g = true
		player.y = player.returny
		player.attacked = false
	end

	if player.g then
		player.y = player.returny
	end
	
	if player.dx > 0 then
		player.lastDx = "right"
	elseif player.dx < 0 then
		player.lastDx = "left"
	end

	player.dx = 0
	player.dy = 0

	player.regen = player.regen - dt

	if player.health < 100 and player.regen < 0 then
		player.health = player.health + 1
		player.regen = 2
	end

end

function playerJump()
	player.g = false
	player.jumpv = -200
	player.returny = player.y
end

function playerAttack()
	
	enemies = {}

	for i = 1, (#zookeepers + #dartguys) do
		if i <= #zookeepers then
			enemies[i] = zookeepers[i]
		else
			enemies[i] = dartguys[i - #zookeepers]
		end
	end


	if cooldown <= 0 then
		cooldown = 0.1
		yolo = true
		if bossLevel == false then
			local hasChanged
			repeat
				hasChanged = false
				for i = 1, (#enemies - 1) do
					if player.lastDx == "right" then
						if enemies[i].x > enemies[i + 1].x then
							enemies[i], enemies[i + 1] = enemies[i + 1], enemies[i]
							hasChanged = true
						end
					elseif player.lastDx == "left" then
						if enemies[i].x < enemies[i + 1].x then
							enemies[i], enemies[i + 1] = enemies[i + 1], enemies[i]
							hasChanged = true
						end
					end
				end
			until hasChanged == false 

			for i = 1, #enemies do
				if player.lastDx == "right" then
					if enemies[i].x <= (player.x + player.width + player.range) and enemies[i].x >= (player.x + (player.width/2)) and (enemies[i].y + zookeeperstats.height) <= ((player.y + player.height) + player.range) and (enemies[i].y + zookeeperstats.height) >= ((player.y + player.height) - player.range) and enemies[i].attacked == false then
						enemies[i].attacked = true
						enemies[i].health = enemies[i].health - player.attackDmg
						enemies[i].dx = 200
						enemies[i].attackedFirst = true
						enemies[i].jumpP = true
						enemyJump(i)
						yolo = false
						if enemies[i].health <= 0 then
							table.remove(enemies, i)
						end
						break
					end
				elseif player.lastDx == "left" then
					if (enemies[i].x + zookeeperstats.width) >= (player.x - player.range) and (enemies[i].x + zookeeperstats.width) <= (player.x + (player.width/2)) and (enemies[i].y + zookeeperstats.height) <= ((player.y + player.height) + player.range) and (enemies[i].y + zookeeperstats.height) >= ((player.y + player.height) - player.range) then
						enemies[i].attacked = true
						enemies[i].health = enemies[i].health - player.attackDmg
						enemies[i].dx = -200
						enemies[i].attackedFirst = true
						enemies[i].jumpP = false
						enemyJump(i)
						yolo = false
						if enemies[i].health <= 0 then
							table.remove(enemies, i)
						end
						break
					end
				end
			end
			zookeepers = {}
			dartguys = {}
			for i = 1, #enemies do
				if enemies[i].type == "zookeeper" then
					zookeepers[i - #dartguys] = enemies[i]
				elseif enemies[i].type == "dartguy" then
					dartguys[i - #zookeepers] = enemies[i]
				end
			end
		elseif bossLevel then
			if player.lastDx == "right" then
				if boss.x <= (player.x + player.width + player.range) and boss.x >= (player.x + (player.width/2)) and (boss.y + boss.height) <= ((player.y + player.height) + player.range) and (boss.y + boss.height) >= ((player.y + player.height) - player.range) then
					boss.health = boss.health - player.attackDmg
					if boss.health <= 0 then
						boss.dead = true
					end
				end
			elseif player.lastDx == "left" then
				if (boss.x + boss.width) >= (player.x - player.range) and (boss.x + boss.width) <= (player.x + (player.width/2)) and (boss.y + boss.height) <= ((player.y + player.height) + player.range) and (boss.y + boss.height) >= ((player.y + player.height) - player.range) then
					boss.health = boss.health - player.attackDmg
					if boss.health <= 0 then
						boss.dead = true
					end
				end
			end
		end
		if yolo then
			print("hi")
		end
	end
end

function playerDead()
	player.cheese = -1
	player.frame = 10
	playable = false
	playableStart = false
	playableEnd = false
end


