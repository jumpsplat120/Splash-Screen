local path   = ...
local folder = string.match(path, ".*/")  or ""

local jump_splash = require(folder .. "jump")
local love_splash = require(folder .. "love")

local splash = {}

splash.splashes = {"love", "jump", "END"}
splash.index    = 1

function splash.update(dt)
	local current = splash.splashes[splash.index]
	local running = true
	
	if current     == "love" then running = love_splash.update(dt)
	elseif current == "jump" then running = jump_splash.update(dt)
	end
	
	if not running and splash.index < #splash.splashes then splash.index = constrain(1, #splash.splashes, splash.index + 1) end
end

function splash.draw()
	local current = splash.splashes[splash.index]
	
	if current     == "love" then love_splash.draw(dt)
	elseif current == "jump" then jump_splash.draw(dt)
	end
end

function splash.keypressed(key, scancode, isrepeat)
	if key and splash.index < #splash.splashes then splash.index = constrain(1, #splash.splashes, splash.index + 1) end
end

function splash.mousepressed(x, y, button, istouch, presses)
	if button and splash.index < #splash.splashes then splash.index = constrain(1, #splash.splashes, splash.index + 1) end
end

function constrain(min, max, input)
	return math.max(math.min(input, max), min)
end

return splash