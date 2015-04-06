



















newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/absorption", name = "absorption", description = "Absorb damage and gain energy." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/projection", name = "projection", description = "Project energy to damage foes." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/psi-fighting", name = "psi-fighting", description = "Wield melee weapons with mentally-manipulated forces." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/focus", name = "focus", description = "Use gems to focus your energies." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/augmented-mobility", generic = true, name = "augmented mobility", description = "Use energy to move yourself and others." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/augmented-striking", name = "augmented striking", description = "Augment melee attacks with psionic enegies." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/voracity", name = "voracity", description = "Pull energy from your surroundings." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/finer-energy-manipulations", generic = true, name = "finer energy manipulations", description = "Subtle applications of the psionic arts." 

newTalentType{ is_mind=true, type="psionic/other", name = "other", description = "Various psionic talents." 



newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/kinetic-mastery", name = "kinetic mastery", min_lev = 10, description = "Mastery of telekinetic forces." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/thermal-mastery", name = "thermal mastery", min_lev = 10, description = "Mastery of pyrokinetic forces." 
newTalentType{ allow_random=true, is_mind=true, autolearn_mindslayer=true, type="psionic/charged-mastery", name = "charged mastery", min_lev = 10, description = "Mastery of electrokinetic forces." 





newTalentType{ allow_random=true, is_mind=true, type="psionic/discharge", name = "discharge", description = "Project feedback on the world around you." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/distortion", name = "distortion", description = "Distort reality with your mental energy." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/dream-forge", generic = true, name = "Dream Forge", description = "Master the dream forge to create powerful armor and effects." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/dream-smith", name = "Dream Smith", description = "Call the dream-forge hammer to smite your foes." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/nightmare", name = "nightmare", description = "Manifest your enemies nightmares." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/psychic-assault", name = "Psychic Assault", description = "Directly attack your opponents minds." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/slumber", name = "slumber", description = "Force enemies into a deep sleep." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/solipsism", name = "solipsism", description = "Nothing exists outside the minds ability to perceive it." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/thought-forms", name = "Thought-Forms", description = "Manifest your thoughts as psionic summons." 


newTalentType{ allow_random=true, is_mind=true, type="psionic/dreaming", generic = true, name = "dreaming", description = "Manipulate the sleep cycles of yourself and your enemies." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/mentalism", generic = true, name = "mentalism", description = "Various mind based effects." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/feedback", generic = true, name = "feedback", description = "Store feedback as you get damaged and use it to protect and heal your body." 
newTalentType{ allow_random=true, is_mind=true, type="psionic/trance", generic = true, name = "trance", description = "Put your mind into a deep trance." 


psi_absorb = {
	stat = { wil=function(level) return 12 + (level-1) * 8 end ,
	level = function(level) return 0 + 5*(level-1)  end

psi_wil_req1 = {
	stat = { wil=function(level) return 12 + (level-1) * 2 end ,
	level = function(level) return 0 + (level-1)  end

psi_wil_req2 = {
	stat = { wil=function(level) return 20 + (level-1) * 2 end ,
	level = function(level) return 4 + (level-1)  end

psi_wil_req3 = {
	stat = { wil=function(level) return 28 + (level-1) * 2 end ,
	level = function(level) return 8 + (level-1)  end

psi_wil_req4 = {
	stat = { wil=function(level) return 36 + (level-1) * 2 end ,
	level = function(level) return 12 + (level-1)  end



psi_wil_high1 = {
	stat = { wil=function(level) return 22 + (level-1) * 2 end ,
	level = function(level) return 10 + (level-1)  end

psi_wil_high2 = {
	stat = { wil=function(level) return 30 + (level-1) * 2 end ,
	level = function(level) return 14 + (level-1)  end

psi_wil_high3 = {
	stat = { wil=function(level) return 38 + (level-1) * 2 end ,
	level = function(level) return 18 + (level-1)  end

psi_wil_high4 = {
	stat = { wil=function(level) return 46 + (level-1) * 2 end ,
	level = function(level) return 22 + (level-1)  end



psi_wil_20_1 = {
	stat = { wil=function(level) return 32 + (level-1) * 2 end ,
	level = function(level) return 20 + (level-1)  end

psi_wil_20_2 = {
	stat = { wil=function(level) return 36 + (level-1) * 2 end ,
	level = function(level) return 24 + (level-1)  end

psi_wil_20_3 = {
	stat = { wil=function(level) return 42 + (level-1) * 2 end ,
	level = function(level) return 28 + (level-1)  end

psi_wil_20_4 = {
	stat = { wil=function(level) return 48 + (level-1) * 2 end ,
	level = function(level) return 32 + (level-1)  end



psi_cun_req1 = {
	stat = { cun=function(level) return 12 + (level-1) * 2 end ,
	level = function(level) return 0 + (level-1)  end

psi_cun_req2 = {
	stat = { cun=function(level) return 20 + (level-1) * 2 end ,
	level = function(level) return 4 + (level-1)  end

psi_cun_req3 = {
	stat = { cun=function(level) return 28 + (level-1) * 2 end ,
	level = function(level) return 8 + (level-1)  end

psi_cun_req4 = {
	stat = { cun=function(level) return 36 + (level-1) * 2 end ,
	level = function(level) return 12 + (level-1)  end




psi_cun_high1 = {
	stat = { cun=function(level) return 22 + (level-1) * 2 end ,
	level = function(level) return 10 + (level-1)  end

psi_cun_high2 = {
	stat = { cun=function(level) return 30 + (level-1) * 2 end ,
	level = function(level) return 14 + (level-1)  end

psi_cun_high3 = {
	stat = { cun=function(level) return 38 + (level-1) * 2 end ,
	level = function(level) return 18 + (level-1)  end

psi_cun_high4 = {
	stat = { cun=function(level) return 46 + (level-1) * 2 end ,
	level = function(level) return 22 + (level-1)  end




function getGemLevel(self)
	local gem_level = 0
	if self:getInven("PSIONIC_FOCUS") then
		local tk_item = self:getInven("PSIONIC_FOCUS")[1]
		if tk_item and ((tk_item.type == "gem") or (tk_item.subtype == "mindstar") or tk_item.combat.is_psionic_focus == true) then
			gem_level = tk_item.material_level or 5
		end
	end
	return gem_level
end


function cancelThoughtForms(self, id)
	local forms = {self.T_TF_DEFENDER, self.T_TF_WARRIOR, self.T_TF_BOWMAN
	for i, t in ipairs(forms) do
		if self:isTalentActive(t) then
			self:forceUseTalent(t, {ignore_energy=true)
		end
		
		if id and id ~= t then
			if self:knowTalent(t) then
				local t = self:getTalentFromId(t)
				self:startTalentCooldown(t)
			end	
		end
	end
end

load("/data/talents/psionic/absorption.lua")
load("/data/talents/psionic/finer-energy-manipulations.lua")

load("/data/talents/psionic/projection.lua")
load("/data/talents/psionic/psi-fighting.lua")
load("/data/talents/psionic/voracity.lua")
load("/data/talents/psionic/augmented-mobility.lua")
load("/data/talents/psionic/augmented-striking.lua")
load("/data/talents/psionic/focus.lua")
load("/data/talents/psionic/other.lua")

load("/data/talents/psionic/kinetic-mastery.lua")
load("/data/talents/psionic/thermal-mastery.lua")
load("/data/talents/psionic/charged-mastery.lua")




load("/data/talents/psionic/discharge.lua")
load("/data/talents/psionic/distortion.lua")
load("/data/talents/psionic/dream-forge.lua")
load("/data/talents/psionic/dream-smith.lua")
load("/data/talents/psionic/dreaming.lua")
load("/data/talents/psionic/mentalism.lua")
load("/data/talents/psionic/feedback.lua")
load("/data/talents/psionic/nightmare.lua")
load("/data/talents/psionic/psychic-assault.lua")
load("/data/talents/psionic/slumber.lua")
load("/data/talents/psionic/solipsism.lua")
load("/data/talents/psionic/thought-forms.lua")

