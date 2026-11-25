local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local UIS=game:GetService("UserInputService")
local lp=Players.LocalPlayer
local cam=workspace.CurrentCamera
local dspd=16 local djmp=50 local ujp=true
local nc=false local na=false local sp=false
local ncs={} local xrs={} local lgs={} local xrc=nil
local ac=0 local FI=nil local BL=nil

local function H(s) local h=5381 for i=1,#s do h=(h*33+string.byte(s,i))%2^32 end return tostring(h) end
local SH=H("基托里")

if game.CoreGui:FindFirstChild("CRK_V4") then game.CoreGui.CRK_V4:Destroy() end

local SG=Instance.new("ScreenGui")
SG.Name="CRK_V4"
SG.ResetOnSpawn=false
SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.Parent=game.CoreGui

-- Captura defaults do personagem
task.spawn(function()
	local c=lp.Character or lp.CharacterAdded:Wait()
	local h=c:WaitForChild("Humanoid",5)
	if not h then return end
	dspd=h.WalkSpeed ujp=h.UseJumpPower
	djmp=ujp and h.JumpPower or h.JumpHeight
end)

-- RGB stroke animado
local function mkStroke(p,th)
	local s=Instance.new("UIStroke",p) s.Thickness=th or 1.5
	task.spawn(function()
		local h=0
		while s and s.Parent do
			h=(h+0.004)%1
			s.Color=Color3.fromHSV(h,0.9,1)
			task.wait(0.03)
		end
	end)
	return s
end

-- RGB text animado
local function mkRGBText(lb)
	task.spawn(function()
		local h=0
		while lb and lb.Parent do
			h=(h+0.004)%1
			lb.TextColor3=Color3.fromHSV(h,0.9,1)
			task.wait(0.03)
		end
	end)
end

local function corner(p,r) local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 12) return c end
local function pad(p,t,b,l,r) local u=Instance.new("UIPadding",p) u.PaddingTop=UDim.new(0,t or 0) u.PaddingBottom=UDim.new(0,b or 0) u.PaddingLeft=UDim.new(0,l or 0) u.PaddingRight=UDim.new(0,r or 0) end

-- ══════════════════════════════════════
--  TELA DE LOGIN
-- ══════════════════════════════════════
local LF=Instance.new("Frame",SG)
LF.Size=UDim2.new(0,300,0,340)
LF.Position=UDim2.new(0.5,-150,0.5,-170)
LF.BackgroundColor3=Color3.fromRGB(10,10,12)
LF.Active=true LF.Draggable=true
corner(LF,20)
mkStroke(LF,2)

-- Gradiente no fundo do login
local lg=Instance.new("UIGradient",LF)
lg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(18,10,30)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8,8,10))}
lg.Rotation=135

-- Brilho topo
local glow=Instance.new("Frame",LF)
glow.Size=UDim2.new(1,0,0,2)
glow.BackgroundColor3=Color3.fromRGB(180,0,255)
glow.BorderSizePixel=0
task.spawn(function()
	local h=0
	while glow and glow.Parent do
		h=(h+0.005)%1
		glow.BackgroundColor3=Color3.fromHSV(h,1,1)
		task.wait(0.03)
	end
end)
local gc=Instance.new("UICorner",glow) gc.CornerRadius=UDim.new(0,20)

-- Avatar
local AvFrame=Instance.new("Frame",LF)
AvFrame.Size=UDim2.new(0,80,0,80)
AvFrame.Position=UDim2.new(0.5,-40,0,30)
AvFrame.BackgroundColor3=Color3.fromRGB(20,10,35)
corner(AvFrame,40)
mkStroke(AvFrame,2)
local Av=Instance.new("ImageLabel",AvFrame)
Av.Size=UDim2.new(1,0,1,0)
Av.BackgroundTransparency=1
Av.Image="rbxassetid://96351081727254"
corner(Av,40)

-- Título login
local LTitle=Instance.new("TextLabel",LF)
LTitle.Size=UDim2.new(1,-20,0,32)
LTitle.Position=UDim2.new(0,10,0,122)
LTitle.BackgroundTransparency=1
LTitle.Text="CRK PAINEL V4"
LTitle.Font=Enum.Font.GothamBold
LTitle.TextSize=22
LTitle.TextXAlignment=Enum.TextXAlignment.Center
mkRGBText(LTitle)

local LSub=Instance.new("TextLabel",LF)
LSub.Size=UDim2.new(1,-20,0,20)
LSub.Position=UDim2.new(0,10,0,154)
LSub.BackgroundTransparency=1
LSub.Text="Digite a senha para continuar"
LSub.Font=Enum.Font.Gotham
LSub.TextSize=11
LSub.TextColor3=Color3.fromRGB(100,100,120)
LSub.TextXAlignment=Enum.TextXAlignment.Center

-- Campo senha
local PBox=Instance.new("TextBox",LF)
PBox.Size=UDim2.new(1,-40,0,44)
PBox.Position=UDim2.new(0,20,0,186)
PBox.BackgroundColor3=Color3.fromRGB(20,15,30)
PBox.TextColor3=Color3.new(1,1,1)
PBox.PlaceholderText="••••••••"
PBox.Text="" PBox.TextSize=16
PBox.Font=Enum.Font.GothamMedium
PBox.TextXAlignment=Enum.TextXAlignment.Center
corner(PBox,10)
mkStroke(PBox,1)
pad(PBox,0,0,10,10)

-- Botão entrar
local LBtn=Instance.new("TextButton",LF)
LBtn.Size=UDim2.new(1,-40,0,46)
LBtn.Position=UDim2.new(0,20,0,244)
LBtn.BackgroundColor3=Color3.fromRGB(120,0,200)
LBtn.Text="ENTRAR"
LBtn.TextColor3=Color3.new(1,1,1)
LBtn.Font=Enum.Font.GothamBold
LBtn.TextSize=15
corner(LBtn,12)
-- Gradiente no botão
local bg=Instance.new("UIGradient",LBtn)
bg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(160,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(80,0,160))}
bg.Rotation=90

local LErr=Instance.new("TextLabel",LF)
LErr.Size=UDim2.new(1,-20,0,20)
LErr.Position=UDim2.new(0,10,0,296)
LErr.BackgroundTransparency=1
LErr.Text=""
LErr.Font=Enum.Font.GothamMedium
LErr.TextSize=11
LErr.TextColor3=Color3.fromRGB(255,80,80)
LErr.TextXAlignment=Enum.TextXAlignment.Center

-- ══════════════════════════════════════
--  PAINEL PRINCIPAL
-- ══════════════════════════════════════
local MF=Instance.new("Frame",SG)
MF.Size=UDim2.new(0,420,0,480)
MF.Position=UDim2.new(0.5,-210,0.5,-240)
MF.BackgroundColor3=Color3.fromRGB(8,8,12)
MF.Visible=false MF.Active=true MF.Draggable=true
corner(MF,20)
mkStroke(MF,1.5)

local MGrad=Instance.new("UIGradient",MF)
MGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(14,10,22)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8,8,12))}
MGrad.Rotation=135

-- Barra de brilho topo
local MGlow=Instance.new("Frame",MF)
MGlow.Size=UDim2.new(1,0,0,2)
MGlow.BorderSizePixel=0
task.spawn(function()
	local h=0.75
	while MGlow and MGlow.Parent do
		h=(h+0.004)%1
		MGlow.BackgroundColor3=Color3.fromHSV(h,1,1)
		task.wait(0.03)
	end
end)
local MGC=Instance.new("UICorner",MGlow) MGC.CornerRadius=UDim.new(0,20)

-- Header
local HDR=Instance.new("Frame",MF)
HDR.Size=UDim2.new(1,-24,0,52)
HDR.Position=UDim2.new(0,12,0,10)
HDR.BackgroundColor3=Color3.fromRGB(16,12,26)
corner(HDR,14)
mkStroke(HDR,1)

local HIcon=Instance.new("ImageLabel",HDR)
HIcon.Size=UDim2.new(0,30,0,30)
HIcon.Position=UDim2.new(0,10,0.5,-15)
HIcon.BackgroundTransparency=1
HIcon.Image="rbxassetid://96351081727254"
corner(HIcon,15)

local HTitle=Instance.new("TextLabel",HDR)
HTitle.Size=UDim2.new(0,160,0,30)
HTitle.Position=UDim2.new(0,48,0.5,-15)
HTitle.BackgroundTransparency=1
HTitle.Text="CRK PAINEL V4"
HTitle.Font=Enum.Font.GothamBold
HTitle.TextSize=16
HTitle.TextXAlignment=Enum.TextXAlignment.Left
mkRGBText(HTitle)

local HStatus=Instance.new("TextLabel",HDR)
HStatus.Size=UDim2.new(0,100,0,22)
HStatus.Position=UDim2.new(1,-148,0.5,-11)
HStatus.BackgroundTransparency=1
HStatus.Text="● offline"
HStatus.Font=Enum.Font.GothamMedium
HStatus.TextSize=11
HStatus.TextColor3=Color3.fromRGB(80,80,100)
HStatus.TextXAlignment=Enum.TextXAlignment.Right

local HClose=Instance.new("TextButton",HDR)
HClose.Size=UDim2.new(0,32,0,32)
HClose.Position=UDim2.new(1,-42,0.5,-16)
HClose.BackgroundColor3=Color3.fromRGB(180,30,60)
HClose.Text="✕"
HClose.TextColor3=Color3.new(1,1,1)
HClose.TextSize=14
HClose.Font=Enum.Font.GothamBold
corner(HClose,8)
HClose.MouseButton1Click:Connect(function()
	local t=TweenService:Create(MF,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,420,0,0),Position=UDim2.new(0.5,-210,0.5,0)})
	t:Play() t.Completed:Connect(function() MF.Visible=false end)
end)

-- Tab bar
local TabBar=Instance.new("Frame",MF)
TabBar.Size=UDim2.new(1,-24,0,42)
TabBar.Position=UDim2.new(0,12,0,70)
TabBar.BackgroundColor3=Color3.fromRGB(14,10,22)
corner(TabBar,12)

local TBLayout=Instance.new("UIListLayout",TabBar)
TBLayout.FillDirection=Enum.FillDirection.Horizontal
TBLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
TBLayout.VerticalAlignment=Enum.VerticalAlignment.Center
TBLayout.Padding=UDim.new(0,4)
pad(TabBar,5,5,6,6)

-- Conteúdo
local Content=Instance.new("Frame",MF)
Content.Size=UDim2.new(1,-24,1,-130)
Content.Position=UDim2.new(0,12,0,120)
Content.BackgroundTransparency=1

local activeTab=nil
local activeScroll=nil

local function mkScroll()
	local sf=Instance.new("ScrollingFrame",Content)
	sf.Size=UDim2.new(1,0,1,0)
	sf.BackgroundTransparency=1
	sf.ScrollBarThickness=3
	sf.ScrollBarImageColor3=Color3.fromRGB(120,0,200)
	sf.CanvasSize=UDim2.new(0,0,0,0)
	sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
	sf.Visible=false
	local l=Instance.new("UIListLayout",sf)
	l.SortOrder=Enum.SortOrder.LayoutOrder
	l.Padding=UDim.new(0,6)
	pad(sf,8,8,0,4)
	return sf
end

local FarmScroll=mkScroll() FarmScroll.Visible=true
local BuffScroll=mkScroll()
local OutroScroll=mkScroll()

-- Status de ativos
local function updateStatus(d)
	ac=math.max(0,ac+d)
	HStatus.Text=ac>0 and("● "..ac.." ativo"..(ac>1 and"s"or""))or"● offline"
	HStatus.TextColor3=ac>0 and Color3.fromRGB(0,220,100) or Color3.fromRGB(80,80,100)
	if BL then BL.Text=tostring(ac) BL.Visible=ac>0 end
end

-- Criar aba
local function mkTab(label,scroll)
	local b=Instance.new("TextButton",TabBar)
	b.Size=UDim2.new(0,112,0,32)
	b.BackgroundColor3=Color3.fromRGB(20,14,34)
	b.Text=label
	b.TextColor3=Color3.fromRGB(120,100,160)
	b.Font=Enum.Font.GothamBold
	b.TextSize=12
	b.AutoButtonColor=false
	corner(b,9)
	b.MouseButton1Click:Connect(function()
		if activeScroll then activeScroll.Visible=false end
		if activeTab then
			activeTab.BackgroundColor3=Color3.fromRGB(20,14,34)
			activeTab.TextColor3=Color3.fromRGB(120,100,160)
		end
		scroll.Visible=true activeScroll=scroll
		activeTab=b
		b.BackgroundColor3=Color3.fromRGB(100,0,180)
		b.TextColor3=Color3.new(1,1,1)
	end)
	return b
end

local tFarm=mkTab("🌾  FARM",FarmScroll)
local tBuff=mkTab("⚡  BUFFS",BuffScroll)
local tOutro=mkTab("⚙  OUTROS",OutroScroll)

-- Selecionar farm por padrão
tFarm.BackgroundColor3=Color3.fromRGB(100,0,180)
tFarm.TextColor3=Color3.new(1,1,1)
activeTab=tFarm activeScroll=FarmScroll

-- Seção label
local function mkSection(txt,parent)
	local f=Instance.new("Frame",parent)
	f.Size=UDim2.new(1,0,0,26)
	f.BackgroundTransparency=1
	local line=Instance.new("Frame",f)
	line.Size=UDim2.new(1,0,0,1)
	line.Position=UDim2.new(0,0,1,-1)
	line.BackgroundColor3=Color3.fromRGB(50,30,80)
	line.BorderSizePixel=0
	local lb=Instance.new("TextLabel",f)
	lb.Size=UDim2.new(1,0,1,0)
	lb.BackgroundTransparency=1
	lb.Text=txt:upper()
	lb.Font=Enum.Font.GothamBold
	lb.TextSize=10
	lb.TextColor3=Color3.fromRGB(140,80,220)
	lb.TextXAlignment=Enum.TextXAlignment.Left
	pad(f,0,0,4,0)
end

-- Toggle card
local function mkToggle(txt,parent,cb,once)
	local card=Instance.new("Frame",parent)
	card.Size=UDim2.new(1,0,0,52)
	card.BackgroundColor3=Color3.fromRGB(14,10,22)
	corner(card,12)

	-- Gradiente sutil
	local cg=Instance.new("UIGradient",card)
	cg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(20,14,32)),ColorSequenceKeypoint.new(1,Color3.fromRGB(12,10,18))}
	cg.Rotation=90

	local title=Instance.new("TextLabel",card)
	title.Size=UDim2.new(0.65,0,1,0)
	title.Position=UDim2.new(0,14,0,0)
	title.BackgroundTransparency=1
	title.Text=txt
	title.Font=Enum.Font.GothamMedium
	title.TextSize=13
	title.TextColor3=Color3.fromRGB(200,185,230)
	title.TextXAlignment=Enum.TextXAlignment.Left

	-- Toggle pill
	local pill=Instance.new("Frame",card)
	pill.Size=UDim2.new(0,46,0,24)
	pill.Position=UDim2.new(1,-58,0.5,-12)
	pill.BackgroundColor3=Color3.fromRGB(30,20,50)
	corner(pill,12)

	local knob=Instance.new("Frame",pill)
	knob.Size=UDim2.new(0,18,0,18)
	knob.Position=UDim2.new(0,3,0.5,-9)
	knob.BackgroundColor3=Color3.fromRGB(100,80,140)
	corner(knob,9)

	local toggled=false
	local str=nil

	local function toggle()
		if toggled and once then return end
		toggled=not toggled
		if toggled then
			TweenService:Create(pill,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(100,0,200)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.2),{Position=UDim2.new(1,-21,0.5,-9),BackgroundColor3=Color3.new(1,1,1)}):Play()
			if once then title.Text=txt.." ✓" title.TextColor3=Color3.fromRGB(160,100,255) end
			if str==nil then str=mkStroke(card,1) end
			updateStatus(1)
		else
			TweenService:Create(pill,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(30,20,50)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.2),{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.fromRGB(100,80,140)}):Play()
			if str then str:Destroy() str=nil end
			updateStatus(-1)
		end
		if cb then pcall(cb,toggled) end
	end

	local btn=Instance.new("TextButton",card)
	btn.Size=UDim2.new(1,0,1,0)
	btn.BackgroundTransparency=1 btn.Text=""
	btn.MouseButton1Click:Connect(toggle)
end

-- Input+toggle card
local function mkInput(txt,parent,def)
	local card=Instance.new("Frame",parent)
	card.Size=UDim2.new(1,0,0,52)
	card.BackgroundColor3=Color3.fromRGB(14,10,22)
	corner(card,12)
	local cg=Instance.new("UIGradient",card)
	cg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(20,14,32)),ColorSequenceKeypoint.new(1,Color3.fromRGB(12,10,18))}
	cg.Rotation=90

	local title=Instance.new("TextLabel",card)
	title.Size=UDim2.new(0.42,0,1,0)
	title.Position=UDim2.new(0,14,0,0)
	title.BackgroundTransparency=1
	title.Text=txt title.Font=Enum.Font.GothamMedium title.TextSize=13
	title.TextColor3=Color3.fromRGB(200,185,230)
	title.TextXAlignment=Enum.TextXAlignment.Left

	local ib=Instance.new("TextBox",card)
	ib.Size=UDim2.new(0,56,0,30)
	ib.Position=UDim2.new(1,-112,0.5,-15)
	ib.BackgroundColor3=Color3.fromRGB(20,14,34)
	ib.TextColor3=Color3.new(1,1,1)
	ib.Text=tostring(def) ib.TextSize=14
	ib.Font=Enum.Font.GothamBold
	ib.TextXAlignment=Enum.TextXAlignment.Center
	corner(ib,8)
	mkStroke(ib,1)

	local pill=Instance.new("Frame",card)
	pill.Size=UDim2.new(0,46,0,24)
	pill.Position=UDim2.new(1,-58,0.5,-12)
	pill.BackgroundColor3=Color3.fromRGB(30,20,50)
	corner(pill,12)
	local knob=Instance.new("Frame",pill)
	knob.Size=UDim2.new(0,18,0,18)
	knob.Position=UDim2.new(0,3,0.5,-9)
	knob.BackgroundColor3=Color3.fromRGB(100,80,140)
	corner(knob,9)

	local tg=false
	local str=nil
	local function toggle()
		tg=not tg
		if tg then
			TweenService:Create(pill,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(100,0,200)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.2),{Position=UDim2.new(1,-21,0.5,-9),BackgroundColor3=Color3.new(1,1,1)}):Play()
			if str==nil then str=mkStroke(card,1) end
			updateStatus(1)
		else
			TweenService:Create(pill,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(30,20,50)}):Play()
			TweenService:Create(knob,TweenInfo.new(0.2),{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.fromRGB(100,80,140)}):Play()
			if str then str:Destroy() str=nil end
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

-- FARM
mkSection("Scripts Externos",FarmScroll)
mkToggle("Farm Peace",FarmScroll,function(s) if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/VertigoCool99/scripts/refs/heads/main/PeaceKeepers.lua"))() end end,true)
mkToggle("Gui Product",FarmScroll,function(s) if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/Server87"))() end end,true)
mkToggle("Infinity Yield",FarmScroll,function(s) if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end end,true)

-- BUFFS
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

-- OUTROS
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
FpsHUD.Size=UDim2.new(0,100,0,32)
FpsHUD.Position=UDim2.new(0,12,1,-48)
FpsHUD.BackgroundColor3=Color3.fromRGB(10,8,16)
FpsHUD.BackgroundTransparency=0.1 FpsHUD.Visible=false
corner(FpsHUD,10) mkStroke(FpsHUD,1)
local FpsLabel=Instance.new("TextLabel",FpsHUD)
FpsLabel.Size=UDim2.new(1,0,1,0)
FpsLabel.BackgroundTransparency=1
FpsLabel.Font=Enum.Font.GothamBold FpsLabel.TextSize=13
FpsLabel.TextColor3=Color3.fromRGB(200,185,230) FpsLabel.Text="FPS —"
local lt2,fc2=tick(),0
RunService.RenderStepped:Connect(function()
	fc2+=1 local n=tick()
	if n-lt2>=1 then
		local f=fc2 FpsLabel.Text="FPS "..f
		FpsLabel.TextColor3=f>=55 and Color3.fromRGB(0,220,100) or f>=30 and Color3.fromRGB(220,180,0) or Color3.fromRGB(220,60,60)
		fc2,lt2=0,n
	end
end)
mkToggle("FPS Counter",OutroScroll,function(s) FpsHUD.Visible=s end,false)

-- ══════════════════════════════════════
--  LÓGICA PRINCIPAL (loops)
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
	FI.BackgroundColor3=Color3.fromRGB(14,10,22)
	FI.Draggable=true
	corner(FI,26) mkStroke(FI,2)

	BL=Instance.new("TextLabel",FI)
	BL.Size=UDim2.new(0,20,0,20)
	BL.Position=UDim2.new(1,-20,0,0)
	BL.BackgroundColor3=Color3.fromRGB(160,0,255)
	BL.TextColor3=Color3.new(1,1,1)
	BL.TextSize=10 BL.Font=Enum.Font.GothamBold
	BL.Text="0" BL.Visible=false
	corner(BL,10)

	FI.MouseButton1Click:Connect(function()
		if MF.Visible then
			local t=TweenService:Create(MF,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,420,0,0),Position=UDim2.new(0.5,-210,0.5,0)})
			t:Play() t.Completed:Connect(function() MF.Visible=false end)
		else
			MF.Visible=true
			MF.Size=UDim2.new(0,420,0,0)
			MF.Position=UDim2.new(0.5,-210,0.5,0)
			TweenService:Create(MF,TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,420,0,480),Position=UDim2.new(0.5,-210,0.5,-240)}):Play()
		end
	end)
end

-- ══════════════════════════════════════
--  LOGIN
-- ══════════════════════════════════════
LBtn.MouseButton1Click:Connect(function()
	if H(PBox.Text)==SH then
		TweenService:Create(LF,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{BackgroundTransparency=1,Size=UDim2.new(0,300,0,0),Position=UDim2.new(0.5,-150,0.5,0)}):Play()
		task.wait(0.3) LF.Visible=false
		MF.Visible=true
		MF.Size=UDim2.new(0,420,0,0)
		MF.Position=UDim2.new(0.5,-210,0.5,0)
		TweenService:Create(MF,TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,420,0,480),Position=UDim2.new(0.5,-210,0.5,-240)}):Play()
		criarIcone()
	else
		LErr.Text="Senha incorreta ✕"
		local op=LF.Position
		for i=1,5 do
			TweenService:Create(LF,TweenInfo.new(0.04),{Position=op+UDim2.new(0,i%2==0 and 7 or-7,0,0)}):Play()
			task.wait(0.045)
		end
		TweenService:Create(LF,TweenInfo.new(0.08),{Position=op}):Play()
		PBox.Text=""
		task.delay(2,function() LErr.Text="" end)
	end
end)
