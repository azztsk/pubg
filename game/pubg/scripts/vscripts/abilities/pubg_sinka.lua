LinkLuaModifier("modifier_pubg_sinka", "abilities/pubg_sinka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pubg_sinka_aura", "abilities/pubg_sinka", LUA_MODIFIER_MOTION_NONE)

pubg_sinka = class({})
function pubg_sinka:GetIntrinsicModifierName()
	return "modifier_pubg_sinka"
end

pubg_sinka1 = class(pubg_sinka)

modifier_pubg_sinka = class({
	IsAura = function(self) return true end,
	GetAuraDuration = function(self) return 2 end,
	GetModifierAura = function(self) return "modifier_pubg_sinka_aura" end,
	GetAuraSearchFlags = function(self) return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end,
	GetAuraSearchTeam = function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchType = function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	GetAuraRadius = function(self) return self.sinka_radius or 0 end,
})

function modifier_pubg_sinka:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local ability = self:GetAbility()
		local sinka_interval = ability:GetSpecialValueFor("sinka_interval")
		local sinka_speed = ability:GetSpecialValueFor("sinka_speed")
		self.sinka_radius = ability:GetSpecialValueFor("sinka_radius")

		local effect = "particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf"
		self.sinka_pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.sinka_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(self.sinka_pfx, 1, Vector(4000,self.sinka_radius, 1))

		self:StartIntervalThink(sinka_interval)
	end
end

function modifier_pubg_sinka:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local sinka_speed = ability:GetSpecialValueFor("sinka_speed")
	local radius_per_tick = ability:GetSpecialValueFor("radius_per_tick")


	self.sinka_radius = self.sinka_radius - radius_per_tick
	if self.sinka_radius <= 0 then
		self:StartIntervalThink(-1)
		ParticleManager:DestroyParticle(self.sinka_pfx, true)
		ParticleManager:ReleaseParticleIndex(self.sinka_pfx)
	end

	ParticleManager:SetParticleControl(self.sinka_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(self.sinka_pfx, 1, Vector(sinka_speed, self.sinka_radius, 1))
end

modifier_pubg_sinka_aura = class({
	IsHidden = function(self) return true end,
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}end,
})

function modifier_pubg_sinka_aura:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("regen")
end
