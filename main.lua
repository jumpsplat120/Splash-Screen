local path   = ...
local folder = string.match(path, ".*/")  or ""

local jump_splash = require(folder .. "jump")
local love_splash = require(folder .. "love")

local splash  = {}
splash.prevBG = {}

splash.splashes = {"love", "jump", false}
splash.index    = 1
splash.load     = 1

local prev

function splash.update(dt)
	if splash.isPlaying() then
		local current = splash.splashes[splash.index]
		local running = true
		
		if not splash.prevBG[1] then 
			local r, g, b, a = love.graphics.getBackgroundColor()
			splash.prevBG = {r, g, b, a}
		end
		--Load splashes in update to avoid load freeze
		if splash.load == 1 then
			love_splash.load()
			splash.load = splash.load + 1
		elseif splash.load == 2 then
			jump_splash.load()
			splash.load = splash.load + 1
		elseif splash.load <= #splash.splashes then
			love.graphics.setBackgroundColor(0,0,0,1)
			
			if not (prev == current) then
				j.log("Playing " .. current .. " splash!")
			end
			
			if current     == "love" then running = love_splash.update(dt, width, height)
			elseif current == "jump" then running = jump_splash.update(dt, width, height)
			end
			
			if not running and splash.index < #splash.splashes then
				love.audio.stop()
				splash.index = constrain(1, #splash.splashes, splash.index + 1)
				
				if splash.index == #splash.splashes then 
					j.log("Resetting background color!")
					love.graphics.setBackgroundColor(splash.prevBG)
					sm.change("loading")
				end
			end
			
			prev = current
		else
			return false
		end
	end
end

function splash.draw()
	local current = splash.splashes[splash.index]
	
	if current     == "love" then love_splash.draw(dt)
	elseif current == "jump" then jump_splash.draw(dt)
	else return false
	end
end

function splash.keypressed(key, scancode, isrepeat)
	if splash.load < #splash.splashes then return end
	if key and splash.index < #splash.splashes then
		love.audio.stop()
		splash.index = constrain(1, #splash.splashes, splash.index + 1)
		j.log("Skipping splash...")
		
		if splash.index == #splash.splashes then 
			j.log("Resetting background color!")
			love.graphics.setBackgroundColor(splash.prevBG)
			sm.change("loading")
		end
	end
end

function splash.mousepressed(x, y, button, istouch, presses)
	if splash.load < #splash.splashes then return end
	if button and splash.index < #splash.splashes then
		love.audio.stop()
		splash.index = constrain(1, #splash.splashes, splash.index + 1)
		j.log("Skipping splash...")
			
		if splash.index == #splash.splashes then 
			j.log("Resetting background color!")
			love.graphics.setBackgroundColor(splash.prevBG)
			sm.change("loading")
		end
	end
end

function splash.resize(w, h)
	width  = w
	height = h
end

function splash.isPlaying()
	if splash.splashes[splash.index] == false then return false else return true end
end

function constrain(min, max, input)
	return math.max(math.min(input, max), min)
end

return splash