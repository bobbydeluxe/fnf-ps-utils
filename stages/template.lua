--WEATHERFX STAGE TEMPLATE

--variable configurations

local rainActive = true
local mistFX = true
local mistOffset = -400 --test
local lightingActive = true
local lightingTimer = 3

--rest of the stuff d'low

function onCreate()
    makeLuaSprite('stageback', 'stageback', -600, -300);
	setScrollFactor('stageback', 0.9, 0.9);
	
	makeLuaSprite('stagefront', 'stagefront', -650, 600);
	setScrollFactor('stagefront', 0.9, 0.9);
	scaleObject('stagefront', 1.1, 1.1);

    addLuaSprite('stageback', false);
	addLuaSprite('stagefront', false);

    for num = 1, 3 do
        precacheSound('Lightning'..num)
    end

    makeAnimatedLuaSprite('lighting', 'lightning', 50, -300)
    addAnimationByPrefix('lighting', 'anim', 'lightning0', 24, false)
    setScrollFactor('lighting', 0.9, 0.9) --change this to ur default scrollFactor
    scaleObject('lighting', 1.75, 1.75)
    addLuaSprite('lighting')
    setProperty('lighting.visible', false)
end

function onCreatePost()
    if shadersEnabled == true then
        initLuaShader('adjustColor')
        for i, object in ipairs({'boyfriend', 'dad', 'gf'}) do
            setSpriteShader(object, 'adjustColor')
            setShaderFloat(object, 'hue', -26)
            setShaderFloat(object, 'saturation', -16)
            setShaderFloat(object, 'contrast', 0)
            setShaderFloat(object, 'brightness', -5)
        end
	end

    if rainActive == true then
        -- Sets up the haxe commands needed for the stage to work.
        runHaxeCode([[
            import psychlua.LuaUtils;
            function activateRainShader() FlxG.camera.setFilters([new ShaderFilter(game.getLuaObject('rainFilter').shader)]);
            function deactivateRainShader() FlxG.camera.setFilters([]);
        ]])

        if shadersEnabled == true then
            initLuaShader('rain')
            makeLuaSprite('rainFilter')
            setSpriteShader('rainFilter', 'rain')
            setShaderFloat('rainFilter', 'uScale', screenHeight / 200)
            
            if stringStartsWith(songName:gsub('-', ' '):lower(), 'darnell') then
                intensityStart = 0.2
                intensityEnd = 0.4
            elseif stringStartsWith(songName:gsub('-', ' '):lower(), 'lit up') then
                intensityStart = 0.1
                intensityEnd = 0.2
            elseif stringStartsWith(songName:gsub('-', ' '):lower(), '2hot') then
                intensityStart = 0.2
                intensityEnd = 0.4
            else
                intensityStart = 0.1
                intensityEnd = 0.15
            end

            setShaderFloat('rainFilter', 'uIntensity', intensityStart)
            setShaderFloatArray('rainFilter', 'uRainColor', {102 / 255, 128 / 255, 204 / 255})
            setShaderFloatArray('rainFilter', 'uFrameBounds', {0, 0, screenWidth, screenHeight})
            runHaxeFunction('activateRainShader')
        end
    end

    if mistFX == true then
        if lowQuality == false then
            mistData = {
                {mistImage = 'mistMid', scrollFactor = 1.2, alpha = 0.6, velocity = 172, scale = 1, objectOrder = ''},
                {mistImage = 'mistMid', scrollFactor = 1.1, alpha = 0.6, velocity = 150, scale = 1, objectOrder = ''},
                {mistImage = 'mistBack', scrollFactor = 1.2, alpha = 0.8, velocity = -80, scale = 1, objectOrder = ''},
                {mistImage = 'mistMid', scrollFactor = 0.95, alpha = 0.5, velocity = -50, scale = 0.8, objectOrder = 'gradient1'},
                {mistImage = 'mistBack', scrollFactor = 0.8, alpha = 1, velocity = 40, scale = 0.7, objectOrder = 'cars1'},
                {mistImage = 'mistMid', scrollFactor = 0.5, alpha = 1, velocity = 20, scale = 1.1, objectOrder = 'city'}
            }
            for mistNum, data in ipairs(mistData) do
                for i = 0, 2 do
                    makeLuaSprite('mist'..mistNum..''..(i + 1), 'mist/'..data.mistImage, -650, -100)
                    scaleObject('mist'..mistNum..''..(i + 1), data.scale, data.scale, false)
                    setScrollFactor('mist'..mistNum..''..(i + 1), data.scrollFactor, data.scrollFactor)
                    setBlendMode('mist'..mistNum..''..(i + 1), 'ADD')
                    if data.objectOrder ~= '' then
                        setObjectOrder('mist'..mistNum..''..(i + 1), getObjectOrder(data.objectOrder) + 1)
                    end
                    addLuaSprite('mist'..mistNum..''..(i + 1), true)
                    setProperty('mist'..mistNum..''..(i + 1)..'.alpha', data.alpha)
                    setProperty('mist'..mistNum..''..(i + 1)..'.color', 0x5C5C5C)
                    setProperty('mist'..mistNum..''..(i + 1)..'.velocity.x', data.velocity)
                    local offsetMist = getProperty('mist'..mistNum..''..(i + 1)..'.x') + (getProperty('mist'..mistNum..''..(i + 1)..'.width') * data.scale) * i
                    setProperty('mist'..mistNum..''..(i + 1)..'.x', offsetMist)
                end
            end
        end
    end
end

local elapsedTime = 0
function onUpdate(elapsed)
    if rainActive == true then
        -- Makes the rain active and increase its intensity from 'intensityStart' to 'intensityEnd'.
        if shadersEnabled == true then
            intensityValue = math.remapToRange(getSongPosition(), 0, songLength, intensityStart, intensityEnd)
            setShaderFloat('rainFilter', 'uIntensity', intensityValue)
            elapsedTime = elapsedTime + elapsed
            setShaderFloat('rainFilter', 'uTime', elapsedTime)
            setShaderFloatArray('rainFilter', 'uScreenResolution', {screenWidth, screenHeight})
            setShaderFloatArray('rainFilter', 'uCameraBounds', {getProperty('camGame.viewLeft'), getProperty('camGame.viewTop'), getProperty('camGame.viewRight'), getProperty('camGame.viewBottom')})
        end
    end

    if lightingActive == true then
        lightingTimer = lightingTimer - elapsed
        if lightingTimer <= 0 then
            strikeLighting()
            lightingTimer = getRandomFloat(7, 15)
        end
    end
end

function onUpdatePost()
    if mistFX == true then
        --[[
        Everything here controls the movement of the fog around the stage.
        3 'mist' sprites of the same placement follow along one another 
        until one of them gets too far to the left or right, and so then get behind the pack.
        Also, all of them do an up and down motion depending on their set values.
        ]]
        
        if lowQuality == false then
            for mistNum, mistScale in ipairs({1, 1, 1, 0.8, 0.7, 1.1}) do
                for i = 1, 3 do
                    if getProperty('mist'..mistNum..''..i..'.velocity.x') > 0 then
                        if getProperty('mist'..mistNum..''..i..'.x') > (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 1.5 then
                            setProperty('mist'..mistNum..''..i..'.x', getProperty('mist'..mistNum..''..i..'.x') - (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 3)
                        end
                    else
                        if getProperty('mist'..mistNum..''..i..'.x') < -(getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 1.5 then
                            setProperty('mist'..mistNum..''..i..'.x', getProperty('mist'..mistNum..''..i..'.x') + (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 3)
                        end
                    end
                end
            end
            
            for i = 1, 3 do
                setProperty('mist1'..i..'.y', mistOffset + 660 + (math.sin(elapsedTime * 0.35) * 70))
                setProperty('mist2'..i..'.y', mistOffset + 500 + (math.sin(elapsedTime * 0.3) * 80))
                setProperty('mist3'..i..'.y', mistOffset + 540 + (math.sin(elapsedTime * 0.4) * 60))
                setProperty('mist4'..i..'.y', mistOffset + 230 + (math.sin(elapsedTime * 0.3) * 70))
                setProperty('mist5'..i..'.y', mistOffset + 170 + (math.sin(elapsedTime * 0.35) * 50))
                setProperty('mist6'..i..'.y', mistOffset + -80 + (math.sin(elapsedTime * 0.08) * 100))
            end
        end
    end
end


function onGameOver()
    lightingActive = false
    if rainActive == true then
        -- Needed if we don't want the rain and lightning to affect the Game Over screen.
        if shadersEnabled == true then
            runHaxeFunction('deactivateRainShader')
        end
    end
end

function onEndSong()
    lightingActive = false -- Needed since we don't want the lighting to be active during a cutscene.
end

function math.remapToRange(value, start1, stop1, start2, stop2)
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1))
end

local lightingOffset = 0
function strikeLighting()
    if getRandomBool(65) then
        lightingOffset = getRandomInt(-250, 280)
    else
        lightingOffset = getRandomInt(780, 900)
    end
    local num = getRandomInt(1, 3)
    setProperty('lighting.visible', true)
    setProperty('lighting.x', lightingOffset)
    playAnim('lighting', 'anim')
    playSound('Lightning'..num)

    if flashingLights == true then
        setProperty('stageback.alpha', 0.7)
        doTweenAlpha('reAddSky', 'stageback', 1, 1.5, 'linear')
    end
end