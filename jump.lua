local path = ...
local folder = string.match(path, ".*/") or ""

local splash = {}

local runtime, length, video, win

function splash.load()
	win   = {}
	video = {}
	
	runtime = 0
	length  = 7
	
	win.w, win.h, win.flags = love.window.getMode()

	video.element = love.graphics.newVideo(folder .. "/assets/jump/video.ogv")
	video.height  = 1080
	video.width   = 1920
	
	return true
end

function splash.update(dt, w, h)
	win.w = w or win.w
	win.h = h or win.h
	if not (video.element:isPlaying()) then
		love.graphics.setColor(1,1,1,1)
		video.element:play()
	end
	runtime = runtime + dt
	if runtime >= length then return false else return true end
end

function splash.draw()
	love.graphics.setColor(1,1,1,1)
	local scale = win.w / video.width
	local y = (math.abs(win.h - (scale * video.height))) * .5
	love.graphics.draw(video.element, 0, y, 0, scale, scale)
end


return splash