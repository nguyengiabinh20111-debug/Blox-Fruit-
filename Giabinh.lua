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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HiroseHubLoader"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 386)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 105, 35)
MainStroke.Thickness = 1.5

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
TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

local VersionBadge = Instance.new("TextLabel")
VersionBadge.Parent = TopBar
VersionBadge.Position = UDim2.new(1, -78, 0.5, -8)
VersionBadge.Size = UDim2.new(0, 42, 0, 16)
VersionBadge.BackgroundColor3 = Color3.fromRGB(50, 30, 20)
VersionBadge.Font = Enum.Font.GothamBold
VersionBadge.Text = "v13.0"
VersionBadge.TextColor3 = Color3.fromRGB(255, 140, 50)
VersionBadge.TextSize = 9
VersionBadge.ZIndex = 2
Instance.new("UICorner", VersionBadge).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Position = UDim2.new(1, -28, 0.5, -9)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
CloseBtn.TextSize = 9
CloseBtn.ZIndex = 2
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local ProfileCard = Instance.new("Frame")
ProfileCard.Parent = MainFrame
ProfileCard.Position = UDim2.new(0, 8, 0, 34)
ProfileCard.Size = UDim2.new(1, -16, 0, 52)
ProfileCard.BackgroundColor3 = Color3.fromRGB(25, 12, 14)
ProfileCard.BackgroundTransparency = 0.35
ProfileCard.ZIndex = 2
Instance.new("UIStroke", ProfileCard).Color = Color3.fromRGB(120, 45, 45)
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local IconBox = Instance.new("TextLabel")
IconBox.Parent = ProfileCard
IconBox.Position = UDim2.new(0, 8, 0.5, -14)
IconBox.Size = UDim2.new(0, 28, 0, 28)
IconBox.BackgroundColor3 = Color3.fromRGB(60, 25, 28)
IconBox.Text = "🌶️"
IconBox.TextSize = 16
IconBox.ZIndex = 2
Instance.new("UICorner", IconBox).CornerRadius = UDim.new(0, 8)

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Parent = ProfileCard
AuthorLabel.Position = UDim2.new(0, 42, 0, 3)
AuthorLabel.Size = UDim2.new(1, -50, 0, 15)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Font = Enum.Font.GothamBold
AuthorLabel.Text = "Tác giả: Hirose x Miyanno"
AuthorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
AuthorLabel.TextSize = 11
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
AuthorLabel.ZIndex = 2

local NameLabel = Instance.new("TextLabel")
NameLabel.Parent = ProfileCard
NameLabel.Position = UDim2.new(0, 42, 0, 18)
NameLabel.Size = UDim2.new(1, -50, 0, 13)
NameLabel.BackgroundTransparency = 1
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = "Chilli & Venyx & Divine V13 Max"
NameLabel.TextColor3 = Color3.fromRGB(255, 190, 120)
NameLabel.TextSize = 10
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.ZIndex = 2

local SubLabel = Instance.new("TextLabel")
SubLabel.Parent = ProfileCard
SubLabel.Position = UDim2.new(0, 42, 0, 31)
SubLabel.Size = UDim2.new(1, -50, 0, 12)
SubLabel.BackgroundTransparency = 1
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "● Sẵn sàng (Chilli VIP)"
SubLabel.TextColor3 = Color3.fromRGB(90, 240, 140)
SubLabel.TextSize = 9
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.ZIndex = 2

local VirexCard = Instance.new("Frame")
VirexCard.Parent = MainFrame
VirexCard.Position = UDim2.new(0, 8, 0, 90)
VirexCard.Size = UDim2.new(1, -16, 0, 34)
VirexCard.BackgroundColor3 = Color3.fromRGB(12, 35, 26)
VirexCard.BackgroundTransparency = 0.35
VirexCard.ZIndex = 2
Instance.new("UIStroke", VirexCard).Color = Color3.fromRGB(40, 110, 80)
Instance.new("UICorner", VirexCard).CornerRadius = UDim.new(0, 10)

local VirexName = Instance.new("TextLabel")
VirexName.Parent = VirexCard
VirexName.Position = UDim2.new(0, 8, 0, 3)
VirexName.Size = UDim2.new(0, 150, 0, 14)
VirexName.BackgroundTransparency = 1
VirexName.Font = Enum.Font.GothamBold
VirexName.Text = "🔍 VIREX - FINDER"
VirexName.TextColor3 = Color3.fromRGB(100, 255, 180)
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
VirexDesc.TextColor3 = Color3.fromRGB(180, 210, 195)
VirexDesc.TextSize = 8
VirexDesc.TextXAlignment = Enum.TextXAlignment.Left
VirexDesc.ZIndex = 2

local RateBadge = Instance.new("TextLabel")
RateBadge.Parent = VirexCard
RateBadge.Position = UDim2.new(1, -96, 0.5, -9)
RateBadge.Size = UDim2.new(0, 88, 0, 18)
RateBadge.BackgroundColor3 = Color3.fromRGB(30, 80, 60)
RateBadge.Font = Enum.Font.GothamBold
RateBadge.Text = "✨ CHUẨN CAO"
RateBadge.TextColor3 = Color3.fromRGB(120, 255, 190)
RateBadge.TextSize = 8
RateBadge.ZIndex = 2
Instance.new("UICorner", RateBadge).CornerRadius = UDim.new(1, 0)

local Sec2Title = Instance.new("TextLabel")
Sec2Title.Parent = MainFrame
Sec2Title.Position = UDim2.new(0, 10, 0, 128)
Sec2Title.Size = UDim2.new(0, 90, 0, 16)
Sec2Title.BackgroundTransparency = 1
Sec2Title.Font = Enum.Font.GothamBold
Sec2Title.Text = "🎮 CHỌN HUB"
Sec2Title.TextColor3 = Color3.fromRGB(240, 240, 250)
Sec2Title.TextSize = 10
Sec2Title.TextXAlignment = Enum.TextXAlignment.Left
Sec2Title.ZIndex = 2

local SoundBtn = Instance.new("TextButton")
SoundBtn.Parent = MainFrame
SoundBtn.Position = UDim2.new(1, -110, 0, 127)
SoundBtn.Size = UDim2.new(0, 102, 0, 16)
SoundBtn.BackgroundColor3 = Color3.fromRGB(32, 140, 78)
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
HubContainer.Position = UDim2.new(0, 8, 0, 148)
HubContainer.Size = UDim2.new(1, -16, 0, 70)
HubContainer.BackgroundTransparency = 1
HubContainer.ZIndex = 2

local function CreateHubCard(name, pos, size, icon, title)
	local Card = Instance.new("TextButton")
	Card.Name = name
	Card.Parent = HubContainer
	Card.Position = pos
	Card.Size = size
	Card.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	Card.BackgroundTransparency = 0.3
	Card.Text = ""
	Card.AutoButtonColor = false
	Card.ZIndex = 2
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

	local Stroke = Instance.new("UIStroke", Card)
	Stroke.Name = "Stroke"
	Stroke.Color = Color3.fromRGB(80, 80, 100)
	Stroke.Thickness = 1.2

	local Title = Instance.new("TextLabel")
	Title.Parent = Card
	Title.Position = UDim2.new(0, 4, 0, 4)
	Title.Size = UDim2.new(1, -8, 0, 16)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.Text = icon .. " " .. title
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 10
	Title.TextXAlignment = Enum.TextXAlignment.Center
	Title.ZIndex = 2

	local StatusPill = Instance.new("TextLabel")
	StatusPill.Name = "StatusPill"
	StatusPill.Parent = Card
	StatusPill.Position = UDim2.new(0, 6, 1, -24)
	StatusPill.Size = UDim2.new(1, -12, 0, 18)
	StatusPill.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
	StatusPill.Font = Enum.Font.GothamBold
	StatusPill.Text = "Chọn"
	StatusPill.TextColor3 = Color3.fromRGB(220, 220, 230)
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
		Chilli = {ChilliCard, Color3.fromRGB(80, 30, 22), Color3.fromRGB(245, 100, 50), "Chilli & Venyx & Divine V13 Max", "● Sẵn sàng (Chilli VIP)"},
		Venyx = {VenyxCard, Color3.fromRGB(38, 35, 85), Color3.fromRGB(110, 100, 255), "Venyx Hub V13 Max", "● Sẵn sàng (Venyx Hub 2)"},
		Divine = {DivineCard, Color3.fromRGB(20, 60, 80), Color3.fromRGB(50, 160, 220), "Divine Hub (Aquavine)", "● Sẵn sàng (Aquavine Divine)"}
	}
	for _, card in ipairs({ChilliCard, VenyxCard, DivineCard}) do
		card.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
		card.Stroke.Color = Color3.fromRGB(80, 80, 100)
		card.Stroke.Thickness = 1.2
		card.StatusPill.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
		card.StatusPill.TextColor3 = Color3.fromRGB(220, 220, 230)
		card.StatusPill.Text = "Chọn"
	end
	local cfg = map[SelectedHub] or map.Chilli
	cfg[1].BackgroundColor3 = cfg[2]
	cfg[1].Stroke.Color = Color3.fromRGB(255, 255, 255)
	cfg[1].Stroke.Thickness = 1.8
	cfg[1].StatusPill.BackgroundColor3 = cfg[3]
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
FpsCard.Position = UDim2.new(0, 8, 0, 224)
FpsCard.Size = UDim2.new(1, -16, 0, 32)
FpsCard.BackgroundColor3 = Color3.fromRGB(20, 28, 35)
FpsCard.BackgroundTransparency = 0.35
FpsCard.ZIndex = 2
Instance.new("UICorner", FpsCard).CornerRadius = UDim.new(0, 10)

local FpsTitle = Instance.new("TextLabel")
FpsTitle.Parent = FpsCard
FpsTitle.Position = UDim2.new(0, 8, 0, 3)
FpsTitle.Size = UDim2.new(0, 160, 0, 13)
FpsTitle.BackgroundTransparency = 1
FpsTitle.Font = Enum.Font.GothamBold
FpsTitle.Text = "🌙 FPS Boost & Fix Lag"
FpsTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
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
FpsSub.TextColor3 = Color3.fromRGB(180, 180, 195)
FpsSub.TextSize = 8
FpsSub.TextXAlignment = Enum.TextXAlignment.Left
FpsSub.ZIndex = 2

local FpsBtn = Instance.new("TextButton")
FpsBtn.Parent = FpsCard
FpsBtn.Position = UDim2.new(1, -48, 0.5, -9)
FpsBtn.Size = UDim2.new(0, 40, 0, 18)
FpsBtn.BackgroundColor3 = Color3.fromRGB(32, 150, 85)
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
DiscordCard.Position = UDim2.new(0, 8, 0, 260)
DiscordCard.Size = UDim2.new(1, -16, 0, 32)
DiscordCard.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
DiscordCard.BackgroundTransparency = 0.35
DiscordCard.ZIndex = 2
Instance.new("UICorner", DiscordCard).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", DiscordCard).Color = Color3.fromRGB(80, 80, 150)

local DiscordTitle = Instance.new("TextLabel")
DiscordTitle.Parent = DiscordCard
DiscordTitle.Position = UDim2.new(0, 8, 0, 3)
DiscordTitle.Size = UDim2.new(0, 150, 0, 13)
DiscordTitle.BackgroundTransparency = 1
DiscordTitle.Font = Enum.Font.GothamBold
DiscordTitle.Text = "💬 DISCORD"
DiscordTitle.TextColor3 = Color3.fromRGB(160, 170, 255)
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
DiscordLinkText.TextColor3 = Color3.fromRGB(230, 235, 255)
DiscordLinkText.TextSize = 9
DiscordLinkText.TextXAlignment = Enum.TextXAlignment.Left
DiscordLinkText.ZIndex = 2

local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent = DiscordCard
CopyBtn.Position = UDim2.new(1, -70, 0.5, -9)
CopyBtn.Size = UDim2.new(0, 62, 0, 18)
CopyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
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

local CrossChatMenuBtn = Instance.new("TextButton")
CrossChatMenuBtn.Parent = MainFrame
CrossChatMenuBtn.Position = UDim2.new(0, 8, 0, 296)
CrossChatMenuBtn.Size = UDim2.new(1, -16, 0, 24)
CrossChatMenuBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
CrossChatMenuBtn.BackgroundTransparency = 0.25
CrossChatMenuBtn.Font = Enum.Font.GothamBold
CrossChatMenuBtn.Text = "🌐 CHAT TOÀN SERVER (MỞ / TẮT)"
CrossChatMenuBtn.TextColor3 = Color3.fromRGB(255, 200, 120)
CrossChatMenuBtn.TextSize = 9.5
CrossChatMenuBtn.ZIndex = 2
Instance.new("UICorner", CrossChatMenuBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", CrossChatMenuBtn).Color = Color3.fromRGB(255, 105, 35)
local WishContainer = Instance.new("Frame")
WishContainer.Parent = MainFrame
WishContainer.Position = UDim2.new(0, 8, 0, 324)
WishContainer.Size = UDim2.new(1, -16, 0, 20)
WishContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WishContainer.BackgroundTransparency = 0.5
WishContainer.ZIndex = 2
Instance.new("UICorner", WishContainer).CornerRadius = UDim.new(0, 8)

local WishLabel = Instance.new("TextLabel")
WishLabel.Parent = WishContainer
WishLabel.Size = UDim2.new(1, 0, 1, 0)
WishLabel.BackgroundTransparency = 1
WishLabel.Font = Enum.Font.GothamBold
WishLabel.Text = "✨ CHÚC BẠN CHƠI GAME VUI VẺ 👉👈"
WishLabel.TextColor3 = Color3.fromRGB(255, 225, 80)
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
ChatGui.Parent = CoreGui
ChatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ChatGui.ResetOnSpawn = false

local ChatPill = Instance.new("TextButton")
ChatPill.Name = "ChatPill"
ChatPill.Parent = ChatGui
ChatPill.Position = UDim2.new(0, 14, 0.72, 0)
ChatPill.Size = UDim2.new(0, 96, 0, 28)
ChatPill.BackgroundColor3 = Color3.fromRGB(20, 16, 26)
ChatPill.BackgroundTransparency = 0.25
ChatPill.Font = Enum.Font.GothamBold
ChatPill.Text = "💬 V13 CHAT"
ChatPill.TextColor3 = Color3.fromRGB(255, 190, 120)
ChatPill.TextSize = 9
ChatPill.ZIndex = 10
Instance.new("UICorner", ChatPill).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ChatPill).Color = Color3.fromRGB(255, 105, 35)
MakeDraggable(ChatPill)

local ChatBox = Instance.new("Frame")
ChatBox.Name = "ChatBox"
ChatBox.Parent = ChatGui
ChatBox.Position = UDim2.new(0, 14, 0.14, 0)
ChatBox.Size = UDim2.new(0, 275, 0, 290)
ChatBox.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
ChatBox.BackgroundTransparency = 0.25
ChatBox.ClipsDescendants = true
ChatBox.Visible = false
ChatBox.ZIndex = 9
Instance.new("UICorner", ChatBox).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", ChatBox).Color = Color3.fromRGB(255, 105, 35)
MakeDraggable(ChatBox)

local ChatBg = Instance.new("ImageLabel")
ChatBg.Name = "ChatBg"
ChatBg.Parent = ChatBox
ChatBg.Size = UDim2.new(1, 0, 1, 0)
ChatBg.Position = UDim2.new(0, 0, 0, 0)
ChatBg.Image = "rbxassetid://73666208807237"
ChatBg.ScaleType = Enum.ScaleType.Crop
ChatBg.BackgroundTransparency = 1
ChatBg.ImageTransparency = 0.05
ChatBg.ZIndex = 9
Instance.new("UICorner", ChatBg).CornerRadius = UDim.new(0, 12)

local ChatDim = Instance.new("Frame")
ChatDim.Parent = ChatBox
ChatDim.Size = UDim2.new(1, 0, 1, 0)
ChatDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatDim.BackgroundTransparency = 0.72
ChatDim.BorderSizePixel = 0
ChatDim.ZIndex = 9
Instance.new("UICorner", ChatDim).CornerRadius = UDim.new(0, 12)

local ChatHeader = Instance.new("TextLabel")
ChatHeader.Parent = ChatBox
ChatHeader.Position = UDim2.new(0, 10, 0, 4)
ChatHeader.Size = UDim2.new(1, -40, 0, 22)
ChatHeader.BackgroundTransparency = 1
ChatHeader.Font = Enum.Font.GothamBold
ChatHeader.Text = "🌐 CHAT XUYÊN SERVER"
ChatHeader.TextColor3 = Color3.fromRGB(255, 200, 125)
ChatHeader.TextSize = 11.5
ChatHeader.TextStrokeTransparency = 0.25
ChatHeader.TextXAlignment = Enum.TextXAlignment.Left
ChatHeader.ZIndex = 11

local HideChatBtn = Instance.new("TextButton")
HideChatBtn.Parent = ChatBox
HideChatBtn.Position = UDim2.new(1, -28, 0, 5)
HideChatBtn.Size = UDim2.new(0, 20, 0, 20)
HideChatBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
HideChatBtn.BackgroundTransparency = 0.35
HideChatBtn.Font = Enum.Font.GothamBold
HideChatBtn.Text = "−"
HideChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideChatBtn.TextSize = 12
HideChatBtn.ZIndex = 11
Instance.new("UICorner", HideChatBtn).CornerRadius = UDim.new(0, 5)

local MsgScroll = Instance.new("ScrollingFrame")
MsgScroll.Parent = ChatBox
MsgScroll.Position = UDim2.new(0, 6, 0, 28)
MsgScroll.Size = UDim2.new(1, -12, 1, -64)
MsgScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MsgScroll.BackgroundTransparency = 0.78
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

local avatarCache = {}
local userIdCache = {}

local function resolveUserId(username, userId)
	local idNum = tonumber(userId)
	if idNum and idNum > 0 then
		return idNum
	end
	local uname = tostring(username or "")
	if uname == "" or uname == "Player" or uname == "Hệ thống" or uname == "Hirose x Miyanno" then
		return nil
	end
	if userIdCache[uname] then
		return userIdCache[uname]
	end
	local plr = Players:FindFirstChild(uname)
	if plr and plr.UserId > 0 then
		userIdCache[uname] = plr.UserId
		return plr.UserId
	end
	local ok, fetchedId = pcall(function()
		return Players:GetUserIdFromNameAsync(uname)
	end)
	if ok and tonumber(fetchedId) and tonumber(fetchedId) > 0 then
		local num = tonumber(fetchedId)
		userIdCache[uname] = num
		return num
	end
	return nil
end

local function applyAvatarAsync(avatarImg, username, userId)
	task.spawn(function()
		local idNum = resolveUserId(username, userId)
		if not idNum then return end
		if avatarCache[idNum] then
			if avatarImg and avatarImg.Parent then
				avatarImg.Image = avatarCache[idNum]
			end
			return
		end
		local ok, url = pcall(function()
			return Players:GetUserThumbnailAsync(idNum, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and type(url) == "string" and url ~= "" then
			avatarCache[idNum] = url
			if avatarImg and avatarImg.Parent then
				avatarImg.Image = url
			end
		end
	end)
end

local msgOrder = 0
local function appendChatLine(username, text, userId, color)
	msgOrder += 1
	local row = Instance.new("Frame")
	row.Name = "MsgRow_" .. tostring(msgOrder)
	row.Parent = MsgScroll
	row.LayoutOrder = msgOrder
	row.Size = UDim2.new(1, 0, 0, 0)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	row.BackgroundTransparency = 0.72
	row.BorderSizePixel = 0
	row.ZIndex = 10
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Parent = row
	avatarImg.Position = UDim2.new(0, 5, 0, 5)
	avatarImg.Size = UDim2.new(0, 28, 0, 28)
	avatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	avatarImg.BackgroundTransparency = 0.5
	avatarImg.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	avatarImg.ScaleType = Enum.ScaleType.Crop
	avatarImg.ZIndex = 11
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
	applyAvatarAsync(avatarImg, username, userId)

	local line = Instance.new("TextLabel")
	line.Parent = row
	line.Position = UDim2.new(0, 38, 0, 3)
	line.Size = UDim2.new(1, -44, 0, 0)
	line.AutomaticSize = Enum.AutomaticSize.Y
	line.BackgroundTransparency = 1
	line.RichText = true
	line.Font = Enum.Font.GothamMedium
	local safeUser = tostring(username or "Player")
	local safeText = tostring(text or "")
	line.Text = '<font size="13.5"><b>' .. safeUser .. '</b></font>\n<font size="12">' .. safeText .. "</font>"
	line.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	line.TextStrokeTransparency = 0.25
	line.TextSize = 12
	line.TextWrapped = true
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.ZIndex = 11

	local rowPad = Instance.new("UIPadding")
	rowPad.Parent = row
	rowPad.PaddingBottom = UDim.new(0, 4)

	task.defer(function()
		MsgScroll.CanvasPosition = Vector2.new(0, math.max(0, MsgScroll.AbsoluteCanvasSize.Y - MsgScroll.AbsoluteWindowSize.Y))
	end)
end
local ChatInput = Instance.new("TextBox")
ChatInput.Parent = ChatBox
ChatInput.Position = UDim2.new(0, 6, 1, -29)
ChatInput.Size = UDim2.new(1, -60, 0, 24)
ChatInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatInput.BackgroundTransparency = 0.68
ChatInput.Font = Enum.Font.Gotham
ChatInput.PlaceholderText = "Nhập tin nhắn..."
ChatInput.PlaceholderColor3 = Color3.fromRGB(185, 190, 205)
ChatInput.Text = ""
ChatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatInput.TextSize = 11
ChatInput.ClearTextOnFocus = false
ChatInput.ZIndex = 11
Instance.new("UICorner", ChatInput).CornerRadius = UDim.new(0, 6)

local SendChatBtn = Instance.new("TextButton")
SendChatBtn.Parent = ChatBox
SendChatBtn.Position = UDim2.new(1, -50, 1, -29)
SendChatBtn.Size = UDim2.new(0, 44, 0, 24)
SendChatBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 35)
SendChatBtn.BackgroundTransparency = 0.15
SendChatBtn.Font = Enum.Font.GothamBold
SendChatBtn.Text = "GỬI"
SendChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendChatBtn.TextSize = 10.5
SendChatBtn.ZIndex = 11
Instance.new("UICorner", SendChatBtn).CornerRadius = UDim.new(0, 6)

local function toggleChatBox()
	ChatBox.Visible = not ChatBox.Visible
end

CrossChatMenuBtn.MouseButton1Click:Connect(toggleChatBox)
ChatPill.MouseButton1Click:Connect(toggleChatBox)
HideChatBtn.MouseButton1Click:Connect(function() ChatBox.Visible = false end)

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
			appendChatLine("Hệ thống", "Gửi lỗi, thử lại sau", 0, Color3.fromRGB(255, 110, 110))
		end
	end)
end

SendChatBtn.MouseButton1Click:Connect(sendCrossChat)
ChatInput.FocusLost:Connect(function(enterPressed) if enterPressed then sendCrossChat() end end)

local lastMsgId = 0
task.spawn(function()
	if not reqFunc then return end
	appendChatLine("Hirose x Miyanno", "Đã kết nối chat xuyên server!", 0, Color3.fromRGB(110, 255, 175))
	while true do
		local url = CHAT_API_URL .. "/messages" .. (lastMsgId > 0 and ("?after=" .. tostring(lastMsgId)) or "")
		local ok, res = pcall(function() return reqFunc({ Url = url, Method = "GET" }) end)
		if ok and res and (res.StatusCode == 200 or res.Success) then
			local data = safeDecode(res.Body)
			if type(data) == "table" and data.ok and type(data.messages) == "table" then
				for _, m in ipairs(data.messages) do
					local mid = tonumber(m.id) or 0
					if mid > lastMsgId then
						lastMsgId = mid
						appendChatLine(tostring(m.user or "Player"), tostring(m.text or ""), m.userId, Color3.fromRGB(255, 255, 255))
					end
				end
			end
		end
		task.wait(2)
	end
end)

local RunBtn = Instance.new("TextButton")
RunBtn.Parent = MainFrame
RunBtn.Position = UDim2.new(0, 8, 0, 350)
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
	ActiveGui.Parent = CoreGui
	ActiveGui.ResetOnSpawn = false

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
