---- OPEN SOURCE 
---- By Montri
script_name("InterfaceEditor")
script_version("1.0.0")
script_author("Montri")
script_description("Allows you to fully customize every element of the Interface directly In-Game")
--- includes
local ffi =			require "ffi"
ffi.cdef
[[
    void *malloc(size_t size);
    void free(void *ptr);
]]
local imgui = require "imgui"
local fa         = require 'fAwesome5'
local ec = require "encoding"
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
local memory = require 'memory'
--------------
----- GLOBAL VARIABLES
ec.default = 'CP1251'
u8 = ec.UTF8
path = getWorkingDirectory() .. '\\config\\Montris Folder\\'
cfg = path .. 'MontrisEditor.ini'
local correctValues = {[1] = "Main",[2] = "HealthBar.Color=",[3] = "Money.Color=",[4] = "WantedStars.Color=",[5] = "Fonts.SA.Color=",[6] = "Fonts.GTA3.Color=",[7] = "Fonts.MenuBackGround.Color=",[8] = "Radar.RingPlane.Color.Red=",[9] = "Radar.RingPlane.Color.Green=",
                [10] = "Radar.RingPlane.Color.Blue=",[11] = "Radar.ZPosBar.Bar.Color.Red=",[12] = "Radar.ZPosBar.Bar.Color.Green=",[13] = "Radar.ZPosBar.Bar.Color.Blue=",[14] = "Radar.ZPosBar.BackTexture.Color.Red=",[15] = "Radar.ZPosBar.BackTexture.Color.Green=",[16] = "Radar.ZPosBar.BackTexture.Color.Blue=",[17] = "Clock.BackGround.Color.Alpha=",[18] = "WantedStars.DistanceBetweenStars=",
                [19] = "Radar.RingPlane.Color.Alpha=",[20] = "Radar.Ring.Part1.Color.Alpha=",[21] = "Radar.Ring.Part2.Color.Alpha=",[22] = "Radar.Ring.Part3.Color.Alpha=",[23] = "Radar.Ring.Part4.Color.Alpha=",[24] = "Radar.ZPosBar.Bar.Color.Alpha=",[25] = "Radar.ZPosBar.BackTexture.Color.Alpha=",[26] = "Money.Format.Positive=",[27] = "Money.Format.Negative=",[28] = "Clock.Format=",[29] = "Weapon.Ammo.Text.Format.OneCartridge=",[30] = "Weapon.Ammo.Text.Format.ManyCartridges=",[31] = "Radar.Main.X-Scale=",[32] = "Radar.RingPlane.X-Scale=",
                [33] = "Radar.Ring.Part1.X-Scale=",[34] = "Radar.Ring.Part2.X-Scale=",[35] = "Radar.Ring.Part3.Y-Scale=",[36] = "Radar.Ring.Part4.X-Scale=",[37] = "Radar.Main.Y-Scale=",[38] = "Radar.RingPlane.Y-Scale=",[39] = "Radar.Ring.Part1.Y-Scale=",[40] = "Radar.Ring.Part2.Y-Scale=",[41] = "Radar.Ring.Part3.X-Scale=",[42] = "Radar.Ring.Part4.Y-Scale=",
                [43] = "HealthBar.X=",[44] = "HealthBar.Y=",[45] = "ArmourBar.X=",[46] = "ArmourBar.Y=",[47] = "BreathBar.X=",[48] = "BreathBar.Y=",[49] = "Money.X=",[50] = "Money.Y=",[51] = "Clock.X=",[52] = "Clock.Y=",[53] = "Weapon.Icon.X=",[54] = "Weapon.Ammo.Text.X=",
                [55] = "Weapon.Icon.Y=",[56] = "Weapon.Ammo.Text.Y=",[57] = "WantedStars.X=",[58] = "WantedStars.Y-Fill=",[59] = "WantedStars.Y-Empty=",[60] = "CarName.X=",[61] = "CarName.Y=",[62] = "Radar.Main.X=",[63] = "Radar.RingPlane.X=",[64] = "Radar.Ring.Part1.X=",[65] = "Radar.Ring.Part2.X=",[66] = "Radar.Ring.Part3.X=",[67] = "Radar.Ring.Part4.X=",[68] = "Radar.Main.Y=",
                [69] = "Radar.RingPlane.Y=",[70] = "Radar.Ring.Part1.Y=",[71] = "Radar.Ring.Part2.Y=",[72] = "Radar.Ring.Part3.Y=",[73] = "Radar.Ring.Part4.Y=",[74] = "Radar.ZPosBar.Bar.X=",[75] = "Radar.ZPosBar.BackTexture.X=",[76] = "Radar.ZPosBar.Bar.Y=",[77] = "Radar.ZPosBar.BackTexture.Y=",[78] = "Radar.ZPosBar.BackTexture.X-Scale=",[79] = "Radar.ZPosBar.BackTexture.Y-Scale=",[80] = "ZoneName.X=",[81] = "ZoneName.Y=",[82] = "[Other]",["83"] = "CheckExeVersion="}
                moneyOriginal = 0
----------------

function blankIni()
	editor = {
        -- Format for Element-Arrays: {<posX>,<posY>,<Height>,<Width>}
        -- Format for Colors: {r,g,b,a}
        health = {131,87,10,110},
        healthColors = {190,0,0,255},
        oxygen = {69,69,8,31},
        oxygenColors = {255,0,0,255},
        armor = {85,47,8,63},
        armorColors = {255,0,0,255},
        money = {15,100,0,0},
        moneyColors = {255,0,0,255},
        moneyFormat = "$%08d",
        moneyNegativeColor = {0},
        moneyNegativeFormat = "-$%08d",
        wanted = {15,113,0,0},
        wantedColors = {255,0,0,255},
        weaponIcon = {23,26,10,110},
        weaponAmmo = {131,79,10,110},
        radar = {55,100,85,85},
        radarColors = {255,255,255,255},
        radarBorderColors = {255,255,255,255},
        menuMapColors = {255,255,255,255},
        clock = {0,0,0,0},
        clockColor = {0},
        clockFormat = "%02d:%02d",
        mapMarkerColors = {255,0,0,255},
        symbolColors = {255,0,0,255},
        myPositionColors = {255,0,0,255},
        moneyCurrentValue = 1,
        starsCurrentValue = 0,
	}
	saveIni()
end

function loadIni()
	local f = io.open(cfg, "r")
	if f then
		editor = decodeJson(f:read("*all"))
		f:close()
	end
end

function saveIni()
	if type(editor) == "table" then
		local f = io.open(cfg, "w")
		f:close()
		if f then
			local f = io.open(cfg, "r+")
			f:write(encodeJson(editor)) 
			f:close()
		end
	end
end
if not doesDirectoryExist(path) then createDirectory(path) end
if doesFileExist(cfg) then loadIni() else blankIni() end

local fsFont = nil
function imgui.BeforeDrawFrame()
	if fa_font == nil then
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
	end
    if fsFont == nil then
        fsFont = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end





local main_window_state = imgui.ImBool(false)
local healthPosX = imgui.ImFloat(editor.health[1])
local healthPosY = imgui.ImFloat(editor.health[2])
local healthHeight = imgui.ImFloat(editor.health[3])
local healthWidth = imgui.ImFloat(editor.health[4])
healthColorr = imgui.ImFloat4(editor.healthColors[1]/255,editor.healthColors[2]/255,editor.healthColors[3]/255, editor.healthColors[4]/255)
local healthRed = editor.healthColors[1]
local healthBlue = editor.healthColors[3]
local healthGreen = editor.healthColors[2]
local healthAlpha = editor.healthColors[4]
local oxygenPosX = imgui.ImFloat(editor.oxygen[1])
local oxygenPosY = imgui.ImFloat(editor.oxygen[2])
local oxygenHeight = imgui.ImFloat(editor.oxygen[3])
local oxygenWidth = imgui.ImFloat(editor.oxygen[4])
oxygenColorr = imgui.ImFloat4(editor.oxygenColors[1]/255,editor.oxygenColors[2]/255,editor.oxygenColors[3]/255, editor.oxygenColors[4]/255)
local oxygenRed = editor.oxygenColors[1]
local oxygenBlue = editor.oxygenColors[3]
local oxygenGreen = editor.oxygenColors[2]
local oxygenAlpha = editor.oxygenColors[4]
local dollarPosX = imgui.ImFloat(editor.money[1])
local dollarPosY = imgui.ImFloat(editor.money[2])
local dollarHeight = imgui.ImFloat(editor.money[3])
local dollarWidth = imgui.ImFloat(editor.money[4])
local armorPosX = imgui.ImFloat(editor.armor[1])
local armorPosY = imgui.ImFloat(editor.armor[2])
local armorHeight = imgui.ImFloat(editor.armor[3])
local armorWidth = imgui.ImFloat(editor.armor[4])
local armorRed = editor.armorColors[1]
local armorBlue = editor.armorColors[3]
local armorGreen = editor.armorColors[2]
local armorAlpha = editor.armorColors[4]
armorColorr = imgui.ImFloat4(editor.armorColors[1]/255,editor.armorColors[2]/255,editor.armorColors[3]/255,editor.armorColors[4]/255)
dollarColorr = imgui.ImFloat4(editor.moneyColors[1]/255,editor.moneyColors[2]/255,editor.moneyColors[3]/255,editor.moneyColors[4]/255)
local dollarRed = editor.moneyColors[1]
local dollarBlue = editor.moneyColors[3]
local dollarGreen = editor.moneyColors[2]
local dollarAlpha = editor.moneyColors[4]
dollarNegativeColor = imgui.ImInt(editor.moneyNegativeColor[1])
dollarString = imgui.ImBuffer(editor.moneyFormat, 7)
dollarNegativeString = imgui.ImBuffer(editor.moneyNegativeFormat, 8)
clockColor = imgui.ImInt(editor.clockColor[1])
clockString = imgui.ImBuffer(editor.clockFormat, 11)
local clockPosX = imgui.ImFloat(editor.clock[1])
local clockPosY = imgui.ImFloat(editor.clock[2])
local radarX = imgui.ImFloat(editor.radar[1])
local radarY = imgui.ImFloat(editor.radar[2])
local radarHeight = imgui.ImFloat(editor.radar[3])
local radarWidth = imgui.ImFloat(editor.radar[4])
local radarRed = editor.radarColors[1]
local radarBlue = editor.radarColors[3]
local radarGreen = editor.radarColors[2]
local radarAlpha = editor.radarColors[4]
radarColorr = imgui.ImFloat4(editor.radarColors[1]/255, editor.radarColors[2]/255,editor.radarColors[3]/255,editor.radarColors[4]/255)
local weaponIconX = imgui.ImFloat(editor.weaponIcon[1])
local weaponIconY = imgui.ImFloat(editor.weaponIcon[2])
local weaponAmmoX = imgui.ImFloat(editor.weaponAmmo[1])
local weaponAmmoY = imgui.ImFloat(editor.weaponAmmo[2])
local wantedStarsX = imgui.ImFloat(editor.wanted[1])
local wantedStarsY = imgui.ImFloat(editor.wanted[2])
local wantedStarsHeight = imgui.ImFloat(editor.wanted[3])
local wantedStarsWidth = imgui.ImFloat(editor.wanted[4])
local wantedStarsRed = editor.wantedColors[1]
local wantedStarsBlue = editor.wantedColors[3]
local wantedStarsGreen = editor.wantedColors[2]
local wantedStarsAlpha = editor.wantedColors[4]
wantedStarsColorr = imgui.ImFloat4(editor.wantedColors[1]/255,editor.wantedColors[2]/255,editor.wantedColors[3]/255,editor.wantedColors[4]/255)
local weaponIconX = imgui.ImFloat(editor.weaponIcon[1])
local weaponIconY = imgui.ImFloat(editor.weaponIcon[2])
local radarX = imgui.ImFloat(editor.radar[1])
local radarY = imgui.ImFloat(editor.radar[2])
local radarHeight = imgui.ImFloat(editor.radar[3])
local radarWidth = imgui.ImFloat(editor.radar[4])
mapColor = imgui.ImFloat4(editor.radarColors[1]/255,editor.radarColors[2]/255,editor.radarColors[3]/255,editor.radarColors[4]/255)
borderColor = imgui.ImFloat4(editor.radarBorderColors[1]/255,editor.radarBorderColors[2]/255,editor.radarBorderColors[3]/255,editor.radarBorderColors[4]/255)
menuMap = imgui.ImFloat4(editor.menuMapColors[1]/255,editor.menuMapColors[2]/255,editor.menuMapColors[3]/255,editor.menuMapColors[4]/255)
mapMarker = imgui.ImFloat4(editor.mapMarkerColors[1]/255,editor.mapMarkerColors[2]/255,editor.mapMarkerColors[3]/255,editor.mapMarkerColors[4]/255)
symbolColor = imgui.ImFloat4(editor.symbolColors[1]/255,editor.symbolColors[2]/255,editor.symbolColors[3]/255,editor.symbolColors[4]/255)
myPosition = imgui.ImFloat4(editor.myPositionColors[1]/255,editor.myPositionColors[2]/255,editor.myPositionColors[3]/255,editor.myPositionColors[4]/255)
local configurator = 0



function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
    sampAddChatMessage("{FFB233}[InterfaceEditor] {FFFFFF}By Montri.")
    sampRegisterChatCommand("ie", editorr)
    while true do
        wait(0)
        changeHud()
        imgui.Process = main_window_state.v
        if moneyOriginal == 0 then
            if sampIsLocalPlayerSpawned() then
                wait(2000)
                money = memory.getint32(0xB7CE50)
                stars = memory.read(0x58DB60,1,0)
                editor.moneyCurrentValue = money
                editor.starsCurrentValue = stars
                saveIni()
                moneyOriginal = 1
                sampAddChatMessage("{FFB233}[InterfaceEditor] {FFFFFF}Modification has {33FF42}fully{FFFFFF} loaded!")
            end 
        end 
    end 
end


function HEXtoRGB(hexArg)

	hexArg = hexArg:gsub('0x','')

	if(string.len(hexArg) == 3) then
		return tonumber('0x'..hexArg:sub(1,1)) * 17, tonumber('0x'..hexArg:sub(2,2)) * 17, tonumber('0x'..hexArg:sub(3,3)) * 17
	elseif(string.len(hexArg) == 8) then
        hexArg = hexArg:sub(1, #hexArg - 2)
        --print(hexArg)
		return tonumber('0x'..hexArg:sub(1,2)), tonumber('0x'..hexArg:sub(3,4)), tonumber('0x'..hexArg:sub(5,6))
	else
		return 0, 0, 0
	end
end 

function imgui.OnDrawFrame()
    if sampIsLocalPlayerSpawned() == false or moneyOriginal == 0 then
        main_window_state.v = false
        sampAddChatMessage("{FFB233}[InterfaceEditor] {FFFFFF}You {FF3333}cannot{FFFFFF} open the Menu until you are/is spawned/fully loaded!")
    end 
    if main_window_state.v and sampIsLocalPlayerSpawned() and moneyOriginal == 1 then
        local sw, sh = getScreenResolution() -- Get Screenresolution to make perfect results.
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600, 355), imgui.Cond.FirstUseEver)
		imgui.Begin("", _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		imgui.PushFont(fsFont) imgui.CenterTextColoredRGB('Montris Editor') imgui.PopFont()
        imgui.Text("")
        --if imgui.Button("Import Settings from InterfaceEditor.asi", imgui.ImVec2(600,25)) then
        --    if getModuleHandle("InterfaceEditor.asi") ~= 0 or getModuleHandle("InterfaceEditor") ~= 0 then
         --       sampAddChatMessage("{FFB233}[InterfaceEditor] {FFFFFF}Cannot copy configs, while its actively running.")
        --    else
        --        local table = lines_from("InterfaceEditor.ini")
        --        local counter = 0
        --        for key, value in pairs(correctValues) do
                    --print(key .. table[key])
         --           if string.find(tostring(table[key]), "%-") then
        --                table[key] = string.gsub(table[key], "-", "0")
        --                value = string.gsub(value, "-", "0")
         --           end 
         --           string = string.format("%s",table[key])
         --           if string.find(string,value) then
         --               counter = counter + 1
         --               table[key] = string.gsub(tostring(table[key]), tostring(value), "")
                        --print(table[key])
         --           end 
         --       end 
        ---        if counter > 81 then
          --          table[2] = string.gsub(tostring(table[2]), "%$", "0x") -- Healthbar Color
         --           editor.healthColors[1],editor.healthColors[2],editor.healthColors[3] = HEXtoRGB(table[2])
         --           editor.healthColors[4] = 255
          --          table[3] = string.gsub(tostring(table[3]), "%$", "0x") -- Money
          --          editor.moneyColors[1],editor.moneyColors[2],editor.moneyColors[3] = HEXtoRGB(table[3])
         --           editor.moneyColors[4] = 255
         --           table[4] = string.gsub(tostring(table[4]), "%$", "0x") -- Wanted Stars
         --           editor.wantedColors[1],editor.wantedColors[2],editor.wantedColors[3] = HEXtoRGB(table[4])
         --           editor.wantedColors[4] = 255
                    -- 9g,10b,8r, 11r,12g,13b,14r,15g,16b,17a,19a,20a,21a,22a,23a,24a,25a,26a
         --           editor.radarColors[1] = tonumber(table[8])
          --          editor.radarColors[2] = tonumber(table[12])
          --          editor.radarColors[3] = tonumber(table[10]) 
         --           editor.radarColors[4] = tonumber(table[19])
          --          editor.clockFormat = tostring(table[28])
          --          -- 28 clock
          --          editor.radar[1] = tonumber(table[62])
           --         editor.radar[2] = tonumber(table[68])
          --          editor.radar[3] = tonumber(table[38])
          --          editor.radar[4] = tonumber(table[32])
          --          -- 62 radarx, 32 width 68 radary, 38 height
          --          -- 43 healthbar x, 44 healthbar y, 45 armor x 46 armor y, 47 breath x 48 breath y 49 money x 50 money y 51 clock x 52 clock y 53 iconx 55 icon y 
           --         editor.health[1] = tonumber(table[43])
           --         editor.health[2] = tonumber(table[44])
           --         editor.armor[1] = tonumber(table[45])
           --         editor.armor[2] =  tonumber(table[46])
           --         editor.oxygen[1] = tonumber(table[47])
          --          editor.oxygen[2] = tonumber(table[48])
          --          editor.money[1] = tonumber(table[49])
           --         editor.health[2] = tonumber(table[50])
          --          editor.clock[1] = tonumber(table[51])
          --          editor.clock[2] = tonumber(table[52])
          --          editor.weaponIcon[1] = tonumber(table[53])
          --          editor.weaponIcon[1] = tonumber(table[55])
                    -- 57 wanted x 59 wanted y, 
          --          editor.wanted[1] = tonumber(table[57])
          --          editor.wanted[2] = tonumber(table[59])
          --          callVariables()
          --          saveIni()
         --           addOneOffSound(0,0,0,1057)
         --       else
         --           sampAddChatMessage("{FFB233}[InterfaceEditor] {FFFFFF}This config is not supported for transfer.")
         --       end 
        --    end 
        --end 
        imgui.BeginChild("Selection", imgui.ImVec2(180, 230), true)
        if imgui.Button(fa.ICON_FA_CLOCK .. " Clock", imgui.ImVec2(170, 25)) then
            configurator = 4
        end 
        if imgui.Button(fa.ICON_FA_HEART .. " Healthbar", imgui.ImVec2(170, 25)) then
            configurator = 1
        end 
        if imgui.Button(fa.ICON_FA_USER_SHIELD .. " Armor", imgui.ImVec2(170,25)) then
            configurator = 9 
        end 
        if imgui.Button(fa.ICON_FA_WATER ..  " Oxygen", imgui.ImVec2(170, 25)) then
            configurator = 2
        end 
        if imgui.Button(fa.ICON_FA_DOLLAR_SIGN .. " Dollar Bar", imgui.ImVec2(170,25)) then
            configurator = 3
        end 
        if imgui.Button(fa.ICON_FA_STAR .. " Wanted Stars", imgui.ImVec2(170, 25)) then
            configurator = 5
        end 
        if imgui.Button(fa.ICON_FA_FIST_RAISED .. " Weapon Icon", imgui.ImVec2(170, 25)) then
            configurator = 6
        end 
        if imgui.Button(fa.ICON_FA_MAP_MARKER_ALT .. " Radar (Minimap)", imgui.ImVec2(170, 25)) then
            configurator = 7
        end 
        if imgui.Button(fa.ICON_FA_MAP .. " Map (ESC)", imgui.ImVec2(170, 25)) then
            configurator = 8
        end 
        imgui.EndChild()
        imgui.SameLine()
        if configurator == 0 then
            imgui.BeginChild("##0", imgui.ImVec2(400,230), true)
            imgui.EndChild()
        end 
        if configurator == 1 then -- Health Settings
            imgui.BeginChild("Health", imgui.ImVec2(400,230), true) 
            if imgui.SliderFloat("Position X", healthPosX, 0, sw) then 
                editor.health[1] = healthPosX.v
                saveIni()
            end
            if imgui.SliderFloat('Position Y',healthPosY, 0, sh) then
                editor.health[2] = healthPosY.v 
                saveIni()
            end
            if imgui.SliderFloat("Height", healthHeight, 0, 105) then
                editor.health[3] = healthHeight.v
                saveIni()
            end
            if imgui.SliderFloat("Width", healthWidth, 0, sh+47.5) then
                editor.health[4] = healthWidth.v
                saveIni()
            end
            if imgui.ColorEdit4("Health Color", healthColorr) then
                healthrgba = imgui.ImColor(healthColorr.v[1],healthColorr.v[2],healthColorr.v[3],healthColorr.v[4])
                healthRed, healthGreen, healthBlue, healthAlpha = healthrgba:GetRGBA()
                healthRed, healthGreen, healthBlue, healthAlpha = healthRed * 255, healthGreen * 255, healthBlue * 255, healthAlpha * 255
                editor.healthColors[1], editor.healthColors[2], editor.healthColors[3], editor.healthColors[4] = healthRed, healthGreen, healthBlue, healthAlpha
                saveIni()
            end
            imgui.EndChild()
        end
        if configurator == 2 then -- Oxygen Settings
            imgui.BeginChild("Oxygen", imgui.ImVec2(400,230), true) 
            if imgui.SliderFloat("Position X", oxygenPosX, 0, sw) then
                editor.oxygen[1] = oxygenPosX.v
                saveIni()
            end 
            if imgui.SliderFloat("Position Y", oxygenPosY, 0, sh) then
                editor.oxygen[2] = oxygenPosY.v
                saveIni()
            end 
            if imgui.SliderFloat("Height", oxygenHeight, 0, 105) then
                editor.oxygen[3] = oxygenHeight.v
                saveIni()
            end 
            if imgui.SliderFloat("Width", oxygenWidth, 0, sw+47.5) then
                editor.oxygen[4] = oxygenWidth.v
                saveIni()
            end 
            if imgui.ColorEdit4("Oxygen Color", oxygenColorr) then
                oxygenrgba = imgui.ImColor(oxygenColorr.v[1],oxygenColorr.v[2],oxygenColorr.v[3],oxygenColorr.v[4])
                oxygenRed, oxygenGreen, oxygenBlue, oxygenAlpha = oxygenrgba:GetRGBA()
                oxygenRed, oxygenGreen, oxygenBlue, oxygenAlpha = oxygenRed*255, oxygenGreen*255, oxygenBlue*255, oxygenAlpha * 255
                editor.oxygenColors[1],editor.oxygenColors[2],editor.oxygenColors[3],editor.oxygenColors[4] = oxygenRed, oxygenGreen, oxygenBlue, oxygenAlpha
                saveIni()
            end 
            imgui.EndChild()
        end 

        if configurator == 3 then -- Dollar Bar Settings
            imgui.BeginChild("Dollar Bar", imgui.ImVec2(400,230),true)
                if imgui.SliderFloat("Position X", dollarPosX, 0, sw) then
                    editor.money[1] = dollarPosX.v
                    saveIni()
                end 
                if imgui.SliderFloat("Position Y", dollarPosY, 0, sh) then
                    editor.money[2] = dollarPosY.v
                    saveIni()
                end 
                if imgui.ColorEdit4("Dollar Bar Color", dollarColorr) then
                    dollarrgba = imgui.ImColor(dollarColorr.v[1],dollarColorr.v[2],dollarColorr.v[3],dollarColorr.v[4])
                    dollarRed, dollarGreen, dollarBlue, dollarAlpha = dollarrgba:GetRGBA()
                    dollarRed, dollarGreen, dollarBlue, dollarAlpha = dollarRed*255, dollarGreen*255, dollarBlue*255, dollarAlpha*255
                    editor.moneyColors[1], editor.moneyColors[2], editor.moneyColors[3], editor.moneyColors[4] = dollarRed, dollarGreen, dollarBlue, dollarAlpha
                    if memory.getint32(0xB7CE50) > 0 then
                    else
                        memory.setint32(0xB7CE50, memory.getint32(0xB7CE50)*-1) 
                    end 
                    saveIni()
                end
                if imgui.InputText("Positive Format", dollarString) then
                    editor.moneyFormat =  tostring(dollarString.v)
                    if memory.getint32(0xB7CE50) > 0 then
                    else
                        memory.setint32(0xB7CE50, memory.getint32(0xB7CE50)*-1) 
                    end 
                    saveIni()
                end 
                if imgui.SliderInt("Negative Color", dollarNegativeColor, 0, 255) then
                    editor.moneyNegativeColor[1] = dollarNegativeColor.v
                    if memory.getint32(0xB7CE50) < 0 then
                    else
                        memory.setint32(0xB7CE50, memory.getint32(0xB7CE50)*-1) 
                    end 
                    saveIni()
                end 
                imgui.Hint("The Colortheme is based on your healthbar Color!", -1, "Information")
                if imgui.InputText("Negative Format", dollarNegativeString) then
                    editor.moneyNegativeFormat = tostring(dollarNegativeString.v)
                    if memory.getint32(0xB7CE50) < 0 then
                    else
                        memory.setint32(0xB7CE50, memory.getint32(0xB7CE50)*-1) 
                    end 
                    saveIni()
                end 
                imgui.EndChild()
        end 
        if configurator == 4 then -- Clock Settings
            imgui.BeginChild("Clock", imgui.ImVec2(400,230),true)
            if imgui.SliderFloat("Position X", clockPosX, 0, sw) then
                editor.clock[1] = clockPosX.v
                saveIni()
            end 
            if imgui.SliderFloat("Position Y", clockPosY, 0, sh) then
                editor.clock[2] = clockPosY.v
                saveIni()
            end 
            if imgui.SliderInt("Clock Color", clockColor, 0, 20) then
                editor.clockColor[1] = clockColor.v
                saveIni()  
            end 
            imgui.Hint("Clockfont 2 shares the same color as Wanted Stars! \n Clockfont 0 shares the same color as Armor!", -1, "Information")
            if imgui.InputText("Format of Clock", clockString) then
                editor.clockFormat = clockString.v
                saveIni()
            end
            imgui.EndChild()
        end 
        if configurator == 5 then -- Wanted Stars Settings
            memory.write(0x58DB60,6,1,0)
            imgui.BeginChild("Wanted Stars", imgui.ImVec2(400,230),true) 
            if imgui.SliderFloat("Position X", wantedStarsX, 0, sw) then
                editor.wanted[1] = wantedStarsX.v
                saveIni()
            end 
            if imgui.SliderFloat("Position Y", wantedStarsY, 0, sh) then
                editor.wanted[2] = wantedStarsY.v
                saveIni()
            end 
            if imgui.ColorEdit4("Color of Wanted Stars", wantedStarsColorr) then
                starsrgba = imgui.ImColor(wantedStarsColorr.v[1],wantedStarsColorr.v[2],wantedStarsColorr.v[3],wantedStarsColorr.v[4])
                wantedStarsRed, wantedStarsGreen, wantedStarsBlue, wantedStarsAlpha = starsrgba:GetRGBA()
                wantedStarsRed, wantedStarsGreen, wantedStarsBlue, wantedStarsAlpha = wantedStarsRed*255,wantedStarsGreen*255,wantedStarsBlue*255,wantedStarsAlpha*255
                editor.wantedColors[1],editor.wantedColors[2],editor.wantedColors[3],editor.wantedColors[4] = wantedStarsRed, wantedStarsGreen, wantedStarsBlue, wantedStarsAlpha
                saveIni()
            end 
            imgui.EndChild()
        else                
            memory.write(0x58DB60,editor.starsCurrentValue,1,0)
        end
        if configurator == 6 then -- Weapon Icon + Weapon Ammo Settings
            imgui.BeginChild("Weapon Icon", imgui.ImVec2(400,230),true) 
            if imgui.SliderFloat("Icon Position X", weaponIconX, 0, sw) then
                editor.weaponIcon[1] = weaponIconX.v
                saveIni()
            end 
            if imgui.SliderFloat("Icon Position Y", weaponIconY, 0, sh) then
                editor.weaponIcon[2] = weaponIconY.v
                saveIni()
            end 
            imgui.EndChild()
        end  
        if configurator == 7 then -- Radar
            imgui.BeginChild("Radar", imgui.ImVec2(400,230),true)
            if imgui.SliderFloat("Position X", radarX,0,sw) then
                editor.radar[1] = radarX.v
                saveIni()
            end 
            if imgui.SliderFloat("Position Y", radarY, 0, sh) then
                editor.radar[2] = radarY.v
                saveIni()
            end 
            if imgui.SliderFloat("Height", radarHeight, 0, sw) then
                editor.radar[3] = radarHeight.v
                saveIni()
            end 
            if imgui.SliderFloat("Width", radarWidth, 0, sw+47.5) then
                editor.radar[4] = radarWidth.v
                saveIni()
            end 
            if imgui.ColorEdit4("Color of Radar",mapColor) then
                editor.radarColors[1] = mapColor.v[1] * 255
                editor.radarColors[2] = mapColor.v[2] * 255
                editor.radarColors[3] = mapColor.v[3] * 255
                saveIni()
            end 
            if imgui.ColorEdit4("Color of Radar Border", borderColor) then
                editor.radarBorderColors[1] = borderColor.v[1] *255
                editor.radarBorderColors[2] = borderColor.v[2] *255
                editor.radarBorderColors[3] = borderColor.v[3] *255
                editor.radarBorderColors[4] = borderColor.v[4] *255
                saveIni()
            end 
            if imgui.ColorEdit4("Color of Radar Symbols", symbolColor) then
                editor.symbolColors[1],editor.symbolColors[2],editor.symbolColors[3],editor.symbolColors[4] = symbolColor.v[1]*255,symbolColor.v[2]*255,symbolColor.v[3]*255,symbolColor.v[4]*255
                saveIni()
            end 
            if imgui.ColorEdit4("Color of my Position", myPosition) then
                editor.myPositionColors[1],editor.myPositionColors[2],editor.myPositionColors[3],editor.myPositionColors[4] = myPosition.v[1]*255,myPosition.v[2]*255,myPosition.v[3]*255,myPosition.v[4]*255
                saveIni()
            end 
            imgui.Hint("Slightly influences the color of 'N' Symbol!", -1, "Information")
            imgui.EndChild()
        end 
        if configurator == 8 then -- MAP IN MENU
            imgui.BeginChild("Radar", imgui.ImVec2(400,230),true)
            if imgui.ColorEdit4("Color of Menu Map", menuMap) then
                editor.menuMapColors[1],editor.menuMapColors[2],editor.menuMapColors[3],editor.menuMapColors[4] = menuMap.v[1]*255,menuMap.v[2]*255,menuMap.v[3]*255,menuMap.v[4]*255
            end 
            --if imgui.ColorEdit4("Color of Map Marker", mapMarker) then
             --   editor.mapMarkerColors[1],editor.mapMarkerColors[2],editor.mapMarkerColors[3],editor.mapMarkerColors[4] = mapMarker.v[1]*255,mapMarker.v[2]*255,mapMarker.v[3]*255,mapMarker.v[4]*255
             --   saveIni()
            --end 
            saveIni()
            imgui.EndChild()
        end 
        if configurator == 9 then -- ARMOR BAR
            imgui.BeginChild("Armor", imgui.ImVec2(400,230),true)
            if imgui.SliderFloat("Armor Position X", armorPosX, 0, sw) then
                editor.armor[1] = armorPosX.v
                saveIni()
            end 
            if imgui.SliderFloat("Armor Position Y", armorPosY, 0, sh) then
                editor.armor[2] = armorPosY.v
                saveIni()
            end 
            if imgui.SliderFloat("Armor Height", armorHeight, 0, 105) then
                editor.armor[3] = armorHeight.v
                saveIni()
            end 
            if imgui.SliderFloat("Armor Width", armorWidth, 0, sw+47.5) then
                editor.armor[4] = armorWidth.v
                saveIni()
            end 
            if imgui.ColorEdit4("Armor Color", armorColorr) then
                armorrgba = imgui.ImColor(armorColorr.v[1],armorColorr.v[2],armorColorr.v[3],armorColorr.v[4])
                armorRed, armorGreen, armorBlue, armorAlpha = armorrgba:GetRGBA()
                armorRed, armorGreen, armorBlue, armorAlpha = armorRed*255, armorGreen*255, armorBlue*255, armorAlpha*255
                editor.armorColors[1],editor.armorColors[2],editor.armorColors[3],editor.armorColors[4] = armorRed, armorGreen, armorBlue, armorAlpha
                saveIni()
            end 
            imgui.EndChild()
        end 
        imgui.BeginChild("End", imgui.ImVec2(585, 50), true)
        imgui.CenterTextColoredRGB("Coded by Montri")
        imgui.Separator()
        imgui.SameLine(212)
        imgui.Link("https://github.com/Montrii")
        imgui.EndChild()
        imgui.End()
    end 
end


function translateTextToHex(text)
    local hexArray = {[" "] = "20", ["!"] = "21", ['"'] = "22", ["#"] = "23", ["$"] = "24", ["%"] = "25", ["&"] = "26", ["'"] = "27", ["("] = "28", [")"] = "29", ["*"] = "2A",
    ["+"] = "2B", ["-"] = "2D", ["."] = "2E", ["/"] = "2F", ["0"] = "30", ["1"] = "31", ["2"] = "32", ["3"] = "33", ["4"] = "34", ["5"] = "35", ["6"] = "36", ["7"] = "37", ["8"] = "38",
    ["9"] = "39", [":"] = "3A", [";"] = "3B", ["<"] = "3C", ["="] = "3D", [">"] = "3E", ["?"] = "3F", ["@"] = "40", ["A"] = "41", ["B"] = "42", ["C"] = "43", ["D"] = "44", ["E"] = 45,
    ["F"] = "46", ["G"] = "47", ["H"] = "48", ["I"] = "49", ["J"] = "4A", ["K"] = "4B", ["L"] = "4C", ["M"] = "4D" ,["N"] = "4E", ["O"] = "4F", ["P"] = "50", ["Q"] = "51", ["R"] = "52",
    ["S"] = "53", ["T"] = "54", ["U"] = "55", ["V"] = "56", ["W"] = "57", ["X"] = "58", ["Y"] = "59", ["Z"] = "5A", ["["] = "5B", ["\\"] = "5C", ["]"] = "5D", ["^"] = "5E", ["_"] = "5F",
    ["`"] = "60", ["a"] = "61", ["b"] = "62", ["c"] = "63", ["d"] = "64", ["e"] = "65", ["f"] = "66", ["g"] = "67", ["h"] = "68", ["i"] = "69", ["j"] = "6A", ["k"] = "6B", ["l"] = "6C",
    ["m"] = "6D", ["n"] = "6E", ["o"] = "6F", ["p"] = "70", ["q"] = "71", ["r"] = "72", ["s"] = "73", ["t"] = "74", ["u"] = "75", ["v"] = "76", ["w"] = "77", ["x"] = "78", ["y"] = "79",
    ["z"] = "7A", ["{"] = "7B", ["|"] = "7C", ["}"] = "7D", ["~"] = "7E"}
    local text_length = string.len(text)
    local hex = ""
    for i = 1, text_length, 1 do
        letter = text:sub(1, 1)
        for key, value in pairs(hexArray) do
            if key == "\\" then
              key = string.sub(key, 1, #key - 1)  
            end 
            if key == letter then
                hex = hex .. value
            end  
        end 
        text = text:sub(2)
    end 
    return hex
end 


function editorr()
    main_window_state.v = not main_window_state.v 
end 

function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
end

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end


function changeHud()
    local healthColor = join_argb(healthAlpha, healthBlue, healthGreen, healthRed)
    memory.write(0xBAB22C, healthColor, 4, true) -- Health string / enemy color / red marker / any red text (RGBA, 4 bytes)
    local healthX = ffi.cast('float*', ffi.C.malloc(4))
    local healthY = ffi.cast('float*', ffi.C.malloc(4))
    local healthHeight = ffi.cast('float*', ffi.C.malloc(4))
    local healthWidth = ffi.cast('float*', ffi.C.malloc(4))
    healthX[0] = editor.health[1]
    healthY[0] = editor.health[2]
    healthHeight[0] = editor.health[3]
    healthWidth[0] = editor.health[4]
    ffi.cast('float**', 0x58EE87)[0] = healthX
    ffi.cast('float**', 0x58EE68)[0] = healthY
    ffi.cast('float**', 0x589358)[0] = healthHeight
    ffi.cast('float**', 0x5892D8)[0] = healthWidth
    local oxygenColor = join_argb(oxygenAlpha, oxygenBlue, oxygenGreen, oxygenRed)
    memory.write(0xBAB238, oxygenColor, 4, true) -- White Color
    local oxygenX = ffi.cast('float*', ffi.C.malloc(4))
    local oxygenY = ffi.cast('float*', ffi.C.malloc(4))
    local oxygenHeight = ffi.cast('float*', ffi.C.malloc(4))
    local oxygenWidth = ffi.cast('float*', ffi.C.malloc(4))
    oxygenX[0] = editor.oxygen[1]
    oxygenY[0] = editor.oxygen[2]
    oxygenHeight[0] = editor.oxygen[3]
    oxygenWidth[0] = editor.oxygen[4]
    ffi.cast('float**',  0x58F11F)[0] = oxygenX
    ffi.cast('float**', 0x58F100)[0] = oxygenY
    ffi.cast('float**',  0x58921E)[0] = oxygenHeight
    ffi.cast('float**', 0x589235)[0] = oxygenWidth
    local dollarColor = join_argb(dollarAlpha, dollarBlue, dollarGreen, dollarRed)
    memory.write(0xbab230, dollarColor, 4, true) -- Money (car name color) = any green text
    memory.setint32(0x58F4D4, 609520896 + editor.moneyNegativeColor[1])
    local moneyX = ffi.cast('float*', ffi.C.malloc(4))
    local moneyY = ffi.cast('float*', ffi.C.malloc(4))
    moneyX[0] = editor.money[1]
    moneyY[0] = editor.money[2]
    ffi.cast('float**', 0x58F5FC)[0] = moneyX
    ffi.cast('float**', 0x58F5DC)[0] = moneyY 
    local moneyText = memory.hex2bin(translateTextToHex(editor.moneyFormat), 0x866C94, 6)
    local moneyNegativeText = memory.hex2bin(translateTextToHex(editor.moneyNegativeFormat), 0x866C8C, 6)
    local armorX = ffi.cast('float*', ffi.C.malloc(4))
    local armorY = ffi.cast('float*', ffi.C.malloc(4))
    local armorHeight = ffi.cast('float*', ffi.C.malloc(4))
    local armorWidth = ffi.cast('float*', ffi.C.malloc(4))
    local armorColor = join_argb(armorAlpha, armorBlue, armorGreen, armorRed)
    memory.write(0xBAB23C, armorColor, 4, true) -- Armor Color
    armorX[0] = editor.armor[1]
    armorY[0] = editor.armor[2]
    armorHeight[0] = editor.armor[3]
    armorWidth[0] = editor.armor[4]
    ffi.cast('float**', 0x58EF59)[0] = armorX
    ffi.cast('float**', 0x58EF3A)[0] = armorY
    ffi.cast('float**', 0x589146)[0] = armorHeight
    ffi.cast('float**', 0x58915D)[0] = armorWidth
    local weaponIconPosX = ffi.cast('float*', ffi.C.malloc(4))
    local weaponIconPosY = ffi.cast('float*', ffi.C.malloc(4))
    local weaponAmmoX = ffi.cast('float*', ffi.C.malloc(4))
    local weaponAmmoY = ffi.cast('float*', ffi.C.malloc(4))
    weaponIconPosX[0] = editor.weaponIcon[1]
    weaponIconPosY[0] = editor.weaponIcon[2]
    editor.weaponAmmo[1],editor.weaponAmmo[2] = 10000.00, 10000.00
    weaponAmmoX[0] = editor.weaponAmmo[1]
    weaponAmmoY[0] = editor.weaponAmmo[2]
    ffi.cast('float**', 0x58F927)[0] = weaponIconPosX -- Weapon Icon X POs
    ffi.cast('float**', 0x58F913)[0] = weaponIconPosY -- Weapon Icon Y Pos
    ffi.cast('float**', 0x58F9F7)[0] = weaponAmmoX -- Weapon Ammo Y Pos
    ffi.cast('float**', 0x58F9DC)[0] = weaponAmmoY -- Weapon Ammo X Pos
    local wantedStarsXX = ffi.cast('float*', ffi.C.malloc(4))
    local wantedStarsYY = ffi.cast('float*', ffi.C.malloc(4))
    wantedStarsXX[0] = editor.wanted[1]
    wantedStarsYY[0] = editor.wanted[2]
    ffi.cast('float**', 0x58DD0F)[0] = wantedStarsXX -- Wanted Stars X
    ffi.cast('float**', 0x58DDFC)[0] = wantedStarsYY -- Wanted Stars Y
    local wantedStarsColor = join_argb(wantedStarsAlpha, wantedStarsBlue, wantedStarsGreen, wantedStarsRed)
    memory.write(0xBAB244, wantedStarsColor, 4, true) -- Wanted level / yellow color (RGBA, 4 bytes)
    local radarX = ffi.cast('float*', ffi.C.malloc(4))
    local radarY = ffi.cast('float*', ffi.C.malloc(4))
    local radarWidth = ffi.cast('float*', ffi.C.malloc(4))
    local radarHeight = ffi.cast('float*', ffi.C.malloc(4))
    radarWidth[0] = editor.radar[4]
    radarHeight[0] = editor.radar[3]
    radarX[0] = editor.radar[1]
    radarY[0] = editor.radar[2]
    ffi.cast('float**', 0x58A79B)[0] = radarX
    ffi.cast('float**', 0x5834D4)[0] = radarX
    ffi.cast('float**', 0x58A836)[0] = radarX
    ffi.cast('float**', 0x58A8E9)[0] = radarX
    ffi.cast('float**', 0x58A98A)[0] = radarX
    ffi.cast('float**', 0x58A469)[0] = radarX
    ffi.cast('float**', 0x58A5E2)[0] = radarX
    ffi.cast('float**', 0x58A6E6)[0] = radarX
    ffi.cast('float**', 0x58A7C7)[0] = radarY
    ffi.cast('float**', 0x58A868)[0] = radarY
    ffi.cast('float**', 0x58A913)[0] = radarY
    ffi.cast('float**', 0x58A9C7)[0] = radarY
    ffi.cast('float**', 0x583500)[0] = radarY
    ffi.cast('float**', 0x58A499)[0] = radarY
    ffi.cast('float**', 0x58A60E)[0] = radarY
    ffi.cast('float**', 0x58A71E)[0] = radarY
    ffi.cast('float**', 0x58A47D)[0] = radarHeight
    ffi.cast('float**', 0x58A632)[0] = radarHeight 
    ffi.cast('float**', 0x58A6AB)[0] = radarHeight 
    ffi.cast('float**', 0x58A70E)[0] = radarHeight 
    ffi.cast('float**', 0x58A801)[0] = radarHeight 
    ffi.cast('float**', 0x58A8AB)[0] = radarHeight 
    ffi.cast('float**', 0x58A921)[0] = radarHeight 
    ffi.cast('float**', 0x58A9D5)[0] = radarHeight 
    ffi.cast('float**', 0x5834F6)[0] = radarHeight 
    ffi.cast('float**', 0x5834C2)[0] = radarWidth
    ffi.cast('float**', 0x58A449)[0] = radarWidth 
    ffi.cast('float**', 0x58A7E9)[0] = radarWidth 
    ffi.cast('float**', 0x58A840)[0] = radarWidth 
    ffi.cast('float**', 0x58A943)[0] = radarWidth 
    ffi.cast('float**', 0x58A99D)[0] = radarWidth 
    local clockText = memory.hex2bin(translateTextToHex(editor.clockFormat), 0x859A6C, 10)
    local clockColor = memory.setint32(0x58EBCA, 609520900+editor.clockColor[1], 1)
    local clockX = ffi.cast('float*', ffi.C.malloc(4))
    local clockY = ffi.cast('float*', ffi.C.malloc(4))
    clockX[0] = editor.clock[1]
    clockY[0] = editor.clock[2]
    ffi.cast('float**',0x58EC16)[0] = clockX
    ffi.cast('float**',0x58EC04)[0] = clockY
    -- RADAR MAP
    memory.setuint8(0x5864CC, editor.radarColors[1], true)
    memory.setuint8(0x5864C7, editor.radarColors[2], true)
    memory.setuint8(0x5864C2, editor.radarColors[3], true)
    -----
    ---- RADAR BORDER
    memory.write(0x58A798, editor.radarBorderColors[1], 1, true)
    memory.write(0x58A89A, editor.radarBorderColors[1], 1, true)
    memory.write(0x58A8EE, editor.radarBorderColors[1], 1, true)
    memory.write(0x58A9A2, editor.radarBorderColors[1], 1, true)

    memory.write(0x58A790, editor.radarBorderColors[2], 1, true)
    memory.write(0x58A896, editor.radarBorderColors[2], 1, true)
    memory.write(0x58A8E6, editor.radarBorderColors[2], 1, true)
    memory.write(0x58A99A, editor.radarBorderColors[2], 1, true)

    memory.write(0x58A78E, editor.radarBorderColors[3], 1, true)
    memory.write(0x58A894, editor.radarBorderColors[3], 1, true)
    memory.write(0x58A8DE, editor.radarBorderColors[3], 1, true)
    memory.write(0x58A996, editor.radarBorderColors[3], 1, true)

    memory.write(0x58A789, editor.radarBorderColors[4], 1, true)
    memory.write(0x58A88F, editor.radarBorderColors[4], 1, true)
    memory.write(0x58A8D9, editor.radarBorderColors[4], 1, true)
    memory.write(0x58A98F, editor.radarBorderColors[4], 1, true)
    -----
    --- MENU MAP
    memory.setuint32(0x5865DB, editor.menuMapColors[1], true)
    memory.setuint32(0x5865BD, editor.menuMapColors[1], true)
    memory.setuint32(0x586617, editor.menuMapColors[1], true)
    memory.setuint32(0x5865F9, editor.menuMapColors[1], true)
    memory.setuint32(0x5865D6, editor.menuMapColors[2], true)
    memory.setuint32(0x5865B8, editor.menuMapColors[2], true)
    memory.setuint32(0x586612, editor.menuMapColors[2], true)
    memory.setuint32(0x5865F4, editor.menuMapColors[2], true)
    memory.setuint32(0x5865D1, editor.menuMapColors[3], true)
    memory.setuint32(0x5865B3, editor.menuMapColors[3], true)
    memory.setuint32(0x58660D, editor.menuMapColors[3], true)
    memory.setuint32(0x5865EF, editor.menuMapColors[3], true)
    -----
    --- NORTH SYMBOL COLOR
    memory.write(0x5860CD, editor.symbolColors[1],1, true)
    memory.write(0x5860C2, editor.symbolColors[2],1, true)
    memory.write(0x5860BD, editor.symbolColors[3],1, true)

    --- MY POSITION COLOR
    memory.write(0x588691, editor.myPositionColors[1],1, true)
    memory.write(0x58868C, editor.myPositionColors[2],1, true)
    memory.write(0x5860BD, editor.myPositionColors[3],1, true)
end 

function onExitScript()
    memory.setint32(0xB7CE50,editor.moneyCurrentValue)
    ffi.C.free(healthX)
    ffi.C.free(healthY)
    ffi.C.free(healthHeight)
    ffi.C.free(healthWidth)
    ffi.C.free(oxygenX)
    ffi.C.free(oxygenY)
    ffi.C.free(oxygenHeight)
    ffi.C.free(oxygenWidth)
    ffi.C.free(moneyX)
    ffi.C.free(moneyY)
    ffi.C.free(armorX)
    ffi.C.free(armorY)
    ffi.C.free(armorHeight)
    ffi.C.free(armorWidth)
    ffi.C.free(weaponIconPosX)
    ffi.C.free(weaponIconPosY)
    ffi.C.free(weaponAmmoX)
    ffi.C.free(weaponAmmoY)
    ffi.C.free(wantedStarsX)
    ffi.C.free(wantedStarsY)
    ffi.C.free(radarX)
    ffi.C.free(radarY)
    ffi.C.free(radarHeight)
    ffi.C.free(radarWidth)
    ffi.C.free(clockX)
    ffi.C.free(clockY)
    memory.write(0x58DB60,editor.starsCurrentValue,1,0)
end 


function join_argb(a, r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end

function math.round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end

function imgui.TextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end

function imgui.Link(link)
    if status_hovered then
        local p = imgui.GetCursorScreenPos()
        imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), link)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + imgui.CalcTextSize(link).y), imgui.ImVec2(p.x + imgui.CalcTextSize(link).x, p.y + imgui.CalcTextSize(link).y), imgui.GetColorU32(imgui.ImVec4(0, 0.5, 1, 1)))
    else
        imgui.TextColored(imgui.ImVec4(0, 0.3, 0.8, 1), link)
    end
    if imgui.IsItemClicked() then os.execute('explorer '..link)
    elseif imgui.IsItemHovered() then
        status_hovered = true else status_hovered = false
    end
end


function imgui.Hint(text, delay, action)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5
        if os.clock() >= go_hint then
            imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0.11, 0.11, 0.11, 1.00))
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], u8'Notification:')
                    imgui.TextUnformatted(text)
                    if action ~= nil then
                        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.TextDisabled], '\n '..action)
                    end
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar(2)
        end
    end
end

function style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

   	style.WindowPadding 		= imgui.ImVec2(8, 8)
    style.WindowRounding 		= 6
    style.ChildWindowRounding 	= 5
    style.FramePadding 			= imgui.ImVec2(5, 3)
    style.FrameRounding 		= 3.0
    style.ItemSpacing 			= imgui.ImVec2(5, 4)
    style.ItemInnerSpacing 		= imgui.ImVec2(4, 4)
    style.IndentSpacing 		= 21
    style.ScrollbarSize 		= 10.0
    style.ScrollbarRounding 	= 13
    style.GrabMinSize 			= 8
    style.GrabRounding			= 1
    style.WindowTitleAlign 		= imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign 		= imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                                = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]                        = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.WindowBg]                            = ImVec4(0.09, 0.09, 0.09, 1.00)
    colors[clr.ChildWindowBg]                       = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                             = ImVec4(0.05, 0.05, 0.05, 1.00)
    colors[clr.ComboBg]                             = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.Border]                              = ImVec4(0.43, 0.43, 0.50, 0.10)
    colors[clr.BorderShadow]                        = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                             = ImVec4(0.30, 0.30, 0.30, 0.10)
    colors[clr.FrameBgHovered]                      = ImVec4(0.00, 0.53, 0.76, 0.30)
    colors[clr.FrameBgActive]                       = ImVec4(0.00, 0.53, 0.76, 0.80)
    colors[clr.TitleBg]                             = ImVec4(0.13, 0.13, 0.13, 0.99)
    colors[clr.TitleBgActive]                       = ImVec4(0.13, 0.13, 0.13, 0.99)
    colors[clr.TitleBgCollapsed]                    = ImVec4(0.05, 0.05, 0.05, 0.79)
    colors[clr.MenuBarBg]                           = ImVec4(0.13, 0.13, 0.13, 0.99)
    colors[clr.ScrollbarBg]                         = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]                       = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]                = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]                 = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CheckMark]                           = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.SliderGrab]                          = ImVec4(0.28, 0.28, 0.28, 1.00)
    colors[clr.SliderGrabActive]                    = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.Button]                              = ImVec4(0.26, 0.26, 0.26, 0.30)
    colors[clr.ButtonHovered]                       = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.ButtonActive]                        = ImVec4(0.00, 0.43, 0.76, 1.00)
    colors[clr.Header]                              = ImVec4(0.12, 0.12, 0.12, 0.94)
    colors[clr.HeaderHovered]                       = ImVec4(0.34, 0.34, 0.35, 0.89)
    colors[clr.HeaderActive]                        = ImVec4(0.12, 0.12, 0.12, 0.94)
    colors[clr.Separator]                           = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.SeparatorHovered]                    = ImVec4(0.26, 0.59, 0.98, 0.78)
    colors[clr.SeparatorActive]                     = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip]                          = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered]                   = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive]                    = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.CloseButton]                         = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]                  = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]                   = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]                           = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]                    = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]                       = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]                = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]                      = ImVec4(0.00, 0.43, 0.76, 1.00)
    colors[clr.ModalWindowDarkening]                = ImVec4(0.20, 0.20, 0.20,  0.0)
end
style()