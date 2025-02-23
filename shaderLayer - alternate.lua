function onCreatePost() 
	if shadersEnabled then

		makeLuaSprite('anamorphix')
		makeGraphic('anamorphix', screenWidth, screenHeight)
		setSpriteShader('anamorphix', 'anamorphix')

		runHaxeCode([[
			game.camGame.setFilters([
				new ShaderFilter(game.getLuaObject('curvature').shader),
				new ShaderFilter(game.getLuaObject('bloom').shader),
				new ShaderFilter(game.getLuaObject('overlay').shader)
				new ShaderFilter(game.getLuaObject('anamorphix').shader)
			]);
		]])
	end
end

function onDestroy()
	if shadersEnabled then
		runHaxeCode([[
			FlxG.game.setFilters([]);
		]])
	end
end