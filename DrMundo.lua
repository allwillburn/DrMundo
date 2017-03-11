local ver = "0.01"

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "DrMundo" then return end


require("OpenPredict")
require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/DrMundo/master/DrMundo.lua', SCRIPT_PATH .. 'DrMundo.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/DrMundo/master/DrMundo.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local MundoQ = {delay = 250, range = 1000, width = 60, speed = 2000}

local DrMundoMenu = Menu("DrMundo", "DrMundo")

DrMundoMenu:SubMenu("Combo", "Combo")

DrMundoMenu.Combo:Boolean("Q", "Use Q in combo", true)
DrMundoMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
DrMundoMenu.Combo:Boolean("W", "Use W in combo", true)
DrMundoMenu.Combo:Boolean("E", "Use E in combo", true)
DrMundoMenu.Combo:Boolean("R", "Use R in combo", true)
DrMundoMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
DrMundoMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
DrMundoMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
DrMundoMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
DrMundoMenu.Combo:Boolean("RHydra", "Use RHydra", true)
DrMundoMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
DrMundoMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
DrMundoMenu.Combo:Boolean("Randuins", "Use Randuins", true)


DrMundoMenu:SubMenu("AutoMode", "AutoMode")
DrMundoMenu.AutoMode:Boolean("Level", "Auto level spells", false)
DrMundoMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
DrMundoMenu.AutoMode:Boolean("Q", "Auto Q", false)
DrMundoMenu.AutoMode:Boolean("W", "Auto W", false)
DrMundoMenu.AutoMode:Boolean("E", "Auto E", false)
DrMundoMenu.AutoMode:Boolean("R", "Auto R", false)

DrMundoMenu:SubMenu("LaneClear", "LaneClear")
DrMundoMenu.LaneClear:Boolean("Q", "Use Q", true)
DrMundoMenu.LaneClear:Boolean("W", "Use W", true)
DrMundoMenu.LaneClear:Boolean("E", "Use E", true)
DrMundoMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
DrMundoMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

DrMundoMenu:SubMenu("Harass", "Harass")
DrMundoMenu.Harass:Boolean("Q", "Use Q", true)
DrMundoMenu.Harass:Boolean("W", "Use W", true)

DrMundoMenu:SubMenu("KillSteal", "KillSteal")
DrMundoMenu.KillSteal:Boolean("Q", "KS w Q", true)
DrMundoMenu.KillSteal:Boolean("E", "KS w E", true)

DrMundoMenu:SubMenu("AutoIgnite", "AutoIgnite")
DrMundoMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

DrMundoMenu:SubMenu("Drawings", "Drawings")
DrMundoMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

DrMundoMenu:SubMenu("SkinChanger", "SkinChanger")
DrMundoMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
DrMundoMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if DrMundoMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if DrMundoMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
				if target ~= nil then 
                                      CastSkillShot(_Q, target)
                                end
            end

            if DrMundoMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 163) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if DrMundoMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if DrMundoMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if DrMundoMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if DrMundoMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if DrMundoMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 200) then
			 CastSpell(_E)
	    end

            if DrMundoMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
                local QPred = GetPrediction(target, MundoQ)
                       if QPred.hitChance > (DrMundoMenu.Combo.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                CastSkillShot(_Q,QPred.target)
                       end
                 end

            if DrMundoMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if DrMundoMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if DrMundoMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if DrMundoMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 163) then
			CastSpell(_W)
	    end
	    
	    
            if DrMundoMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1000) and (EnemiesAround(myHeroPos(), 1000) >= DrMundoMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and DrMundoMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSkillShot(_Q, target)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 150) and DrMundoMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if DrMundoMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 1000) then
	        	CastSkillShot(_Q, closeminion)
                end

                if DrMundoMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 163) then
	        	CastSpell(_W)
	        end

                if DrMundoMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 150) then
	        	CastSpell(_E)
	        end

                if DrMundoMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if DrMundoMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if DrMundoMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 1000) then
		      CastSkillShot(_Q, target)
          end
        end 
        if DrMundoMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 163) then
	  	      CastSpell(_W)
          end
        end
        if DrMundoMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 150) then
		      CastSpell(_E)
	  end
        end
        if DrMundoMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 1000) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if DrMundoMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if DrMundoMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 1000, 0, 200, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("DrMundoempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if DrMundoMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>DrMundo</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





