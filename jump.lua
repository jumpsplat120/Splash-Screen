local path = ...
local folder = string.match(path, ".*/") or ""

local splash = {}

local runtime, length, video, win

function splash.load()
	win = {}
	
	runtime = 0
	length  = 7
	
	win.w, win.h, win.flags = love.window.getMode()
	
	--ORIGINAL VIDEO: 1920x1080
	video = love.graphics.newVideo(folder .. "/assets/jump/video.ogv")
	
	return true
end

function splash.update(dt, w, h)
	win.w = w or win.w
	win.h = h or win.h
	if not (video:isPlaying()) then
		love.graphics.setColor(1,1,1,1)
		video:play()
	end
	runtime = runtime + dt
	if runtime >= length then return false else return true end
end

function splash.draw()
	local scale = win.h / 1080
	love.graphics.draw(video, 0, 0, 0, scale, scale)
end


return splash