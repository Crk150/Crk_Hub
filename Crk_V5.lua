-- CRK PAINEL V5 — visual profissional
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local lp=Players.LocalPlayer
local cam=workspace.CurrentCamera
local dspd=16 local djmp=50 local ujp=true
local nc=false local na=false local sp=false
local ncs={} local xrs={} local lgs={} local xrc=nil
local ac=0 local FI=nil local BL=nil

local function H(s) local h=5381 for i=1,#s do h=(h*33+string.byte(s,i))%2^32 end return tostring(h) end
local SH=H("基托里")

if game.CoreGui:FindFirstChild("CRK_V5") then game.CoreGui.CRK_V5:Destroy() end

local SG=Instance.new("ScreenGui")
SG.Name="CRK_V5"
SG.ResetOnSpawn=false
SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.Parent=game.CoreGui

task.spawn(function()
	local c=lp.Character or lp.CharacterAdded:Wait()
	local h=c:WaitForChild("Humanoid",5)
	if not h then return end
	dspd=h.WalkSpeed ujp=h.UseJumpPower
	djmp=ujp and h.JumpPower or h.JumpHeight
end)

-- Helpers
local function corner(p,r)
	local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 12) return c
end
local function pad(p,t,b,l,r)
	local u=Instance.new("UIPadding",p)
	u.PaddingTop=UDim.new(0,t or 0) u.PaddingBottom=UDim.new(0,b or 0)
	u.PaddingLeft=UDim.new(0,l or 0) u.PaddingRight=UDim.new(0,r or 0)
end

-- Stroke estático roxo limpo (sem RGB caótico nas bordas)
local function mkStroke(p,th,col)
	local s=Instance.new("UIStroke",p)
	s.Thickness=th or 1
	s.Color=col or Color3.fromRGB(80,0,160)
	return s
end

-- RGB animado só para texto de título
local function mkRGBText(lb)
	task.spawn(function()
		local h=0.75
		while lb and lb.Parent do
			h=(h+0.004)%1
			lb.TextColor3=Color3.fromHSV(h,0.85,1)
			task.wait(0.03)
		end
	end)
end

-- ══════════════════════════════════════
--  TELA DE LOGIN — visual limpo
-- ══════════════════════════════════════
local LF=Instance.new("Frame",SG)
LF.Size=UDim2.new(0,320,0,350)
LF.Position=UDim2.new(0.5,-160,0.5,-175)
LF.BackgroundColor3=Color3.fromRGB(12,10,18)
LF.Active=true LF.Draggable=true
LF.ClipsDescendants=true
corner(LF,18)
mkStroke(LF,1.5,Color3.fromRGB(80,0,160))

-- Gradiente fundo
local lg=Instance.new("UIGradient",LF)
lg.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(20,12,34)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(10,8,16))
}
lg.Rotation=145

-- Barra decorativa topo (dentro do clip, sem vazamento)
local LGlow=Instance.new("Frame",LF)
LGlow.Size=UDim2.new(1,0,0,3)
LGlow.Position=UDim2.new(0,0,0,0)
LGlow.BorderSizePixel=0
task.spawn(function()
	local h=0.75
	while LGlow and LGlow.Parent do
		h=(h+0.005)%1
		LGlow.BackgroundColor3=Color3.fromHSV(h,1,1)
		task.wait(0.03)
	end
end)

-- Avatar com borda roxa estática
local AvFrame=Instance.new("Frame",LF)
AvFrame.Size=UDim2.new(0,76,0,76)
AvFrame.Position=UDim2.new(0.5,-38,0,22)
AvFrame.BackgroundColor3=Color3.fromRGB(18,10,30)
corner(AvFrame,38)
mkStroke(AvFrame,2,Color3.fromRGB(100,0,200))

local Av=Instance.new("ImageLabel",AvFrame)
Av.Size=UDim2.new(1,-4,1,-4)
Av.Position=UDim2.new(0,2,0,2)
Av.BackgroundTransparency=1
Av.Image="rbxassetid://96351081727254"
corner(Av,36)

-- Título RGB
local LTitle=Instance.new("TextLabel",LF)
LTitle.Size=UDim2.new(1,0,0,30)
LTitle.Position=UDim2.new(0,0,0,110)
LTitle.BackgroundTransparency=1
LTitle.Text="CRK PAINEL V5"
LTitle.Font=Enum.Font.GothamBold
LTitle.TextSize=20
LTitle.TextXAlignment=Enum.TextXAlignment.Center
mkRGBText(LTitle)

local LSub=Instance.new("TextLabel",LF)
LSub.Size=UDim2.new(1,0,0,18)
LSub.Position=UDim2.new(0,0,0,142)
LSub.BackgroundTransparency=1
LSub.Text="Digite a senha para continuar"
LSub.Font=Enum.Font.Gotham
LSub.TextSize=11
LSub.TextColor3=Color3.fromRGB(90,80,110)
LSub.TextXAlignment=Enum.TextXAlignment.Center

-- Campo senha
local PBox=Instance.new("TextBox",LF)
PBox.Size=UDim2.new(1,-48,0,42)
PBox.Position=UDim2.new(0,24,0,172)
PBox.BackgroundColor3=Color3.fromRGB(18,13,28)
PBox.TextColor3=Color3.fromRGB(220,210,240)
PBox.PlaceholderColor3=Color3.fromRGB(80,70,100)
PBox.PlaceholderText="senha..."
PBox.Text="" PBox.TextSize=15
PBox.Font=Enum.Font.GothamMedium
PBox.TextXAlignment=Enum.TextXAlignment.Center
corner(PBox,10)
mkStroke(PBox,1,Color3.fromRGB(60,0,120))

-- Botão entrar
local LBtn=Instance.new("TextButton",LF)
LBtn.Size=UDim2.new(1,-48,0,44)
LBtn.Position=UDim2.new(0,24,0,228)
LBtn.BackgroundColor3=Color3.fromRGB(100,0,190)
LBtn.Text="ENTRAR"
LBtn.TextColor3=Color3.new(1,1,1)
LBtn.Font=Enum.Font.GothamBold
LBtn.TextSize=14
LBtn.AutoButtonColor=false
corner(LBtn,10)
local LBG=Instance.new("UIGradient",LBtn)
LBG.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(140,20,255)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(80,0,160))
}
LBG.Rotation=90
-- hover sutil
LBtn.MouseEnter:Connect(function() TweenService:Create(LBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(120,10,220)}):Play() end)
LBtn.MouseLeave:Connect(function() TweenService:Create(LBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(100,0,190)}):Play() end)

local LErr=Instance.new("TextLabel",LF)
LErr.Size=UDim2.new(1,0,0,18)
LErr.Position=UDim2.new(0,0,0,282)
LErr.BackgroundTransparency=1
LErr.Text=""
LErr.Font=Enum.Font.GothamMedium
LErr.TextSize=11
LErr.TextColor3=Color3.fromRGB(255,70,70)
LErr.TextXAlignment=Enum.TextXAlignment.Center

-- Versão
local LVer=Instance.new("TextLabel",LF)
LVer.Size=UDim2.new(1,0,0,16)
LVer.Position=UDim2.new(0,0,0,314)
LVer.BackgroundTransparency=1
LVer.Text="v5.0 • by CRK"
LVer.Font=Enum.Font.Gotham
LVer.TextSize=10
LVer.TextColor3=Color3.fromRGB(55,45,75)
LVer.TextXAlignment=Enum.TextXAlignment.Center

-- ══════════════════════════════════════
--  PAINEL PRINCIPAL
-- ══════════════════════════════════════
local MF=Instance.new("Frame",SG)
MF.Size=UDim2.new(0,440,0,500)
MF.Position=UDim2.new(0.5,-220,0.5,-250)
MF.BackgroundColor3=Color3.fromRGB(10,8,16)
MF.Visible=false MF.Active=true MF.Draggable=true
MF.ClipsDescendants=true
corner(MF,18)
mkStroke(MF,1,Color3.fromRGB(55,0,110))

local MGrad=Instance.new("UIGradient",MF)
MGrad.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(16,11,26)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(8,7,13))
}
MGrad.Rotation=160

-- Barra glow topo (dentro do clip)
local MGlow=Instance.new("Frame",MF)
MGlow.Size=UDim2.new(1,0,0,3)
MGlow.Position=UDim2.new(0,0,0,0)
MGlow.BorderSizePixel=0
task.spawn(function()
	local h=0.75
	while MGlow and MGlow.Parent do
		h=(h+0.004)%1
		MGlow.BackgroundColor3=Color3.fromHSV(h,1,1)
		task.wait(0.03)
	end
end)

-- Header
local HDR=Instance.new("Frame",MF)
HDR.Size=UDim2.new(1,-20,0,54)
HDR.Position=UDim2.new(0,10,0,12)
HDR.BackgroundColor3=Color3.fromRGB(16,11,28)
corner(HDR,14)
mkStroke(HDR,1,Color3.fromRGB(50,0,100))

local HGrad=Instance.new("UIGradient",HDR)
HGrad.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(22,15,38)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,22))
}
HGrad.Rotation=90

local HIcon=Instance.new("ImageLabel",HDR)
HIcon.Size=UDim2.new(0,32,0,32)
HIcon.Position=UDim2.new(0,12,0.5,-16)
HIcon.BackgroundColor3=Color3.fromRGB(14,10,22)
HIcon.Image="rbxassetid://96351081727254"
corner(HIcon,16)
mkStroke(HIcon,1,Color3.fromRGB(80,0,160))

local HTitle=Instance.new("TextLabel",HDR)
HTitle.Size=UDim2.new(0,180,0,28)
HTitle.Position=UDim2.new(0,52,0.5,-14)
HTitle.BackgroundTransparency=1
HTitle.Text="CRK PAINEL V5"
HTitle.Font=Enum.Font.GothamBold
HTitle.TextSize=15
HTitle.TextXAlignment=Enum.TextXAlignment.Left
mkRGBText(HTitle)

local HStatus=Instance.new("Frame",HDR)
HStatus.Size=UDim2.new(0,90,0,22)
HStatus.Position=UDim2.new(1,-134,0.5,-11)
HStatus.BackgroundColor3=Color3.fromRGB(12,8,20)
corner(HStatus,8)
mkStroke(HStatus,1,Color3.fromRGB(40,0,80))
local HStatusLbl=Instance.new("TextLabel",HStatus)
HStatusLbl.Size=UDim2.new(1,0,1,0)
HStatusLbl.BackgroundTransparency=1
HStatusLbl.Text="● offline"
HStatusLbl.Font=Enum.Font.GothamMedium
HStatusLbl.TextSize=10
HStatusLbl.TextColor3=Color3.fromRGB(80,70,100)

local HClose=Instance.new("TextButton",HDR)
HClose.Size=UDim2.new(0,30,0,30)
HClose.Position=UDim2.new(1,-42,0.5,-15)
HClose.BackgroundColor3=Color3.fromRGB(160,25,55)
HClose.Text="✕"
HClose.TextColor3=Color3.new(1,1,1)
HClose.TextSize=13
HClose.Font=Enum.Font.GothamBold
HClose.AutoButtonColor=false
corner(HClose,8)
HClose.MouseEnter:Connect(function() TweenService:Create(HClose,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(220,40,70)}):Play() end)
HClose.MouseLeave:Connect(function() TweenService:Create(HClose,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(160,25,55)}):Play() end)
HClose.MouseButton1Click:Connect(function()
	local t=TweenService:Create(MF,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
		{Size=UDim2.new(0,440,0,0),Position=UDim2.new(0.5,-220,0.5,0)})
	t:Play() t.Completed:Connect(function() MF.Visible=false end)
end)

-- Tab bar
local TabBar=Instance.new("Frame",MF)
TabBar.Size=UDim2.new(1,-20,0,40)
TabBar.Position=UDim2.new(0,10,0,74)
TabBar.BackgroundColor3=Color3.fromRGB(14,10,22)
corner(TabBar,12)
mkStroke(TabBar,1,Color3.fromRGB(40,0,80))

local TBLayout=Instance.new("UIListLayout",TabBar)
TBLayout.FillDirection=Enum.FillDirection.Horizontal
TBLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
TBLayout.VerticalAlignment=Enum.VerticalAlignment.Center
TBLayout.Padding=UDim.new(0,4)
pad(TabBar,5,5,6,6)

-- Área de conteúdo
local Content=Instance.new("Frame",MF)
Content.Size=UDim2.new(1,-20,1,-126)
Content.Position=UDim2.new(0,10,0,122)
Content.BackgroundTransparency=1

local activeTab=nil
local activeScroll=nil

local function mkScroll()
	local sf=Instance.new("ScrollingFrame",Content)
	sf.Size=UDim2.new(1,0,1,0)
	sf.BackgroundTransparency=1
	sf.ScrollBarThickness=2
	sf.ScrollBarImageColor3=Color3.fromRGB(100,0,200)
	sf.CanvasSize=UDim2.new(0,0,0,0)
	sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
	sf.Visible=false
	local l=Instance.new("UIListLayout",sf)
	l.SortOrder=Enum.SortOrder.LayoutOrder
	l.Padding=UDim.new(0,5)
	pad(sf,6,10,0,6)
	return sf
end

local FarmScroll=mkScroll() FarmScroll.Visible=true
local BuffScroll=mkScroll()
local OutroScroll=mkScroll()

-- Ativos
local function updateStatus(d)
	ac=math.max(0,ac+d)
	HStatusLbl.Text=ac>0 and("● "..ac.." ativo"..(ac>1 and"s"or""))or"● offline"
	HStatusLbl.TextColor3=ac>0 and Color3.fromRGB(80,220,120) or Color3.fromRGB(80,70,100)
	if BL then BL.Text=tostring(ac) BL.Visible=ac>0 end
end

-- Tabs
local function mkTab(label,scroll)
	local b=Instance.new("TextButton",TabBar)
	b.Size=UDim2.new(0,120,0,30)
	b.BackgroundColor3=Color3.fromRGB(18,13,30)
	b.Text=label
	b.TextColor3=Color3.fromRGB(100,85,135)
	b.Font=Enum.Font.GothamBold
	b.TextSize=11
	b.AutoButtonColor=false
	corner(b,9)
	b.MouseButton1Click:Connect(function()
		if activeScroll then activeScroll.Visible=false end
		if activeTab then
			TweenService:Create(activeTab,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(18,13,30)}):Play()
			activeTab.TextColor3=Color3.fromRGB(100,85,135)
		end
		scroll.Visible=true activeScroll=scroll activeTab=b
		TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(90,0,170)}):Play()
		b.TextColor3=Color3.new(1,1,1)
	end)
	return b
end

local tFarm=mkTab("🌾 FARM",FarmScroll)
local tBuff=mkTab("⚡ BUFFS",BuffScroll)
local tOutro=mkTab("⚙ OUTROS",OutroScroll)

-- Default
tFarm.BackgroundColor3=Color3.fromRGB(90,0,170)
tFarm.TextColor3=Color3.new(1,1,1)
activeTab=tFarm activeScroll=FarmScroll

-- Seção
local function mkSection(txt,parent)
	local f=Instance.new("Frame",parent)
	f.Size=UDim2.new(1,0,0,24)
	f.BackgroundTransparency=1
	local line=Instance.new("Frame",f)
	line.Size=UDim2.new(1,0,0,1)
	line.Position=UDim2.new(0,0,1,-1)
	line.BackgroundColor3=Color3.fromRGB(40,20,65)
	line.BorderSizePixel=0
	local lb=Instance.new("TextLabel",f)
	lb.Size=UDim2.new(1,0,1,0)
	lb.BackgroundTransparency=1
	lb.Text=txt:upper()
	lb.Font=Enum.Font.GothamBold
	lb.TextSize=10
	lb.TextColor3=Color3.fromRGB(120,60,200)
	lb.TextXAlignment=Enum.TextXAlignment.Left
	pad(f,0,0,2,0)
end

-- Toggle card profissional
local function mkToggle(txt,parent,cb,once)
	local card=Instance.new("Frame",parent)
	card.Size=UDim2.new(1,0,0,50)
	card.BackgroundColor3=Color3.fromRGB(15,11,24)
	corner(card,12)
	mkStroke(card,1,Color3.fromRGB(35,20,55))

	local cg=Instance.new("UIGradient",card)
	cg.Color=ColorSequence.new{
		ColorSequenceKeypoint.new(0,Color3.fromRGB(20,14,32)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(13,10,20))
	}
	cg.Rotation=90

	local title=Instance.new("TextLabel",card)
	title.Size=UDim2.new(0.65,0,1,0)
	title.Position=UDim2.new(0,14,0,0)
	title.BackgroundTransparency=1
	title.Text=txt
	title.Font=Enum.Font.GothamMedium
	title.TextSize=13
	title.TextColor3=Color3.fromRGB(195,180,225)
	title.TextXAlignment=Enum.TextXAlignment.Left

	-- Pill container
	local pill=Instance.new("Frame",card)
	pill.Size=UDim2.new(0,44,0,22)
	pill.Position=UDim2.new(1,-56,0.5,-11)
	pill.BackgroundColor3=Color3.fromRGB(28,18,45)
	corner(pill,11)
	mkStroke(pill,1,Color3.fromRGB(50,25,80))

	local knob=Instance.new("Frame",pill)
	knob.Size=UDim2.new(0,16,0,16)
	knob.Position=UDim2.new(0,3,0.5,-8)
	knob.BackgroundColor3=Color3.fromRGB(90,70,120)
	corner(knob,8)

	local toggled=false

	local function toggle()
		if toggled and once then return end
		toggled=not toggled
		if toggled then
			TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(90,0,180)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
				{Position=UDim2.new(1,-19,0.5,-8),BackgroundColor3=Color3.new(1,1,1)}):Play()
			mkStroke(pill,1,Color3.fromRGB(120,0,240))
			if once then
				title.Text=txt.." ✓"
				title.TextColor3=Color3.fromRGB(150,90,255)
			end
			updateStatus(1)
		else
			TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(28,18,45)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.18),
				{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=Color3.fromRGB(90,70,120)}):Play()
			-- restore pill stroke
			for _,c in pairs(pill:GetChildren()) do if c:IsA("UIStroke") then c:Destroy() end end
			mkStroke(pill,1,Color3.fromRGB(50,25,80))
			updateStatus(-1)
		end
		if cb then pcall(cb,toggled) end
	end

	local btn=Instance.new("TextButton",card)
	btn.Size=UDim2.new(1,0,1,0)
	btn.BackgroundTransparency=1 btn.Text=""
	btn.MouseButton1Click:Connect(toggle)
end

-- Input+toggle
local function mkInput(txt,parent,def)
	local card=Instance.new("Frame",parent)
	card.Size=UDim2.new(1,0,0,50)
	card.BackgroundColor3=Color3.fromRGB(15,11,24)
	corner(card,12)
	mkStroke(card,1,Color3.fromRGB(35,20,55))
	local cg=Instance.new("UIGradient",card)
	cg.Color=ColorSequence.new{
		ColorSequenceKeypoint.new(0,Color3.fromRGB(20,14,32)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(13,10,20))
	}
	cg.Rotation=90

	local title=Instance.new("TextLabel",card)
	title.Size=UDim2.new(0.42,0,1,0)
	title.Position=UDim2.new(0,14,0,0)
	title.BackgroundTransparency=1
	title.Text=txt title.Font=Enum.Font.GothamMedium title.TextSize=13
	title.TextColor3=Color3.fromRGB(195,180,225)
	title.TextXAlignment=Enum.TextXAlignment.Left

	local ib=Instance.new("TextBox",card)
	ib.Size=UDim2.new(0,52,0,28)
	ib.Position=UDim2.new(1,-106,0.5,-14)
	ib.BackgroundColor3=Color3.fromRGB(18,12,32)
	ib.TextColor3=Color3.fromRGB(220,205,245)
	ib.Text=tostring(def) ib.TextSize=14
	ib.Font=Enum.Font.GothamBold
	ib.TextXAlignment=Enum.TextXAlignment.Center
	corner(ib,8)
	mkStroke(ib,1,Color3.fromRGB(60,0,120))

	local pill=Instance.new("Frame",card)
	pill.Size=UDim2.new(0,44,0,22)
	pill.Position=UDim2.new(1,-56,0.5,-11)
	pill.BackgroundColor3=Color3.fromRGB(28,18,45)
	corner(pill,11)
	mkStroke(pill,1,Color3.fromRGB(50,25,80))
	local knob=Instance.new("Frame",pill)
	knob.Size=UDim2.new(0,16,0,16)
	knob.Position=UDim2.new(0,3,0.5,-8)
	knob.BackgroundColor3=Color3.fromRGB(90,70,120)
	corner(knob,8)

	local tg=false
	local function toggle()
		tg=not tg
		if tg then
			TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(90,0,180)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
				{Position=UDim2.new(1,-19,0.5,-8),BackgroundColor3=Color3.new(1,1,1)}):Play()
			mkStroke(pill,1,Color3.fromRGB(120,0,240))
			updateStatus(1)
		else
			TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(28,18,45)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.18),
				{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=Color3.fromRGB(90,70,120)}):Play()
			for _,c in pairs(pill:GetChildren()) do if c:IsA("UIStroke") then c:Destroy() end end
			mkStroke(pill,1,Color3.fromRGB(50,25,80))
			updateStatus(-1)
		end
	end
	local btn=Instance.new("TextButton",card)
	btn.Size=UDim2.new(1,0,1,0)
	btn.BackgroundTransparency=1 btn.Text=""
	btn.MouseButton1Click:Connect(toggle)
	return function() return tg end, ib
end

-- ══════════════════════════════════════
--  CONTEÚDO DAS ABAS
-- ══════════════════════════════════════
mkSection("Scripts Externos",FarmScroll)
mkToggle("Farm Peace",FarmScroll,function(s) if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/VertigoCool99/scripts/refs/heads/main/PeaceKeepers.lua"))() end end,true)
mkToggle("Gui Product",FarmScroll,function(s) if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/Server87"))() end end,true)
mkToggle("Infinity Yield",FarmScroll,function(s) if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end end,true)

mkSection("Movimento",BuffScroll)
local iSp,spB=mkInput("Speed",BuffScroll,50)
local iJp,jpB=mkInput("Jump",BuffScroll,100)
mkToggle("Noclip",BuffScroll,function(s) nc=s end,false)
mkSection("Combate",BuffScroll)
mkToggle("SpinBot",BuffScroll,function(s) sp=s end,false)
mkToggle("NPC Aimbot",BuffScroll,function(s) na=s end,false)
mkSection("Visual",BuffScroll)
mkToggle("X-Ray",BuffScroll,function(s)
	if s then
		for _,v in pairs(workspace:GetDescendants()) do
			pcall(function()
				if v:IsA("BasePart") and not v:IsDescendantOf(lp.Character) and v.Transparency~=1 then
					xrs[v]={v.Transparency,v.CanCollide}
					v.Transparency=0.65 v.CanCollide=false
				end
			end)
		end
		xrc=workspace.DescendantAdded:Connect(function(v)
			pcall(function()
				task.wait()
				if v:IsA("BasePart") and not v:IsDescendantOf(lp.Character) then
					xrs[v]={v.Transparency,v.CanCollide}
					v.Transparency=0.65 v.CanCollide=false
				end
			end)
		end)
	else
		if xrc then xrc:Disconnect() xrc=nil end
		for pt,pr in pairs(xrs) do
			pcall(function() if pt and pt.Parent then pt.Transparency=pr[1] pt.CanCollide=pr[2] end end)
		end
		xrs={}
	end
end,false)

mkSection("Performance",OutroScroll)
mkToggle("Anti Lag Ultra",OutroScroll,function(s)
	if s then
		for _,v in pairs(game:GetDescendants()) do
			pcall(function()
				if v:IsA("BasePart") or v:IsA("MeshPart") then lgs[v]={v.Material,v.Reflectance} v.Material=Enum.Material.SmoothPlastic v.Reflectance=0
				elseif v:IsA("Decal") or v:IsA("Texture") then lgs[v]=v.Transparency v.Transparency=1
				elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("PostEffect") then lgs[v]=v.Enabled v.Enabled=false
				elseif v:IsA("Sky") then lgs[v]=true v.Parent=nil end
			end)
		end
		Lighting.GlobalShadows=false settings().Rendering.QualityLevel=1
	else
		for o,sn in pairs(lgs) do
			pcall(function()
				if not o or not o.Parent then return end
				if o:IsA("BasePart") or o:IsA("MeshPart") then o.Material=sn[1] o.Reflectance=sn[2]
				elseif o:IsA("Decal") or o:IsA("Texture") then o.Transparency=sn
				elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("PostEffect") then o.Enabled=sn end
			end)
		end
		lgs={} Lighting.GlobalShadows=true
	end
end,false)

local FpsHUD=Instance.new("Frame",SG)
FpsHUD.Size=UDim2.new(0,100,0,30)
FpsHUD.Position=UDim2.new(0,12,1,-46)
FpsHUD.BackgroundColor3=Color3.fromRGB(12,9,20)
FpsHUD.Visible=false
corner(FpsHUD,10)
mkStroke(FpsHUD,1,Color3.fromRGB(55,0,110))
local FpsLabel=Instance.new("TextLabel",FpsHUD)
FpsLabel.Size=UDim2.new(1,0,1,0)
FpsLabel.BackgroundTransparency=1
FpsLabel.Font=Enum.Font.GothamBold FpsLabel.TextSize=12
FpsLabel.TextColor3=Color3.fromRGB(195,180,225) FpsLabel.Text="FPS —"
local lt2,fc2=tick(),0
RunService.RenderStepped:Connect(function()
	fc2+=1 local n=tick()
	if n-lt2>=1 then
		local f=fc2 FpsLabel.Text="FPS "..f
		FpsLabel.TextColor3=f>=55 and Color3.fromRGB(0,215,100) or f>=30 and Color3.fromRGB(215,175,0) or Color3.fromRGB(215,55,55)
		fc2,lt2=0,n
	end
end)
mkToggle("FPS Counter",OutroScroll,function(s) FpsHUD.Visible=s end,false)

-- ══════════════════════════════════════
--  LOOPS
-- ══════════════════════════════════════
RunService.RenderStepped:Connect(function()
	if not na then return end
	local sc=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
	local tg,bd=nil,math.huge
	for _,m in pairs(workspace:GetChildren()) do
		pcall(function()
			local h=m:FindFirstChildOfClass("Humanoid")
			if h and m~=lp.Character and h.Health>0 and not Players:GetPlayerFromCharacter(m) then
				local r=m:FindFirstChild("HumanoidRootPart")
				if r then
					local sv,os=cam:WorldToViewportPoint(r.Position)
					if os then
						local d=(Vector2.new(sv.X,sv.Y)-sc).Magnitude
						if d<160 and d<bd then bd,tg=d,r end
					end
				end
			end
		end)
	end
	if tg and tg.Parent then
		cam.CFrame=cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position,tg.Position+Vector3.new(0,1.4,0)),0.12)
	end
end)

RunService.Stepped:Connect(function()
	local ch=lp.Character if not ch then return end
	local hm=ch:FindFirstChildOfClass("Humanoid") if not hm then return end
	pcall(function()
		hm.WalkSpeed=iSp() and(tonumber(spB.Text)or dspd)or dspd
		local jv=iJp() and(tonumber(jpB.Text)or djmp)or djmp
		if ujp then hm.JumpPower=jv else hm.JumpHeight=jv end
		if nc then
			for _,v in pairs(ch:GetDescendants()) do
				if v:IsA("BasePart") then if ncs[v]==nil then ncs[v]=v.CanCollide end v.CanCollide=false end
			end
		else
			if next(ncs) then for pt,vl in pairs(ncs) do if pt and pt.Parent then pt.CanCollide=vl end end ncs={} end
		end
		local rt=ch:FindFirstChild("HumanoidRootPart")
		if sp and rt then rt.CFrame=rt.CFrame*CFrame.Angles(0,math.rad(22),0) end
	end)
end)

-- ══════════════════════════════════════
--  ÍCONE FLUTUANTE
-- ══════════════════════════════════════
local function criarIcone()
	FI=Instance.new("ImageButton",SG)
	FI.Size=UDim2.new(0,52,0,52)
	FI.Position=UDim2.new(0,16,0.5,-26)
	FI.Image="rbxassetid://96351081727254"
	FI.BackgroundColor3=Color3.fromRGB(14,10,24)
	FI.Draggable=true
	corner(FI,26)
	mkStroke(FI,2,Color3.fromRGB(90,0,180))

	BL=Instance.new("TextLabel",FI)
	BL.Size=UDim2.new(0,20,0,20)
	BL.Position=UDim2.new(1,-18,0,0)
	BL.BackgroundColor3=Color3.fromRGB(140,0,240)
	BL.TextColor3=Color3.new(1,1,1)
	BL.TextSize=10 BL.Font=Enum.Font.GothamBold
	BL.Text="0" BL.Visible=false
	corner(BL,10)

	FI.MouseButton1Click:Connect(function()
		if MF.Visible then
			local t=TweenService:Create(MF,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
				{Size=UDim2.new(0,440,0,0),Position=UDim2.new(0.5,-220,0.5,0)})
			t:Play() t.Completed:Connect(function() MF.Visible=false end)
		else
			MF.Visible=true
			MF.Size=UDim2.new(0,440,0,0)
			MF.Position=UDim2.new(0.5,-220,0.5,0)
			TweenService:Create(MF,TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
				{Size=UDim2.new(0,440,0,500),Position=UDim2.new(0.5,-220,0.5,-250)}):Play()
		end
	end)
end

-- ══════════════════════════════════════
--  HANDLER LOGIN
-- ══════════════════════════════════════
LBtn.MouseButton1Click:Connect(function()
	if H(PBox.Text)==SH then
		TweenService:Create(LF,TweenInfo.new(0.22,Enum.EasingStyle.Quad),
			{BackgroundTransparency=1,Size=UDim2.new(0,320,0,0),Position=UDim2.new(0.5,-160,0.5,0)}):Play()
		task.wait(0.28) LF.Visible=false
		MF.Visible=true
		MF.Size=UDim2.new(0,440,0,0)
		MF.Position=UDim2.new(0.5,-220,0.5,0)
		TweenService:Create(MF,TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
			{Size=UDim2.new(0,440,0,500),Position=UDim2.new(0.5,-220,0.5,-250)}):Play()
		criarIcone()
	else
		LErr.Text="Senha incorreta ✕"
		local op=LF.Position
		for i=1,5 do
			TweenService:Create(LF,TweenInfo.new(0.04),{Position=op+UDim2.new(0,i%2==0 and 8 or-8,0,0)}):Play()
			task.wait(0.045)
		end
		TweenService:Create(LF,TweenInfo.new(0.08),{Position=op}):Play()
		PBox.Text=""
		task.delay(2,function() LErr.Text="" end)
	end
end)
