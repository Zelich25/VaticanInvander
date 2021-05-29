
player = {}
player.x = 400
player.y = 500
bullets={}
bullets_p = {}
bullets_generation_tick_p = 60
bullets_generation_tick_e = 30
enemy_size = 0.7
player_size = 0.3
enemies_controller = {}
enemies_controller.enemies ={}

col=10
row=5

function player:shoot()
	if bullets_generation_tick_p <= 0 then
		bullets_generation_tick_p = 60
		bullet = {}
		bullet.x = player.x + 15
		bullet.y = player.y
		table.insert(bullets_p, bullet)
		love.audio.play(player_shoot_sound)
	end
end

function shoot(enemy)
	if bullets_generation_tick_e <= 0 then
		bullets_generation_tick_e = math.random(100,200)
		bullet = {}
		bullet.x = enemy[math.random(#enemy)].x + 34
		bullet.y = enemy[math.random(#enemy)].y --+ enemies_controller.image:getHeight()/2
		table.insert(bullets, bullet)
	end
end

enemies_list = {}

function love.load()
	player.image = love.graphics.newImage('images/magikR.png')
    player.explose_shoot = love.audio.newSource('sounds/shoot.mp3','static')
	music = love.audio.newSource('sounds/barka.mp3','static')
	player_shoot_sound = love.audio.newSource('sounds/shoot.mp3','static')
	music:setLooping(true)
	love.audio.play(music)
	background = love.graphics.newImage("images/popehomeXL.png")
	player.width = player.image:getWidth() * player_size
	player.height = player.image:getHeight() * player_size
	enemies_controller:spawnEnemies(col,row)

end

function enemies_controller:spawnEnemies(x,y)

	i=0 j=0 a=0 b=0
	while i < y do
		while j < x do
		enemies_controller.image= love.graphics.newImage('images/popehead.png')
		enemies_controller:spawnEnemy(a,b)
		a=a+enemy.width*1.1*enemy_size	j=j+1
		end
		j=0	a=0	b=b+enemy.height*1.1*enemy_size i=i+1
	end
end

function enemies_controller:spawnEnemy(x,y)

	enemy ={}
	enemy.x=x
	enemy.y=y
	enemy.speed =0.7
	enemy.width= enemies_controller.image:getWidth()
	enemy.height= enemies_controller.image:getHeight()
	table.insert(self.enemies, enemy)

end

function love.draw()
	--love.graphics.print("Space Invaders Example", 400, 300)
	--love.graphics.newImage("images/popehomeXL.png")
	--love.graphics.setColor(255,1,1)
	love.graphics.draw(background)

	for it, b in pairs(bullets_p) do
		love.graphics.rectangle("fill",b.x, b.y, 5,20)
	end
	for it, b in pairs(bullets) do
		love.graphics.rectangle("fill",b.x, b.y, 5,20)
	end

	for _,e in pairs(enemies_controller.enemies) do
		love.graphics.draw(enemies_controller.image, e.x,e.y,0,enemy_size)
	end
	love.graphics.draw(player.image, player.x, 500, 0, player_size)
end

function love.update()
	if love.keyboard.isDown('right') then
		if player.x > 800 - player.width - 10 then
			player.x = 800 - player.width - 10
		end
		--print("Right key pressed")
		player.image = love.graphics.newImage('images/magikR.png')
		player.x = player.x + 5
	end
	if love.keyboard.isDown('left') then
		if player.x  < 10 then
			player.x = 10
		end
		--print("Left key pressed")
		player.image = love.graphics.newImage('images/magikL.png')
		player.x = player.x - 5
	end
	if love.keyboard.isDown('space') then
		player.shoot()
	end
	if love.keyboard.isDown('q') then
		love.event.quit()
	end

	for it, b in pairs(bullets_p) do
		b.y = b.y - 5
	end
	for it, b in pairs(bullets) do
		b.y = b.y + 5
	end

	for _,e in pairs(enemies_controller.enemies)do
		e.x = e.x + e.speed
		if bullets_generation_tick_e <= 0 then
			for _,e in pairs(enemies_controller.enemies)do
				shoot(enemies_controller.enemies)
			end
		end
		if e.x + e.width >= 800 or e.x < 0 then
			bounce(enemies_controller.enemies)
		end
	end
	checkCollisions(enemies_controller.enemies,bullets_p)
	gameOver(enemies_controller.enemies,bullets)
	bullets_generation_tick_p = bullets_generation_tick_p - 1
	bullets_generation_tick_e = bullets_generation_tick_e - 1
end

function checkCollisions(enemies, bullets)
	for i, e in ipairs(enemies)do
		for j, bullet in ipairs(bullets)do
			if bullet.y <= e.y + e.height/2 and bullet.y + 10 >= e.y + e.height/2  and bullet.x > e.x and bullet.x < e.x + e.width then
				table.remove(enemies, i)
				table.remove(bullets, j)
			end
		end
	end
end

function gameOver(enemies,bullets)
	for _, b in ipairs(bullets)do
		if b.y >= player.y + 20
			and b.y < player.y + player.height
			and b.x >= player.x + 15
			and b.x < player.x + player.width
			then print("GameOver")
			print("iksde")
			love.event.quit("restart")
		end
	end
		for _, e in ipairs(enemies)do
			if e.y + enemy.height >= player.y + 30
			then print("GameOver")
				love.event.quit("restart")
			end
		end
end

function bounce(enemies)
	for _, e in ipairs(enemies)do
		e.y = e.y + e.height
		e.speed = e.speed * -1
	end
end
