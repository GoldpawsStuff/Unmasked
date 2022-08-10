--[[

	The MIT License (MIT)

	Copyright (c) 2022 Lars Norberg

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
local Addon,Private = ...

-- Lua API
local pairs = pairs

-- WoW API
local CancelSpellByName = CancelSpellByName
local GetSpellInfo = GetSpellInfo
local InCombatLockdown = InCombatLockdown
local UnitBuff = UnitBuff

Private.frame = CreateFrame("Frame", nil, WorldFrame)
Private.frame:RegisterEvent("ADDON_LOADED")
Private.frame:SetScript("OnEvent", function(self, event, ...)

	if (event == "ADDON_LOADED") then
		local addon = ...
		if (addon == Addon) then
			self:UnregisterEvent("ADDON_LOADED")
			self.auras = {}
			for id in pairs({

				-- Blingtron
				[134522] = true, 	-- Dressed to Kill (Male?)
				[222256] = true, 	-- Dressed to Kill (Female?)

				-- Toys
				[354546] = true, 	-- Inner Child -- VERIFIED!
				[354909] = true, 	-- Inner Child
				[354910] = true, 	-- Inner Child
				[354911] = true, 	-- Inner Child
				[354912] = true, 	-- Inner Child
				[354913] = true, 	-- Inner Child
				[354914] = true, 	-- Inner Child
				[354915] = true, 	-- Inner Child
				[354916] = true, 	-- Inner Child
				[354917] = true, 	-- Inner Child
				[354919] = true, 	-- Inner Child
				[354920] = true, 	-- Inner Child
				[354922] = true, 	-- Inner Child
				[354924] = true, 	-- Inner Child
				[354940] = true, 	-- Inner Child
				[354941] = true, 	-- Inner Child
				[354942] = true, 	-- Inner Child
				[354943] = true, 	-- Inner Child
				[354944] = true, 	-- Inner Child
				[354945] = true, 	-- Inner Child
				[354946] = true, 	-- Inner Child
				[354947] = true, 	-- Inner Child
				[354948] = true, 	-- Inner Child
				[354949] = true, 	-- Inner Child
				[354950] = true, 	-- Inner Child
				[354951] = true, 	-- Inner Child
				[354952] = true, 	-- Inner Child
				[354953] = true, 	-- Inner Child
				[354954] = true, 	-- Inner Child
				[354955] = true, 	-- Inner Child
				[354956] = true, 	-- Inner Child
				[354957] = true, 	-- Inner Child
				[354958] = true, 	-- Inner Child
				[354959] = true, 	-- Inner Child
				[354960] = true, 	-- Inner Child
				[354961] = true, 	-- Inner Child
				[354962] = true, 	-- Inner Child

				-- Hallow's End Costumes
				[172010] = true, 	-- Abomination Costume
				[218132] = true, 	-- Banshee Costume
				[ 24732] = true, 	-- Bat Costume
				[191703] = true, 	-- Bat Costume
				[285521] = true, 	-- Blue Dragon Body Costume
				[285519] = true, 	-- Blue Dragon Head Costume
				[285523] = true, 	-- Blue Dragon Tail Costume
				[ 97135] = true, 	-- Children's Costume Aura
				[261477] = true, 	-- Dervish
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
				[ 58493] = true, 	-- Mohawked!
				[190824] = true, 	-- Murloc Costume (17th Anniversary)
				[191211] = true, 	-- Nerubian Costume
				[ 24710] = true, 	-- Ninja Costume
				[ 24711] = true, 	-- Ninja Costume
				[191686] = true, 	-- Ninja Costume
				[334407] = true, 	-- Noble Bearing (The Harvest - Revendreth Treasure)
				[ 61734] = true, 	-- Noblegarden Bunny
				[ 24708] = true, 	-- Pirate Costume
				[173958] = true, 	-- Pirate Costume
				[173959] = true, 	-- Pirate Costume
				[191682] = true, 	-- Pirate Costume
				[191683] = true, 	-- Pirate Costume
				[243319] = true, 	-- Quilboar Costume (17th Anniversary)
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
				[243317] = true, 	-- Trogg Costume (17th Anniversary)
				[ 61781] = true, 	-- Turkey Feathers
				[178306] = true, 	-- Warsong Orc Costume
				[178307] = true, 	-- Warsong Orc Costume
				[191208] = true, 	-- Wight Costume
				[ 24740] = true, 	-- Wisp Costume
				[279509] = true, 	-- Witch!
				[171930] = true, 	-- "Yipp-Saron" Costume

				--[   768] = true 	-- Cat Form (DEVELOPMENT PURPOSES ONLY!)
			}) do
				local name = GetSpellInfo(id)
				if (name) then
					self.auras[name] = true
				end
			end
		else
			return
		end
	end

	if (InCombatLockdown()) then
		return self:RegisterEvent("PLAYER_REGEN_ENABLED")
	elseif (event == "PLAYER_REGEN_ENABLED") then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	local index = 1
	while true do
		local name = UnitBuff("player", index)
		if (not name) then
			return
		end
		if (self.auras[name]) then
			CancelSpellByName(name)
		end
		index = index + 1
	end
end)
