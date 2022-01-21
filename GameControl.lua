function loadLevels()
	levelnum = 0
	currentStart = 0
	currentEnd = 1500
	playable = true
	playableEnd = true
	lvlStart = false
	lvlEnd = true
	-- level = { { width = 1500, startX = 500, zooK = 0, dartG = 0, drawTimes = 2},
	-- 		  { width = 1500, startX = 2500, zooK = 0, dartG = 0, drawTimes = 2},
	-- 		  { width = 1500, startX = 4500, zooK = 0, dartG = 0, drawTimes = 2},
	-- 		  { width = 2500, startX = 6500, zooK = 0, dartG = 0, drawTimes = 3},
	-- 		  { width = 1500, startX = 9500, zooK = 0, dartG = 0, drawTimes = 2},
	-- 		  { width = 1500, startX = 11500, zooK = 0, dartG = 0, drawTimes = 2},
	-- 		  { width = 2000, startX = 13500, zooK = 0, dartG = 0, drawTimes = 2},
	-- 		  { width = 2500, startX = 16000, zooK = 0, dartG = 0, drawTimes = 3},
	-- 		  { width = 3000, startX = 19000, zooK = 0, dartG = 0, drawTimes = 3},
	-- 		  { width = 4000, startX = 22500, zooK = 0, dartG = 0, drawTimes = 4},
	-- 		  { width = 2000, startX = 27000, zooK = 0, dartG = 0, drawTimes = 2}
	-- 			}

	level = { { width = 1500, startX = 500, zooK = 1, dartG = 0, drawTimes = 2},
			  { width = 1500, startX = 2500, zooK = 2, dartG = 0, drawTimes = 2},
			  { width = 1500, startX = 4500, zooK = 3, dartG = 0, drawTimes = 2},
			  { width = 2500, startX = 6500, zooK = 4, dartG = 0, drawTimes = 3},
			  { width = 1500, startX = 9500, zooK = 0, dartG = 1, drawTimes = 2},
			  { width = 1500, startX = 11500, zooK = 1, dartG = 1, drawTimes = 2},
			  { width = 2000, startX = 13500, zooK = 1, dartG = 2, drawTimes = 2},
			  { width = 2500, startX = 16000, zooK = 2, dartG = 2, drawTimes = 3},
			  { width = 3000, startX = 19000, zooK = 2, dartG = 3, drawTimes = 3},
			  { width = 4000, startX = 22500, zooK = 3, dartG = 3, drawTimes = 4},
			  { width = 2000, startX = 27000, zooK = 0, dartG = 0, drawTimes = 2}
				}
end

function levelControl(dt)
	if #zookeepers == 0 and #dartguys == 0 and lvlEnd == false and bossLevel == false then
		currentEnd = level[levelnum + 1].startX + level[levelnum + 1].width
		playable = false
		playableEnd = false
		lvlEnd = true
		lvlStart = false
	end

	if  bossLevel == false then
		if camera.x >= level[levelnum + 1].startX and lvlStart == false then
			levelnum = levelnum + 1
			if levelnum < 11 then
				playable = false
				lvlStart = true
				lvlEnd = false
				player.frame = 0
				createZooKeepers(level[levelnum].zooK)
				createDartGuys(level[levelnum].dartG)
				currentStart = level[levelnum].startX
				currentEnd = level[levelnum].startX + level[levelnum].width
			elseif levelnum == 11 then
				game = false
				player.v = 300
				bossLevel = true
				playable = false
				lvlStart = true
				lvlEnd = true
				createBoss()
				currentStart = level[levelnum].startX
				currentEnd = level[levelnum].startX + level[levelnum].width
			end
		end
	end

	if playable == false and lvlStart and player.dead == false then
		player.frame = 0
		if game then
			for i = 1, #zookeepers do
				if zookeepers[i].x > (zookeepers[i].orgx - 1000) then
					zookeepers[i].x = zookeepers[i].x - (500 * dt)
				else
					playable = true

				end
			end
			for i = 1, #dartguys do
				if dartguys[i].x > (dartguys[i].orgx - 1000) then
					dartguys[i].x = dartguys[i].x - (500 * dt)
				else
					playable = true
				end
			end
		elseif bossLevel and boss.dead == false then
			if boss.x > (boss.orgx - 1000) then
				boss.x = boss.x - (500 * dt)
			else
				playable = true
			end
		end 
	elseif playable == false and lvlEnd and player.dead == false then
		if player.x <= ((width/2) - (player.width/2)) then
			playable = true
			playableEnd = true
		else
			player.x = player.x - (500 * dt)
			camera.x = camera.x + (500 * dt)
		end
	end
end

function Start(dt)
	player.cooldown = player.cooldown - dt
	if player.x + player.width < (lollipopx - 10) and player.cooldown < 0 and boss.exit == false then
		player.x = player.x + (75 * dt)
		player.frame = 10
	elseif boss.x > (lollipopx + 150) and boss.exit == false and player.cooldown < 0 then
		boss.x = boss.x - (600 * dt)
	elseif boss.x <= (lollipopx + 150) and player.cooldown < 0 and boss.exit == false then
		boss.exit = true
	elseif boss.exit and boss.x <= width and player.cooldown < 0 then
		boss.x = boss.x + (600 * dt)
	elseif boss.x >= width and player.cooldown < 0 then
		gameStart = false
		game = true
	end
end


function drawLollipop()
	if boss.exit and boss.dead == false then
		lollipopx = boss.x + 10
		lollipopy = boss.y + 60
	elseif boss.dead and cheese then
		cheese = false
		lollipopx = boss.x + 10
		lollipopy = (player.y + player.height) - 175
	elseif bossLevel == false then
		lollipopx = 300
		lollipopy = (player.y + player.height) - 175
	end

	print(lollipopy)

	love.graphics.reset()

	love.graphics.draw(lollipop, lollipopx, lollipopy)

end