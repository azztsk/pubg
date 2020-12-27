
round = 0

if main_mode == nil then
	main_mode = class({})
end

function main_mode:InitGameMode()
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(main_mode, 'OnGameRulesStateChange'), self)
	--Say(nil,"DAROU ! ", false)
	Convars:SetBool("sv_cheats", true)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(main_mode,"OnPlayerPickHero"), main_mode)
	ListenToGameEvent("player_disconnect", Dynamic_Wrap(main_mode, "OnDisconnect"), main_mode)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(main_mode, "OnReconnect"), main_mode)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(main_mode, "OnNPCSpawned"), main_mode)

	CustomGameEventManager:RegisterListener('On_Difficult_Chosen',Dynamic_Wrap(main_mode , 'On_Difficult_Chosen'))

end

function main_mode:OnGameRulesStateChange()
	local newState = GameRules:State_Get()

	if newState  == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if GameRules.mode == 1 then
			for i = 0, DOTA_MAX_PLAYERS-1 do
				local hPlayer = PlayerResource:GetPlayer(i)
				if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
					hPlayer:MakeRandomHeroSelection()
--					name = PlayerResource:GetSelectedHeroEntity(i):GetUnitName()
				end
			end

		elseif GameRules.mode == 3 then 
			for i = 0, DOTA_MAX_PLAYERS-1 do
				local hPlayer = PlayerResource:GetPlayer(i)
				--GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_pudge")
				if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
					--hPlayer:MakeRandomHeroSelection()
					--local newHero = PlayerResource:ReplaceHeroWith(i,"npc_dota_hero_nevermore",0,0)			--ReplaceHeroWith()

--					name = PlayerResource:GetSelectedHeroEntity(i):GetUnitName()
				end
			end		
			
		end
	end

	if newState  == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		for i = 0, 9 do
			local hPlayer = PlayerResource:GetPlayer(i)
			if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
				hPlayer:MakeRandomHeroSelection()
				--name = PlayerResource:GetSelectedHeroEntity(i):GetUnitName()
			end
		end
	end
	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
		if GetMapName() == "dota_zombie_survival" then
					main_mode:WdSpawner1()
			else	main_mode:WdSpawner()
		end			
	
		--main_mode:WdSound()
		--main_mode:ZombieSpawner()
		--Say(nil,"DAROU ! ", false)
	end


	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for i = 0, 9 do
			if ( PlayerResource:IsValidPlayer(i) ) then
				local player = PlayerResource:GetPlayer(i)
				if player ~= nil then
					local h = player:GetAssignedHero()
					if h~= nil then
						h:RemoveModifierByName("modifier_tutorial_sleep")
					end
				end
			end
		end
		EmitGlobalSound("narod_pognali")
		
		if GetMapName() ~= "dota_zombie_survival" then
			main_mode:BoxSpawner()
		end			

		if GetMapName() == "dota_zombie_night" then			
			main_mode:SetSameTeam()
			main_mode:ZombieSpawner()
			main_mode:SetSameTeam1()
			main_mode:ZombieSpawner1()
		end
		if GetMapName() == "dota_zombie_survival" then			
			main_mode:ZombieSurival()
			ListenToGameEvent( "entity_killed", Dynamic_Wrap( main_mode, 'OnEntityKilled' ), self )
		end
		
		if (GetMapName() ~= "dota_zombie_night") and (GetMapName() ~= "dota_zombie_survival") then			
			main_mode:BossSpawn()
		end
		
	end
	
end 


function main_mode:WdSound()
	local return_time = 7.9
	Timers:CreateTimer(0, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
		EmitGlobalSound("wd_dance")
          return return_time  -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)		
end	

function main_mode:BoxSpawner()
     local return_time = 300 -- Записываем в переменную значение '10'
	Timers:CreateTimer(4, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
		EmitGlobalSound("pubg.drop_box")
 		GameRules:SendCustomMessage("#Game_notification_drop_box1",0,0)		 
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)		
	Timers:CreateTimer(10, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
       
		EmitGlobalSound("Hero_Gyrocopter.CallDown.Fire")
 		GameRules:SendCustomMessage("#Game_notification_drop_box2",0,0)		 
        
         for i=1, 8 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
            --if RandomInt(1,100) < 101 then 
				local point = Entities:FindByName( nil, "chest_spawner"..i):GetAbsOrigin() 
				  if RandomInt(1,100) < 56 then 		unit = CreateUnitByName( "npc_dota_chest1", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				  elseif RandomInt(1,100) < 67 then 	unit = CreateUnitByName( "npc_dota_chest2", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
						--Say(nil,"DAROU222 ! ", false)
				  elseif i > 1 then						unit = CreateUnitByName( "npc_dota_chest3", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
						--Say(nil,"DAROU333 ! ", false)

				  end
			--end
 	--Say(nil,"DAROU000 ! ", false)
       end
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)

	Timers:CreateTimer(304, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
		EmitGlobalSound("pubg.drop_box")
 		GameRules:SendCustomMessage("#Game_notification_drop_box1",0,0)		 
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)		
	Timers:CreateTimer(310, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
       
		EmitGlobalSound("Hero_Gyrocopter.CallDown.Fire")
 		GameRules:SendCustomMessage("#Game_notification_drop_box2",0,0)		 
        
         for i=1, 8 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
            --if RandomInt(1,100) < 101 then 
				local point = Entities:FindByName( nil, "chest_spawner"..i):GetAbsOrigin() 
				  if RandomInt(1,100) < 51 then 		unit = CreateUnitByName( "npc_dota_chest2", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				  elseif RandomInt(1,100) < 67 then 	unit = CreateUnitByName( "npc_dota_chest3", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				  elseif RandomInt(1,100) < 101 then 	unit = CreateUnitByName( "npc_dota_chest4", point , true, nil, nil, DOTA_TEAM_NEUTRALS )

				  end
			--end
 	--Say(nil,"DAROU000 ! ", false)
       end
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)

	Timers:CreateTimer(614, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
		EmitGlobalSound("pubg.drop_box")
 		GameRules:SendCustomMessage("#Game_notification_drop_box1",0,0)		 
           -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)		
	Timers:CreateTimer(620, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
       
		EmitGlobalSound("Hero_Gyrocopter.CallDown.Fire")
 		GameRules:SendCustomMessage("#Game_notification_drop_box2",0,0)		 
        
         for i=1, 8 do -- Произведет нижние действия столько раз, сколько указано в ROUND_UNITS. То есть в нашем случае создаст 2 юнита.
            --if RandomInt(1,100) < 101 then 
				local point = Entities:FindByName( nil, "chest_spawner"..i):GetAbsOrigin() 
				  if RandomInt(1,100) < 61 then 		unit = CreateUnitByName( "npc_dota_chest3", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				  elseif RandomInt(1,100) < 101 then 	unit = CreateUnitByName( "npc_dota_chest4", point , true, nil, nil, DOTA_TEAM_NEUTRALS )

				  end
			--end
 	--Say(nil,"DAROU000 ! ", false)
       end
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)	
end

function main_mode:ZombieSpawner()
    local return_time = 360 -- Записываем в переменную значение '10'
	local count_mini_z = 240
	local count_big_z = 12
	local count_boss_z = 0
	local waypoint = Entities:FindByName( nil, "wd_spawner")
	Timers:CreateTimer(240, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
       
		EmitGlobalSound("ResidentEvil")
 		GameRules:SendCustomMessage("#Game_notification_zombie_spawn",0,0)		 
        
		for i=1 , count_mini_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			Timers:CreateTimer(i*1, function()
				local  	unit = CreateUnitByName( "npc_dota_zombie1", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
			end)
		end
				 
		for i=1 , count_big_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			Timers:CreateTimer(i*15, function()
				local  	unit = CreateUnitByName( "npc_dota_zombie2", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
			end)
		end
				 
		for i=1 , count_boss_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			Timers:CreateTimer(i*120, function()
				local  	unit = CreateUnitByName( "npc_dota_zombie3", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
			end)
		end
				 
			
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)
	
end

function main_mode:ZombieSpawner1()
    local return_time = 360 -- Записываем в переменную значение '10'
	local count_mini_z = 480
	local count_big_z = 30
	local count_boss_z = 1
	local waypoint = Entities:FindByName( nil, "wd_spawner")
	Timers:CreateTimer(720, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
       
		EmitGlobalSound("ResidentEvil")
 		GameRules:SendCustomMessage("#Game_notification_zombie_spawn",0,0)		 
        
		for i=1 , count_mini_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			Timers:CreateTimer(i*0.5, function()
				local  	unit = CreateUnitByName( "npc_dota_zombie1", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
			end)
		end
				 
		for i=1 , count_big_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			Timers:CreateTimer(i*8, function()
				local  	unit = CreateUnitByName( "npc_dota_zombie2", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
			end)
		end
				 
		for i=1 , count_boss_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			Timers:CreateTimer(i*120, function()
				local  	unit = CreateUnitByName( "npc_dota_zombie3", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
				unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
			end)
		end
				 
			
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)
	
end
function main_mode:SetSameTeam()
	local team = DOTA_TEAM_GOODGUYS
Timers:CreateTimer(240, function()
	GameRules:SetCustomGameTeamMaxPlayers( team, PlayerResource:GetPlayerCount() )
	
	Timers:CreateTimer(240, function()
		local allCreatures = Entities:FindAllByClassname('npc_dota_creature')
		for i = 1, #allCreatures, 1 do
			local creature = allCreatures[i]
			creature:AddNewModifier(creature, nil, "modifier_invisible", {duration = 0.1})
		end
	end)
	for i=0,9 do
		if PlayerResource:IsValidPlayer(i) then
			local hero = PlayerResource:GetSelectedHeroEntity(i)
			local main_team = PlayerResource:GetTeam(i)
			hero:SetTeam(team)
			PlayerResource:SetCustomTeamAssignment(i,team)
			Timers:CreateTimer(240, function()
				hero:AddNewModifier(hero, nil, "modifier_invisible", {duration = 0.1})
				hero:SetTeam(main_team)
				PlayerResource:SetCustomTeamAssignment(i,main_team)
			end)
		end
	end
end)
	GameRules:SetCustomGameTeamMaxPlayers( team, 0 )

end

function main_mode:SetSameTeam1()
	local team = DOTA_TEAM_GOODGUYS
Timers:CreateTimer(720, function()
	GameRules:SetCustomGameTeamMaxPlayers( team, PlayerResource:GetPlayerCount() )
	for i=0,9 do
		if PlayerResource:IsValidPlayer(i) then
			local hero = PlayerResource:GetSelectedHeroEntity(i)
			local main_team = PlayerResource:GetTeam(i)
			hero:SetTeam(team)
			PlayerResource:SetCustomTeamAssignment(i,team)
			Timers:CreateTimer(240, function()
				hero:AddNewModifier(hero, nil, "modifier_invisible", {duration = 0.1})
				hero:SetTeam(main_team)
				PlayerResource:SetCustomTeamAssignment(i,main_team)
			end)
		end
	end
end)
	GameRules:SetCustomGameTeamMaxPlayers( team, 0 )


end

function main_mode:BossSpawn()
	
 	Timers:CreateTimer(360, function()
		GameRules:SendCustomMessage("#Game_notification_boss_spawn",0,0)		 
		local unit = nil
		local int = RandomInt(1,3)
		local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
		if int == 1 then 
			unit = CreateUnitByName( "npc_dota_creature_ogre_tank", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
		elseif int == 2 then 
			unit = CreateUnitByName( "npc_dota_creature_ogre_tank_boss", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
		elseif int == 3 then 
			unit = CreateUnitByName( "npc_dota_creature_ogre_seal", point , true, nil, nil, DOTA_TEAM_NEUTRALS )
		end	
--		unit:SetMaxHealth(unit:GetMaxHealth()+ 1000*PlayerResource:GetPlayerCount() )
--		unit:SetHealth(unit:GetMaxHealth())
--		return 10
	end)						 	
end


function main_mode:WdSpawner()
	
	local 	point = Entities:FindByName( nil, "wd_spawner"):GetAbsOrigin() 
	local  	unit = CreateUnitByName( "npc_dota_wd", point , true, nil, nil, DOTA_TEAM_NEUTRALS )		
						 	
end

function main_mode:WdSpawner1()
	
	local 	point = Entities:FindByName( nil, "wd_spawner"):GetAbsOrigin() 
	local  	unit = CreateUnitByName( "npc_dota_wd1", point , true, nil, nil, DOTA_TEAM_BADGUYS )		
						 	
end

function main_mode:ZombieSurival()

	local player_count = PlayerResource:GetPlayerCount()
	 count_creeps = 0
	 count_kills = 0
	 round = round + 1
	 count_mini_z = 0
	 count_big_z = 0
	 count_boss_z = 0
	 waypoint = Entities:FindByName( nil, "wd_spawner")
	Timers:CreateTimer(1, function()  -- Создаем таймер, который запустится через 15 секунд после начала матча и запустит следующую функцию
       
		count_mini_z = math.floor(round * 5 * player_count)
		count_big_z = math.floor(round * 0.5 * player_count)
		count_boss_z = math.floor(round * 0.1 )      
		count_creeps = count_mini_z + count_big_z + count_boss_z

		EmitGlobalSound("ResidentEvil")
 		GameRules:SendCustomMessage("#Game_notification_zombie_spawn1",0,0)		 
 		GameRules:SendCustomMessage("ROUND №"..round,0,0)
 --		GameRules:SendCustomMessage("count zombie1 ="..count_mini_z,0,0)
 --		GameRules:SendCustomMessage("count zombie2 ="..count_big_z,0,0)
 --		GameRules:SendCustomMessage("count zombie3 ="..count_boss_z,0,0)
		

		 for i=1 , count_mini_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			local  	unit = CreateUnitByName( "npc_dota_zombie01", point , true, nil, nil, DOTA_TEAM_BADGUYS )
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
		end
				 
		for i=1 , count_big_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			local  	unit = CreateUnitByName( "npc_dota_zombie02", point , true, nil, nil, DOTA_TEAM_BADGUYS )
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
		end
				 
		for i=1 , count_boss_z do				

			local 	point = Entities:FindByName( nil, "zombie_spawner"..RandomInt(1,18)):GetAbsOrigin() 
			local  	unit = CreateUnitByName( "npc_dota_zombie03", point , true, nil, nil, DOTA_TEAM_BADGUYS )
			unit:SetInitialGoalEntity( waypoint ) -- Посылаем мобов на наш way1, координаты которого мы записали в переменную 'waypoint'			
			
		end
				 
			
            -- Возвращаем таймеру время, через которое он должен снова сработать. Когда пройдет последний раунд таймер получит значение 'nil' и выключится.
    end)
	
end

function main_mode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0

	if killedTeam == DOTA_TEAM_BADGUYS then
		count_kills = count_kills+1
		if count_kills == count_creeps then
			main_mode:ZombieSurival()
		end
	end
	
end

function Respoint (keys )
	Timers:CreateTimer(0.1,function()	          

		local caster = keys.caster 	--пробиваем IP усопшего
		caster.respoint = caster:GetAbsOrigin() -- определяем точку спавна
	end)
end

function Respawn (keys )
	local caster= keys.caster                --пробиваем IP усопшего
	local point = caster.respoint			-- пробиваем адрес дома
	local team= caster:GetTeamNumber()      --пробиваем команду терпилы
	local name= caster:GetUnitName()         --Пробиваем имя покойного
	Timers:CreateTimer(5,function()	          --Через сколько секунд появится новый фраер(5)
	local unit = CreateUnitByName(name, point + RandomVector( RandomFloat( 0, 50)), true, nil, nil, team) 
-- создаем нового пацыка по трем аргументам ( имя покойного ,адрес дома ,true,nil,nil,команда терпилы)
	end)
end

function main_mode:OnNPCSpawned(keys)
-- DebugPrint("[BAREBONES] NPC Spawned")
 --DebugPrintTable(keys)
 local npc = EntIndexToHScript(keys.entindex)
	if npc:IsRealHero() then
		for i = 0, 9 do
			local ability = npc:GetAbilityByIndex( i )
			if ability and ability ~= keys.ability then
				ability:SetLevel(1)
			end
		end

	end
	
	if npc:GetUnitName() == "npc_dota_hero_invoker" then
		local ability = npc:FindAbilityByName("special_bonus_unique_invoker_4")
		ability:SetLevel(1)
		local ability = npc:FindAbilityByName("holy_shield")
		ability:SetLevel(1)
		
	end			
end

function main_mode:OnPlayerPickHero(keys)
 	local newState = GameRules:State_Get()
	local hero = EntIndexToHScript(keys.heroindex)
	if newState == DOTA_GAMERULES_STATE_PRE_GAME  then
		hero:AddNewModifier(hero, nil, "modifier_tutorial_sleep", nil)
	end
--	hero:RemoveItem(hero:GetItemInSlot(0))
--	hero:RemoveItem(hero:GetItemInSlot(1))
	
end

function main_mode:OnDisconnect(keys)
	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	hero:RespawnHero(false,false)
	hero:AddNewModifier(hero, nil, "modifier_tutorial_sleep", nil)
	hero:AddNewModifier(hero, nil, "modifier_invulnerable", nil)
--	hero:AddNewModifier(hero, nil, "modifier_rune_invis", nil)
 
end

 function main_mode:OnReconnect(keys)
	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	hero:RemoveModifierByName("modifier_invulnerable")
	hero:RemoveModifierByName("modifier_tutorial_sleep")
--	hero:AddNewModifier(hero, nil, "modifier_rune_invis", {duration = 0.00})
 	
 end
 
 function main_mode:On_Difficult_Chosen( event )
    local difficulty = event.difficulty

	    GameRules.mode = difficulty

	if GameRules.mode == 2 then 
		local GM = GameRules:GetGameModeEntity()
		GM:SetCustomGameForceHero("npc_dota_hero_pudge")
		GameRules:SetHeroSelectionTime(0)
		GameRules:SetStrategyTime(0)
		GameRules:SetShowcaseTime(0)
	end

	if GameRules.mode == 3 then 
		local GM = GameRules:GetGameModeEntity()
		GM:SetCustomGameForceHero("npc_dota_hero_nevermore")
		GameRules:SetHeroSelectionTime(0)
		GameRules:SetStrategyTime(0)
		GameRules:SetShowcaseTime(0)
	end

	if GameRules.mode == 4 then 
		local GM = GameRules:GetGameModeEntity()
		GM:SetCustomGameForceHero("npc_dota_hero_invoker")
		GameRules:SetHeroSelectionTime(0)
		GameRules:SetStrategyTime(0)
		GameRules:SetShowcaseTime(0)
	end

	if GameRules.mode == 5 then 
		local GM = GameRules:GetGameModeEntity()
		GM:SetCustomGameForceHero("npc_dota_hero_mirana")
		GameRules:SetHeroSelectionTime(0)
		GameRules:SetStrategyTime(0)
		GameRules:SetShowcaseTime(0)
	end

	if GameRules.mode == 6 then 
		local GM = GameRules:GetGameModeEntity()
		GM:SetCustomGameForceHero("npc_dota_hero_monkey_king")
		GameRules:SetHeroSelectionTime(0)
		GameRules:SetStrategyTime(0)
		GameRules:SetShowcaseTime(0)
	end
	
end


