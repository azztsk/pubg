
LinkLuaModifier( "modifier_ogre_seal_surprise_passive", "modifiers/modifier_ogre_seal_surprise_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hSurpriseSmash = thisEntity:FindAbilityByName( "ogre_seal_surprise_smash" )
	thisEntity.hFlop = thisEntity:FindAbilityByName( "ogreseal_flop" )
	thisEntity.flSearchRadius = 5000
--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_ogre_seal_surprise_passive", {surprise_radius = thisEntity.surprise_radius} )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	thisEntity:SetContextThink( "OgreSealThink", OgreSealThink, 1 )
end

--------------------------------------------------------------------------------

function OgreSealThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local hEnemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),
									thisEntity:GetOrigin(),
									nil,
									5000,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO ,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST,
									false )
	if #hEnemies == 0 then
		return 1
	end


	if thisEntity.hFlop ~= nil and thisEntity.hFlop:IsFullyCastable() then
		return CastBellyFlop( hEnemies[1] )
	end

	thisEntity:MoveToPosition(hEnemies[1]:GetAbsOrigin())

	return 0.5
end

--------------------------------------------------------------------------------

function CastBellyFlop( enemy )
	local position = thisEntity:GetOrigin() + thisEntity:GetForwardVector() * 50
	local positionRandom = position + RandomVector(15)

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hFlop:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 3 
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

