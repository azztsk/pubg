


function SetRadius( event )
	-- Variables


	-- Store current Health/Mana to detect gained value
	local caster = 			event.caster
--	caster.radius = 	ability:GetTalentSpecialValueFor("sinka_radius")
	caster.radius = 	1250
	-- Store the ally unit
	Say(nil,"radius =" .. caster.radius, false)

end

--[[
	Author: Ractidous
	Date: 04.02.2015.
	Check for tether break distance.
]]
function CheckDistance( event )
	local caster = event.caster
	local ability = event.ability
--	local tick_radius = 	ability:GetTalentSpecialValueFor("radius_per_tick")

--[[	-- Now on latching, so we don't need to break tether.
	local allies = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, caster:GetOrigin(), caster, caster.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO  , DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			ability:ApplyDataDrivenModifier( caster, ally, "modifier_pubg_sinka_regen", { duration = ability:GetSpecialValueFor( "tick" ) } )
		end
	end
]]
	local caster_loc =  caster:GetAbsOrigin()
	Say(nil,"radius =" .. caster.radius, false)

	if caster.blast_pfx ~= nil then ParticleManager:DestroyParticle(caster.blast_pfx,false) end
	caster.blast_pfx = ParticleManager:CreateParticle("particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(caster.blast_pfx)
	ParticleManager:SetParticleControl(caster.blast_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(caster.blast_pfx, 1, Vector(250, caster.radius, 1))
	ParticleManager:ReleaseParticleIndex(caster.blast_pfx)
	--ParticleManager:DestroyParticle(caster.blast_pfx,true)

	caster.radius = caster.radius - 250

end

function EffectOn( keys)

	local caster = keys.caster
	local caster_loc =  caster:GetAbsOrigin()

	local blast_pfx = ParticleManager:CreateParticle("particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(blast_pfx)
	ParticleManager:SetParticleControl(blast_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(250, 1000, 1))
	ParticleManager:ReleaseParticleIndex(blast_pfx)
	--ParticleManager:DestroyParticle(blast_pfx,true)
	
end