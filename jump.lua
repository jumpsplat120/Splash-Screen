local splash = {}

function splash.update(dt)
	return true
end

function splash.draw()
	love.graphics.setColor({1,1,1,1})
	love.graphics.rectangle("fill", 0, 0, 5, 5)
end

return splash