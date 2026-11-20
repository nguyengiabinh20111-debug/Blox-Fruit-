local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer

for _, name in ipairs({"HiroseHubLoader", "ActiveHubNotification", "HiroseCrossChatGui"}) do
	local old = CoreGui:FindFirstChild(name)
	if old then pcall(function() old:Destroy() end) end
end

local DISCORD_LINK = "https://discord.gg/uqhEpzXy9q"
local CHAT_API_URL = "https://hirosemiyano.nguyengiabinh20111.workers.dev"
local CHAT_SERVER_TAG = tostring(game.JobId ~= "" and string.sub(game.JobId, 1, 8) or "Global")
local ADMIN_ROBLOX_USERNAME = "djia9243"

local SCRIPTS = {
	Chilli = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()',
	Venyx = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"))()',
	Divine = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Aquavine/main/DivineHub"))()'
}

local SelectedHub = "Chilli"
local SoundEnabled = true
local FpsBoostEnabled = true

local function ApplyFixLag()
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		if Terrain then
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveTransparency = 1
			Terrain.WaterReflectance = 0
		end
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				v.Reflectance = 0
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			end
		end
	end)
end

local function MakeDraggable(guiObj)
	local dragging, dragInput, dragStart, startPos
	guiObj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiObj.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	guiObj.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			guiObj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function attachGui(gui)
	local ok = pcall(function() gui.Parent = CoreGui end)
	if not ok or not gui.Parent then
		if LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui") then
			gui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		end
	end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HiroseHubLoader"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
attachGui(ScreenGui)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 398)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local BgImage = Instance.new("ImageLabel")
BgImage.Parent = MainFrame
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "rbxassetid://78034177322041"
BgImage.ScaleType = Enum.ScaleType.Stretch
BgImage.ZIndex = 0
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 14)
MakeDraggable(MainFrame)

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 2

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.Size = UDim2.new(0, 210, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🌶️ CHILLI & VENYX & DIVINE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 210, 130)
TitleLabel.TextStrokeTransparency = 0.25
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

local VersionBadge = Instance.new("TextLabel")
VersionBadge.Parent = TopBar
VersionBadge.Position = UDim2.new(1, -78, 0.5, -8)
VersionBadge.Size = UDim2.new(0, 42, 0, 16)
VersionBadge.BackgroundColor3 = Color3.fromRGB(255, 105, 35)
VersionBadge.BackgroundTransparency = 0.2
VersionBadge.Font = Enum.Font.GothamBold
VersionBadge.Text = "v13.0"
VersionBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionBadge.TextSize = 9
VersionBadge.ZIndex = 2
Instance.new("UICorner", VersionBadge).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Position = UDim2.new(1, -28, 0.5, -9)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.BackgroundTransparency = 0.55
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 9
CloseBtn.ZIndex = 2
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local ProfileCard = Instance.new("Frame")
ProfileCard.Parent = MainFrame
ProfileCard.Position = UDim2.new(0, 8, 0, 34)
ProfileCard.Size = UDim2.new(1, -16, 0, 52)
ProfileCard.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ProfileCard.BackgroundTransparency = 0.68
ProfileCard.ZIndex = 2
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local IconBox = Instance.new("TextLabel")
IconBox.Parent = ProfileCard
IconBox.Position = UDim2.new(0, 8, 0.5, -14)
IconBox.Size = UDim2.new(0, 28, 0, 28)
IconBox.BackgroundColor3 = Color3.fromRGB(255, 105, 35)
IconBox.BackgroundTransparency = 0.35
IconBox.Text = "🌶️"
IconBox.TextSize = 16
IconBox.ZIndex = 2
Instance.new("UICorner", IconBox).CornerRadius = UDim.new(0, 8)

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Parent = ProfileCard
AuthorLabel.Position = UDim2.new(0, 42, 0, 3)
AuthorLabel.Size = UDim2.new(1, -50, 0, 16)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Font = Enum.Font.GothamBold
AuthorLabel.Text = "Tác giả: Hirose x Miyanno"
AuthorLabel.TextColor3 = Color3.fromRGB(255, 210, 130)
AuthorLabel.TextStrokeTransparency = 0.2
AuthorLabel.TextSize = 12.5
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
AuthorLabel.ZIndex = 2

local NameLabel = Instance.new("TextLabel")
NameLabel.Parent = ProfileCard
NameLabel.Position = UDim2.new(0, 42, 0, 19)
NameLabel.Size = UDim2.new(1, -50, 0, 13)
NameLabel.BackgroundTransparency = 1
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = "Chilli & Venyx & Divine V13 Max"
NameLabel.TextColor3 = Color3.fromRGB(255, 235, 190)
NameLabel.TextStrokeTransparency = 0.25
NameLabel.TextSize = 10
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.ZIndex = 2

local SubLabel = Instance.new("TextLabel")
SubLabel.Parent = ProfileCard
SubLabel.Position = UDim2.new(0, 42, 0, 32)
SubLabel.Size = UDim2.new(1, -50, 0, 12)
SubLabel.BackgroundTransparency = 1
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "● Sẵn sàng (Chilli VIP)"
SubLabel.TextColor3 = Color3.fromRGB(115, 255, 175)
SubLabel.TextStrokeTransparency = 0.25
SubLabel.TextSize = 9
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.ZIndex = 2
local VirexCard = Instance.new("Frame")
VirexCard.Parent = MainFrame
VirexCard.Position = UDim2.new(0, 8, 0, 90)
VirexCard.Size = UDim2.new(1, -16, 0, 34)
VirexCard.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VirexCard.BackgroundTransparency = 0.68
VirexCard.ZIndex = 2
Instance.new("UICorner", VirexCard).CornerRadius = UDim.new(0, 10)

local VirexName = Instance.new("TextLabel")
VirexName.Parent = VirexCard
VirexName.Position = UDim2.new(0, 8, 0, 3)
VirexName.Size = UDim2.new(0, 150, 0, 14)
VirexName.BackgroundTransparency = 1
VirexName.Font = Enum.Font.GothamBold
VirexName.Text = "🔍 VIREX - FINDER"
VirexName.TextColor3 = Color3.fromRGB(115, 255, 175)
VirexName.TextStrokeTransparency = 0.25
VirexName.TextSize = 10
VirexName.TextXAlignment = Enum.TextXAlignment.Left
VirexName.ZIndex = 2

local VirexDesc = Instance.new("TextLabel")
VirexDesc.Parent = VirexCard
VirexDesc.Position = UDim2.new(0, 8, 0, 17)
VirexDesc.Size = UDim2.new(0, 150, 0, 14)
VirexDesc.BackgroundTransparency = 1
VirexDesc.Font = Enum.Font.Gotham
VirexDesc.Text = "Tính năng nổi bật V13"
VirexDesc.TextColor3 = Color3.fromRGB(235, 240, 255)
VirexDesc.TextStrokeTransparency = 0.25
VirexDesc.TextSize = 8
VirexDesc.TextXAlignment = Enum.TextXAlignment.Left
VirexDesc.ZIndex = 2

local RateBadge = Instance.new("TextLabel")
RateBadge.Parent = VirexCard
RateBadge.Position = UDim2.new(1, -96, 0.5, -9)
RateBadge.Size = UDim2.new(0, 88, 0, 18)
RateBadge.BackgroundColor3 = Color3.fromRGB(25, 95, 58)
RateBadge.BackgroundTransparency = 0.25
RateBadge.Font = Enum.Font.GothamBold
RateBadge.Text = "✨ CHUẨN CAO"
RateBadge.TextColor3 = Color3.fromRGB(130, 255, 185)
RateBadge.TextSize = 8
RateBadge.ZIndex = 2
Instance.new("UICorner", RateBadge).CornerRadius = UDim.new(1, 0)

local ChatIntroCard = Instance.new("Frame")
ChatIntroCard.Parent = MainFrame
ChatIntroCard.Position = UDim2.new(0, 8, 0, 128)
ChatIntroCard.Size = UDim2.new(1, -16, 0, 34)
ChatIntroCard.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatIntroCard.BackgroundTransparency = 0.68
ChatIntroCard.ZIndex = 2
Instance.new("UICorner", ChatIntroCard).CornerRadius = UDim.new(0, 10)

local ChatIntroTitle = Instance.new("TextLabel")
ChatIntroTitle.Parent = ChatIntroCard
ChatIntroTitle.Position = UDim2.new(0, 8, 0, 3)
ChatIntroTitle.Size = UDim2.new(0, 165, 0, 14)
ChatIntroTitle.BackgroundTransparency = 1
ChatIntroTitle.Font = Enum.Font.GothamBold
ChatIntroTitle.Text = "🌐 CHAT TOÀN SERVER"
ChatIntroTitle.TextColor3 = Color3.fromRGB(255, 210, 130)
ChatIntroTitle.TextStrokeTransparency = 0.25
ChatIntroTitle.TextSize = 10
ChatIntroTitle.TextXAlignment = Enum.TextXAlignment.Left
ChatIntroTitle.ZIndex = 2

local ChatIntroDesc = Instance.new("TextLabel")
ChatIntroDesc.Parent = ChatIntroCard
ChatIntroDesc.Position = UDim2.new(0, 8, 0, 17)
ChatIntroDesc.Size = UDim2.new(0, 175, 0, 14)
ChatIntroDesc.BackgroundTransparency = 1
ChatIntroDesc.Font = Enum.Font.Gotham
ChatIntroDesc.Text = "Chat xuyên server + avatar người chơi"
ChatIntroDesc.TextColor3 = Color3.fromRGB(235, 240, 255)
ChatIntroDesc.TextStrokeTransparency = 0.25
ChatIntroDesc.TextSize = 8
ChatIntroDesc.TextXAlignment = Enum.TextXAlignment.Left
ChatIntroDesc.ZIndex = 2

local ChatIntroBadge = Instance.new("TextLabel")
ChatIntroBadge.Parent = ChatIntroCard
ChatIntroBadge.Position = UDim2.new(1, -88, 0.5, -9)
ChatIntroBadge.Size = UDim2.new(0, 80, 0, 18)
ChatIntroBadge.BackgroundColor3 = Color3.fromRGB(255, 105, 35)
ChatIntroBadge.BackgroundTransparency = 0.2
ChatIntroBadge.Font = Enum.Font.GothamBold
ChatIntroBadge.Text = "💬 TÍNH NĂNG MỚI"
ChatIntroBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatIntroBadge.TextSize = 7.5
ChatIntroBadge.ZIndex = 2
Instance.new("UICorner", ChatIntroBadge).CornerRadius = UDim.new(1, 0)

local Sec2Title = Instance.new("TextLabel")
Sec2Title.Parent = MainFrame
Sec2Title.Position = UDim2.new(0, 10, 0, 166)
Sec2Title.Size = UDim2.new(0, 90, 0, 16)
Sec2Title.BackgroundTransparency = 1
Sec2Title.Font = Enum.Font.GothamBold
Sec2Title.Text = "🎮 CHỌN HUB"
Sec2Title.TextColor3 = Color3.fromRGB(255, 210, 130)
Sec2Title.TextStrokeTransparency = 0.25
Sec2Title.TextSize = 10
Sec2Title.TextXAlignment = Enum.TextXAlignment.Left
Sec2Title.ZIndex = 2

local SoundBtn = Instance.new("TextButton")
SoundBtn.Parent = MainFrame
SoundBtn.Position = UDim2.new(1, -110, 0, 165)
SoundBtn.Size = UDim2.new(0, 102, 0, 16)
SoundBtn.BackgroundColor3 = Color3.fromRGB(32, 140, 78)
SoundBtn.BackgroundTransparency = 0.2
SoundBtn.Font = Enum.Font.GothamBold
SoundBtn.Text = "🔊 ÂM THANH: BẬT"
SoundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SoundBtn.TextSize = 8
SoundBtn.ZIndex = 2
Instance.new("UICorner", SoundBtn).CornerRadius = UDim.new(1, 0)

SoundBtn.MouseButton1Click:Connect(function()
	SoundEnabled = not SoundEnabled
	SoundBtn.Text = SoundEnabled and "🔊 ÂM THANH: BẬT" or "🔇 ÂM THANH: TẮT"
	SoundBtn.BackgroundColor3 = SoundEnabled and Color3.fromRGB(32, 140, 78) or Color3.fromRGB(60, 60, 70)
end)

local HubContainer = Instance.new("Frame")
HubContainer.Parent = MainFrame
HubContainer.Position = UDim2.new(0, 8, 0, 186)
HubContainer.Size = UDim2.new(1, -16, 0, 70)
HubContainer.BackgroundTransparency = 1
HubContainer.ZIndex = 2

local function CreateHubCard(name, pos, size, icon, title)
	local Card = Instance.new("TextButton")
	Card.Name = name
	Card.Parent = HubContainer
	Card.Position = pos
	Card.Size = size
	Card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Card.BackgroundTransparency = 0.68
	Card.Text = ""
	Card.AutoButtonColor = false
	Card.ZIndex = 2
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

	local Title = Instance.new("TextLabel")
	Title.Parent = Card
	Title.Position = UDim2.new(0, 4, 0, 4)
	Title.Size = UDim2.new(1, -8, 0, 16)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.Text = icon .. " " .. title
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextStrokeTransparency = 0.25
	Title.TextSize = 10
	Title.TextXAlignment = Enum.TextXAlignment.Center
	Title.ZIndex = 2

	local StatusPill = Instance.new("TextLabel")
	StatusPill.Name = "StatusPill"
	StatusPill.Parent = Card
	StatusPill.Position = UDim2.new(0, 6, 1, -24)
	StatusPill.Size = UDim2.new(1, -12, 0, 18)
	StatusPill.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	StatusPill.BackgroundTransparency = 0.25
	StatusPill.Font = Enum.Font.GothamBold
	StatusPill.Text = "Chọn"
	StatusPill.TextColor3 = Color3.fromRGB(235, 240, 255)
	StatusPill.TextSize = 9
	StatusPill.ZIndex = 2
	Instance.new("UICorner", StatusPill).CornerRadius = UDim.new(0, 6)

	return Card
end

local ChilliCard = CreateHubCard("ChilliCard", UDim2.new(0, 0, 0, 0), UDim2.new(0.32, 0, 1, 0), "🔥", "Chilli")
local VenyxCard = CreateHubCard("VenyxCard", UDim2.new(0.34, 0, 0, 0), UDim2.new(0.32, 0, 1, 0), "⚡", "Venyx")
local DivineCard = CreateHubCard("DivineCard", UDim2.new(0.68, 0, 0, 0), UDim2.new(0.32, 0, 1, 0), "💎", "Divine")

local function UpdateHubSelection()
	local map = {
		Chilli = {ChilliCard, Color3.fromRGB(45, 22, 12), Color3.fromRGB(255, 105, 35), "Chilli & Venyx & Divine V13 Max", "● Sẵn sàng (Chilli VIP)"},
		Venyx = {VenyxCard, Color3.fromRGB(22, 24, 52), Color3.fromRGB(110, 100, 255), "Venyx Hub V13 Max", "● Sẵn sàng (Venyx Hub 2)"},
		Divine = {DivineCard, Color3.fromRGB(14, 38, 52), Color3.fromRGB(50, 160, 220), "Divine Hub (Aquavine)", "● Sẵn sàng (Aquavine Divine)"}
	}
	for _, card in ipairs({ChilliCard, VenyxCard, DivineCard}) do
		card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		card.BackgroundTransparency = 0.68
		card.StatusPill.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		card.StatusPill.BackgroundTransparency = 0.25
		card.StatusPill.TextColor3 = Color3.fromRGB(235, 240, 255)
		card.StatusPill.Text = "Chọn"
	end
	local cfg = map[SelectedHub] or map.Chilli
	cfg[1].BackgroundColor3 = cfg[2]
	cfg[1].BackgroundTransparency = 0.55
	cfg[1].StatusPill.BackgroundColor3 = cfg[3]
	cfg[1].StatusPill.BackgroundTransparency = 0.15
	cfg[1].StatusPill.TextColor3 = Color3.fromRGB(255, 255, 255)
	cfg[1].StatusPill.Text = "✓ CHỌN"
	NameLabel.Text = cfg[4]
	SubLabel.Text = cfg[5]
end

ChilliCard.MouseButton1Click:Connect(function() SelectedHub = "Chilli" UpdateHubSelection() end)
VenyxCard.MouseButton1Click:Connect(function() SelectedHub = "Venyx" UpdateHubSelection() end)
DivineCard.MouseButton1Click:Connect(function() SelectedHub = "Divine" UpdateHubSelection() end)
UpdateHubSelection()

local FpsCard = Instance.new("Frame")
FpsCard.Parent = MainFrame
FpsCard.Position = UDim2.new(0, 8, 0, 262)
FpsCard.Size = UDim2.new(1, -16, 0, 32)
FpsCard.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FpsCard.BackgroundTransparency = 0.68
FpsCard.ZIndex = 2
Instance.new("UICorner", FpsCard).CornerRadius = UDim.new(0, 10)

local FpsTitle = Instance.new("TextLabel")
FpsTitle.Parent = FpsCard
FpsTitle.Position = UDim2.new(0, 8, 0, 3)
FpsTitle.Size = UDim2.new(0, 160, 0, 13)
FpsTitle.BackgroundTransparency = 1
FpsTitle.Font = Enum.Font.GothamBold
FpsTitle.Text = "🌙 FPS Boost & Fix Lag"
FpsTitle.TextColor3 = Color3.fromRGB(255, 210, 130)
FpsTitle.TextStrokeTransparency = 0.25
FpsTitle.TextSize = 10
FpsTitle.TextXAlignment = Enum.TextXAlignment.Left
FpsTitle.ZIndex = 2

local FpsSub = Instance.new("TextLabel")
FpsSub.Parent = FpsCard
FpsSub.Position = UDim2.new(0, 8, 0, 16)
FpsSub.Size = UDim2.new(0, 180, 0, 13)
FpsSub.BackgroundTransparency = 1
FpsSub.Font = Enum.Font.Gotham
FpsSub.Text = "Tối ưu hóa game cực mượt"
FpsSub.TextColor3 = Color3.fromRGB(235, 240, 255)
FpsSub.TextStrokeTransparency = 0.25
FpsSub.TextSize = 8
FpsSub.TextXAlignment = Enum.TextXAlignment.Left
FpsSub.ZIndex = 2

local FpsBtn = Instance.new("TextButton")
FpsBtn.Parent = FpsCard
FpsBtn.Position = UDim2.new(1, -48, 0.5, -9)
FpsBtn.Size = UDim2.new(0, 40, 0, 18)
FpsBtn.BackgroundColor3 = Color3.fromRGB(32, 150, 85)
FpsBtn.BackgroundTransparency = 0.2
FpsBtn.Font = Enum.Font.GothamBold
FpsBtn.Text = "BẬT"
FpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsBtn.TextSize = 9
FpsBtn.ZIndex = 2
Instance.new("UICorner", FpsBtn).CornerRadius = UDim.new(1, 0)

FpsBtn.MouseButton1Click:Connect(function()
	FpsBoostEnabled = not FpsBoostEnabled
	FpsBtn.Text = FpsBoostEnabled and "BẬT" or "TẮT"
	FpsBtn.BackgroundColor3 = FpsBoostEnabled and Color3.fromRGB(32, 150, 85) or Color3.fromRGB(60, 60, 70)
end)

local DiscordCard = Instance.new("Frame")
DiscordCard.Parent = MainFrame
DiscordCard.Position = UDim2.new(0, 8, 0, 298)
DiscordCard.Size = UDim2.new(1, -16, 0, 32)
DiscordCard.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DiscordCard.BackgroundTransparency = 0.68
DiscordCard.ZIndex = 2
Instance.new("UICorner", DiscordCard).CornerRadius = UDim.new(0, 10)

local DiscordTitle = Instance.new("TextLabel")
DiscordTitle.Parent = DiscordCard
DiscordTitle.Position = UDim2.new(0, 8, 0, 3)
DiscordTitle.Size = UDim2.new(0, 150, 0, 13)
DiscordTitle.BackgroundTransparency = 1
DiscordTitle.Font = Enum.Font.GothamBold
DiscordTitle.Text = "💬 DISCORD"
DiscordTitle.TextColor3 = Color3.fromRGB(170, 195, 255)
DiscordTitle.TextStrokeTransparency = 0.25
DiscordTitle.TextSize = 9
DiscordTitle.TextXAlignment = Enum.TextXAlignment.Left
DiscordTitle.ZIndex = 2

local DiscordLinkText = Instance.new("TextLabel")
DiscordLinkText.Parent = DiscordCard
DiscordLinkText.Position = UDim2.new(0, 8, 0, 16)
DiscordLinkText.Size = UDim2.new(0, 170, 0, 13)
DiscordLinkText.BackgroundTransparency = 1
DiscordLinkText.Font = Enum.Font.Gotham
DiscordLinkText.Text = DISCORD_LINK
DiscordLinkText.TextColor3 = Color3.fromRGB(235, 240, 255)
DiscordLinkText.TextStrokeTransparency = 0.25
DiscordLinkText.TextSize = 9
DiscordLinkText.TextXAlignment = Enum.TextXAlignment.Left
DiscordLinkText.ZIndex = 2

local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent = DiscordCard
CopyBtn.Position = UDim2.new(1, -70, 0.5, -9)
CopyBtn.Size = UDim2.new(0, 62, 0, 18)
CopyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
CopyBtn.BackgroundTransparency = 0.2
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Text = "📋 SAO CHÉP"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 8
CopyBtn.ZIndex = 2
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)

CopyBtn.MouseButton1Click:Connect(function()
	if setclipboard then pcall(setclipboard, DISCORD_LINK) end
	CopyBtn.Text = "✓ CHÉP"
	task.wait(1.5)
	CopyBtn.Text = "📋 SAO CHÉP"
end)

local WishContainer = Instance.new("Frame")
WishContainer.Parent = MainFrame
WishContainer.Position = UDim2.new(0, 8, 0, 334)
WishContainer.Size = UDim2.new(1, -16, 0, 20)
WishContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WishContainer.BackgroundTransparency = 0.68
WishContainer.ZIndex = 2
Instance.new("UICorner", WishContainer).CornerRadius = UDim.new(0, 8)

local WishLabel = Instance.new("TextLabel")
WishLabel.Parent = WishContainer
WishLabel.Size = UDim2.new(1, 0, 1, 0)
WishLabel.BackgroundTransparency = 1
WishLabel.Font = Enum.Font.GothamBold
WishLabel.Text = "✨ CHÚC BẠN CHƠI GAME VUI VẺ 👉👈"
WishLabel.TextColor3 = Color3.fromRGB(255, 210, 130)
WishLabel.TextStrokeTransparency = 0.25
WishLabel.TextSize = 9
WishLabel.ZIndex = 3
local reqFunc = (syn and syn.request) or (http and http.request) or request or http_request

local function safeDecode(raw)
	if type(raw) ~= "string" or raw == "" then return nil end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	return ok and decoded or nil
end

local function safeEncode(tbl)
	local ok, encoded = pcall(function() return HttpService:JSONEncode(tbl) end)
	return ok and encoded or nil
end

local ChatGui = Instance.new("ScreenGui")
ChatGui.Name = "HiroseCrossChatGui"
ChatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ChatGui.ResetOnSpawn = false
attachGui(ChatGui)

local ChatPill = Instance.new("TextButton")
ChatPill.Name = "ChatPill"
ChatPill.Parent = ChatGui
ChatPill.Position = UDim2.new(0, 12, 0.76, 0)
ChatPill.Size = UDim2.new(0, 96, 0, 28)
ChatPill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatPill.BackgroundTransparency = 0.55
ChatPill.Font = Enum.Font.GothamBold
ChatPill.Text = "💬 V13 CHAT"
ChatPill.TextColor3 = Color3.fromRGB(255, 210, 130)
ChatPill.TextStrokeTransparency = 0.25
ChatPill.TextSize = 9
ChatPill.ZIndex = 10
Instance.new("UICorner", ChatPill).CornerRadius = UDim.new(1, 0)
MakeDraggable(ChatPill)

local ChatBox = Instance.new("Frame")
ChatBox.Name = "ChatBox"
ChatBox.Parent = ChatGui
ChatBox.Position = UDim2.new(0, 10, 0.04, 0)
ChatBox.Size = UDim2.new(0, 250, 0, 372)
ChatBox.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ChatBox.BackgroundTransparency = 0.45
ChatBox.BorderSizePixel = 0
ChatBox.ClipsDescendants = true
ChatBox.Visible = false
ChatBox.ZIndex = 9
Instance.new("UICorner", ChatBox).CornerRadius = UDim.new(0, 12)
MakeDraggable(ChatBox)

local ChatBg = Instance.new("ImageLabel")
ChatBg.Name = "ChatBg"
ChatBg.Parent = ChatBox
ChatBg.Size = UDim2.new(1, 0, 1, 0)
ChatBg.Position = UDim2.new(0, 0, 0, 0)
ChatBg.Image = "rbxassetid://73666208807237"
ChatBg.ScaleType = Enum.ScaleType.Crop
ChatBg.BackgroundTransparency = 1
ChatBg.ImageTransparency = 0
ChatBg.ZIndex = 9
Instance.new("UICorner", ChatBg).CornerRadius = UDim.new(0, 12)

local ChatDim = Instance.new("Frame")
ChatDim.Parent = ChatBox
ChatDim.Size = UDim2.new(1, 0, 1, 0)
ChatDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatDim.BackgroundTransparency = 0.85
ChatDim.BorderSizePixel = 0
ChatDim.ZIndex = 9
Instance.new("UICorner", ChatDim).CornerRadius = UDim.new(0, 12)

local ChatAuthorLabel = Instance.new("TextLabel")
ChatAuthorLabel.Parent = ChatBox
ChatAuthorLabel.Position = UDim2.new(0, 8, 0, 4)
ChatAuthorLabel.Size = UDim2.new(1, -34, 0, 18)
ChatAuthorLabel.BackgroundTransparency = 1
ChatAuthorLabel.Font = Enum.Font.GothamBold
ChatAuthorLabel.Text = "Tác giả: Hirose x Miyanno"
ChatAuthorLabel.TextColor3 = Color3.fromRGB(255, 210, 130)
ChatAuthorLabel.TextStrokeTransparency = 0.2
ChatAuthorLabel.TextSize = 13
ChatAuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
ChatAuthorLabel.ZIndex = 11

local ChatDiscordSub = Instance.new("TextLabel")
ChatDiscordSub.Parent = ChatBox
ChatDiscordSub.Position = UDim2.new(0, 8, 0, 21)
ChatDiscordSub.Size = UDim2.new(1, -98, 0, 13)
ChatDiscordSub.BackgroundTransparency = 1
ChatDiscordSub.Font = Enum.Font.GothamMedium
ChatDiscordSub.Text = "https://discord.gg/uqhEpzXy9q"
ChatDiscordSub.TextColor3 = Color3.fromRGB(170, 195, 255)
ChatDiscordSub.TextStrokeTransparency = 0.25
ChatDiscordSub.TextSize = 8.5
ChatDiscordSub.TextXAlignment = Enum.TextXAlignment.Left
ChatDiscordSub.ZIndex = 11

local OnlineToggleBtn = Instance.new("TextButton")
OnlineToggleBtn.Parent = ChatBox
OnlineToggleBtn.Position = UDim2.new(1, -92, 0, 20)
OnlineToggleBtn.Size = UDim2.new(0, 64, 0, 14)
OnlineToggleBtn.BackgroundColor3 = Color3.fromRGB(16, 48, 32)
OnlineToggleBtn.BackgroundTransparency = 0.35
OnlineToggleBtn.Font = Enum.Font.GothamBold
OnlineToggleBtn.Text = "● 1 online ▾"
OnlineToggleBtn.TextColor3 = Color3.fromRGB(115, 255, 175)
OnlineToggleBtn.TextSize = 8.5
OnlineToggleBtn.ZIndex = 11
Instance.new("UICorner", OnlineToggleBtn).CornerRadius = UDim.new(1, 0)

local HideChatBtn = Instance.new("TextButton")
HideChatBtn.Parent = ChatBox
HideChatBtn.Position = UDim2.new(1, -24, 0, 5)
HideChatBtn.Size = UDim2.new(0, 18, 0, 18)
HideChatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HideChatBtn.BackgroundTransparency = 0.55
HideChatBtn.Font = Enum.Font.GothamBold
HideChatBtn.Text = "−"
HideChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideChatBtn.TextSize = 12
HideChatBtn.ZIndex = 11
Instance.new("UICorner", HideChatBtn).CornerRadius = UDim.new(0, 5)

local MsgScroll = Instance.new("ScrollingFrame")
MsgScroll.Parent = ChatBox
MsgScroll.Position = UDim2.new(0, 6, 0, 37)
MsgScroll.Size = UDim2.new(1, -12, 1, -71)
MsgScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MsgScroll.BackgroundTransparency = 0.88
MsgScroll.BorderSizePixel = 0
MsgScroll.ScrollBarThickness = 3
MsgScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
MsgScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MsgScroll.ZIndex = 10
Instance.new("UICorner", MsgScroll).CornerRadius = UDim.new(0, 8)

local MsgLayout = Instance.new("UIListLayout")
MsgLayout.Parent = MsgScroll
MsgLayout.SortOrder = Enum.SortOrder.LayoutOrder
MsgLayout.Padding = UDim.new(0, 5)

local MsgPad = Instance.new("UIPadding")
MsgPad.Parent = MsgScroll
MsgPad.PaddingTop = UDim.new(0, 5)
MsgPad.PaddingBottom = UDim.new(0, 5)
MsgPad.PaddingLeft = UDim.new(0, 5)
MsgPad.PaddingRight = UDim.new(0, 5)

local OnlinePanel = Instance.new("Frame")
OnlinePanel.Name = "OnlinePanel"
OnlinePanel.Parent = ChatBox
OnlinePanel.Position = UDim2.new(0, 6, 0, 37)
OnlinePanel.Size = UDim2.new(1, -12, 1, -43)
OnlinePanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OnlinePanel.BackgroundTransparency = 0.75
OnlinePanel.BorderSizePixel = 0
OnlinePanel.Visible = false
OnlinePanel.ZIndex = 13
Instance.new("UICorner", OnlinePanel).CornerRadius = UDim.new(0, 8)

local BackFromOnlineBtn = Instance.new("TextButton")
BackFromOnlineBtn.Parent = OnlinePanel
BackFromOnlineBtn.Position = UDim2.new(0, 6, 0, 4)
BackFromOnlineBtn.Size = UDim2.new(0, 62, 0, 18)
BackFromOnlineBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 35)
BackFromOnlineBtn.BackgroundTransparency = 0.2
BackFromOnlineBtn.Font = Enum.Font.GothamBold
BackFromOnlineBtn.Text = "< Quay lại"
BackFromOnlineBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackFromOnlineBtn.TextSize = 8.5
BackFromOnlineBtn.ZIndex = 14
Instance.new("UICorner", BackFromOnlineBtn).CornerRadius = UDim.new(0, 6)

local OnlineListTitle = Instance.new("TextLabel")
OnlineListTitle.Parent = OnlinePanel
OnlineListTitle.Position = UDim2.new(0, 74, 0, 4)
OnlineListTitle.Size = UDim2.new(1, -80, 0, 18)
OnlineListTitle.BackgroundTransparency = 1
OnlineListTitle.Font = Enum.Font.GothamBold
OnlineListTitle.Text = "Đang bật script · 1"
OnlineListTitle.TextColor3 = Color3.fromRGB(115, 255, 175)
OnlineListTitle.TextStrokeTransparency = 0.25
OnlineListTitle.TextSize = 9.5
OnlineListTitle.TextXAlignment = Enum.TextXAlignment.Right
OnlineListTitle.ZIndex = 14

local OnlineScroll = Instance.new("ScrollingFrame")
OnlineScroll.Parent = OnlinePanel
OnlineScroll.Position = UDim2.new(0, 5, 0, 26)
OnlineScroll.Size = UDim2.new(1, -10, 1, -30)
OnlineScroll.BackgroundTransparency = 1
OnlineScroll.BorderSizePixel = 0
OnlineScroll.ScrollBarThickness = 3
OnlineScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
OnlineScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
OnlineScroll.ZIndex = 14

local OnlineLayout = Instance.new("UIListLayout")
OnlineLayout.Parent = OnlineScroll
OnlineLayout.SortOrder = Enum.SortOrder.LayoutOrder
OnlineLayout.Padding = UDim.new(0, 4)
local avatarCache, userIdCache, activeScriptUsers = {}, {}, {}

local function resolveUserId(username, userId)
	local idNum = tonumber(userId)
	if idNum and idNum > 0 then return idNum end
	local uname = tostring(username or "")
	if uname == "" or uname == "Player" or uname == "Hệ thống" or uname == "Hirose x Miyanno" then return nil end
	if userIdCache[uname] then return userIdCache[uname] end
	local plr = Players:FindFirstChild(uname)
	if plr and plr.UserId > 0 then userIdCache[uname] = plr.UserId return plr.UserId end
	local ok, fetchedId = pcall(function() return Players:GetUserIdFromNameAsync(uname) end)
	if ok and tonumber(fetchedId) and tonumber(fetchedId) > 0 then
		userIdCache[uname] = tonumber(fetchedId)
		return tonumber(fetchedId)
	end
	return nil
end

local function applyAvatarAsync(avatarImg, username, userId)
	task.spawn(function()
		local idNum = resolveUserId(username, userId)
		if not idNum then return end
		if avatarCache[idNum] then
			if avatarImg and avatarImg.Parent then avatarImg.Image = avatarCache[idNum] end
			return
		end
		local ok, url = pcall(function()
			return Players:GetUserThumbnailAsync(idNum, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and type(url) == "string" and url ~= "" then
			avatarCache[idNum] = url
			if avatarImg and avatarImg.Parent then avatarImg.Image = url end
		end
	end)
end

local function rebuildOnlineList()
	for _, child in ipairs(OnlineScroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	local count = 0
	for _, info in pairs(activeScriptUsers) do
		count += 1
		local item = Instance.new("Frame")
		item.Parent = OnlineScroll
		item.LayoutOrder = count
		item.Size = UDim2.new(1, 0, 0, 34)
		item.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		item.BackgroundTransparency = 0.72
		item.BorderSizePixel = 0
		item.ZIndex = 15
		Instance.new("UICorner", item).CornerRadius = UDim.new(0, 7)

		local av = Instance.new("ImageLabel")
		av.Parent = item
		av.Position = UDim2.new(0, 5, 0.5, -12)
		av.Size = UDim2.new(0, 24, 0, 24)
		av.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		av.BackgroundTransparency = 0.65
		av.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		av.ScaleType = Enum.ScaleType.Crop
		av.ZIndex = 16
		Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
		applyAvatarAsync(av, info.realName, info.userId)

		local editedLbl = Instance.new("TextLabel")
		editedLbl.Parent = item
		editedLbl.Position = UDim2.new(0, 34, 0, 3)
		editedLbl.Size = UDim2.new(1, -40, 0, 14)
		editedLbl.BackgroundTransparency = 1
		editedLbl.Font = Enum.Font.GothamBold
		editedLbl.Text = tostring(info.editedName or info.realName)
		editedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		editedLbl.TextStrokeTransparency = 0.25
		editedLbl.TextSize = 10.5
		editedLbl.TextXAlignment = Enum.TextXAlignment.Left
		editedLbl.ZIndex = 16

		local rawLbl = Instance.new("TextLabel")
		rawLbl.Parent = item
		rawLbl.Position = UDim2.new(0, 34, 0, 17)
		rawLbl.Size = UDim2.new(1, -40, 0, 13)
		rawLbl.BackgroundTransparency = 1
		rawLbl.Font = Enum.Font.Gotham
		rawLbl.Text = "@" .. tostring(info.realName)
		rawLbl.TextColor3 = Color3.fromRGB(185, 200, 225)
		rawLbl.TextStrokeTransparency = 0.25
		rawLbl.TextSize = 8.5
		rawLbl.TextXAlignment = Enum.TextXAlignment.Left
		rawLbl.ZIndex = 16
	end
	local finalCount = math.max(1, count)
	OnlineToggleBtn.Text = "● " .. tostring(finalCount) .. " online ▾"
	OnlineListTitle.Text = "Đang bật script · " .. tostring(finalCount)
end

local function registerScriptUser(realName, editedName, userId)
	local rName = tostring(realName or "")
	if rName == "" or rName == "Player" or rName == "Hệ thống" or rName == "Hirose x Miyanno" then return end
	local eName = tostring(editedName or "")
	if eName == "" then
		local plr = Players:FindFirstChild(rName)
		eName = (plr and plr.DisplayName) or rName
	end
	activeScriptUsers[rName] = { realName = rName, editedName = eName, userId = tonumber(userId) or 0 }
	rebuildOnlineList()
end

OnlineToggleBtn.MouseButton1Click:Connect(function() rebuildOnlineList() OnlinePanel.Visible = not OnlinePanel.Visible end)
BackFromOnlineBtn.MouseButton1Click:Connect(function() OnlinePanel.Visible = false end)

local function formatTimeShort(ts)
	local num = tonumber(ts)
	if num and num > 0 then
		if num > 1e11 then num = math.floor(num / 1000) end
		local ok, dt = pcall(function() return os.date("%H:%M", num) end)
		if ok and type(dt) == "string" and #dt == 5 then return dt end
	end
	local okNow, nowStr = pcall(function() return os.date("%H:%M") end)
	return (okNow and nowStr) or "22:48"
end

local msgOrder = 0
local function appendChatLine(username, text, userId, timestamp, customColor)
	msgOrder += 1
	local safeUser = tostring(username or "Player")
	local safeText = tostring(text or "")
	local myName = (LocalPlayer and LocalPlayer.Name) or ""
	local isSelf = (myName ~= "" and safeUser == myName)
	local isAdmin = (safeUser == ADMIN_ROBLOX_USERNAME)
	local timeStr = formatTimeShort(timestamp)

	local row = Instance.new("Frame")
	row.Name = "MsgRow_" .. tostring(msgOrder)
	row.Parent = MsgScroll
	row.LayoutOrder = msgOrder
	row.Size = UDim2.new(1, 0, 0, 42)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.BackgroundColor3 = isSelf and Color3.fromRGB(35, 22, 12) or Color3.fromRGB(0, 0, 0)
	row.BackgroundTransparency = isSelf and 0.76 or 0.82
	row.BorderSizePixel = 0
	row.ZIndex = 10
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Parent = row
	avatarImg.Size = UDim2.new(0, 26, 0, 26)
	avatarImg.Position = isSelf and UDim2.new(1, -31, 0, 6) or UDim2.new(0, 5, 0, 6)
	avatarImg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	avatarImg.BackgroundTransparency = 0.65
	avatarImg.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	avatarImg.ScaleType = Enum.ScaleType.Crop
	avatarImg.ZIndex = 11
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
	applyAvatarAsync(avatarImg, safeUser, userId)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Parent = row
	nameLabel.Position = isSelf and UDim2.new(0, 6, 0, 3) or UDim2.new(0, 35, 0, 3)
	nameLabel.Size = UDim2.new(1, -41, 0, 14)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = safeUser .. (isAdmin and " [ADMIN]" or "") .. " · " .. timeStr
	nameLabel.TextColor3 = customColor or (isAdmin and Color3.fromRGB(255, 95, 95) or (isSelf and Color3.fromRGB(255, 210, 125) or Color3.fromRGB(165, 225, 255)))
	nameLabel.TextStrokeTransparency = 0.25
	nameLabel.TextSize = 10.5
	nameLabel.TextWrapped = true
	nameLabel.TextXAlignment = isSelf and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
	nameLabel.ZIndex = 11

	local bodyLabel = Instance.new("TextLabel")
	bodyLabel.Parent = row
	bodyLabel.Position = isSelf and UDim2.new(0, 6, 0, 17) or UDim2.new(0, 35, 0, 17)
	bodyLabel.Size = UDim2.new(1, -41, 0, 16)
	bodyLabel.AutomaticSize = Enum.AutomaticSize.Y
	bodyLabel.BackgroundTransparency = 1
	bodyLabel.Font = Enum.Font.GothamMedium
	bodyLabel.Text = safeText
	bodyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	bodyLabel.TextStrokeTransparency = 0.25
	bodyLabel.TextSize = 11.5
	bodyLabel.TextWrapped = true
	bodyLabel.TextXAlignment = isSelf and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
	bodyLabel.ZIndex = 11

	local rowPad = Instance.new("UIPadding")
	rowPad.Parent = row
	rowPad.PaddingBottom = UDim.new(0, 5)

	task.defer(function()
		MsgScroll.CanvasPosition = Vector2.new(0, math.max(0, MsgScroll.AbsoluteCanvasSize.Y - MsgScroll.AbsoluteWindowSize.Y))
	end)
end

local ChatInput = Instance.new("TextBox")
ChatInput.Parent = ChatBox
ChatInput.Position = UDim2.new(0, 6, 1, -27)
ChatInput.Size = UDim2.new(1, -54, 0, 22)
ChatInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatInput.BackgroundTransparency = 0.78
ChatInput.Font = Enum.Font.Gotham
ChatInput.PlaceholderText = "Nhập tin nhắn..."
ChatInput.PlaceholderColor3 = Color3.fromRGB(205, 210, 225)
ChatInput.Text = ""
ChatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatInput.TextSize = 10.5
ChatInput.ClearTextOnFocus = false
ChatInput.ZIndex = 11
Instance.new("UICorner", ChatInput).CornerRadius = UDim.new(0, 6)

local SendChatBtn = Instance.new("TextButton")
SendChatBtn.Parent = ChatBox
SendChatBtn.Position = UDim2.new(1, -44, 1, -27)
SendChatBtn.Size = UDim2.new(0, 38, 0, 22)
SendChatBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 35)
SendChatBtn.BackgroundTransparency = 0.15
SendChatBtn.Font = Enum.Font.GothamBold
SendChatBtn.Text = "GỬI"
SendChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendChatBtn.TextSize = 10
SendChatBtn.ZIndex = 11
Instance.new("UICorner", SendChatBtn).CornerRadius = UDim.new(0, 6)

ChatPill.MouseButton1Click:Connect(function() ChatBox.Visible = not ChatBox.Visible if not ChatBox.Visible then OnlinePanel.Visible = false end end)
HideChatBtn.MouseButton1Click:Connect(function() ChatBox.Visible = false OnlinePanel.Visible = false end)

local isSending = false
local function sendCrossChat()
	if isSending or not reqFunc then return end
	local rawText = ChatInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if rawText == "" then return end
	if #rawText > 200 then rawText = string.sub(rawText, 1, 200) end
	isSending = true
	SendChatBtn.Text = "..."
	ChatInput.Text = ""
	local payload = safeEncode({
		user = (LocalPlayer and LocalPlayer.Name) or "Player",
		displayName = (LocalPlayer and LocalPlayer.DisplayName) or ((LocalPlayer and LocalPlayer.Name) or "Player"),
		userId = (LocalPlayer and LocalPlayer.UserId) or 0,
		text = rawText,
		server = CHAT_SERVER_TAG
	})
	task.spawn(function()
		local ok, res = pcall(function()
			return reqFunc({ Url = CHAT_API_URL .. "/send", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload })
		end)
		isSending = false
		SendChatBtn.Text = "GỬI"
		if not (ok and res and (res.StatusCode == 200 or res.Success)) then
			appendChatLine("Hệ thống", "Gửi lỗi, thử lại sau", 0, os.time(), Color3.fromRGB(255, 110, 110))
		end
	end)
end

SendChatBtn.MouseButton1Click:Connect(sendCrossChat)
ChatInput.FocusLost:Connect(function(enterPressed) if enterPressed then sendCrossChat() end end)

local lastMsgId = 0
task.spawn(function()
	if not reqFunc then return end
	local myUser = (LocalPlayer and LocalPlayer.Name) or "Player"
	local myDisplay = (LocalPlayer and LocalPlayer.DisplayName) or myUser
	local myId = (LocalPlayer and LocalPlayer.UserId) or 0
	registerScriptUser(myUser, myDisplay, myId)
	appendChatLine("Hirose x Miyanno", "Đã kết nối chat xuyên server!", 0, os.time(), Color3.fromRGB(110, 255, 175))

	local function syncActiveUsers(listData)
		if type(listData) ~= "table" then return end
		local fresh = { [myUser] = { realName = myUser, editedName = myDisplay, userId = myId } }
		for _, u in ipairs(listData) do
			if type(u) == "table" then
				local rName = tostring(u.user or u.username or u.realName or "")
				if rName ~= "" and rName ~= "Player" then
					fresh[rName] = { realName = rName, editedName = tostring(u.displayName or u.editedName or u.nick or rName), userId = tonumber(u.userId) or 0 }
				end
			elseif type(u) == "string" and u ~= "" then
				fresh[u] = { realName = u, editedName = u, userId = 0 }
			end
		end
		activeScriptUsers = fresh
		rebuildOnlineList()
	end

	task.spawn(function()
		while true do
			pcall(function()
				local r = reqFunc({
					Url = CHAT_API_URL .. "/ping",
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = safeEncode({ user = myUser, displayName = myDisplay, userId = myId, server = CHAT_SERVER_TAG })
				})
				if r and r.Body then
					local pData = safeDecode(r.Body)
					if type(pData) == "table" then
						syncActiveUsers(pData.users or pData.activeUsers)
					end
				end
			end)
			task.wait(25)
		end
	end)

	while true do
		local url = CHAT_API_URL .. "/messages" .. (lastMsgId > 0 and ("?after=" .. tostring(lastMsgId)) or "")
		local ok, res = pcall(function() return reqFunc({ Url = url, Method = "GET" }) end)
		if ok and res and (res.StatusCode == 200 or res.Success) then
			local data = safeDecode(res.Body)
			if type(data) == "table" and data.ok then
				syncActiveUsers(data.users or data.activeUsers)
				if type(data.messages) == "table" then
					for _, m in ipairs(data.messages) do
						local mid = tonumber(m.id) or 0
						if mid > lastMsgId then
							lastMsgId = mid
							appendChatLine(tostring(m.user or "Player"), tostring(m.text or ""), m.userId, m.time or m.timestamp or m.createdAt)
						end
					end
				end
			end
		end
		task.wait(2)
	end
end)

local RunBtn = Instance.new("TextButton")
RunBtn.Parent = MainFrame
RunBtn.Position = UDim2.new(0, 8, 0, 360)
RunBtn.Size = UDim2.new(1, -16, 0, 24)
RunBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 35)
RunBtn.Font = Enum.Font.GothamBold
RunBtn.Text = "🚀 CHẠY SCRIPT"
RunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RunBtn.TextSize = 10
RunBtn.ZIndex = 2
Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(1, 0)

RunBtn.MouseButton1Click:Connect(function()
	RunBtn.Text = "⏳ ĐANG TẢI & FIX LAG..."
	if FpsBoostEnabled then ApplyFixLag() end

	local hubTitleText = SelectedHub == "Venyx" and "Venyx Hub V13 Max" or (SelectedHub == "Divine" and "Divine Hub (Aquavine)" or "Chilli & Venyx & Divine V13 Max")
	local ActiveGui = Instance.new("ScreenGui")
	ActiveGui.Name = "ActiveHubNotification"
	ActiveGui.ResetOnSpawn = false
	attachGui(ActiveGui)

	local NotifFrame = Instance.new("Frame")
	NotifFrame.Parent = ActiveGui
	NotifFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	NotifFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	NotifFrame.Size = UDim2.new(0, 240, 0, 56)
	NotifFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
	NotifFrame.BackgroundTransparency = 0.2
	Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(1, 0)

	local RainbowStroke = Instance.new("UIStroke", NotifFrame)
	RainbowStroke.Thickness = 2.5
	task.spawn(function()
		local hue = 0
		while RainbowStroke and RainbowStroke.Parent do
			hue = (hue + 0.01) % 1
			RainbowStroke.Color = Color3.fromHSV(hue, 1, 1)
			task.wait(0.04)
		end
	end)
	MakeDraggable(NotifFrame)

	local IconContainer = Instance.new("Frame", NotifFrame)
	IconContainer.Position = UDim2.new(0, 8, 0.5, -13)
	IconContainer.Size = UDim2.new(0, 26, 0, 26)
	IconContainer.BackgroundTransparency = 1
	local IconImage = Instance.new("ImageLabel", IconContainer)
	IconImage.Size = UDim2.new(1, 0, 1, 0)
	IconImage.BackgroundTransparency = 1
	IconImage.Image = "rbxassetid://83467411655369"
	IconImage.ScaleType = Enum.ScaleType.Crop
	Instance.new("UICorner", IconImage).CornerRadius = UDim.new(1, 0)

	local NotifTitle = Instance.new("TextLabel", NotifFrame)
	NotifTitle.Position = UDim2.new(0, 38, 0, 5)
	NotifTitle.Size = UDim2.new(1, -75, 0, 15)
	NotifTitle.BackgroundTransparency = 1
	NotifTitle.Font = Enum.Font.GothamBold
	NotifTitle.Text = hubTitleText
	NotifTitle.TextColor3 = Color3.fromRGB(255, 190, 120)
	NotifTitle.TextSize = 9
	NotifTitle.TextXAlignment = Enum.TextXAlignment.Left

	local NotifSub = Instance.new("TextLabel", NotifFrame)
	NotifSub.Position = UDim2.new(0, 38, 0, 21)
	NotifSub.Size = UDim2.new(1, -75, 0, 14)
	NotifSub.BackgroundTransparency = 1
	NotifSub.Font = Enum.Font.GothamBold
	NotifSub.Text = "👤 Tác giả: Hirose x Miyanno | 💬 Bấm copy link"
	NotifSub.TextColor3 = Color3.fromRGB(255, 100, 100)
	NotifSub.TextSize = 7.5
	NotifSub.TextXAlignment = Enum.TextXAlignment.Left

	local NotifDetail = Instance.new("TextLabel", NotifFrame)
	NotifDetail.Position = UDim2.new(0, 38, 0, 35)
	NotifDetail.Size = UDim2.new(1, -75, 0, 14)
	NotifDetail.BackgroundTransparency = 1
	NotifDetail.Font = Enum.Font.GothamMedium
	NotifDetail.Text = "discord.gg/uqhEpzXy9q"
	NotifDetail.TextColor3 = Color3.fromRGB(160, 170, 255)
	NotifDetail.TextSize = 8
	NotifDetail.TextXAlignment = Enum.TextXAlignment.Left

	local ClickBtn = Instance.new("TextButton", NotifFrame)
	ClickBtn.Position = UDim2.new(0, 38, 0, 0)
	ClickBtn.Size = UDim2.new(1, -75, 1, 0)
	ClickBtn.BackgroundTransparency = 1
	ClickBtn.Text = ""
	ClickBtn.MouseButton1Click:Connect(function()
		if setclipboard then pcall(setclipboard, DISCORD_LINK) end
		NotifTitle.Text = "✓ ĐÃ SAO CHÉP LINK!"
		task.wait(1.5)
		NotifTitle.Text = hubTitleText
	end)

	local MinimizeText = Instance.new("TextLabel", NotifFrame)
	MinimizeText.Position = UDim2.new(0, 12, 0, 0)
	MinimizeText.Size = UDim2.new(1, -44, 1, 0)
	MinimizeText.BackgroundTransparency = 1
	MinimizeText.Font = Enum.Font.GothamBold
	MinimizeText.Text = "Tác Giả: Hirose x Miyanno"
	MinimizeText.TextColor3 = Color3.fromRGB(255, 120, 120)
	MinimizeText.TextSize = 9
	MinimizeText.TextXAlignment = Enum.TextXAlignment.Left
	MinimizeText.Visible = false

	local ToggleBtn = Instance.new("TextButton", NotifFrame)
	ToggleBtn.Position = UDim2.new(1, -32, 0.5, -14)
	ToggleBtn.Size = UDim2.new(0, 26, 0, 26)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	ToggleBtn.Font = Enum.Font.GothamBold
	ToggleBtn.Text = "▲"
	ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleBtn.TextSize = 11
	Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

	local isMinimized = false
	ToggleBtn.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			ToggleBtn.Text = "▼"
			TweenService:Create(NotifFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 160, 0, 32)}):Play()
			NotifTitle.Visible = false
			NotifSub.Visible = false
			NotifDetail.Visible = false
			IconContainer.Visible = false
			MinimizeText.Visible = true
		else
			ToggleBtn.Text = "▲"
			TweenService:Create(NotifFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 240, 0, 56)}):Play()
			MinimizeText.Visible = false
			task.wait(0.1)
			NotifTitle.Visible = true
			NotifSub.Visible = true
			NotifDetail.Visible = true
			IconContainer.Visible = true
		end
	end)

	local targetCode = SCRIPTS[SelectedHub]
	task.spawn(function()
		local func, err = loadstring(targetCode)
		if func then func() else warn("Lỗi load script: " .. tostring(err)) end
	end)

	task.wait(0.5)
	ScreenGui:Destroy()
end)
