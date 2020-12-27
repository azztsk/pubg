modifier_creature_bonus_chicken = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnCreated( kv )
	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	self.gold_drop = true
	
	if IsServer() then
		self.flAccumDamage = 0
		self.flBonusAcumDamage = 0
		self.nBagsDropped = 0
		self.bTeleporting = false
		self.vCenter = Vector( 2183, -333, 320 )
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter
			})

	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnTakeDamage( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		if (hUnit == self:GetParent()) and (self.gold_drop == true) then		
			local flDamage = params.damage
			if flDamage <= 0 then
				return
			end
			self.flAccumDamage = self.flAccumDamage + flDamage
			self.flBonusAcumDamage = self.flBonusAcumDamage + flDamage			
			if self.flAccumDamage >= 50 then
				local newItem = CreateItem( "item_bag_of_gold", nil, nil )
				local nGoldAmount = 10
				if self:GetParent():GetUnitName() == "npc_dota_creature_bonus_chicken2" then
					nGoldAmount = 8
				end

				
				newItem:SetPurchaseTime( 0 )
				newItem:SetCurrentCharges( nGoldAmount )
					
				local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
				local dropTarget = hUnit:GetAbsOrigin() + RandomVector( RandomFloat( 100, 350 ) )
				newItem:LaunchLoot( true, 300, 0.75, dropTarget )

				self.flAccumDamage = self.flAccumDamage - 50
				self.nBagsDropped = self.nBagsDropped + 1
				self.total_gold = self.total_gold - 10
				if self.total_gold <= 0 then
					self.gold_drop = false
				end
			end
			if self.flBonusAcumDamage >= 1500 then
				local newItem = CreateItem( "item_bonus_health1", nil, nil )
			
					
				local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
				local dropTarget = hUnit:GetAbsOrigin() + RandomVector( RandomFloat( 100, 350 ) )
				newItem:LaunchLoot( true, 300, 0.75, dropTarget )

				self.flBonusAcumDamage = self.flBonusAcumDamage - 1500

			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}

	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end