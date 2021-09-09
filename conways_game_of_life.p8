pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
DEBUG = false

function _init()
	-- Create grid
	g = create_grid(31, 28)

	-- Create cursor
	c = {0,0}
	c.show = false

	-- Create timer
	t = 0
	game_speed = 5
	paused = true

	-- Create offsets
	xOff, yOff = 2, 0
	cell_size = 4
end

function _draw()
	cls()
	draw_grid()
	if (paused) draw_cursor()
	draw_hud()
end

function _update()
	t += 1
	if paused then
		c.show = not c.show
		move_cursor()
		click_cursor()
	end

	if (btnp(4)) paused = not paused
	
	if t > game_speed and not paused then
		update_grid()
		t = 0
	end
end

function draw_cursor()
	if c.show then
		local cx, cy = (c[1]*cell_size)+xOff, (c[2]*cell_size)+yOff	-- Calculate x and y to draw cursor 
		rectfill(cx+1, cy+1, cx+cell_size-1, cy+cell_size-1, 11)	-- Draw cursor
	end
end

function draw_grid()
	for i = 1, g.x do
		for ii = 1, g.y do
			local x, y = ((i-1)*cell_size) + xOff, ((ii-1)*cell_size) + yOff	-- Calculate x and y for cell
			rect(x, y, x+cell_size, y+cell_size, 1) 				-- Draw box for grid
			if (g[i][ii]) rectfill(x+1, y+1, x+cell_size-1, y+cell_size-1, 7)	-- Draw box if cell is alive
			
		end
	end
end

function draw_hud()
	-- Draw background
	rectfill(2,117,126,127, 1)
	rect	(2,117,126,127, 7)
	
	if not DEBUG then
		print("🅾️" .. (paused and "play" or "pause"), 5, 120, 7)
		if (paused) print("❎toggle cell", 37, 120)
	else
		print(stat(1).."cpu ", 5, 120, 7)
		print(stat(7) .. "fps ", 64, 120)
	end
end

function update_grid()
	next = create_grid(g.x, g.y)
	for i = 1, g.x do
		for ii = 1, g.y do
			local n = get_neighbours(i, ii)
			if ((n == 2 or n == 3) and g[i][ii]) next[i][ii] = true	-- If cell has 2 or 3 neighbours then it survives
			if (n == 3 and not g[i][ii]) next[i][ii] = true		-- If cell is dead but has 3 live neighbours then repopulate
		end
	end
	
	g = next
end

function get_neighbours(x, y)
	local n = 0
	
	-- Need to check if the cell is missing neighbours due to grid limitation
	local has_left = x > 1
	local has_right = x < g.x
	local has_top = y > 1
	local has_bottom = y < g.y

	if has_top then
		if (has_left) then  if (g[x-1][y-1]) then  n += 1 end end	-- Top left
		if (g[x][y-1]) n += 1						-- Top middle
		if (has_right) then if (g[x+1][y-1]) then  n += 1 end end	-- Top right
	end

	if (has_left) then if (g[x-1][y]) then n += 1 end end			-- Middle left
	if (has_right) then if (g[x+1][y]) then n += 1 end end			-- Middle right

	
	if has_bottom then
		if (has_left) then if (g[x-1][y+1]) then n += 1 end end		-- Bottom left
		if (g[x][y+1]) n += 1						-- Bottom middle
		if (has_right) then if (g[x+1][y+1]) then n += 1 end end	-- Bottom right
	end

	return n
end

function click_cursor()
	local x, y = c[1], c[2]
	if (btnp(5)) g[x+1][y+1] = not g[x+1][y+1] -- Toggle cell if clicked
end

function move_cursor()
	if (btnp(1) and c[1] < g.x-1) c[1] += 1
	if (btnp(0) and c[1] > 0) c[1] -= 1
	if (btnp(2) and c[2] > 0) c[2] -= 1
	if (btnp(3) and c[2] < g.y-1) c[2] += 1
end


function create_grid(x, y)
	local grid = {}
	grid.x, grid.y = x, y
	for i = 1, x do
		grid[i] = {}
		for ii = 1, y do
			grid[i][ii] = false
		end
	end
	return grid
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
