pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
DEBUG = false

function _init()
	-- Create grid
	g = {}
	g.x = 128
	g.y = 128
	g = create_grid(g.x, g.y, g)

	-- Create cursor
	c = {0,0}
	c.show = false

	-- Create timer
	t = 0
	paused = true
	fps = stat(7)
end

function _draw()
	-- Clear screen
	cls()

	-- Draw tiles
	for i = 1,g.x do
		for ii = 1,g.y do
			if g[i][ii] then pset(i-1, ii-1, 7) end
		end
	end

	-- Draw cursor
	if c.show then -- Every other frame
		pset(c[1], c[2], 10)
	end

	print(tostr(paused), 0, 120, 10)
end

function _update()
	t += 1
	c.show = not c.show
	move_cursor()
	click_cursor()

	if (btnp(4)) paused = not paused
	
	if t > 15 and not paused then
		update_grid()
		t = 0
	end
end

function update_grid()
	next = create_grid(g.x, g.y, {})
	for i = 1,g.x do
		for ii = 1,g.y do
			local n = get_neighbours(i,ii)
			if ((n == 2 or n == 3) and g[i][ii]) next[i][ii] = true
			if (n == 3 and not g[i][ii]) next[i][ii] = true
		end
	end
	
	g = next
end

function get_neighbours(x, y)
	local n = 0
	
	local has_left = x > 1
	local has_right = x < g.x
	local has_top = y > 1
	local has_bottom = y < g.y

	if has_top then
		if (has_left) then  if (g[x-1][y-1]) then  n += 1 end end	-- Top left
		if (g[x][y-1]) n += 1					--Top Middle
		if (has_right) then if (g[x+1][y-1]) then  n += 1 end end	-- Top right
	end

	if (has_left) then if (g[x-1][y]) then n += 1 end end --Middle left
	if (has_right) then if (g[x+1][y]) then n += 1 end end --Middle right

	
	if has_bottom then
		if (has_left) then if (g[x-1][y+1]) then n += 1 end end	-- Top left
		if (g[x][y+1]) n += 1			--Top Middle
		if (has_right) then if (g[x+1][y+1]) then n += 1 end end	-- Top right
	end

	return n
end

function click_cursor()
	local x,y = c[1], c[2]
	if (btnp(5)) g[x+1][y+1] = not g[x+1][y+1]
end

function move_cursor()
	if (btnp(1) and c[1] < g.x-1) c[1] += 1
	if (btnp(0) and c[1] > 0) c[1] -= 1
	if (btnp(2) and c[2] > 0) c[2] -= 1
	if (btnp(3) and c[2] < g.y-1) c[2] += 1
end


function create_grid(x, y, grid)
	for i = 1, x do
		grid[i] = {}
		for ii = 1, y do
			grid[i][ii] = false
		end
	end
	grid.x = x
	grid.y = y
	return grid
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
