--// CRK PAINEL V2 — REDESIGN VISUAL
-- Roblox Executor Script — Luau

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting   = game:GetService("Lighting")
local Workspace  = game:GetService("Workspace")
local UIS        = game:GetService("UserInputService")
local TweenSvc   = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ===========================
-- DESIGN TOKENS
-- ===========================
local C = {
    DEEP      = Color3.fromRGB(10,  10,  13),
    PANEL     = Color3.fromRGB(15,  15,  20),
    CARD      = Color3.fromRGB(21,  21,  28),
    ELEM      = Color3.fromRGB(28,  28,  38),
    ACCENT    = Color3.fromRGB(210, 20,  55),
    SUCCESS   = Color3.fromRGB(0,   210, 100),
    WARN      = Color3.fromRGB(255, 170, 0),
    T1        = Color3.fromRGB(240, 240, 248),
    T2        = Color3.fromRGB(140, 140, 158),
    T3        = Color3.fromRGB(70,  70,  85),
    BORDER    = Color3.fromRGB(38,  38,  52),
    TRACK_ON  = Color3.fromRGB(0,   190, 90),
    TRACK_OFF = Color3.fromRGB(45,  45,  60),
}

-- ===========================
-- STATE
-- ===========================
local gameDefaultSpeed  = 16
local gameDefaultJump   = 50
local useJumpPowerProp  = true
local isNoclipActive    = false
local isNpcAimbotActive = false
local isSpin            = false
local originalProps     = {}
local allKeybindBoxes   = {}
local keybindActions    = {}
local FloatIconRef      = nil

-- Cleanup
if game.CoreGui:FindFirstChild("CRK_PAINEL_V2") then
    game.CoreGui.CRK_PAINEL_V2:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "CRK_PAINEL_V2"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent         = game.CoreGui

-- ===========================
-- DEFAULTS
-- ===========================
local function CaptureGameDefaults()
    local ok, err = pcall(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum  = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        gameDefaultSpeed = hum.WalkSpeed
        useJumpPowerProp = hum.UseJumpPower
        gameDefaultJump  = useJumpPowerProp and hum.JumpPower or hum.JumpHeight
    end)
    if not ok then warn("[CRK] Defaults: " .. tostring(err)) end
end
CaptureGameDefaults()

-- ===========================
-- HELPERS
-- ===========================
local function tw(obj, props, t, style, dir)
    TweenSvc:Create(obj,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function corner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 10)
    return c
end

local function uistroke(parent, color, thickness)
    local s = Instance.new("UIStroke", parent)
    s.Color     = color or C.BORDER
    s.Thickness = thickness or 1
    return s
end

local function lbl(parent, text, size, color, font, xa)
    local l = Instance.new("TextLabel", parent)
    l.Text               = text
    l.TextSize           = size or 13
    l.TextColor3         = color or C.T1
    l.Font               = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment     = xa or Enum.TextXAlignment.Left
    return l
end

-- ===========================
-- RGB HELPERS
-- ===========================
local function ApplyRGBStroke(obj)
    if not obj or not obj.Parent then return end
    local s = uistroke(obj, Color3.new(1,0,0), 1.5)
    task.spawn(function()
        while obj and obj.Parent do
            for i = 0, 1, 0.008 do
                if not obj.Parent then return end
                s.Color = Color3.fromHSV(i, 0.85, 1)
                task.wait(0.03)
            end
        end
    end)
end

local function ApplyRGBText(textLabel)
    if not textLabel or not textLabel.Parent then return end
    task.spawn(function()
        while textLabel and textLabel.Parent do
            for i = 0, 1, 0.008 do
                if not textLabel.Parent then return end
                textLabel.TextColor3 = Color3.fromHSV(i, 0.85, 1)
                task.wait(0.03)
            end
        end
    end)
end

-- ===========================
-- TOAST SYSTEM
-- ===========================
local ToastQueue  = {}
local toastActive = false

local function showToast(message, isOk)
    table.insert(ToastQueue, { msg = message, ok = isOk })
    if toastActive then return end
    toastActive = true
    task.spawn(function()
        while #ToastQueue > 0 do
            local item = table.remove(ToastQueue, 1)

            local toast = Instance.new("Frame", ScreenGui)
            toast.Size            = UDim2.new(0, 230, 0, 42)
            toast.Position        = UDim2.new(1, -245, 0, -50)
            toast.BackgroundColor3 = C.CARD
            toast.BorderSizePixel = 0
            corner(toast, 10)
            uistroke(toast, item.ok and C.SUCCESS or C.ACCENT, 1)

            local dot = Instance.new("Frame", toast)
            dot.Size            = UDim2.new(0, 6, 0, 6)
            dot.Position        = UDim2.new(0, 14, 0.5, -3)
            dot.BackgroundColor3 = item.ok and C.SUCCESS or C.ACCENT
            dot.BorderSizePixel = 0
            corner(dot, 3)

            local msg = lbl(toast, item.msg, 12, C.T1, Enum.Font.GothamMedium, Enum.TextXAlignment.Left)
            msg.Size     = UDim2.new(1, -32, 1, 0)
            msg.Position = UDim2.new(0, 28, 0, 0)

            tw(toast, { Position = UDim2.new(1, -245, 0, 14) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            task.wait(2.2)
            tw(toast, { Position = UDim2.new(1, -245, 0, -50) }, 0.22)
            task.wait(0.25)
            toast:Destroy()
            task.wait(0.08)
        end
        toastActive = false
    end)
end

-- ===========================
-- LOGIN FRAME
-- ===========================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size            = UDim2.new(0, 340, 0, 295)
LoginFrame.Position        = UDim2.new(0.5, -170, 0.5, -147)
LoginFrame.BackgroundColor3 = C.PANEL
LoginFrame.Active          = true
LoginFrame.Draggable       = true
LoginFrame.BorderSizePixel = 0
corner(LoginFrame, 18)
ApplyRGBStroke(LoginFrame)

-- Accent top bar
local AccentBar = Instance.new("Frame", LoginFrame)
AccentBar.Size            = UDim2.new(1, 0, 0, 3)
AccentBar.Position        = UDim2.new(0, 0, 0, 0)
AccentBar.BackgroundColor3 = C.ACCENT
AccentBar.BorderSizePixel = 0

-- Logo
local LoginIcon = Instance.new("ImageLabel", LoginFrame)
LoginIcon.Size               = UDim2.new(0, 72, 0, 72)
LoginIcon.Position           = UDim2.new(0.5, -36, 0, 18)
LoginIcon.BackgroundColor3   = C.ELEM
LoginIcon.Image              = "rbxassetid://96351081727254"
LoginIcon.ScaleType          = Enum.ScaleType.Fit
LoginIcon.BorderSizePixel    = 0
corner(LoginIcon, 36)
uistroke(LoginIcon, C.BORDER, 1)

-- Title
local LoginTitle = lbl(LoginFrame, "CRK PAINEL", 26, C.T1, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
LoginTitle.Size     = UDim2.new(1, 0, 0, 32)
LoginTitle.Position = UDim2.new(0, 0, 0, 100)
ApplyRGBText(LoginTitle)

local LoginSub = lbl(LoginFrame, "v2.0  —  ACESSO SEGURO", 10, C.T3, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
LoginSub.Size     = UDim2.new(1, 0, 0, 16)
LoginSub.Position = UDim2.new(0, 0, 0, 133)

-- Password field
local PwWrap = Instance.new("Frame", LoginFrame)
PwWrap.Size            = UDim2.new(0.82, 0, 0, 44)
PwWrap.Position        = UDim2.new(0.09, 0, 0, 162)
PwWrap.BackgroundColor3 = C.ELEM
PwWrap.BorderSizePixel = 0
corner(PwWrap, 10)
uistroke(PwWrap, C.BORDER, 1)

local PwIcon = lbl(PwWrap, "🔑", 15, C.T2, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
PwIcon.Size     = UDim2.new(0, 36, 1, 0)
PwIcon.Position = UDim2.new(0, 0, 0, 0)

local PasswordBox = Instance.new("TextBox", PwWrap)
PasswordBox.Size            = UDim2.new(1, -44, 1, 0)
PasswordBox.Position        = UDim2.new(0, 40, 0, 0)
PasswordBox.PlaceholderText = "Insira a senha..."
PasswordBox.Text            = ""
PasswordBox.BackgroundTransparency = 1
PasswordBox.TextColor3      = C.T1
PasswordBox.PlaceholderColor3 = C.T3
PasswordBox.Font            = Enum.Font.GothamMedium
PasswordBox.TextSize        = 13
PasswordBox.TextXAlignment  = Enum.TextXAlignment.Left

-- Login button
local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size            = UDim2.new(0.82, 0, 0, 40)
LoginBtn.Position        = UDim2.new(0.09, 0, 0, 220)
LoginBtn.Text            = "ENTRAR"
LoginBtn.Font            = Enum.Font.GothamBlack
LoginBtn.TextSize        = 13
LoginBtn.TextColor3      = C.T1
LoginBtn.BackgroundColor3 = C.ACCENT
LoginBtn.AutoButtonColor = false
LoginBtn.BorderSizePixel = 0
corner(LoginBtn, 10)

LoginBtn.MouseEnter:Connect(function() tw(LoginBtn, {BackgroundColor3 = Color3.fromRGB(240,40,75)}, 0.15) end)
LoginBtn.MouseLeave:Connect(function() tw(LoginBtn, {BackgroundColor3 = C.ACCENT}, 0.15) end)

local LoginError = lbl(LoginFrame, "", 11, Color3.fromRGB(255,80,80), Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
LoginError.Size     = UDim2.new(1, 0, 0, 16)
LoginError.Position = UDim2.new(0, 0, 0, 273)

-- ===========================
-- MAIN FRAME
-- ===========================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size            = UDim2.new(0, 500, 0, 350)
MainFrame.Position        = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = C.DEEP
MainFrame.Visible         = false
MainFrame.Active          = true
MainFrame.Draggable       = true
MainFrame.BorderSizePixel = 0
corner(MainFrame, 16)
ApplyRGBStroke(MainFrame)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size            = UDim2.new(0, 112, 1, 0)
Sidebar.Position        = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = C.PANEL
Sidebar.BorderSizePixel = 0
corner(Sidebar, 16)

-- Mask sidebar right corners
local SideMaskR = Instance.new("Frame", Sidebar)
SideMaskR.Size            = UDim2.new(0, 16, 1, 0)
SideMaskR.Position        = UDim2.new(1, -16, 0, 0)
SideMaskR.BackgroundColor3 = C.PANEL
SideMaskR.BorderSizePixel = 0

-- Sidebar logo
local SideIcon = Instance.new("ImageLabel", Sidebar)
SideIcon.Size            = UDim2.new(0, 46, 0, 46)
SideIcon.Position        = UDim2.new(0.5, -23, 0, 14)
SideIcon.BackgroundColor3 = C.ELEM
SideIcon.Image           = "rbxassetid://96351081727254"
SideIcon.ScaleType       = Enum.ScaleType.Fit
SideIcon.BorderSizePixel = 0
corner(SideIcon, 23)

local SideTitle = lbl(Sidebar, "CRK", 14, C.T1, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
SideTitle.Size     = UDim2.new(1, 0, 0, 20)
SideTitle.Position = UDim2.new(0, 0, 0, 64)
ApplyRGBText(SideTitle)

local SideVer = lbl(Sidebar, "v2.0", 10, C.T3, Enum.Font.Gotham, Enum.TextXAlignment.Center)
SideVer.Size     = UDim2.new(1, 0, 0, 14)
SideVer.Position = UDim2.new(0, 0, 0, 83)

-- Sidebar divider
local SideDivider = Instance.new("Frame", Sidebar)
SideDivider.Size            = UDim2.new(0.65, 0, 0, 1)
SideDivider.Position        = UDim2.new(0.175, 0, 0, 104)
SideDivider.BackgroundColor3 = C.BORDER
SideDivider.BorderSizePixel = 0

-- Tab builder
local function createSideTab(icon, name, yPos)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size            = UDim2.new(0, 86, 0, 62)
    btn.Position        = UDim2.new(0.5, -43, 0, yPos)
    btn.BackgroundColor3 = C.ELEM
    btn.Text            = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    corner(btn, 10)

    local ic = lbl(btn, icon, 22, C.T2, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
    ic.Size     = UDim2.new(1, 0, 0, 28)
    ic.Position = UDim2.new(0, 0, 0, 10)
    ic.Name     = "Icon"

    local nm = lbl(btn, name, 10, C.T3, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    nm.Size     = UDim2.new(1, 0, 0, 14)
    nm.Position = UDim2.new(0, 0, 0, 40)
    nm.Name     = "TabName"

    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= C.ACCENT then
            tw(btn, {BackgroundColor3 = C.CARD}, 0.1)
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= C.ACCENT then
            tw(btn, {BackgroundColor3 = C.ELEM}, 0.1)
        end
    end)

    return btn, ic, nm
end

local FarmTabBtn,   FarmTabIc,   FarmTabNm   = createSideTab("🌾", "FARM",   118)
local BuffTabBtn,   BuffTabIc,   BuffTabNm   = createSideTab("⚡", "BUFFS",  188)
local OutrosTabBtn, OutrosTabIc, OutrosTabNm = createSideTab("⚙️", "OUTROS", 258)

-- Close button
local CloseBtn = Instance.new("TextButton", Sidebar)
CloseBtn.Size            = UDim2.new(0, 30, 0, 30)
CloseBtn.Position        = UDim2.new(0.5, -15, 1, -38)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50,20,25)
CloseBtn.Text            = "✕"
CloseBtn.TextColor3      = Color3.fromRGB(220,60,60)
CloseBtn.Font            = Enum.Font.GothamBold
CloseBtn.TextSize        = 14
CloseBtn.AutoButtonColor = false
CloseBtn.BorderSizePixel = 0
corner(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- ===========================
-- CONTENT AREA
-- ===========================
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size            = UDim2.new(1, -124, 1, 0)
ContentArea.Position        = UDim2.new(0, 120, 0, 0)
ContentArea.BackgroundTransparency = 1

-- Header
local ContentHeader = Instance.new("Frame", ContentArea)
ContentHeader.Size            = UDim2.new(1, 0, 0, 54)
ContentHeader.BackgroundTransparency = 1

local ContentTitle = lbl(ContentHeader, "FARM", 20, C.T1, Enum.Font.GothamBlack, Enum.TextXAlignment.Left)
ContentTitle.Size     = UDim2.new(0.6, 0, 1, 0)
ContentTitle.Position = UDim2.new(0, 8, 0, 0)

-- Player info chip
local PlayerChip = Instance.new("Frame", ContentHeader)
PlayerChip.Size            = UDim2.new(0, 136, 0, 32)
PlayerChip.Position        = UDim2.new(1, -140, 0.5, -16)
PlayerChip.BackgroundColor3 = C.ELEM
PlayerChip.BorderSizePixel = 0
corner(PlayerChip, 8)

local PlayerAvatar = Instance.new("ImageLabel", PlayerChip)
PlayerAvatar.Size            = UDim2.new(0, 24, 0, 24)
PlayerAvatar.Position        = UDim2.new(0, 4, 0.5, -12)
PlayerAvatar.BackgroundColor3 = C.CARD
PlayerAvatar.BorderSizePixel = 0
PlayerAvatar.Image           = ""
PlayerAvatar.ScaleType       = Enum.ScaleType.Crop
corner(PlayerAvatar, 12)
pcall(function()
    PlayerAvatar.Image = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size48x48
    )
end)

local PlayerNameLbl = lbl(PlayerChip, LocalPlayer.Name, 11, C.T1, Enum.Font.GothamMedium, Enum.TextXAlignment.Left)
PlayerNameLbl.Size            = UDim2.new(1, -34, 1, 0)
PlayerNameLbl.Position        = UDim2.new(0, 32, 0, 0)
PlayerNameLbl.ClipsDescendants = true

-- Header divider
local HDivider = Instance.new("Frame", ContentArea)
HDivider.Size            = UDim2.new(1, -8, 0, 1)
HDivider.Position        = UDim2.new(0, 4, 0, 54)
HDivider.BackgroundColor3 = C.BORDER
HDivider.BorderSizePixel = 0

-- Footer (FPS bar)
local Footer = Instance.new("Frame", ContentArea)
Footer.Size            = UDim2.new(1, 0, 0, 28)
Footer.Position        = UDim2.new(0, 0, 1, -28)
Footer.BackgroundTransparency = 1

local FDivider = Instance.new("Frame", Footer)
FDivider.Size            = UDim2.new(1, -8, 0, 1)
FDivider.Position        = UDim2.new(0, 4, 0, 0)
FDivider.BackgroundColor3 = C.BORDER
FDivider.BorderSizePixel = 0

local FPSLabel = lbl(Footer, "FPS: —", 11, C.T3, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
FPSLabel.Size     = UDim2.new(0.5, 0, 1, 0)
FPSLabel.Position = UDim2.new(0, 8, 0, 4)

local TagLabel = lbl(Footer, "CRK PAINEL V2", 10, C.T3, Enum.Font.Gotham, Enum.TextXAlignment.Right)
TagLabel.Size     = UDim2.new(0.5, 0, 1, 0)
TagLabel.Position = UDim2.new(0.5, -8, 0, 4)

-- ===========================
-- CONTAINERS
-- ===========================
local function createContainer(name)
    local sf = Instance.new("ScrollingFrame", ContentArea)
    sf.Name              = name
    sf.Size              = UDim2.new(1, -8, 1, -90)
    sf.Position          = UDim2.new(0, 4, 0, 60)
    sf.BackgroundTransparency = 1
    sf.ScrollBarThickness = 2
    sf.ScrollBarImageColor3 = C.T3
    sf.CanvasSize        = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Visible           = false
    local layout = Instance.new("UIListLayout", sf)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding   = UDim.new(0, 5)
    return sf
end

local FarmContainer   = createContainer("FarmContainer")
local BuffsContainer  = createContainer("BuffsContainer")
local OutrosContainer = createContainer("OutrosContainer")
FarmContainer.Visible = true

-- Section separator
local function createSection(parent, text)
    local f = Instance.new("Frame", parent)
    f.Size                  = UDim2.new(1, -4, 0, 24)
    f.BackgroundTransparency = 1

    local lbSec = lbl(f, "— " .. text:upper(), 10, C.T3, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
    lbSec.Size     = UDim2.new(1, -8, 1, 0)
    lbSec.Position = UDim2.new(0, 4, 0, 0)
    return f
end

-- ===========================
-- KEYBIND BOX
-- ===========================
local function createKeybindBox(parent)
    local kb = Instance.new("TextBox", parent)
    kb.Size              = UDim2.new(0, 28, 0, 20)
    kb.Position          = UDim2.new(1, -64, 0.5, -10)
    kb.BackgroundColor3  = C.ELEM
    kb.TextColor3        = C.T1
    kb.PlaceholderColor3 = C.T3
    kb.Font              = Enum.Font.GothamBold
    kb.TextSize          = 11
    kb.Text              = ""
    kb.PlaceholderText   = "KEY"
    kb.Visible           = false
    kb.TextXAlignment    = Enum.TextXAlignment.Center
    corner(kb, 4)
    uistroke(kb, C.BORDER, 1)
    table.insert(allKeybindBoxes, kb)

    kb:GetPropertyChangedSignal("Text"):Connect(function()
        local t = kb.Text:sub(1,1):upper()
        if kb.Text ~= t then kb.Text = t end
    end)
    return kb
end

-- ===========================
-- SWITCH (animated)
-- ===========================
local function createSwitch(parent)
    local track = Instance.new("Frame", parent)
    track.Size            = UDim2.new(0, 36, 0, 20)
    track.Position        = UDim2.new(1, -40, 0.5, -10)
    track.BackgroundColor3 = C.TRACK_OFF
    track.BorderSizePixel = 0
    corner(track, 10)

    local thumb = Instance.new("Frame", track)
    thumb.Size            = UDim2.new(0, 14, 0, 14)
    thumb.Position        = UDim2.new(0, 3, 0.5, -7)
    thumb.BackgroundColor3 = C.T1
    thumb.BorderSizePixel = 0
    corner(thumb, 7)

    local function setState(on)
        tw(track, {BackgroundColor3 = on and C.TRACK_ON or C.TRACK_OFF}, 0.18)
        tw(thumb, {Position = on and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)},
            0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    return track, setState
end

-- ===========================
-- TOGGLE FACTORY
-- ===========================
local function createToggleBtn(text, parent, callback, isOneTime)
    local btn = Instance.new("TextButton", parent)
    btn.Size            = UDim2.new(1, -4, 0, 40)
    btn.BackgroundColor3 = C.CARD
    btn.Text            = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    corner(btn, 10)
    uistroke(btn, C.BORDER, 1)

    local title = lbl(btn, text, 13, C.T2, Enum.Font.GothamMedium, Enum.TextXAlignment.Left)
    title.Size     = UDim2.new(0.55, 0, 1, 0)
    title.Position = UDim2.new(0, 14, 0, 0)

    local _, setState = createSwitch(btn)
    local kb = createKeybindBox(btn)

    local toggled = false
    local function toggleAction()
        if toggled and isOneTime then return end
        toggled = not toggled
        setState(toggled)
        if isOneTime and toggled then
            title.Text       = text .. " ✓"
            title.TextColor3 = C.SUCCESS
        end
        showToast((toggled and "ON  " or "OFF  ") .. text, toggled)
        if callback then
            local ok, err = pcall(callback, toggled)
            if not ok then warn("[CRK] Toggle '" .. text .. "': " .. tostring(err)) end
        end
    end

    btn.MouseButton1Click:Connect(toggleAction)
    btn.MouseEnter:Connect(function() tw(btn, {BackgroundColor3 = C.ELEM}, 0.12) end)
    btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = C.CARD}, 0.12) end)

    keybindActions[kb] = toggleAction
    return btn
end

-- ===========================
-- INPUT TOGGLE FACTORY
-- ===========================
local function createInputToggle(text, parent, defaultVal)
    local frame = Instance.new("Frame", parent)
    frame.Size            = UDim2.new(1, -4, 0, 40)
    frame.BackgroundColor3 = C.CARD
    frame.BorderSizePixel = 0
    corner(frame, 10)
    uistroke(frame, C.BORDER, 1)

    local title = lbl(frame, text, 13, C.T2, Enum.Font.GothamMedium, Enum.TextXAlignment.Left)
    title.Size     = UDim2.new(0.4, 0, 1, 0)
    title.Position = UDim2.new(0, 14, 0, 0)

    local input = Instance.new("TextBox", frame)
    input.Size            = UDim2.new(0, 46, 0, 24)
    input.Position        = UDim2.new(1, -142, 0.5, -12)
    input.BackgroundColor3 = C.ELEM
    input.TextColor3      = C.T1
    input.Font            = Enum.Font.GothamBold
    input.TextSize        = 12
    input.TextXAlignment  = Enum.TextXAlignment.Center
    input.Text            = tostring(defaultVal)
    input.BorderSizePixel = 0
    corner(input, 6)
    uistroke(input, C.BORDER, 1)

    local _, setState = createSwitch(frame)
    local kb = createKeybindBox(frame)

    local toggled = false
    local function toggleAction()
        toggled = not toggled
        setState(toggled)
        title.TextColor3 = toggled and C.T1 or C.T2
        showToast((toggled and "ON  " or "OFF  ") .. text, toggled)
    end

    local trigger = Instance.new("TextButton", frame)
    trigger.Size            = UDim2.new(0, 44, 1, 0)
    trigger.Position        = UDim2.new(1, -44, 0, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text            = ""
    trigger.MouseButton1Click:Connect(toggleAction)
    keybindActions[kb] = toggleAction

    return function() return toggled end, input
end

-- ===========================
-- GLOBAL KEYBIND LISTENER
-- ===========================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local k = input.KeyCode.Name
        for box, action in pairs(keybindActions) do
            if box and box.Parent and box.Visible and box.Text ~= "" and box.Text ~= "KEY" then
                if box.Text:upper() == k then
                    local ok, err = pcall(action)
                    if not ok then warn("[CRK] Keybind: " .. tostring(err)) end
                end
            end
        end
    end
end)

-- FPS update
local lastT = tick(); local frames = 0
RunService.RenderStepped:Connect(function()
    frames += 1
    local now = tick()
    if now - lastT >= 1 then
        FPSLabel.Text       = "FPS: " .. frames
        FPSLabel.TextColor3 = frames >= 55 and C.SUCCESS or (frames >= 30 and C.WARN or C.ACCENT)
        frames = 0; lastT = now
    end
end)

-- ===========================
-- POPULATE: FARM
-- ===========================
createSection(FarmContainer, "Scripts Externos")
createToggleBtn("Farm Peace", FarmContainer, function(s)
    if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/VertigoCool99/scripts/refs/heads/main/PeaceKeepers.lua"))() end
end, true)
createToggleBtn("Gui Product", FarmContainer, function(s)
    if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/Server87"))() end
end, true)
createToggleBtn("Infinity Yield", FarmContainer, function(s)
    if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end
end, true)

-- ===========================
-- POPULATE: BUFFS
-- ===========================
createSection(BuffsContainer, "Movimento")
local isSpeed, speedBox = createInputToggle("Speed Hack", BuffsContainer, 50)
local isJump,  jumpBox  = createInputToggle("Jump Power",  BuffsContainer, 100)

createSection(BuffsContainer, "Combate")
createToggleBtn("Noclip", BuffsContainer, function(s) isNoclipActive = s end, false)
createToggleBtn("SpinBot  (Anti-Aim)", BuffsContainer, function(s) isSpin = s end, false)
createToggleBtn("NPC Aimbot  (Aggro)", BuffsContainer, function(s) isNpcAimbotActive = s end, false)

createSection(BuffsContainer, "Visual")
createToggleBtn("X-Ray / Walls", BuffsContainer, function(s)
    if s then
        for _, v in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) and v.Transparency ~= 1 then
                    originalProps[v] = {v.Transparency, v.CanCollide}
                    v.Transparency = 0.7
                    v.CanCollide   = false
                end
            end)
        end
    else
        for part, props in pairs(originalProps) do
            pcall(function()
                if part and part.Parent then
                    part.Transparency = props[1]
                    part.CanCollide   = props[2]
                end
            end)
        end
        originalProps = {}
    end
end, false)

-- ===========================
-- POPULATE: OUTROS
-- ===========================
createSection(OutrosContainer, "Performance")
createToggleBtn("Anti Lag Ultra", OutrosContainer, function(s)
    if not s then return end
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") or v:IsA("MeshPart") then
                v.Material    = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("Sky") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("PostEffect") then
                v.Enabled = false
            end
        end)
    end
    Lighting.GlobalShadows       = false
    settings().Rendering.QualityLevel = 1
end, false)

createSection(OutrosContainer, "Interface")
createToggleBtn("Hide Icon", OutrosContainer, function(s)
    if FloatIconRef and FloatIconRef.Parent then
        tw(FloatIconRef, {BackgroundTransparency = s and 1 or 0, ImageTransparency = s and 1 or 0}, 0.2)
        local sk = FloatIconRef:FindFirstChildOfClass("UIStroke")
        if sk then sk.Enabled = not s end
    end
end, false)

createToggleBtn("PC Keybinds", OutrosContainer, function(s)
    for _, box in ipairs(allKeybindBoxes) do
        if box and box.Parent then box.Visible = s end
    end
end, false)

-- ===========================
-- GAME LOOPS
-- ===========================
RunService.RenderStepped:Connect(function()
    if not isNpcAimbotActive then return end
    local target, maxDist = nil, math.huge
    for _, model in pairs(Workspace:GetChildren()) do
        pcall(function()
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and model ~= LocalPlayer.Character and hum.Health > 0 then
                if not Players:GetPlayerFromCharacter(model) then
                    local root = model:FindFirstChild("HumanoidRootPart")
                    if root then
                        local _, onScreen = Camera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            local d = (root.Position - Camera.CFrame.Position).Magnitude
                            if d < maxDist then maxDist = d; target = root end
                        end
                    end
                end
            end
        end)
    end
    if target and target.Parent then
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.WalkSpeed = isSpeed() and (tonumber(speedBox.Text) or gameDefaultSpeed) or gameDefaultSpeed
        local jv = isJump() and (tonumber(jumpBox.Text) or gameDefaultJump) or gameDefaultJump
        if useJumpPowerProp then hum.JumpPower = jv else hum.JumpHeight = jv end
        if isNoclipActive then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if isSpin and root then
            root.CFrame *= CFrame.Angles(0, math.rad(25), 0)
        end
    end)
end)

-- ===========================
-- TAB SWITCHING
-- ===========================
local tabs = {
    { btn = FarmTabBtn,   container = FarmContainer,   title = "FARM",   ic = FarmTabIc,   nm = FarmTabNm   },
    { btn = BuffTabBtn,   container = BuffsContainer,   title = "BUFFS",  ic = BuffTabIc,   nm = BuffTabNm   },
    { btn = OutrosTabBtn, container = OutrosContainer,  title = "OUTROS", ic = OutrosTabIc, nm = OutrosTabNm },
}

local function switchTab(active)
    for _, t in ipairs(tabs) do
        local on = t == active
        t.container.Visible = on
        tw(t.btn, {BackgroundColor3 = on and C.ACCENT or C.ELEM}, 0.15)
        t.ic.TextColor3 = on and C.T1 or C.T2
        t.nm.TextColor3 = on and C.T1 or C.T3
        if on then ContentTitle.Text = t.title end
    end
end
switchTab(tabs[1])

for _, t in ipairs(tabs) do
    t.btn.MouseButton1Click:Connect(function() switchTab(t) end)
end

-- ===========================
-- LOGIN LOGIC
-- ===========================
LoginBtn.MouseButton1Click:Connect(function()
    if PasswordBox.Text == "基托里" then
        tw(LoginFrame, {BackgroundTransparency = 1}, 0.25)
        task.wait(0.3)
        LoginFrame.Visible = false

        MainFrame.Visible = true
        MainFrame.Size    = UDim2.new(0, 500, 0, 0)
        tw(MainFrame, {Size = UDim2.new(0, 500, 0, 350)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        -- Float icon
        FloatIconRef = Instance.new("ImageButton", ScreenGui)
        FloatIconRef.Size            = UDim2.new(0, 54, 0, 54)
        FloatIconRef.Position        = UDim2.new(0.02, 0, 0.5, -27)
        FloatIconRef.Image           = "rbxassetid://96351081727254"
        FloatIconRef.BackgroundColor3 = C.PANEL
        FloatIconRef.ScaleType       = Enum.ScaleType.Fit
        FloatIconRef.Draggable       = true
        FloatIconRef.AutoButtonColor = false
        FloatIconRef.BorderSizePixel = 0
        corner(FloatIconRef, 27)
        ApplyRGBStroke(FloatIconRef)

        FloatIconRef.MouseEnter:Connect(function() tw(FloatIconRef, {BackgroundColor3 = C.ELEM}, 0.15) end)
        FloatIconRef.MouseLeave:Connect(function() tw(FloatIconRef, {BackgroundColor3 = C.PANEL}, 0.15) end)

        FloatIconRef.MouseButton1Click:Connect(function()
            if MainFrame.Visible then
                MainFrame.Visible = false
            else
                MainFrame.Visible = true
                MainFrame.Size    = UDim2.new(0, 500, 0, 0)
                tw(MainFrame, {Size = UDim2.new(0, 500, 0, 350)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end
        end)

        showToast("Bem-vindo, " .. LocalPlayer.Name .. "!", true)
    else
        PasswordBox.Text = ""
        LoginError.Text  = "✕  Senha incorreta"
        -- Shake animation
        local ox = LoginFrame.Position
        for i = 1, 3 do
            tw(LoginFrame, {Position = UDim2.new(0.5, -178, 0.5, -147)}, 0.05)
            task.wait(0.055)
            tw(LoginFrame, {Position = UDim2.new(0.5, -162, 0.5, -147)}, 0.05)
            task.wait(0.055)
        end
        tw(LoginFrame, {Position = ox}, 0.05)
        task.wait(2)
        LoginError.Text = ""
    end
end)
