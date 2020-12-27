



function SetColor(data)

	local moob = data.caster
	local name = moob:GetUnitName()
	
	local a = 0
	local b = 191
	local c = 255

	if name == "npc_dota_chest1" then
		a = 218
		b = 165
		c = 32
	end

	if name == "npc_dota_chest2" then
		a = 173
		b = 255
		c = 47
	end

	if name == "npc_dota_chest3" then
		a = 0
		b = 0
		c = 0
	end	

	if name == "npc_dota_chest4" then
		a = 255
		b = 0
		c = 0
	end	
	


	if name == "npc_candy" then
		team = DOTA_TEAM_GOODGUYS
	end

--	GameRules:GetGameModeEntity():SetContextThink(string.format("RespawnThink_%d",moob:GetEntityIndex()), 
--		function()
		moob:SetRenderColor(a, b, c)
--		end,
--		data.Time)		

end


