--[[

	The MIT License (MIT)

	Copyright (c) 2021 Lars Norberg

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

--]]
local ADDON = ...

local Unmasked = _G.UnmaskedActionButton
if (not Unmasked) then
	return
end

-- WoW API
local InCombatLockdown = InCombatLockdown
local UnitAura = UnitAura

local auras = {

	-- Blingtron
	[134522] = true, 	-- Dressed to Kill (Male?)
	[222256] = true, 	-- Dressed to Kill (Female?)

	-- Hallow's End Costumes
	[172010] = true, 	-- Abomination Costume
	[218132] = true, 	-- Banshee Costume
	[ 24732] = true, 	-- Bat Costume
	[191703] = true, 	-- Bat Costume
	[285521] = true, 	-- Blue Dragon Body Costume
	[285519] = true, 	-- Blue Dragon Head Costume
	[285523] = true, 	-- Blue Dragon Tail Costume
	[ 97135] = true, 	-- Children's Costume Aura
	[257204] = true, 	-- Dirty Horse Costume
	[257205] = true, 	-- Dirty Horse Costume
	[191194] = true, 	-- Exquisite Deathwing Costume
	[192472] = true, 	-- Exquisite Deathwing Costume
	[217917] = true, 	-- Exquisite Grommash Costume
	[171958] = true, 	-- Exquisite Lich King Costume
	[190837] = true, 	-- Exquisite VanCleef Costume
	[246237] = true, 	-- Exquisite Xavius Costume
	[191210] = true, 	-- Gargoyle Costume
	[172015] = true, 	-- Geist Costume
	[ 24735] = true, 	-- Ghost Costume
	[ 24736] = true, 	-- Ghost Costume
	[191700] = true, 	-- Ghost Costume
	[191698] = true, 	-- Ghost Costume
	[172008] = true, 	-- Ghoul Costume
	[190826] = true, 	-- Gnoll Costume (17th Anniversary)
	[190824] = true, 	-- Murloc Costume (17th Anniversary)
	[243319] = true, 	-- Quilboar Costume (17th Anniversary)
	[243317] = true, 	-- Trogg Costume (17th Anniversary)
	[285522] = true, 	-- Green Dragon Body Costume
	[285520] = true, 	-- Green Dragon Head Costume
	[285524] = true, 	-- Green Dragon Tail Costume
	[246242] = true, 	-- Horse Head Costume
	[246241] = true, 	-- Horse Tail Costume
	[ 44212] = true, 	-- Jack-o'-Lanterned!
	[177656] = true, 	-- Kor'kron Foot Soldier Costume
	[177657] = true, 	-- Kor'kron Foot Soldier Costume
	[ 24712] = true, 	-- Leper Gnome Costume
	[ 24713] = true, 	-- Leper Gnome Costume
	[191701] = true, 	-- Leper Gnome Costume
	[171479] = true, 	-- "Lil' Starlet" Costume
	[171470] = true, 	-- "Mad Alchemist" Costume
	[191211] = true, 	-- Nerubian Costume
	[ 24710] = true, 	-- Ninja Costume
	[ 24711] = true, 	-- Ninja Costume
	[191686] = true, 	-- Ninja Costume
	[334407] = true, 	-- Noble Bearing (The Harvest - Revendreth Treasure)
	[ 24708] = true, 	-- Pirate Costume
	[173958] = true, 	-- Pirate Costume
	[173959] = true, 	-- Pirate Costume
	[191682] = true, 	-- Pirate Costume
	[191683] = true, 	-- Pirate Costume
	[ 61716] = true, 	-- Rabbit Costume
	[233598] = true, 	-- Red Dragon Body Costume
	[233594] = true, 	-- Red Dragon Head Costume
	[233599] = true, 	-- Red Dragon Tail Costume
	[ 30167] = true, 	-- Red Ogre Costume
	[102362] = true, 	-- Red Ogre Mage Costume
	[ 24723] = true, 	-- Skeleton Costume
	[191702] = true, 	-- Skeleton Costume
	[172003] = true, 	-- Slime Costume
	[172020] = true, 	-- Spider Costume
	[ 99976] = true, 	-- Squashling Costume
	[243321] = true, 	-- Tranquil Mechanical Yeti Costume
	[178306] = true, 	-- Warsong Orc Costume
	[178307] = true, 	-- Warsong Orc Costume
	[191208] = true, 	-- Wight Costume
	[ 24740] = true, 	-- Wisp Costume
	[279509] = true, 	-- Witch!
	[171930] = true, 	-- "Yipp-Saron" Costume

	--[   768] = true 	-- Cat Form (DEVELOPMENT PURPOSES ONLY!)
}

-- Return a value rounded to the nearest integer.
local math_round = function(value, precision)
	if (precision) then
		value = value * 10^precision
		value = (value + .5) - (value + .5)%1
		value = value / 10^precision
		return value
	else 
		return (value + .5) - (value + .5)%1
	end 
end

-- Convert a coordinate within a frame to a usable position
local parse = function(parentWidth, parentHeight, x, y, bottomOffset, leftOffset, topOffset, rightOffset)
	if (y < parentHeight * 1/3) then 
		if (x < parentWidth * 1/3) then 
			return "BOTTOMLEFT", leftOffset, bottomOffset
		elseif (x > parentWidth * 2/3) then 
			return "BOTTOMRIGHT", rightOffset, bottomOffset
		else 
			return "BOTTOM", x - parentWidth/2, bottomOffset
		end 
	elseif (y > parentHeight * 2/3) then 
		if (x < parentWidth * 1/3) then 
			return "TOPLEFT", leftOffset, topOffset
		elseif x > parentWidth * 2/3 then 
			return "TOPRIGHT", rightOffset, topOffset
		else 
			return "TOP", x - parentWidth/2, topOffset
		end 
	else 
		if (x < parentWidth * 1/3) then 
			return "LEFT", leftOffset, y - parentHeight/2
		elseif (x > parentWidth * 2/3) then 
			return "RIGHT", rightOffset, y - parentHeight/2
		else 
			return "CENTER", x - parentWidth/2, y - parentHeight/2
		end 
	end 
end

-- Needed for position parsing. Can probably simplify a bit.
local getParsedPosition = function(self)

	-- Retrieve UI coordinates
	local uiScale = UIParent:GetEffectiveScale()
	local uiWidth, uiHeight = UIParent:GetSize()
	local uiBottom = UIParent:GetBottom()
	local uiLeft = UIParent:GetLeft()
	local uiTop = UIParent:GetTop()
	local uiRight = UIParent:GetRight()

	local worldWidth = math_round(WorldFrame:GetWidth())
	local worldHeight = math_round(WorldFrame:GetHeight()) -- this is 768, always. why not just assume?

	-- Turn UI coordinates into unscaled screen coordinates
	uiWidth = uiWidth*uiScale
	uiHeight = uiHeight*uiScale
	uiBottom = uiBottom*uiScale
	uiLeft = uiLeft*uiScale
	uiTop = uiTop*uiScale - worldHeight -- use values relative to edges, not origin
	uiRight = uiRight*uiScale - worldWidth -- use values relative to edges, not origin

	-- Retrieve frame coordinates
	local frameScale = self:GetEffectiveScale()
	local x, y = self:GetCenter()
	local bottom = self:GetBottom()
	local left = self:GetLeft()
	local top = self:GetTop()
	local right = self:GetRight()

	-- Turn frame coordinates into unscaled screen coordinates
	x = x*frameScale
	y = y*frameScale
	bottom = bottom*frameScale
	left = left*frameScale
	top = top*frameScale - worldHeight -- use values relative to edges, not origin
	right = right*frameScale - worldWidth -- use values relative to edges, not origin

	-- Figure out the frame position relative to the UI master frame
	left = left - uiLeft
	bottom = bottom - uiBottom
	right = right - uiRight
	top = top - uiTop

	-- Figure out the point within the given coordinate space
	local point, offsetX, offsetY = parse(uiWidth, uiHeight, x, y, bottom, left, top, right)

	-- Convert coordinates to the frame's scale. 
	return point, offsetX/frameScale, offsetY/frameScale
end

Unmasked.GetParsedPosition = getParsedPosition
Unmasked:SetScript("OnHide", function(self) self.macro = nil end) -- trigger a re-iteration on next show
Unmasked:SetScript("OnEvent", function(self, event, ...) 

	if (event == "ADDON_LOADED") then
		local addon = ...;
		if (addon == "Unmasked") then
			local db = Unmasked_DB
			if (db) and (db.point) and (db.offsetX) and (db.offsetX) then
				self:ClearAllPoints()
				self:SetPoint(db.point, db.offsetX, db.offsetY)
			end
			self:UnregisterEvent("ADDON_LOADED")
		else
			return
		end
	end

	if (InCombatLockdown()) then
		return self:RegisterEvent("PLAYER_REGEN_ENABLED")
	elseif (event == "PLAYER_REGEN_ENABLED") then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
	local macro

	-- Iterate current auras
	local index = 1
	local name, _, _, _, _, _, _, _, _, spellID = UnitAura("player", index, "HELPFUL")
	while (spellID) do
		if (auras[spellID]) then
			if (macro) then
				macro = macro .."\n".."/cancelaura "..name
			else
				macro = "/cancelaura "..name
			end
		end
		index = index + 1
		name, _, _, _, _, _, _, _, _, spellID = UnitAura("player", index, "HELPFUL")
	end

	if (macro) then
		if (macro ~= self.macro) then
			self.macro = macro
			self:SetAttribute("macrotext", macro)
			self:Show()
		end
	elseif (self.macro) then
		self.macro = nil
		self:SetAttribute("macrotext")
		self:Hide()
	end

end)

-- Clear the macro and hide the button securely on clicks.
SecureHandlerWrapScript(Unmasked, "PostClick", Unmasked, [[ self:Hide(); self:SetAttribute("macrotext", nil); ]])

Unmasked.bg = Unmasked:CreateTexture()
Unmasked.bg:SetAllPoints()
Unmasked.bg:SetTexture([[Interface\AddOns\]]..ADDON..[[\icons-raid-targets.tga]])
Unmasked.bg:SetTexCoord(2/4, 3/4, 1/4, 2/4)