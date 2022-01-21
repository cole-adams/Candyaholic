function drawMenu()
	love.graphics.setColor(50, 160, 255)
	love.graphics.rectangle("fill", 0, 0, width, height)

	love.graphics.setColor(255, 148, 218)
	love.graphics.setFont(fontTitle)
	love.graphics.print("Candyaholic", 210, 50)
	love.graphics.setFont(fontMain)
	love.graphics.print("Play", 400, 600)

end