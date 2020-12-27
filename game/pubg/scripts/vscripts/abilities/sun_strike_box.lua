function CreateTreasureSunStrikeTrap( keys )
	--print( "[treasure_chest_surprises] CreateSunStrikeTrap()" )
	local hTreasureEnt = keys.caster
	local hSunStrikeAbility = hTreasureEnt:FindAbilityByName( "trap_sun_strike" )

	if hSunStrikeAbility == nil then
		print( string.format( "CDungeon:OnTreasureOpen - ERROR: %s is missing required ability", hTreasureEnt:GetUnitName() ) )
		return
	end
	EmitGlobalSound("Surprise")
	
	local hEnemies = FindUnitsInRadius( hTreasureEnt:GetTeamNumber(), hTreasureEnt:GetOrigin(), hTreasureEnt, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsRealHero() then
			local kv = 
			{
				duration = hSunStrikeAbility:GetSpecialValueFor( "delay" ),
				area_of_effect = hSunStrikeAbility:GetSpecialValueFor( "area_of_effect" ),
				vision_distance = hSunStrikeAbility:GetSpecialValueFor( "vision_distance" ),
			 	vision_duration = hSunStrikeAbility:GetSpecialValueFor( "vision_duration" ),
				damage = hSunStrikeAbility:GetSpecialValueFor( "damage" ),
			}

			local vTarget = hEnemy:GetOrigin() -- + hEnemy:GetForwardVector() * 100
			local vTarget1 = hEnemy:GetOrigin()  + hEnemy:GetForwardVector() * 50

			CreateModifierThinker( hTreasureEnt, hSunStrikeAbility, "modifier_invoker_sun_strike", kv, vTarget, hTreasureEnt:GetTeamNumber(), false )

			EmitSoundOnLocationForAllies( vTarget, "Hero_Invoker.SunStrike.Charge", hEnemy )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vTarget )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			
			CreateModifierThinker( hTreasureEnt, hSunStrikeAbility, "modifier_invoker_sun_strike", kv, vTarget1, hTreasureEnt:GetTeamNumber(), false )

			EmitSoundOnLocationForAllies( vTarget1, "Hero_Invoker.SunStrike.Charge", hEnemy )

			local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vTarget1 )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end


--[[	local gameEvent = {}
	gameEvent["player_id"] = hPlayerHero:GetPlayerID()
	gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
	gameEvent["locstring_value"] = "trap_sun_strike"
	gameEvent["message"] = "#Dungeon_FoundChestTrap"
	FireGameEvent( "dota_combat_event_message", gameEvent )
]]
end