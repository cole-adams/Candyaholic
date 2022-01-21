function love.load()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	lollipopx = 0
	lollipopy = 0
	cheese = true

	fontTitle = love.graphics.newFont("PinkCandyPopcornFont.ttf", 100)
	fontMain = love.graphics.newFont("PinkCandyPopcornFont.ttf", 75)
	fontSmall = love.graphics.newFont("PinkCandyPopcornFont.ttf", 40)
	hand = love.mouse.getSystemCursor("hand")

	player = {x = 0, y = 330, v = 350, width = 175, --v = 250
			height = 100, health = 100, xp = 0, g = true, dx = 0, dy = 0,  returny = 330,
			lastDx = true, range = 50, attackDmg = 10, attacked = false, attackedFirst = false, 
			jumpP = true, frame = 0, scale = 1, frameCooldown = 0, cheese = 1, dead = false, regen = 0}
	zookeeperstats = { v = 75, width = 100, height = 175, health = 50, jumpv = 0}
	dartguystats = { v = 75, width = 100, height = 175, health = 30, jumpv = 0}

	zookeepers = {}
	dartguys = {}
	bullets = {}
	darken = 0

	camera = {y = 150, x = 0, lx = false, ly = false, lpr = true, lpl = false, lpu = true, lpd = true, dy = 0, dx = 0, lastdx = 0,
	 v = 250}

	streetpng = love.graphics.newImage("background.png")
	streetpng:setFilter("nearest", "linear")

	require "Player"
	require "ZooKeeper"
	require "DartGuy"
	require "Camera"
	require "GameControl"
	require "Menu"
	require "Boss"

	game = false
	menu = true
	bossLevel = false

	fade = false

	loadLevels()

	enemies = {}

	drawFirst = true
	cooldown = 0

	lionAnim = {}
	lion = love.graphics.newImage("lion.png")
	zookeeperPng = love.graphics.newImage("ZooKeeper.png")
	dartguyPng = love.graphics.newImage("DartGuy.png")
	dart = love.graphics.newImage("Dart.png")
	bossPng = love.graphics.newImage("Boss.png")
	lollipop = love.graphics.newImage("Lollipop.png")

	lion:setFilter("nearest", "linear")
	b = 0

	for a = 1, 2 do
		for i = 1, 3 do
			b = b + 1
			lionAnim[b] = love.graphics.newQuad( (i-1) * player.width, (a-1) * player.height, player.width, player.height, 3 * player.width, 2 * player.height )
		end
	end


end

function love.update(dt)
	if menu then
		cursorx, cursory = love.mouse.getPosition()
		if cursorx >= 400 and cursorx <= 572 and cursory >= 631 and cursory <= 697 then
			love.mouse.setCursor(hand)
		else
			love.mouse.setCursor()
		end
	elseif gameStart then
		Start(dt)
	elseif game then
		levelControl(dt)
		cooldown = cooldown - dt
		for i = 1, #dartguys do
			dartguys[i].cooldown = dartguys[i].cooldown - dt
		end
		for i = 1, #zookeepers do
			zookeepers[i].cooldown = zookeepers[i].cooldown - dt
		end

		if playableEnd then
			cameraAdjust(dt)
		end

		playerMovement(dt)

		if playable then
			zooKeeperMovement(dt)
			dartGuyMovement(dt)
			zookeeperAttack()
			dartGuyAttack(dt)
		end

		if player.health <= 0 then
			player.dead = true
			playerDead()
		end

		cursorx, cursory = love.mouse.getPosition()
		if player.dead then
			if player.dead and cursorx >= 175 and cursorx <= 810 and cursory >= 631 and cursory <= 697 then
				love.mouse.setCursor(hand)
			else
				love.mouse.setCursor()
			end
		end		

	elseif bossLevel then
		boss.exit = true
		levelControl(dt)
		cooldown = cooldown - dt

		if playableEnd then
			cameraAdjust(dt)
		end

		bossAttack(dt)
		playerMovement(dt)
		bossMovement(dt)

		if player.health <= 0 then
			player.dead = true
			playerDead()
		end

		if boss.dead then
			bossDead()
			if boss.x > width then
				if player.x < lollipopx - player.width then
					player.x = player.x + (300 * dt)
				elseif player.x > lollipopx - player.width then
					player.x = player.x - (300 * dt)
				end

				if player.y < (lollipopy + 175) - player.height then
					player.y = player.y + (300 * dt)
				elseif player.y > (lollipopy + 175) - player.height then
					player.y = player.y - (300 * dt)
				end
			end
		end

	end
end

function love.draw()
	if menu then
		drawMenu()
	elseif gameStart then
		drawCamera()
		drawPlayer()
		drawBoss()
		drawLollipop()
	elseif game then
		drawCamera()
		drawZooKeeper()
		drawDartGuy()
		drawPlayer()
		if player.dead then
			love.graphics.setFont(fontTitle)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("You Died", 275, 50)

			love.graphics.setFont(fontMain)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("Return to Menu", 175, 600)
		end
	elseif bossLevel then
		drawCamera()
		drawBoss()
		drawLollipop()
		drawPlayer()
		if player.dead then
			love.graphics.setFont(fontTitle)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("You Died", 275, 50)

			love.graphics.setFont(fontMain)
			love.graphics.print("Return to Menu", 175, 600)
		end
		if fade then
			love.graphics.setFont(fontTitle)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("You Won!", 275, 50)

			love.graphics.setFont(fontMain)
			love.graphics.print("Return to Menu", 175, 600)
		end
	end
end

function love.keypressed(key)
	if key == " " and player.g and playable and menu == false then
		playerJump()
	elseif key == "q" and cooldown <= 0 and playable and menu == false then
		playerAttack()
	end
end

function love.mousepressed(x, y, button)
	if menu and x >= 400 and x <= 572 and y >= 631 and y <= 697 then
		menu = false
		gameStart = true
		player.cooldown = 1
		createBoss()
		love.mouse.setCursor()
	elseif player.dead and x >= 175 and x <= 810 and y >= 631 and y <= 697 then
		love.mouse.setCursor()
		love.load()
	elseif fade and x >= 175 and x <= 810 and y >= 631 and y <= 697 then
		love.mouse.setCursor()
		love.load()
	end
end

