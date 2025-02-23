function onCreatePost() 
	if shadersEnabled then

		makeLuaSprite('curvature')
		makeGraphic('curvature', screenWidth, screenHeight)
		setSpriteShader('curvature', 'curvature')

		makeLuaSprite('curvatureHUD')
		makeGraphic('curvatureHUD', screenWidth, screenHeight)
		setSpriteShader('curvatureHUD', 'curvatureHUD')

		makeLuaSprite('bloom')
		makeGraphic('bloom', screenWidth, screenHeight)
		setSpriteShader('bloom', 'bloom')

		makeLuaSprite('overlay')
		makeGraphic('overlay', screenWidth, screenHeight)
		setSpriteShader('overlay', 'overlay')

		runHaxeCode([[
			game.camGame.setFilters([
				new ShaderFilter(game.getLuaObject('curvature').shader),
				new ShaderFilter(game.getLuaObject('bloom').shader),
				new ShaderFilter(game.getLuaObject('overlay').shader)
			]);
			game.camHUD.setFilters([
			new ShaderFilter(game.getLuaObject('curvatureHUD').shader)
			]);
			game.camOther.setFilters([
			new ShaderFilter(game.getLuaObject('curvatureHUD').shader)
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