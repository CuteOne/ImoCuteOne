-- Largeur
 if not LargeurFrame then
	LargeurFrame = 40 -- Pixels
end
-- Hauteur
if not HauteurFrame then
	HauteurFrame = 17 -- Pixels
end

-- Classes Colors from API.
_ClassColors = {
["Hunter"]		= {B=0.45,	G=0.83,	R=0.67,	Hex="|cffabd473"},
["Warrior"]		= {B=0.43,	G=0.61,	R=0.78,	Hex="|cffc79c6e"},
["Paladin"] 	= {B=0.73,	G=0.55,	R=0.96,	Hex="|cfff58cba"},
["Mage"]		= {B=0.94,	G=0.8,	R=0.41,	Hex="|cff69ccf0"},
["Priest"]		= {B=1,		G=1,	R=1,	Hex="|cffffffff"},
["Warlock"]		= {B=0.79,	G=0.51,	R=0.58,	Hex="|cff9482c9"},
["Shaman"]		= {B=0.87,	G=0.44,	R=0,	Hex="|cff0070de"},
["DeathKnight"]	= {B=0.23,	G=0.12,	R=0.77,	Hex="|cffc41f3b"},
["Druid"]		= {B=0.04,	G=0.49,	R=1,	Hex="|cffff7d0a"},
["Monk"]		= {B=0.59,	G=1,	R=0,	Hex="|cff00ff96"},
["Rogue"]		= {B=0.41,	G=0.96,	R=1,	Hex="|cfffff569"}
}
-- Player
local PlayerFrameColorR = _ClassColors[UnitClass("player")].R
local PlayerFrameColorG = _ClassColors[UnitClass("player")].G
local PlayerFrameColorB = _ClassColors[UnitClass("player")].B

---------------------------------

-- Macro Toggle ON/OFF
SLASH_BAR1 = "/cutebar"
function SlashCmdList.BAR(msg, editbox)
	if not FrameShown then
		if not Cute_Frame then
			CreateBar()
		end
		print("|cffff7d0aActivating Display")
		Cute_Frame:Show() 
		Cute_Frame2:Show() 
		Cute_Frame3:Show() 
		Cute_Frame4:Show() 		
		FrameShown = true
	else
		print("|cffff7d0aDisactivated Display")
		Cute_Frame:Hide() 
		Cute_Frame2:Hide() 
		Cute_Frame3:Hide() 	
		Cute_Frame4:Hide() 	
		FrameShown = nil
	end
end

-- Mettre a jour les valeurs chaque frame.
function Cute_FrameUpdate(self, elapsed)
	-- Frame 1
	if cute.rkp() ~= nil and UnitDebuffID("Target", 1822, "Player") then
		local rkpDisplay = math.floor(cute.rkp())
		--if rkpDisplay > 1000 then
			Cute_Frame.Text:SetText((math.floor(rkpDisplay)).."%") 
		--else 
		--	Cute_Frame.Text:SetText(rkpDisplay) 
		--end
		Cute_Frame:SetValue(cute.rkp())
		-- Status Color
		if cute.rkp() > 108 then
			Cute_Frame:GetStatusBarTexture():SetTexture(0/255, 255/255, 0/255,0.75,"OVERLAY")
		else
			Cute_Frame:GetStatusBarTexture():SetTexture(217/255, 0/255, 0/255,0.75,"OVERLAY")
		end
	else
		Cute_Frame:SetValue(0)
		Cute_Frame.Text:SetText("RKP")
	end
	-- Frame 2
	if cute.rkd() ~= nil and UnitDebuffID("Target", 1822, "Player") then
		local rkdDisplay = math.floor(cute.rkd())
		if rkdDisplay > 1000 then
			Cute_Frame2.Text:SetText((math.floor(rkdDisplay/1000)).."k") 
		else 
			Cute_Frame2.Text:SetText(rkdDisplay) 
		end
		Cute_Frame2:SetValue(cute.rkd())
		Cute_Frame2:GetStatusBarTexture():SetTexture(217/255, 0/255, 0/255,0.75,"OVERLAY")
	else
		Cute_Frame2:SetValue(0)
		Cute_Frame2.Text:SetText("RKD")

	end	
	-- Frame 3
	if cute.rpp()  ~= nil and UnitDebuffID("Target", 1079, "Player") then
		local rppDisplay = math.floor(cute.rpp())
		--if rppDisplay > 1000 then
			Cute_Frame3.Text:SetText((math.floor(rppDisplay)).."%") 
		--else 
		--	Cute_Frame3.Text:SetText(rkpDisplay) 
		--end
		Cute_Frame3:SetValue(cute.rpp())
		-- Status Color
		if cute.rpp() > 108 then
			Cute_Frame3:GetStatusBarTexture():SetTexture(0/255, 255/255, 0/255,0.75,"OVERLAY")
		else
			Cute_Frame3:GetStatusBarTexture():SetTexture(217/255, 0/255, 0/255,0.75,"OVERLAY")
		end
	else
		Cute_Frame3:SetValue(0)
		Cute_Frame3.Text:SetText("RPP")
	end
	-- Frame 4
	if cute.rpd() ~= nil and UnitDebuffID("Target", 1079, "Player") then
		local rpdDisplay = math.floor(cute.rpd())
		if rpdDisplay > 1000 then
			Cute_Frame4.Text:SetText((math.floor(rpdDisplay/1000)).."k") 
		else 
			Cute_Frame4.Text:SetText(rpdDisplay) 
		end
		Cute_Frame4:SetValue(cute.rpd())
		Cute_Frame4:GetStatusBarTexture():SetTexture(217/255, 0/255, 0/255,0.75,"OVERLAY")
	else
		Cute_Frame4:SetValue(0)
		Cute_Frame4.Text:SetText("RPD")

	end	
end

if Cute_Frame == nil then
	LargeurBord = LargeurFrame + 8
	HauteurBord = HauteurFrame + 8
	Cute_Frame = CreateFrame("StatusBar", nil, UIParent)
	Cute_Frame:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		tile = true,
		tileSize = 16,
	})
	Cute_Frame:SetStatusBarTexture([[Interface\TARGETINGFRAME\UI-StatusBar]],"OVERLAY")
	Cute_Frame:SetOrientation("HORIZONTAL")
	Cute_Frame:SetStatusBarColor(1,1,1,1)
	Cute_Frame:SetBackdropColor(1,1,1,1)
	Cute_Frame:GetStatusBarTexture():SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75,"OVERLAY")
	Cute_Frame:SetMinMaxValues(0, 15)
	Cute_Frame:SetWidth(LargeurFrame)
	Cute_Frame:SetHeight(HauteurFrame)
	Cute_Frame:SetPoint("CENTER",150,150)
	Cute_Frame:SetClampedToScreen(true)
	Cute_Frame:SetScript("OnUpdate", Cute_FrameUpdate)
	Cute_Frame:EnableMouse(true)
	Cute_Frame:SetMovable(true)
	Cute_Frame:RegisterForDrag("LeftButton")
	Cute_Frame:SetScript("OnDragStart", Cute_Frame.StartMoving)
	Cute_Frame:SetScript("OnDragStop", Cute_Frame.StopMovingOrSizing)
	Cute_Frame:SetValue(0)

	texture = Cute_Frame:CreateTexture(nil, "BACKGROUND")
	Cute_Frame.texture = texture
	Cute_Frame.texture:SetAllPoints()
	Cute_Frame.texture:SetTexture(25/255,25/255,25/255,1)

	border = Cute_Frame:CreateTexture(nil, "BACKGROUND")
	Cute_Frame.Border = border
	Cute_Frame.Border:SetPoint("LEFT",-4,0)
	Cute_Frame.Border:SetWidth(LargeurBord)
	Cute_Frame.Border:SetHeight(HauteurBord)
	Cute_Frame.Border:SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.15)

	bartext = Cute_Frame:CreateFontString(nil, "OVERLAY")
	Cute_Frame.Text = bartext
	Cute_Frame.Text:SetFontObject("MovieSubtitleFont")
	Cute_Frame.Text:SetTextHeight(13)
	Cute_Frame.Text:SetPoint("CENTER",0,0)
	Cute_Frame.Text:SetTextColor(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75)
	Cute_Frame:Hide() 

	Cute_Frame2 = CreateFrame("StatusBar", nil, Cute_Frame)
	Cute_Frame2:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		tile = true,
		tileSize = 16,
	})
	Cute_Frame2:SetStatusBarTexture([[Interface\TARGETINGFRAME\UI-StatusBar]],"OVERLAY")
	Cute_Frame2:SetOrientation("HORIZONTAL")
	Cute_Frame2:SetStatusBarColor(1,1,1,1)
	Cute_Frame2:SetBackdropColor(1,1,1,1)
	Cute_Frame2:GetStatusBarTexture():SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75,"OVERLAY")
	Cute_Frame2:SetMinMaxValues(0, 15)
	Cute_Frame2:SetWidth(LargeurFrame)
	Cute_Frame2:SetHeight(HauteurFrame)
	Cute_Frame2:SetPoint("CENTER",48,0)
	Cute_Frame2:SetClampedToScreen(true)
	Cute_Frame2:SetScript("OnUpdate", Cute_FrameUpdate)
	Cute_Frame2:SetValue(0)

	texture = Cute_Frame2:CreateTexture(nil, "BACKGROUND")
	Cute_Frame2.texture = texture
	Cute_Frame2.texture:SetAllPoints()
	Cute_Frame2.texture:SetTexture(25/255,25/255,25/255,1)

	border = Cute_Frame2:CreateTexture(nil, "BACKGROUND")
	Cute_Frame2.Border = border
	Cute_Frame2.Border:SetPoint("LEFT",-4,0)
	Cute_Frame2.Border:SetWidth(LargeurBord)
	Cute_Frame2.Border:SetHeight(HauteurBord)
	Cute_Frame2.Border:SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.15)

	bartext = Cute_Frame2:CreateFontString(nil, "OVERLAY")
	Cute_Frame2.Text = bartext
	Cute_Frame2.Text:SetFontObject("MovieSubtitleFont")
	Cute_Frame2.Text:SetTextHeight(13)
	Cute_Frame2.Text:SetPoint("CENTER",0,0)
	Cute_Frame2.Text:SetTextColor(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75)
	Cute_Frame2:Hide() 

	Cute_Frame3 = CreateFrame("StatusBar", nil, Cute_Frame)
	Cute_Frame3:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		tile = true,
		tileSize = 16,
	})
	Cute_Frame3:SetStatusBarTexture([[Interface\TARGETINGFRAME\UI-StatusBar]],"OVERLAY")
	Cute_Frame3:SetOrientation("HORIZONTAL")
	Cute_Frame3:SetStatusBarColor(1,1,1,1)
	Cute_Frame3:SetBackdropColor(1,1,1,1)
	Cute_Frame3:GetStatusBarTexture():SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75,"OVERLAY")
	Cute_Frame3:SetMinMaxValues(0, 15)
	Cute_Frame3:SetWidth(LargeurFrame)
	Cute_Frame3:SetHeight(HauteurFrame)
	Cute_Frame3:SetPoint("CENTER",0,20)
	Cute_Frame3:SetClampedToScreen(true)
	Cute_Frame3:SetScript("OnUpdate", Cute_FrameUpdate)
	Cute_Frame3:SetValue(0)

	texture = Cute_Frame3:CreateTexture(nil, "BACKGROUND")
	Cute_Frame3.texture = texture
	Cute_Frame3.texture:SetAllPoints()
	Cute_Frame3.texture:SetTexture(25/255,25/255,25/255,1)

	border = Cute_Frame3:CreateTexture(nil, "BACKGROUND")
	Cute_Frame3.Border = border
	Cute_Frame3.Border:SetPoint("LEFT",-4,0)
	Cute_Frame3.Border:SetWidth(LargeurBord)
	Cute_Frame3.Border:SetHeight(HauteurBord)
	Cute_Frame3.Border:SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.15)

	bartext = Cute_Frame3:CreateFontString(nil, "OVERLAY")
	Cute_Frame3.Text = bartext
	Cute_Frame3.Text:SetFontObject("MovieSubtitleFont")
	Cute_Frame3.Text:SetTextHeight(13)
	Cute_Frame3.Text:SetPoint("CENTER",0,0)
	Cute_Frame3.Text:SetTextColor(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75)
	Cute_Frame3:Hide() 

	LargeurBord = LargeurFrame + 8
	HauteurBord = HauteurFrame + 8
	Cute_Frame4 = CreateFrame("StatusBar", nil, Cute_Frame)
	Cute_Frame4:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		tile = true,
		tileSize = 16,
	})
	Cute_Frame4:SetStatusBarTexture([[Interface\TARGETINGFRAME\UI-StatusBar]],"OVERLAY")
	Cute_Frame4:SetOrientation("HORIZONTAL")
	Cute_Frame4:SetStatusBarColor(1,1,1,1)
	Cute_Frame4:SetBackdropColor(1,1,1,1)
	Cute_Frame4:GetStatusBarTexture():SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75,"OVERLAY")
	Cute_Frame4:SetMinMaxValues(0, 15)
	Cute_Frame4:SetWidth(LargeurFrame)
	Cute_Frame4:SetHeight(HauteurFrame)
	Cute_Frame4:SetPoint("CENTER",48,20)
	Cute_Frame4:SetClampedToScreen(true)
	Cute_Frame4:SetScript("OnUpdate", Cute_FrameUpdate)
	Cute_Frame4:SetValue(0)

	texture = Cute_Frame4:CreateTexture(nil, "BACKGROUND")
	Cute_Frame4.texture = texture
	Cute_Frame4.texture:SetAllPoints()
	Cute_Frame4.texture:SetTexture(25/255,25/255,25/255,1)

	border = Cute_Frame4:CreateTexture(nil, "BACKGROUND")
	Cute_Frame4.Border = border
	Cute_Frame4.Border:SetPoint("LEFT",-4,0)
	Cute_Frame4.Border:SetWidth(LargeurBord)
	Cute_Frame4.Border:SetHeight(HauteurBord)
	Cute_Frame4.Border:SetTexture(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.15)

	bartext = Cute_Frame4:CreateFontString(nil, "OVERLAY")
	Cute_Frame4.Text = bartext
	Cute_Frame4.Text:SetFontObject("MovieSubtitleFont")
	Cute_Frame4.Text:SetTextHeight(13)
	Cute_Frame4.Text:SetPoint("CENTER",0,0)
	Cute_Frame4.Text:SetTextColor(PlayerFrameColorR, PlayerFrameColorG, PlayerFrameColorB,0.75)
	Cute_Frame4:Hide() 

end