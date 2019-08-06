local path   = ...
local folder = string.match(path, ".*/")  or ""

local jump_splash = require(folder .. "jump")
local love_splash = require(folder .. "love")

local splash = {}

function splash.load()
	jump_splash.load()
	love_splash.load()
end

function splash.update(dt)
	jump_splash.update(dt)
	love_splash.update(dt)
end

function splash.draw()
	jump_splash.draw()
	love_splash.draw()
end

return splash