local path = ...
local folder = string.match(path, ".*/")  or ""

local splash = {}

local runtime = 0
local tilt    = 0

local heart
local powered

local win = {}

win.w, win.h, win.flags = love.window.getMode( )

function splash.load()
	heart   = love.graphics.newImage(folder .. "/assets/heart.png")
	powered = love.graphics.newImage(folder .. "/assets/powered.png")
end

function splash.update(dt)
	runtime = runtime + dt
end

function splash.draw()
	--Bars sweeping across screen
	local blue  = {0.1529, 0.6666, 0.8823, 1}
	local pink  = {0.9058, 0.2901, 0.6000, 1}
	local white = {1.0000, 1.0000, 1.0000, 1}
	
	local mode = "fill"
	
	local cx = win.w / 2
	local cy = win.h / 2
	
	if runtime < 2 then
		do
			local height = cy
			local width = (math.pow(runtime, 10))
			
			do
				local x = 0
				local y = 0
				
				love.graphics.setColor(pink)
				love.graphics.rectangle(mode, x, y, width, height)
			end
			
			do
				local x = win.w
				local y = cy
				
				love.graphics.setColor(blue)
				love.graphics.rectangle(mode, x, y, -width, height)
			end
		end
	end
	
	--Circle, rotation, and heart
	if runtime >= 2 and runtime < 10 then
		love.graphics.translate(cx, cy)
		love.graphics.rotate(math.rad(tilt))
		love.graphics.translate(-cx, -cy)
		
		--circle stencil
		do
			local x      = cx
			local y      = cy
			local radius = inOutBack(runtime - 2, win.w / 1.5, 100 - win.w / 1.5, 2)
			
			love.graphics.stencil(function() love.graphics.circle(mode, x, y, radius) end)
		end
		
		--bars
		do
			local height = cx
			local width  = win.w
			
			love.graphics.setStencilTest("greater", 0)
				do
					local x = 0
					local y = 0
					
					love.graphics.setColor(pink)
					love.graphics.rectangle(mode, x, y, width, height)
				end
				do
					local x = win.w
					local y = cy
					
					love.graphics.setColor(blue)
					love.graphics.rectangle(mode, x, y, -width, height)
				end
			love.graphics.setStencilTest()
			
		end
		
		--heart
		if runtime >= 3 then
			love.graphics.setColor(white)
			
			love.graphics.translate(cx, cy)
			love.graphics.rotate(math.rad(-tilt))
			love.graphics.translate(-cx, -cy)
		
			--ORIGINAL SIZE: 600x600
			local size   = inOutElastic(runtime - 3, .025, 1, 2, 1)/5
			local x      = cx
			local y      = cy
			local r      = math.rad(-(45 + tilt))
			local offset = 300
			
			love.graphics.draw(heart, x, y, r, size, size, offset, offset)
			
			if tilt < 45 then tilt = -inOutBack(runtime - 3, 0, 45, 2) end
		end
		
		--LOVE text
		if runtime >= 3.5 then
			love.graphics.setColor(white)
			
			--ORIGINAL SIZE 1000x1000
			local size   = constrain(0,1,runtime - 3.5)/3
			local x      = cx
			local y      = cy
			local r      = outQuart(runtime - 3.5, 0, -5, 2) * 360
			local offset = 500
			
			love.graphics.setStencilTest("equal", 0)
				love.graphics.draw(powered, x, y, math.rad(r), size, size, offset, offset)
			love.graphics.setStencilTest()
		end
	end
end

--https://github.com/EmmanuelOga/easing
--time, begin, change (begin - ending), duration, amplitude, period
function inOutBack(t, b, c, d, s)
  s = s or 1.70158
  s = s * 1.525
  t = t / d * 2
  if t > d then return c + b end
  if t < 1 then
    return c / 2 * (t * t * ((s + 1) * t - s)) + b
  else
    t = t - 2
    return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
  end
end

function inOutElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d * 2

  if t == 2 then return b + c end

  p = p or d * (0.3 * 1.5)
  a = a or 0

  local s

  if not a or a < math.abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * math.pi) * math.asin(c / a)
  end

  if t < 1 then
    t = t - 1
    return -0.5 * (a * math.pow(2, 10 * t) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
  else
    t = t - 1
    return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p ) * 0.5 + c + b
  end
end

function outQuad(t, b, c, d)
	t = t / d
	if t >= 1 then return c end
	return -c * t * (t - 2) + b
end

function outQuart(t, b, c, d)
	if t / d >= 1 then return c end
	t = t / d - 1
	return -c * (math.pow(t, 4) - 1) + b
end

function constrain(min, max, input)
	return math.max(math.min(input, max), min)
end

return splash