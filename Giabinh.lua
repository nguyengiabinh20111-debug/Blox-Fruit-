-- === PHAN 1/4 ===
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer

for _, name in ipairs({"HiroseHubLoader", "ActiveHubNotification", "HiroseCrossChatGui"}) do
	local old = CoreGui:FindFirstChild(name)
	if old then pcall(function() old:Destroy() end) end
	if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
		local oldP = LocalPlayer.PlayerGui:FindFirstChild(name)
		if oldP then pcall(function() oldP:Destroy() end) end
	end
end

local DISCORD_LINK = "https://discord.gg/uqhEpzXy9q"
local CHAT_API_URL = "https://hirosemiyano.nguyengiabinh20111.workers.dev"
local CHAT_SERVER_TAG = tostring(game.JobId ~= "" and string.sub(game.JobId, 1, 8) or "Global")
local ADMIN_ROBLOX_USERNAME = "djia9243"
local CUSTOM_ICON_ASSET = "rbxassetid://106041745164419"
local SCRIPTS = {
	Chilli = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()',
	Venyx = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"))()',
	Divine = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Aquavine/main/DivineHub"))()'
}
local SelectedHub, SoundEnabled, FpsBoostEnabled = "Chilli", true, true
local MakeDraggable, attachGui

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name, ScreenGui.ResetOnSpawn = "HiroseHubLoader", false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name, MainFrame.Parent = "MainFrame", ScreenGui
MainFrame.AnchorPoint, MainFrame.Position = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 398)
MainFrame.BackgroundColor3, MainFrame.BorderSizePixel, MainFrame.ClipsDescendants = Color3.fromRGB(0, 0, 0), 0, true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local BgImage = Instance.new("ImageLabel")
BgImage.Parent, BgImage.Size = MainFrame, UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency, BgImage.Image, BgImage.ScaleType, BgImage.ZIndex = 1, "rbxassetid://78034177322041", Enum.ScaleType.Stretch, 0
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 14)

local TopBar = Instance.new("Frame")
TopBar.Parent, TopBar.Size, TopBar.BackgroundTransparency, TopBar.ZIndex = MainFrame, UDim2.new(1, 0, 0, 32), 1, 2

local function makeLbl(parent, pos, size, font, text, color, tSize, xAlign)
	local l = Instance.new("TextLabel")
	l.Parent, l.Position, l.Size = parent, pos, size
	l.BackgroundTransparency, l.Font, l.Text = 1, font, text
	l.TextColor3, l.TextStrokeTransparency, l.TextSize = color, 0.25, tSize
	l.TextXAlignment, l.ZIndex = xAlign or Enum.TextXAlignment.Left, 2
	return l
end

makeLbl(TopBar, UDim2.new(0, 8, 0, 0), UDim2.new(0, 210, 1, 0), Enum.Font.GothamBold, "🌶️ CHILLI & VENYX & DIVINE", Color3.fromRGB(255, 210, 130), 12)

local VersionBadge = makeLbl(TopBar, UDim2.new(1, -78, 0.5, -8), UDim2.new(0, 42, 0, 16), Enum.Font.GothamBold, "v13.0", Color3.fromRGB(255, 255, 255), 9, Enum.TextXAlignment.Center)
VersionBadge.BackgroundTransparency, VersionBadge.BackgroundColor3 = 0.2, Color3.fromRGB(255, 105, 35)
Instance.new("UICorner", VersionBadge).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent, CloseBtn.Position, CloseBtn.Size = TopBar, UDim2.new(1, -28, 0.5, -9), UDim2.new(0, 18, 0, 18)
CloseBtn.BackgroundColor3, CloseBtn.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.55
CloseBtn.Font, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize, CloseBtn.ZIndex = Enum.Font.GothamBold, "X", Color3.fromRGB(255, 255, 255), 9, 2
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local function makeCard(posY, h)
	local f = Instance.new("Frame")
	f.Parent, f.Position, f.Size = MainFrame, UDim2.new(0, 8, 0, posY), UDim2.new(1, -16, 0, h)
	f.BackgroundColor3, f.BackgroundTransparency, f.ZIndex = Color3.fromRGB(0, 0, 0), 0.68, 2
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
	return f
end

local ProfileCard = makeCard(34, 52)
local IconBox = makeLbl(ProfileCard, UDim2.new(0, 8, 0.5, -14), UDim2.new(0, 28, 0, 28), Enum.Font.GothamBold, "🌶️", Color3.fromRGB(255, 255, 255), 16, Enum.TextXAlignment.Center)
IconBox.BackgroundTransparency, IconBox.BackgroundColor3 = 0.35, Color3.fromRGB(255, 105, 35)
Instance.new("UICorner", IconBox).CornerRadius = UDim.new(0, 8)

makeLbl(ProfileCard, UDim2.new(0, 42, 0, 3), UDim2.new(1, -50, 0, 16), Enum.Font.GothamBold, "Tác giả: Hirose x Miyano", Color3.fromRGB(255, 210, 130), 12.5).TextStrokeTransparency = 0.2
local NameLabel = makeLbl(ProfileCard, UDim2.new(0, 42, 0, 19), UDim2.new(1, -50, 0, 13), Enum.Font.GothamBold, "Chilli & Venyx & Divine V13 Max", Color3.fromRGB(255, 235, 190), 10)
local SubLabel = makeLbl(ProfileCard, UDim2.new(0, 42, 0, 32), UDim2.new(1, -50, 0, 12), Enum.Font.Gotham, "● Sẵn sàng (Chilli VIP)", Color3.fromRGB(115, 255, 175), 9)

local VirexCard = makeCard(90, 34)
makeLbl(VirexCard, UDim2.new(0, 8, 0, 3), UDim2.new(0, 150, 0, 14), Enum.Font.GothamBold, "🔍 VIREX - FINDER", Color3.fromRGB(115, 255, 175), 10)
makeLbl(VirexCard, UDim2.new(0, 8, 0, 17), UDim2.new(0, 150, 0, 14), Enum.Font.Gotham, "Tính năng nổi bật V13", Color3.fromRGB(235, 240, 255), 8)
local RateBadge = makeLbl(VirexCard, UDim2.new(1, -96, 0.5, -9), UDim2.new(0, 88, 0, 18), Enum.Font.GothamBold, "✨ CHUẨN CAO", Color3.fromRGB(130, 255, 185), 8, Enum.TextXAlignment.Center)
RateBadge.BackgroundTransparency, RateBadge.BackgroundColor3 = 0.25, Color3.fromRGB(25, 95, 58)
Instance.new("UICorner", RateBadge).CornerRadius = UDim.new(1, 0)

local ChatIntroCard = makeCard(128, 34)
makeLbl(ChatIntroCard, UDim2.new(0, 8, 0, 3), UDim2.new(0, 165, 0, 14), Enum.Font.GothamBold, "🌐 CHAT TOÀN SERVER", Color3.fromRGB(255, 210, 130), 10)
makeLbl(ChatIntroCard, UDim2.new(0, 8, 0, 17), UDim2.new(0, 175, 0, 14), Enum.Font.Gotham, "Chat xuyên server + avatar người chơi", Color3.fromRGB(235, 240, 255), 8)
local ChatIntroBadge = makeLbl(ChatIntroCard, UDim2.new(1, -88, 0.5, -9), UDim2.new(0, 80, 0, 18), Enum.Font.GothamBold, "💬 TÍNH NĂNG MỚI", Color3.fromRGB(255, 255, 255), 7.5, Enum.TextXAlignment.Center)
ChatIntroBadge.BackgroundTransparency, ChatIntroBadge.BackgroundColor3 = 0.2, Color3.fromRGB(255, 105, 35)
Instance.new("UICorner", ChatIntroBadge).CornerRadius = UDim.new(1, 0)
-- === PHAN 2/4 ===
makeLbl(MainFrame, UDim2.new(0, 10, 0, 166), UDim2.new(0, 90, 0, 16), Enum.Font.GothamBold, "🎮 CHỌN HUB", Color3.fromRGB(255, 210, 130), 10)

local SoundBtn = Instance.new("TextButton")
SoundBtn.Parent, SoundBtn.Position, SoundBtn.Size = MainFrame, UDim2.new(1, -110, 0, 165), UDim2.new(0, 102, 0, 16)
SoundBtn.BackgroundColor3, SoundBtn.BackgroundTransparency = Color3.fromRGB(32, 140, 78), 0.2
SoundBtn.Font, SoundBtn.Text, SoundBtn.TextColor3, SoundBtn.TextSize, SoundBtn.ZIndex = Enum.Font.GothamBold, "🔊 ÂM THANH: BẬT", Color3.fromRGB(255, 255, 255), 8, 2
Instance.new("UICorner", SoundBtn).CornerRadius = UDim.new(1, 0)
SoundBtn.MouseButton1Click:Connect(function()
	SoundEnabled = not SoundEnabled
	SoundBtn.Text = SoundEnabled and "🔊 ÂM THANH: BẬT" or "🔇 ÂM THANH: TẮT"
	SoundBtn.BackgroundColor3 = SoundEnabled and Color3.fromRGB(32, 140, 78) or Color3.fromRGB(60, 60, 70)
end)

local HubContainer = Instance.new("Frame")
HubContainer.Parent, HubContainer.Position, HubContainer.Size = MainFrame, UDim2.new(0, 8, 0, 186), UDim2.new(1, -16, 0, 70)
HubContainer.BackgroundTransparency, HubContainer.ZIndex = 1, 2

local function makeHubCard(name, pos, size, icon, title)
	local Card = Instance.new("TextButton")
	Card.Name, Card.Parent, Card.Position, Card.Size = name, HubContainer, pos, size
	Card.BackgroundColor3, Card.BackgroundTransparency, Card.Text, Card.AutoButtonColor, Card.ZIndex = Color3.fromRGB(0, 0, 0), 0.68, "", false, 2
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
	local t = makeLbl(Card, UDim2.new(0, 4, 0, 4), UDim2.new(1, -8, 0, 16), Enum.Font.GothamBold, icon .. " " .. title, Color3.fromRGB(255, 255, 255), 10, Enum.TextXAlignment.Center)
	t.ZIndex = 2
	local pill = makeLbl(Card, UDim2.new(0, 6, 1, -24), UDim2.new(1, -12, 0, 18), Enum.Font.GothamBold, "Chọn", Color3.fromRGB(235, 240, 255), 9, Enum.TextXAlignment.Center)
	pill.Name, pill.BackgroundTransparency, pill.BackgroundColor3, pill.ZIndex = "StatusPill", 0.25, Color3.fromRGB(35, 35, 45), 2
	Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 6)
	return Card
end

local ChilliCard = makeHubCard("ChilliCard", UDim2.new(0, 0, 0, 0), UDim2.new(0.32, 0, 1, 0), "🔥", "Chilli")
local VenyxCard = makeHubCard("VenyxCard", UDim2.new(0.34, 0, 0, 0), UDim2.new(0.32, 0, 1, 0), "⚡", "Venyx")
local DivineCard = makeHubCard("DivineCard", UDim2.new(0.68, 0, 0, 0), UDim2.new(0.32, 0, 1, 0), "💎", "Divine")

local function UpdateHubSelection()
	local map = {
		Chilli = {ChilliCard, Color3.fromRGB(45, 22, 12), Color3.fromRGB(255, 105, 35), "Chilli & Venyx & Divine V13 Max", "● Sẵn sàng (Chilli VIP)"},
		Venyx = {VenyxCard, Color3.fromRGB(22, 24, 52), Color3.fromRGB(110, 100, 255), "Venyx Hub V13 Max", "● Sẵn sàng (Venyx Hub 2)"},
		Divine = {DivineCard, Color3.fromRGB(14, 38, 52), Color3.fromRGB(50, 160, 220), "Divine Hub (Aquavine)", "● Sẵn sàng (Aquavine Divine)"}
	}
	for _, card in ipairs({ChilliCard, VenyxCard, DivineCard}) do
		card.BackgroundColor3, card.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.68
		card.StatusPill.BackgroundColor3, card.StatusPill.BackgroundTransparency = Color3.fromRGB(35, 35, 45), 0.25
		card.StatusPill.TextColor3, card.StatusPill.Text = Color3.fromRGB(235, 240, 255), "Chọn"
	end
	local cfg = map[SelectedHub] or map.Chilli
	cfg[1].BackgroundColor3, cfg[1].BackgroundTransparency = cfg[2], 0.55
	cfg[1].StatusPill.BackgroundColor3, cfg[1].StatusPill.BackgroundTransparency = cfg[3], 0.15
	cfg[1].StatusPill.TextColor3, cfg[1].StatusPill.Text = Color3.fromRGB(255, 255, 255), "✓ CHỌN"
	NameLabel.Text, SubLabel.Text = cfg[4], cfg[5]
end
ChilliCard.MouseButton1Click:Connect(function() SelectedHub = "Chilli" UpdateHubSelection() end)
VenyxCard.MouseButton1Click:Connect(function() SelectedHub = "Venyx" UpdateHubSelection() end)
DivineCard.MouseButton1Click:Connect(function() SelectedHub = "Divine" UpdateHubSelection() end)
UpdateHubSelection()

local FpsCard = makeCard(262, 32)
makeLbl(FpsCard, UDim2.new(0, 8, 0, 3), UDim2.new(0, 160, 0, 13), Enum.Font.GothamBold, "🌙 FPS Boost & Fix Lag", Color3.fromRGB(255, 210, 130), 10)
makeLbl(FpsCard, UDim2.new(0, 8, 0, 16), UDim2.new(0, 180, 0, 13), Enum.Font.Gotham, "Tối ưu hóa game cực mượt", Color3.fromRGB(235, 240, 255), 8)
local FpsBtn = Instance.new("TextButton")
FpsBtn.Parent, FpsBtn.Position, FpsBtn.Size = FpsCard, UDim2.new(1, -48, 0.5, -9), UDim2.new(0, 40, 0, 18)
FpsBtn.BackgroundColor3, FpsBtn.BackgroundTransparency = Color3.fromRGB(32, 150, 85), 0.2
FpsBtn.Font, FpsBtn.Text, FpsBtn.TextColor3, FpsBtn.TextSize, FpsBtn.ZIndex = Enum.Font.GothamBold, "BẬT", Color3.fromRGB(255, 255, 255), 9, 2
Instance.new("UICorner", FpsBtn).CornerRadius = UDim.new(1, 0)
FpsBtn.MouseButton1Click:Connect(function()
	FpsBoostEnabled = not FpsBoostEnabled
	FpsBtn.Text = FpsBoostEnabled and "BẬT" or "TẮT"
	FpsBtn.BackgroundColor3 = FpsBoostEnabled and Color3.fromRGB(32, 150, 85) or Color3.fromRGB(60, 60, 70)
end)

local DiscordCard = makeCard(298, 32)
makeLbl(DiscordCard, UDim2.new(0, 8, 0, 3), UDim2.new(0, 150, 0, 13), Enum.Font.GothamBold, "💬 DISCORD", Color3.fromRGB(170, 195, 255), 9)
makeLbl(DiscordCard, UDim2.new(0, 8, 0, 16), UDim2.new(0, 170, 0, 13), Enum.Font.Gotham, DISCORD_LINK, Color3.fromRGB(235, 240, 255), 9)
local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent, CopyBtn.Position, CopyBtn.Size = DiscordCard, UDim2.new(1, -70, 0.5, -9), UDim2.new(0, 62, 0, 18)
CopyBtn.BackgroundColor3, CopyBtn.BackgroundTransparency = Color3.fromRGB(88, 101, 242), 0.2
CopyBtn.Font, CopyBtn.Text, CopyBtn.TextColor3, CopyBtn.TextSize, CopyBtn.ZIndex = Enum.Font.GothamBold, "📋 SAO CHÉP", Color3.fromRGB(255, 255, 255), 8, 2
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
CopyBtn.MouseButton1Click:Connect(function()
	if setclipboard then pcall(setclipboard, DISCORD_LINK) end
	CopyBtn.Text = "✓ CHÉP" task.wait(1.5) CopyBtn.Text = "📋 SAO CHÉP"
end)

local WishContainer = makeCard(334, 20)
WishContainer.UICorner.CornerRadius = UDim.new(0, 8)
makeLbl(WishContainer, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Enum.Font.GothamBold, "✨ CHÚC BẠN CHƠI GAME VUI VẺ 👉👈", Color3.fromRGB(255, 210, 130), 9, Enum.TextXAlignment.Center).ZIndex = 3

local ChatGui = Instance.new("ScreenGui")
ChatGui.Name, ChatGui.ResetOnSpawn = "HiroseCrossChatGui", false
ChatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ChatPill = Instance.new("ImageButton")
ChatPill.Name, ChatPill.Parent = "ChatPill", ChatGui
ChatPill.Position, ChatPill.Size = UDim2.new(0, 14, 0.72, 0), UDim2.new(0, 52, 0, 52)
ChatPill.BackgroundColor3, ChatPill.BackgroundTransparency = Color3.fromRGB(16, 17, 24), 0.1
ChatPill.Image, ChatPill.ScaleType, ChatPill.ZIndex = CUSTOM_ICON_ASSET, Enum.ScaleType.Crop, 10
Instance.new("UICorner", ChatPill).CornerRadius = UDim.new(1, 0)

local ChatBox = Instance.new("Frame")
ChatBox.Name, ChatBox.Parent = "ChatBox", ChatGui
ChatBox.Position, ChatBox.Size = UDim2.new(0, 10, 0.04, 0), UDim2.new(0, 250, 0, 372)
ChatBox.BackgroundColor3, ChatBox.BackgroundTransparency = Color3.fromRGB(18, 18, 26), 0.45
ChatBox.BorderSizePixel, ChatBox.ClipsDescendants, ChatBox.Visible, ChatBox.ZIndex = 0, true, false, 9
Instance.new("UICorner", ChatBox).CornerRadius = UDim.new(0, 12)

local ChatBg = Instance.new("ImageLabel")
ChatBg.Name, ChatBg.Parent, ChatBg.Size = "ChatBg", ChatBox, UDim2.new(1, 0, 1, 0)
ChatBg.Image, ChatBg.ScaleType, ChatBg.BackgroundTransparency, ChatBg.ZIndex = "rbxassetid://73666208807237", Enum.ScaleType.Crop, 1, 9
Instance.new("UICorner", ChatBg).CornerRadius = UDim.new(0, 12)

local AuthorAfterIcon = Instance.new("ImageLabel")
AuthorAfterIcon.Parent, AuthorAfterIcon.Position, AuthorAfterIcon.Size = ChatBox, UDim2.new(0, 4, 0, 2), UDim2.new(0, 30, 0, 30)
AuthorAfterIcon.BackgroundTransparency, AuthorAfterIcon.Image, AuthorAfterIcon.ScaleType, AuthorAfterIcon.ZIndex = 1, CUSTOM_ICON_ASSET, Enum.ScaleType.Crop, 11
Instance.new("UICorner", AuthorAfterIcon).CornerRadius = UDim.new(1, 0)

makeLbl(ChatBox, UDim2.new(0, 38, 0, 2), UDim2.new(1, -66, 0, 19), Enum.Font.GothamBold, "Tác giả: Hirose x Miyano", Color3.fromRGB(255, 210, 130), 14.5).ZIndex = 11
makeLbl(ChatBox, UDim2.new(0, 38, 0, 22), UDim2.new(1, -128, 0, 13), Enum.Font.GothamMedium, DISCORD_LINK, Color3.fromRGB(170, 195, 255), 8.5).ZIndex = 11

local OnlineToggleBtn = Instance.new("TextButton")
OnlineToggleBtn.Parent, OnlineToggleBtn.Position, OnlineToggleBtn.Size = ChatBox, UDim2.new(1, -92, 0, 21), UDim2.new(0, 64, 0, 14)
OnlineToggleBtn.BackgroundColor3, OnlineToggleBtn.BackgroundTransparency = Color3.fromRGB(16, 48, 32), 0.35
OnlineToggleBtn.Font, OnlineToggleBtn.Text, OnlineToggleBtn.TextColor3, OnlineToggleBtn.TextSize, OnlineToggleBtn.ZIndex = Enum.Font.GothamBold, "● 1 online ▾", Color3.fromRGB(115, 255, 175), 8.5, 11
Instance.new("UICorner", OnlineToggleBtn).CornerRadius = UDim.new(1, 0)

local HideChatBtn = Instance.new("TextButton")
HideChatBtn.Parent, HideChatBtn.Position, HideChatBtn.Size = ChatBox, UDim2.new(1, -24, 0, 5), UDim2.new(0, 18, 0, 18)
HideChatBtn.BackgroundColor3, HideChatBtn.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.55
HideChatBtn.Font, HideChatBtn.Text, HideChatBtn.TextColor3, HideChatBtn.TextSize, HideChatBtn.ZIndex = Enum.Font.GothamBold, "−", Color3.fromRGB(255, 255, 255), 12, 11
Instance.new("UICorner", HideChatBtn).CornerRadius = UDim.new(0, 5)

local MsgScroll = Instance.new("ScrollingFrame")
MsgScroll.Parent, MsgScroll.Position, MsgScroll.Size = ChatBox, UDim2.new(0, 6, 0, 38), UDim2.new(1, -12, 1, -72)
MsgScroll.BackgroundTransparency, MsgScroll.BorderSizePixel, MsgScroll.ScrollBarThickness = 1, 0, 3
MsgScroll.CanvasSize, MsgScroll.AutomaticCanvasSize, MsgScroll.Visible, MsgScroll.ZIndex = UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.Y, false, 10
local MsgLayout = Instance.new("UIListLayout")
MsgLayout.Parent, MsgLayout.SortOrder, MsgLayout.Padding = MsgScroll, Enum.SortOrder.LayoutOrder, UDim.new(0, 6)
local MsgPad = Instance.new("UIPadding")
MsgPad.Parent = MsgScroll
MsgPad.PaddingTop, MsgPad.PaddingBottom, MsgPad.PaddingLeft, MsgPad.PaddingRight = UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 4)

local LockedChatNotice = makeLbl(ChatBox, UDim2.new(0, 12, 0.42, 0), UDim2.new(1, -24, 0, 36), Enum.Font.GothamBold, "🔒 Chưa có tin nhắn mới.\nKhi có người nhắn, tin nhắn sẽ hiện!", Color3.fromRGB(255, 225, 150), 10, Enum.TextXAlignment.Center)
LockedChatNotice.TextWrapped, LockedChatNotice.ZIndex = true, 11

local OnlinePanel = Instance.new("Frame")
OnlinePanel.Parent, OnlinePanel.Position, OnlinePanel.Size = ChatBox, UDim2.new(0, 6, 0, 38), UDim2.new(1, -12, 1, -44)
OnlinePanel.BackgroundColor3, OnlinePanel.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.14
OnlinePanel.BorderSizePixel, OnlinePanel.Visible, OnlinePanel.ZIndex = 0, false, 14
Instance.new("UICorner", OnlinePanel).CornerRadius = UDim.new(0, 8)

local BackFromOnlineBtn = Instance.new("TextButton")
BackFromOnlineBtn.Parent, BackFromOnlineBtn.Position, BackFromOnlineBtn.Size = OnlinePanel, UDim2.new(0, 6, 0, 4), UDim2.new(0, 62, 0, 18)
BackFromOnlineBtn.BackgroundColor3, BackFromOnlineBtn.BackgroundTransparency = Color3.fromRGB(255, 105, 35), 0.2
BackFromOnlineBtn.Font, BackFromOnlineBtn.Text, BackFromOnlineBtn.TextColor3, BackFromOnlineBtn.TextSize, BackFromOnlineBtn.ZIndex = Enum.Font.GothamBold, "< Quay lại", Color3.fromRGB(255, 255, 255), 8.5, 15
Instance.new("UICorner", BackFromOnlineBtn).CornerRadius = UDim.new(0, 6)

local OnlineListTitle = makeLbl(OnlinePanel, UDim2.new(0, 74, 0, 4), UDim2.new(1, -80, 0, 18), Enum.Font.GothamBold, "Đang bật script · 1", Color3.fromRGB(115, 255, 175), 9.5, Enum.TextXAlignment.Right)
OnlineListTitle.ZIndex = 15

local OnlineScroll = Instance.new("ScrollingFrame")
OnlineScroll.Parent, OnlineScroll.Position, OnlineScroll.Size = OnlinePanel, UDim2.new(0, 5, 0, 26), UDim2.new(1, -10, 1, -30)
OnlineScroll.BackgroundTransparency, OnlineScroll.BorderSizePixel, OnlineScroll.ScrollBarThickness = 1, 0, 3
OnlineScroll.CanvasSize, OnlineScroll.AutomaticCanvasSize, OnlineScroll.ZIndex = UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.Y, 15
local OnlineLayout = Instance.new("UIListLayout")
OnlineLayout.Parent, OnlineLayout.SortOrder, OnlineLayout.Padding = OnlineScroll, Enum.SortOrder.LayoutOrder, UDim.new(0, 4)
-- === PHAN 3/4 ===
local reqFunc = (syn and syn.request) or (http and http.request) or request or http_request
local function safeDecode(raw)
	if type(raw) ~= "string" or raw == "" then return nil end
	local ok, d = pcall(function() return HttpService:JSONDecode(raw) end)
	return ok and d or nil
end
local function safeEncode(t)
	local ok, e = pcall(function() return HttpService:JSONEncode(t) end)
	return ok and e or nil
end

local function ApplyFixLag()
	pcall(function()
		Lighting.GlobalShadows, Lighting.FogEnd = false, 9e9
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		if Terrain then Terrain.WaterWaveSize, Terrain.WaterWaveTransparency, Terrain.WaterReflectance = 0, 1, 0 end
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then v.Material, v.Reflectance = Enum.Material.SmoothPlastic, 0
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled = false end
		end
	end)
end

MakeDraggable = function(guiObj)
	local dragging, dragInput, dragStart, startPos
	guiObj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, startPos = true, input.Position, guiObj.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	guiObj.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			guiObj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

attachGui = function(gui)
	local ok = pcall(function() gui.Parent = CoreGui end)
	if not ok or not gui.Parent then
		local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if pg then gui.Parent = pg end
	end
end
attachGui(ScreenGui)
attachGui(ChatGui)
MakeDraggable(MainFrame)
MakeDraggable(ChatPill)
MakeDraggable(ChatBox)

local avatarCache, userIdCache, activeScriptUsers, reactBadgeMap = {}, {}, {}, {}
local hasSeenFirstMessage, currentGameName, externalOnlineCount = false, "Roblox", 0
task.spawn(function()
	local ok, info = pcall(function() return MarketplaceService:GetProductInfoAsync(game.PlaceId) end)
	if ok and info and type(info.Name) == "string" and info.Name ~= "" then currentGameName = info.Name end
end)

local function unlockChatStream()
	if not hasSeenFirstMessage then hasSeenFirstMessage, LockedChatNotice.Visible, MsgScroll.Visible = true, false, true end
end

local function resolveUserId(username, userId)
	local idNum = tonumber(userId)
	if idNum and idNum > 0 then return idNum end
	local uname = tostring(username or "")
	if uname == "" or uname == "Player" or uname == "Hệ thống" or uname == "Hirose x Miyano" then return nil end
	if userIdCache[uname] then return userIdCache[uname] end
	local plr = Players:FindFirstChild(uname)
	if plr and plr.UserId > 0 then userIdCache[uname] = plr.UserId return plr.UserId end
	local ok, fId = pcall(function() return Players:GetUserIdFromNameAsync(uname) end)
	if ok and tonumber(fId) and tonumber(fId) > 0 then userIdCache[uname] = tonumber(fId) return tonumber(fId) end
	return nil
end

local function applyAvatarAsync(avatarImg, username, userId)
	task.spawn(function()
		local idNum = resolveUserId(username, userId)
		if not idNum then return end
		if avatarCache[idNum] then if avatarImg and avatarImg.Parent then avatarImg.Image = avatarCache[idNum] end return end
		local ok, url = pcall(function() return Players:GetUserThumbnailAsync(idNum, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
		if ok and type(url) == "string" and url ~= "" then avatarCache[idNum] = url if avatarImg and avatarImg.Parent then avatarImg.Image = url end end
	end)
end

local ProfileModal = Instance.new("Frame")
ProfileModal.Parent, ProfileModal.Position, ProfileModal.Size = ChatBox, UDim2.new(0, 6, 0.11, 0), UDim2.new(0, 218, 0, 256)
ProfileModal.BackgroundColor3, ProfileModal.BackgroundTransparency, ProfileModal.Visible, ProfileModal.ZIndex = Color3.fromRGB(16, 17, 24), 0.08, false, 22
Instance.new("UICorner", ProfileModal).CornerRadius = UDim.new(0, 12)

local CloseProfileBtn = Instance.new("TextButton")
CloseProfileBtn.Parent, CloseProfileBtn.Position, CloseProfileBtn.Size = ProfileModal, UDim2.new(1, -24, 0, 6), UDim2.new(0, 18, 0, 18)
CloseProfileBtn.BackgroundColor3, CloseProfileBtn.Font, CloseProfileBtn.Text, CloseProfileBtn.TextColor3, CloseProfileBtn.TextSize, CloseProfileBtn.ZIndex = Color3.fromRGB(220, 65, 65), Enum.Font.GothamBold, "X", Color3.fromRGB(255, 255, 255), 9, 23
Instance.new("UICorner", CloseProfileBtn).CornerRadius = UDim.new(1, 0)
CloseProfileBtn.MouseButton1Click:Connect(function() ProfileModal.Visible = false end)

local BigAvatar = Instance.new("ImageLabel")
BigAvatar.Parent, BigAvatar.AnchorPoint, BigAvatar.Position, BigAvatar.Size = ProfileModal, Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 12), UDim2.new(0, 60, 0, 60)
BigAvatar.BackgroundColor3, BigAvatar.BackgroundTransparency, BigAvatar.Image, BigAvatar.ScaleType, BigAvatar.ZIndex = Color3.fromRGB(0, 0, 0), 0.5, "rbxasset://textures/ui/GuiImagePlaceholder.png", Enum.ScaleType.Crop, 23
Instance.new("UICorner", BigAvatar).CornerRadius = UDim.new(1, 0)

local ProfileCurrentName = makeLbl(ProfileModal, UDim2.new(0, 10, 0, 76), UDim2.new(1, -20, 0, 16), Enum.Font.GothamBold, "", Color3.fromRGB(255, 220, 120), 11.5, Enum.TextXAlignment.Center)
ProfileCurrentName.ZIndex = 23
local ProfileHandleName = makeLbl(ProfileModal, UDim2.new(0, 10, 0, 92), UDim2.new(1, -20, 0, 13), Enum.Font.Gotham, "", Color3.fromRGB(185, 200, 225), 9, Enum.TextXAlignment.Center)
ProfileHandleName.ZIndex = 23
local ProfileInfoBody = makeLbl(ProfileModal, UDim2.new(0, 12, 0, 112), UDim2.new(1, -24, 0, 136), Enum.Font.GothamMedium, "", Color3.fromRGB(240, 244, 255), 10)
ProfileInfoBody.TextWrapped, ProfileInfoBody.TextYAlignment, ProfileInfoBody.ZIndex = true, Enum.TextYAlignment.Top, 23

local function openUserProfile(rawUser, userId)
	local uname = tostring(rawUser or "Player")
	if uname == "" or uname == "Hệ thống" then return end
	local plr = Players:FindFirstChild(uname)
	local curName = (plr and plr.DisplayName) or uname
	local resolvedId = resolveUserId(uname, userId) or 0
	BigAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	applyAvatarAsync(BigAvatar, uname, resolvedId)
	ProfileCurrentName.Text, ProfileHandleName.Text = curName, "@" .. uname
	ProfileInfoBody.Text = "Tên: " .. curName .. "\nId: " .. tostring(resolvedId) .. "\nNgày tạo: Đang tải...\nGame: " .. tostring(currentGameName)
	ProfileModal.Visible = true
	if resolvedId > 0 and reqFunc then
		task.spawn(function()
			local ok, res = pcall(function() return reqFunc({ Url = "https://users.roblox.com/v1/users/" .. tostring(resolvedId), Method = "GET" }) end)
			local d = ok and res and safeDecode(res.Body)
			if type(d) == "table" and type(d.created) == "string" then
				local y, m, day = d.created:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)")
				local dateStr = (y and m and day) and (day .. "/" .. m .. "/" .. y) or d.created
				if ProfileModal.Visible then ProfileInfoBody.Text = "Tên: " .. curName .. "\nId: " .. tostring(resolvedId) .. "\nNgày tạo: " .. dateStr .. "\nGame: " .. tostring(currentGameName) end
			end
		end)
	end
end

local function sendRemoteFriendRequest(targetUser, targetId)
	local resolvedId = resolveUserId(targetUser, targetId)
	if not resolvedId or resolvedId <= 0 then return end
	local targetPlr = Players:GetPlayerByUserId(resolvedId) or Players:FindFirstChild(tostring(targetUser or ""))
	if targetPlr and LocalPlayer then
		pcall(function() LocalPlayer:RequestFriendship(targetPlr) end)
		pcall(function() StarterGui:SetCore("PromptSendFriendRequest", targetPlr) end)
	end
	if reqFunc then
		task.spawn(function()
			pcall(function()
				reqFunc({ Url = "https://friends.roblox.com/v1/users/" .. tostring(resolvedId) .. "/request-friendship", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = safeEncode({ friendshipOriginSourceType = "PlayerSearch" }) })
			end)
		end)
	end
end

local function applyReactionToBadge(msgId, emoji)
	local midNum = tonumber(msgId)
	if not midNum or midNum <= 0 or type(emoji) ~= "string" or emoji == "" then return end
	local badge = reactBadgeMap[midNum]
	if badge and badge.Parent then badge.Text, badge.Visible = emoji, true end
end

local function publishReaction(msgId, emoji)
	applyReactionToBadge(msgId, emoji)
	local midNum = tonumber(msgId)
	if not midNum or midNum <= 0 or not reqFunc then return end
	task.spawn(function()
		pcall(function()
			reqFunc({ Url = CHAT_API_URL .. "/react", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = safeEncode({ messageId = midNum, emoji = emoji, user = (LocalPlayer and LocalPlayer.Name) or "Player" }) })
		end)
	end)
end

local function attachHDrag(scrollFrame, mult)
	local drag, sx, scx = false, 0, 0
	scrollFrame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			drag, sx, scx = true, inp.Position.X, scrollFrame.CanvasPosition.X
		end
	end)
	scrollFrame.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = false end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local maxX = math.max(0, scrollFrame.AbsoluteCanvasSize.X - scrollFrame.AbsoluteWindowSize.X)
			scrollFrame.CanvasPosition = Vector2.new(math.clamp(scx - (inp.Position.X - sx) * (mult or 1.25), 0, maxX), 0)
		end
	end)
end

local ActionSheet = Instance.new("Frame")
ActionSheet.Parent, ActionSheet.Position, ActionSheet.Size = ChatBox, UDim2.new(0, 6, 0.41, 0), UDim2.new(1, -12, 0, 92)
ActionSheet.BackgroundColor3, ActionSheet.BackgroundTransparency, ActionSheet.Visible, ActionSheet.ZIndex = Color3.fromRGB(20, 16, 30), 0.06, false, 19
Instance.new("UICorner", ActionSheet).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", ActionSheet).Color = Color3.fromRGB(255, 130, 60)

local selectedMsgTarget, ChatInput, sendDirectText = nil, nil, nil
local function makeSBtn(pos, size, bg, txt, cb)
	local b = Instance.new("TextButton")
	b.Parent, b.Position, b.Size, b.BackgroundColor3 = ActionSheet, pos, size, bg
	b.Font, b.Text, b.TextColor3, b.TextSize, b.ZIndex = Enum.Font.GothamBold, txt, Color3.fromRGB(255, 255, 255), 8.5, 20
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	b.MouseButton1Click:Connect(cb)
end
makeSBtn(UDim2.new(0, 5, 0, 6), UDim2.new(0.32, -4, 0, 26), Color3.fromRGB(42, 45, 58), "📋 Chép", function() if selectedMsgTarget and setclipboard then pcall(setclipboard, tostring(selectedMsgTarget.text or "")) end ActionSheet.Visible = false end)
makeSBtn(UDim2.new(0.34, 0, 0, 6), UDim2.new(0.32, -4, 0, 26), Color3.fromRGB(235, 110, 45), "↩ Trả lời", function() if selectedMsgTarget and ChatInput then ChatInput.Text = "@" .. tostring(selectedMsgTarget.user) .. " (" .. tostring(selectedMsgTarget.text) .. ") " ChatInput:CaptureFocus() end ActionSheet.Visible = false end)
makeSBtn(UDim2.new(0.68, 0, 0, 6), UDim2.new(0.32, -5, 0, 26), Color3.fromRGB(36, 150, 92), "🤝 Kết bạn", function() if selectedMsgTarget then sendRemoteFriendRequest(selectedMsgTarget.user, selectedMsgTarget.userId) end ActionSheet.Visible = false end)

local ReactionDock = Instance.new("Frame")
ReactionDock.Parent, ReactionDock.Position, ReactionDock.Size = ActionSheet, UDim2.new(0, 5, 0, 40), UDim2.new(1, -31, 0, 42)
ReactionDock.BackgroundColor3, ReactionDock.BackgroundTransparency, ReactionDock.ZIndex = Color3.fromRGB(34, 24, 48), 0.08, 20
Instance.new("UICorner", ReactionDock).CornerRadius = UDim.new(1, 0)

local EmojiScroll = Instance.new("ScrollingFrame")
EmojiScroll.Parent, EmojiScroll.Position, EmojiScroll.Size = ReactionDock, UDim2.new(0, 4, 0, 2), UDim2.new(1, -8, 1, -4)
EmojiScroll.BackgroundTransparency, EmojiScroll.BorderSizePixel, EmojiScroll.ScrollBarThickness = 1, 0, 2
EmojiScroll.ScrollingDirection, EmojiScroll.CanvasSize, EmojiScroll.AutomaticCanvasSize, EmojiScroll.Active, EmojiScroll.ZIndex = Enum.ScrollingDirection.X, UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.X, true, 21
local EmojiLayout = Instance.new("UIListLayout")
EmojiLayout.Parent, EmojiLayout.FillDirection, EmojiLayout.VerticalAlignment, EmojiLayout.Padding = EmojiScroll, Enum.FillDirection.Horizontal, Enum.VerticalAlignment.Center, UDim.new(0, 5)
attachHDrag(EmojiScroll, 1.25)

for i, em in ipairs({"❤️", "😂", "😮", "😢", "👍", "🔥", "🥰", "😭", "😡", "🎉", "💯", "✨", "🤡", "🤝", "💔", "🤩"}) do
	local eb = Instance.new("TextButton")
	eb.Parent, eb.LayoutOrder, eb.Size = EmojiScroll, i, UDim2.new(0, 28, 0, 28)
	eb.BackgroundColor3, eb.BackgroundTransparency, eb.Font, eb.Text, eb.TextColor3, eb.TextSize, eb.ZIndex = Color3.fromRGB(52, 36, 72), 0.15, Enum.Font.GothamBold, em, Color3.fromRGB(255, 255, 255), 13.5, 22
	Instance.new("UICorner", eb).CornerRadius = UDim.new(1, 0)
	eb.MouseButton1Click:Connect(function()
		if selectedMsgTarget then
			if selectedMsgTarget.msgId and selectedMsgTarget.msgId > 0 then publishReaction(selectedMsgTarget.msgId, em)
			elseif selectedMsgTarget.reactLabel then selectedMsgTarget.reactLabel.Text, selectedMsgTarget.reactLabel.Visible = em, true end
		end
		ActionSheet.Visible = false
	end)
end

local closeDockBtn = Instance.new("TextButton")
closeDockBtn.Parent, closeDockBtn.Position, closeDockBtn.Size = ActionSheet, UDim2.new(1, -24, 0, 48), UDim2.new(0, 19, 0, 26)
closeDockBtn.BackgroundColor3, closeDockBtn.Font, closeDockBtn.Text, closeDockBtn.TextColor3, closeDockBtn.TextSize, closeDockBtn.ZIndex = Color3.fromRGB(185, 55, 75), Enum.Font.GothamBold, "X", Color3.fromRGB(255, 255, 255), 9, 21
Instance.new("UICorner", closeDockBtn).CornerRadius = UDim.new(0, 6)
closeDockBtn.MouseButton1Click:Connect(function() ActionSheet.Visible = false end)

local function rebuildOnlineList()
	for _, c in ipairs(OnlineScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	local nowSec, count = os.time(), 0
	for rName, info in pairs(activeScriptUsers) do
		if (type(info.lastSeen) ~= "number") or (math.abs(nowSec - info.lastSeen) <= 90) then
			count += 1
			local item = Instance.new("Frame")
			item.Parent, item.LayoutOrder, item.Size = OnlineScroll, count, UDim2.new(1, 0, 0, 34)
			item.BackgroundColor3, item.BackgroundTransparency, item.ZIndex = Color3.fromRGB(24, 24, 34), 0.25, 16
			Instance.new("UICorner", item).CornerRadius = UDim.new(0, 7)
			local av = Instance.new("ImageButton")
			av.Parent, av.Position, av.Size = item, UDim2.new(0, 5, 0.5, -12), UDim2.new(0, 24, 0, 24)
			av.BackgroundColor3, av.BackgroundTransparency, av.Image, av.ScaleType, av.ZIndex = Color3.fromRGB(0, 0, 0), 0.5, "rbxasset://textures/ui/GuiImagePlaceholder.png", Enum.ScaleType.Crop, 17
			Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
			applyAvatarAsync(av, info.realName, info.userId)
			av.MouseButton1Click:Connect(function() openUserProfile(info.realName, info.userId) end)
			makeLbl(item, UDim2.new(0, 34, 0, 3), UDim2.new(1, -40, 0, 14), Enum.Font.GothamBold, tostring(info.editedName or rName), Color3.fromRGB(255, 255, 255), 10.5).ZIndex = 17
			makeLbl(item, UDim2.new(0, 34, 0, 17), UDim2.new(1, -40, 0, 13), Enum.Font.Gotham, "@" .. tostring(rName), Color3.fromRGB(185, 200, 225), 8.5).ZIndex = 17
		end
	end
	local finalCount = math.max(1, count, tonumber(externalOnlineCount) or 0)
	OnlineToggleBtn.Text, OnlineListTitle.Text = "● " .. tostring(finalCount) .. " online ▾", "Đang bật script · " .. tostring(finalCount)
end

local function registerScriptUser(realName, editedName, userId, lastSeen)
	local rName = tostring(realName or "")
	if rName == "" or rName == "Player" or rName == "Hệ thống" or rName == "Hirose x Miyano" then return end
	local eName = tostring(editedName or "")
	if eName == "" then local plr = Players:FindFirstChild(rName) eName = (plr and plr.DisplayName) or rName end
	local ts = tonumber(lastSeen) or os.time()
	if ts > 1e11 then ts = math.floor(ts / 1000) end
	activeScriptUsers[rName] = { realName = rName, editedName = eName, userId = tonumber(userId) or 0, lastSeen = ts }
	rebuildOnlineList()
end

OnlineToggleBtn.MouseButton1Click:Connect(function() rebuildOnlineList() OnlinePanel.Visible = not OnlinePanel.Visible end)
BackFromOnlineBtn.MouseButton1Click:Connect(function() OnlinePanel.Visible = false end)

ChatInput = Instance.new("TextBox")
ChatInput.Parent, ChatInput.Position, ChatInput.Size = ChatBox, UDim2.new(0, 6, 1, -27), UDim2.new(1, -78, 0, 22)
ChatInput.BackgroundColor3, ChatInput.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.22
ChatInput.Font, ChatInput.PlaceholderText, ChatInput.PlaceholderColor3 = Enum.Font.Gotham, "Nhập tin nhắn...", Color3.fromRGB(220, 225, 240)
ChatInput.Text, ChatInput.TextColor3, ChatInput.TextSize, ChatInput.ClearTextOnFocus, ChatInput.ZIndex = "", Color3.fromRGB(255, 255, 255), 10.5, false, 11
Instance.new("UICorner", ChatInput).CornerRadius = UDim.new(0, 6)

local OpenSendIconBtn = Instance.new("TextButton")
OpenSendIconBtn.Parent, OpenSendIconBtn.Position, OpenSendIconBtn.Size = ChatBox, UDim2.new(1, -68, 1, -27), UDim2.new(0, 24, 0, 22)
OpenSendIconBtn.BackgroundColor3, OpenSendIconBtn.BackgroundTransparency = Color3.fromRGB(48, 36, 68), 0.15
OpenSendIconBtn.Font, OpenSendIconBtn.Text, OpenSendIconBtn.TextColor3, OpenSendIconBtn.TextSize, OpenSendIconBtn.ZIndex = Enum.Font.GothamBold, "😀", Color3.fromRGB(255, 255, 255), 12, 11
Instance.new("UICorner", OpenSendIconBtn).CornerRadius = UDim.new(0, 6)

local SendChatBtn = Instance.new("TextButton")
SendChatBtn.Parent, SendChatBtn.Position, SendChatBtn.Size = ChatBox, UDim2.new(1, -40, 1, -27), UDim2.new(0, 34, 0, 22)
SendChatBtn.BackgroundColor3, SendChatBtn.BackgroundTransparency = Color3.fromRGB(255, 105, 35), 0.12
SendChatBtn.Font, SendChatBtn.Text, SendChatBtn.TextColor3, SendChatBtn.TextSize, SendChatBtn.ZIndex = Enum.Font.GothamBold, "GỬI", Color3.fromRGB(255, 255, 255), 10, 11
Instance.new("UICorner", SendChatBtn).CornerRadius = UDim.new(0, 6)

local SendIconPopup = Instance.new("Frame")
SendIconPopup.Parent, SendIconPopup.Position, SendIconPopup.Size = ChatBox, UDim2.new(0, 6, 1, -69), UDim2.new(1, -12, 0, 38)
SendIconPopup.BackgroundColor3, SendIconPopup.BackgroundTransparency, SendIconPopup.Visible, SendIconPopup.ZIndex = Color3.fromRGB(22, 18, 34), 0.08, false, 24
Instance.new("UICorner", SendIconPopup).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", SendIconPopup).Color = Color3.fromRGB(255, 130, 60)

local SendIconScroll = Instance.new("ScrollingFrame")
SendIconScroll.Parent, SendIconScroll.Position, SendIconScroll.Size = SendIconPopup, UDim2.new(0, 4, 0, 3), UDim2.new(1, -8, 1, -6)
SendIconScroll.BackgroundTransparency, SendIconScroll.BorderSizePixel, SendIconScroll.ScrollBarThickness = 1, 0, 2
SendIconScroll.ScrollingDirection, SendIconScroll.CanvasSize, SendIconScroll.AutomaticCanvasSize, SendIconScroll.Active, SendIconScroll.ZIndex = Enum.ScrollingDirection.X, UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.X, true, 25
local SendIconLayout = Instance.new("UIListLayout")
SendIconLayout.Parent, SendIconLayout.FillDirection, SendIconLayout.VerticalAlignment, SendIconLayout.Padding = SendIconScroll, Enum.FillDirection.Horizontal, Enum.VerticalAlignment.Center, UDim.new(0, 5)
attachHDrag(SendIconScroll, 1.25)

local twentyIcons = {"😀", "😂", "🥰", "😎", "🤩", "😭", "😡", "🤯", "🥳", "👍", "❤️", "🔥", "💯", "✨", "🎉", "🤝", "🙏",
	-- === PHAN 4/4 ===
local function formatLockedTime(ts)
	local num = tonumber(ts)
	if num and num > 0 then
		if num > 1e11 then num = math.floor(num / 1000) end
		local ok, dt = pcall(function() return os.date("%H:%M", num) end)
		if ok and type(dt) == "string" and #dt == 5 then return dt end
	end
	local okNow, nowStr = pcall(function() return os.date("%H:%M") end)
	return (okNow and nowStr) or "02:14"
end

local msgOrder = 0
local function appendChatLine(username, text, userId, timestamp, customColor, shouldUnlock, autoCopyText, serverMsgId, initialReaction)
	if shouldUnlock then unlockChatStream() end
	msgOrder += 1
	local safeUser, safeText, safeId, midNum = tostring(username or "Player"), tostring(text or ""), tonumber(userId) or 0, tonumber(serverMsgId) or 0
	local myName = (LocalPlayer and LocalPlayer.Name) or ""
	local isSelf, isAdmin = (myName ~= "" and safeUser == myName), (safeUser == ADMIN_ROBLOX_USERNAME)
	local lockedTime = formatLockedTime(timestamp)

	local row = Instance.new("Frame")
	row.Name, row.Parent, row.LayoutOrder = "MsgRow_" .. tostring(msgOrder), MsgScroll, msgOrder
	row.Size, row.AutomaticSize, row.BackgroundTransparency, row.ZIndex = UDim2.new(1, 0, 0, 42), Enum.AutomaticSize.Y, 1, 10

	local avatarImg = Instance.new("ImageButton")
	avatarImg.Parent, avatarImg.Size = row, UDim2.new(0, 26, 0, 26)
	avatarImg.Position = isSelf and UDim2.new(1, -28, 0, 2) or UDim2.new(0, 2, 0, 2)
	avatarImg.BackgroundColor3, avatarImg.BackgroundTransparency, avatarImg.Image, avatarImg.ScaleType, avatarImg.ZIndex = Color3.fromRGB(0, 0, 0), 0.45, "rbxasset://textures/ui/GuiImagePlaceholder.png", Enum.ScaleType.Crop, 12
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
	applyAvatarAsync(avatarImg, safeUser, safeId)
	avatarImg.MouseButton1Click:Connect(function() openUserProfile(safeUser, safeId) end)

	local nameLbl = makeLbl(row, isSelf and UDim2.new(0, 4, 0, 0) or UDim2.new(0, 32, 0, 0), UDim2.new(1, -36, 0, 14), Enum.Font.GothamBold, safeUser .. " · " .. lockedTime, customColor or (isSelf and Color3.fromRGB(255, 210, 125) or Color3.fromRGB(165, 225, 255)), 10, isSelf and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left)
	nameLbl.ZIndex = 11
	if isAdmin then nameLbl.RichText, nameLbl.Text, nameLbl.TextColor3 = true, '<font color="#FFD746">' .. safeUser .. '</font> <font color="#FF3737">[ADMIN]</font> · ' .. lockedTime, Color3.fromRGB(220, 225, 240) end

	local msgStack = Instance.new("Frame")
	msgStack.Parent, msgStack.AnchorPoint = row, isSelf and Vector2.new(1, 0) or Vector2.new(0, 0)
	msgStack.Position = isSelf and UDim2.new(1, -32, 0, 15) or UDim2.new(0, 32, 0, 15)
	msgStack.Size, msgStack.AutomaticSize, msgStack.BackgroundTransparency, msgStack.ZIndex = UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.XY, 1, 11
	local stackLayout = Instance.new("UIListLayout")
	stackLayout.Parent, stackLayout.SortOrder, stackLayout.Padding = msgStack, Enum.SortOrder.LayoutOrder, UDim.new(0, 3)
	stackLayout.HorizontalAlignment = isSelf and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left

	local bubble = Instance.new("TextButton")
	bubble.Parent, bubble.LayoutOrder, bubble.Size = msgStack, 1, UDim2.new(0, 0, 0, 22)
	bubble.AutomaticSize, bubble.BackgroundColor3, bubble.BackgroundTransparency = Enum.AutomaticSize.XY, Color3.fromRGB(0, 0, 0), 0.42
	bubble.BorderSizePixel, bubble.Text, bubble.Font = 0, safeText, Enum.Font.GothamMedium
	bubble.TextColor3, bubble.TextStrokeTransparency, bubble.TextSize, bubble.TextWrapped, bubble.ZIndex = Color3.fromRGB(255, 255, 255), 0.25, 11.5, true, 11
	bubble.TextXAlignment = isSelf and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
	Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 8)
	local sLim = Instance.new("UISizeConstraint", bubble)
	sLim.MaxSize, sLim.MinSize = Vector2.new(165, 180), Vector2.new(26, 22)
	local bPad = Instance.new("UIPadding", bubble)
	bPad.PaddingTop, bPad.PaddingBottom, bPad.PaddingLeft, bPad.PaddingRight = UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 7), UDim.new(0, 7)

	local reactBadge = makeLbl(msgStack, UDim2.new(), UDim2.new(0, 24, 0, 16), Enum.Font.GothamBold, "", Color3.fromRGB(255, 255, 255), 11, Enum.TextXAlignment.Center)
	reactBadge.LayoutOrder, reactBadge.BackgroundTransparency, reactBadge.BackgroundColor3, reactBadge.Visible, reactBadge.ZIndex = 2, 0.2, Color3.fromRGB(16, 17, 24), false, 13
	Instance.new("UICorner", reactBadge).CornerRadius = UDim.new(1, 0)
	if midNum > 0 then
		reactBadgeMap[midNum] = reactBadge
		if type(initialReaction) == "string" and initialReaction ~= "" then reactBadge.Text, reactBadge.Visible = initialReaction, true end
	end
	Instance.new("UIPadding", row).PaddingBottom = UDim.new(0, 4)

	bubble.MouseButton1Click:Connect(function()
		if autoCopyText and setclipboard then
			pcall(setclipboard, autoCopyText)
			bubble.Text = "✓ Đã chép: " .. autoCopyText
			task.wait(1.2)
			if bubble and bubble.Parent then bubble.Text = safeText end
			return
		end
		selectedMsgTarget = { user = safeUser, text = safeText, userId = safeId, msgId = midNum, reactLabel = reactBadge }
		ActionSheet.Visible = true
	end)
	task.defer(function() MsgScroll.CanvasPosition = Vector2.new(0, math.max(0, MsgScroll.AbsoluteCanvasSize.Y - MsgScroll.AbsoluteWindowSize.Y)) end)
end

local isSending = false
sendDirectText = function(msgStr)
	if isSending or not reqFunc then return end
	local rawText = tostring(msgStr or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if rawText == "" then return end
	if #rawText > 200 then rawText = string.sub(rawText, 1, 200) end
	isSending, SendChatBtn.Text = true, "..."
	unlockChatStream()
	local nowTs = os.time()
	local payload = safeEncode({ user = (LocalPlayer and LocalPlayer.Name) or "Player", displayName = (LocalPlayer and LocalPlayer.DisplayName) or ((LocalPlayer and LocalPlayer.Name) or "Player"), userId = (LocalPlayer and LocalPlayer.UserId) or 0, text = rawText, time = nowTs, server = CHAT_SERVER_TAG })
	task.spawn(function()
		local ok, res = pcall(function() return reqFunc({ Url = CHAT_API_URL .. "/send", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload }) end)
		isSending, SendChatBtn.Text = false, "GỬI"
		if not (ok and res and (res.StatusCode == 200 or res.Success)) then appendChatLine("Hệ thống", "Gửi lỗi, thử lại sau", 0, nowTs, Color3.fromRGB(255, 110, 110), true) end
	end)
end

ChatPill.MouseButton1Click:Connect(function() ChatBox.Visible, ChatPill.Visible = true, false end)
HideChatBtn.MouseButton1Click:Connect(function() ChatBox.Visible, OnlinePanel.Visible, ActionSheet.Visible, ProfileModal.Visible, SendIconPopup.Visible, ChatPill.Visible = false, false, false, false, false, true end)
local function sendCrossChat() local txt = ChatInput.Text ChatInput.Text = "" sendDirectText(txt) end
SendChatBtn.MouseButton1Click:Connect(sendCrossChat)
ChatInput.FocusLost:Connect(function(enter) if enter then sendCrossChat() end end)

local lastMsgId, clearCycleSignal = 0, 0
task.spawn(function() while ChatGui and ChatGui.Parent do task.wait(300) appendChatLine("Hệ thống", DISCORD_LINK, 0, os.time(), Color3.fromRGB(170, 195, 255), true, DISCORD_LINK) end end)
task.spawn(function()
	while ChatGui and ChatGui.Parent do
		task.wait(1800)
		clearCycleSignal += 1
		reactBadgeMap = {}
		for _, c in ipairs(MsgScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
		MsgScroll.CanvasPosition = Vector2.new(0, 0)
		appendChatLine("Hệ thống", "Mỗi 30 phút hệ thống sẽ tự xoá toàn bộ tin nhắn!", 0, os.time(), Color3.fromRGB(255, 210, 130), true)
	end
end)

task.spawn(function()
	if not reqFunc then return end
	local myUser = (LocalPlayer and LocalPlayer.Name) or "Player"
	local myDisplay = (LocalPlayer and LocalPlayer.DisplayName) or myUser
	local myId = (LocalPlayer and LocalPlayer.UserId) or 0
	registerScriptUser(myUser, myDisplay, myId, os.time())

	local function ingestUserRecord(u, seenMap)
		if type(u) == "table" then
			local rName = tostring(u.user or u.username or u.realName or u.name or "")
			if rName ~= "" and rName ~= "Player" and rName ~= "Hệ thống" then
				local seenTs = tonumber(u.lastSeen or u.updatedAt or u.ping or u.time) or os.time()
				if seenTs > 1e11 then seenTs = math.floor(seenTs / 1000) end
				seenMap[rName] = { realName = rName, editedName = tostring(u.displayName or u.editedName or u.nick or rName), userId = tonumber(u.userId or u.id) or 0, lastSeen = seenTs }
			end
		elseif type(u) == "string" and u ~= "" and u ~= "Player" then
			seenMap[u] = { realName = u, editedName = u, userId = 0, lastSeen = os.time() }
		end
	end

	local function syncActiveUsers(payload)
		if type(payload) ~= "table" then return end
		local fresh = { [myUser] = { realName = myUser, editedName = myDisplay, userId = myId, lastSeen = os.time() } }
		for _, lst in ipairs({ payload.users, payload.activeUsers, payload.onlineUsers, payload.clients, payload.members }) do
			if type(lst) == "table" then
				if #lst > 0 then for _, item in ipairs(lst) do ingestUserRecord(item, fresh) end
				else for k, v in pairs(lst) do
					if type(v) == "table" then if not v.user and type(k) == "string" then v.user = k end ingestUserRecord(v, fresh)
					elseif type(k) == "string" and v then ingestUserRecord(k, fresh) end
				end end
			end
		end
		local explicitNum = tonumber(payload.online or payload.onlineCount or payload.count or payload.activeCount)
		if explicitNum and explicitNum > 0 then externalOnlineCount = explicitNum end
		activeScriptUsers = fresh
		rebuildOnlineList()
	end

	task.spawn(function()
		while true do
			pcall(function()
				local r = reqFunc({ Url = CHAT_API_URL .. "/ping", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = safeEncode({ user = myUser, displayName = myDisplay, userId = myId, server = CHAT_SERVER_TAG, placeId = game.PlaceId }) })
				local pData = r and r.Body and safeDecode(r.Body)
				if type(pData) == "table" then syncActiveUsers(pData) end
			end)
			task.wait(15)
		end
	end)

	local seededInitialHistory = false
	while true do
		local seenClearAtStart = clearCycleSignal
		local url = CHAT_API_URL .. "/messages" .. (lastMsgId > 0 and ("?after=" .. tostring(lastMsgId)) or "")
		local ok, res = pcall(function() return reqFunc({ Url = url, Method = "GET" }) end)
		if ok and res and (res.StatusCode == 200 or res.Success) then
			local data = safeDecode(res.Body)
			if type(data) == "table" then
				syncActiveUsers(data)
				if type(data.reactions) == "table" then for rMid, rEmo in pairs(data.reactions) do applyReactionToBadge(rMid, rEmo) end end
				if type(data.messages) == "table" then
					for _, m in ipairs(data.messages) do
						local mid, rx, mUser = tonumber(m.id) or 0, m.reaction or m.emoji, tostring(m.user or "Player")
						local mDisp, mUid, mTs = tostring(m.displayName or ""), tonumber(m.userId) or 0, m.time or m.timestamp or m.createdAt
						if mUser ~= "" and mUser ~= "Player" and mUser ~= "Hệ thống" then registerScriptUser(mUser, mDisp, mUid, mTs) end
						if mid > lastMsgId then
							lastMsgId = mid
							if seededInitialHistory and seenClearAtStart == clearCycleSignal then appendChatLine(mUser, tostring(m.text or ""), mUid, mTs, nil, true, nil, mid, rx) end
						elseif mid > 0 and type(rx) == "string" and rx ~= "" then applyReactionToBadge(mid, rx) end
					end
					seededInitialHistory = true
				end
			end
		end
		task.wait(2)
	end
end)

local RunBtn = Instance.new("TextButton")
RunBtn.Parent, RunBtn.Position, RunBtn.Size = MainFrame, UDim2.new(0, 8, 0, 360), UDim2.new(1, -16, 0, 24)
RunBtn.BackgroundColor3, RunBtn.Font, RunBtn.Text = Color3.fromRGB(255, 105, 35), Enum.Font.GothamBold, "🚀 CHẠY SCRIPT"
RunBtn.TextColor3, RunBtn.TextSize, RunBtn.ZIndex = Color3.fromRGB(255, 255, 255), 10, 2
Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(1, 0)

RunBtn.MouseButton1Click:Connect(function()
	RunBtn.Text = "⏳ ĐANG TẢI & FIX LAG..."
	if FpsBoostEnabled then ApplyFixLag() end
	local hubTitleText = SelectedHub == "Venyx" and "Venyx Hub V13 Max" or (SelectedHub == "Divine" and "Divine Hub (Aquavine)" or "Chilli & Venyx & Divine V13 Max")
	local ActiveGui = Instance.new("ScreenGui")
	ActiveGui.Name, ActiveGui.ResetOnSpawn = "ActiveHubNotification", false
	attachGui(ActiveGui)
	local NotifFrame = Instance.new("Frame")
	NotifFrame.Parent, NotifFrame.AnchorPoint, NotifFrame.Position, NotifFrame.Size = ActiveGui, Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 240, 0, 56)
	NotifFrame.BackgroundColor3, NotifFrame.BackgroundTransparency = Color3.fromRGB(16, 16, 22), 0.2
	Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(1, 0)
	local RainbowStroke = Instance.new("UIStroke", NotifFrame)
	RainbowStroke.Thickness = 2.5
	task.spawn(function() local h = 0 while RainbowStroke and RainbowStroke.Parent do h = (h + 0.01) % 1 RainbowStroke.Color = Color3.fromHSV(h, 1, 1) task.wait(0.04) end end)
	MakeDraggable(NotifFrame)
	local IconContainer = Instance.new("Frame", NotifFrame)
	IconContainer.Position, IconContainer.Size, IconContainer.BackgroundTransparency = UDim2.new(0, 8, 0.5, -13), UDim2.new(0, 26, 0, 26), 1
	local IconImage = Instance.new("ImageLabel", IconContainer)
	IconImage.Size, IconImage.BackgroundTransparency, IconImage.Image, IconImage.ScaleType = UDim2.new(1, 0, 1, 0), 1, "rbxassetid://83467411655369", Enum.ScaleType.Crop
	Instance.new("UICorner", IconImage).CornerRadius = UDim.new(1, 0)
	local NotifTitle = makeLbl(NotifFrame, UDim2.new(0, 38, 0, 5), UDim2.new(1, -75, 0, 15), Enum.Font.GothamBold, hubTitleText, Color3.fromRGB(255, 190, 120), 9)
	local NotifSub = makeLbl(NotifFrame, UDim2.new(0, 38, 0, 21), UDim2.new(1, -75, 0, 14), Enum.Font.GothamBold, "👤 Tác giả: Hirose x Miyano | 💬 Bấm copy link", Color3.fromRGB(255, 100, 100), 7.5)
	local NotifDetail = makeLbl(NotifFrame, UDim2.new(0, 38, 0, 35), UDim2.new(1, -75, 0, 14), Enum.Font.GothamMedium, "discord.gg/uqhEpzXy9q", Color3.fromRGB(160, 170, 255), 8)
	local ClickBtn = Instance.new("TextButton", NotifFrame)
	ClickBtn.Position, ClickBtn.Size, ClickBtn.BackgroundTransparency, ClickBtn.Text = UDim2.new(0, 38, 0, 0), UDim2.new(1, -75, 1, 0), 1, ""
	ClickBtn.MouseButton1Click:Connect(function() if setclipboard then pcall(setclipboard, DISCORD_LINK) end NotifTitle.Text = "✓ ĐÃ SAO CHÉP LINK!" task.wait(1.5) NotifTitle.Text = hubTitleText end)
	local MinimizeText = makeLbl(NotifFrame, UDim2.new(0, 12, 0, 0), UDim2.new(1, -44, 1, 0), Enum.Font.GothamBold, "Tác Giả: Hirose x Miyano", Color3.fromRGB(255, 120, 120), 9)
	MinimizeText.Visible = false
	local ToggleBtn = Instance.new("TextButton", NotifFrame)
	ToggleBtn.Position, ToggleBtn.Size = UDim2.new(1, -32, 0.5, -14), UDim2.new(0, 26, 0, 26)
	ToggleBtn.BackgroundColor3, ToggleBtn.Font, ToggleBtn.Text, ToggleBtn.TextColor3, ToggleBtn.TextSize = Color3.fromRGB(40, 40, 55), Enum.Font.GothamBold, "▲", Color3.fromRGB(255, 255, 255), 11
	Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
	local isMin = false
	ToggleBtn.MouseButton1Click:Connect(function()
		isMin = not isMin
		ToggleBtn.Text = isMin and "▼" or "▲"
		TweenService:Create(NotifFrame, TweenInfo.new(0.2), {Size = isMin and UDim2.new(0, 160, 0, 32) or UDim2.new(0, 240, 0, 56)}):Play()
		if isMin then NotifTitle.Visible, NotifSub.Visible, NotifDetail.Visible, IconContainer.Visible, MinimizeText.Visible = false, false, false, false, true
		else MinimizeText.Visible = false task.wait(0.1) NotifTitle.Visible, NotifSub.Visible, NotifDetail.Visible, IconContainer.Visible = true, true, true, true end
	end)
	task.spawn(function() local f, err = loadstring(SCRIPTS[SelectedHub]) if f then f() else warn("Lỗi load script: " .. tostring(err)) end end)
	task.wait(0.5) ScreenGui:Destroy()
end)
	
