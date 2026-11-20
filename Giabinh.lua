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
	Divine = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Aquavine/main/Divine"))()'
}

local SelectedHub = "Chilli"
local SoundEnabled = true
local FpsBoostEnabled = true

local reqFunc = (syn and syn.request)
	or (http and http.request)
	or http_request
	or request
	or (HttpService and function(opts)
		local body = HttpService:RequestAsync({
			Url = opts.Url,
			Method = opts.Method or "GET",
			Headers = opts.Headers or {},
			Body = opts.Body
		})
		return {
			StatusCode = body.StatusCode,
			Success = body.Success,
			Body = body.Body
		}
	end)

local function safeEncode(tbl)
	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(tbl)
	end)
	return ok and encoded or "{}"
end

local function safeDecode(str)
	if type(str) ~= "string" or str == "" then return nil end
	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(str)
	end)
	return ok and decoded or nil
end

local function ApplyFixLag()
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		if settings and settings().Rendering then
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end
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
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
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
MainFrame.Size = UDim2.new(0, 310, 0, 365)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
MakeDraggable(MainFrame)

local TitleBar = Instance.new("TextLabel")
TitleBar.Parent = MainFrame
TitleBar.Position = UDim2.new(0, 12, 0, 8)
TitleBar.Size = UDim2.new(1, -60, 0, 24)
TitleBar.BackgroundTransparency = 1
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "HIROSE x MIYANNO V13 MAX"
TitleBar.TextColor3 = Color3.fromRGB(255, 195, 110)
TitleBar.TextSize = 14
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 55, 65)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Parent = MainFrame
AuthorLabel.Position = UDim2.new(0, 12, 0, 34)
AuthorLabel.Size = UDim2.new(1, -24, 0, 18)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Font = Enum.Font.Gotham
AuthorLabel.Text = "Tac gia: Hirose x Miyanno | Hub da chon: Chilli"
AuthorLabel.TextColor3 = Color3.fromRGB(190, 198, 220)
AuthorLabel.TextSize = 11
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
local hubNames = {"Chilli", "Venyx", "Divine"}
local hubButtons = {}

for idx, hName in ipairs(hubNames) do
	local btn = Instance.new("TextButton")
	btn.Name = "Hub_" .. hName
	btn.Parent = MainFrame
	btn.Position = UDim2.new(0, 12 + (idx - 1) * 98, 0, 62)
	btn.Size = UDim2.new(0, 90, 0, 32)
	btn.Font = Enum.Font.GothamBold
	btn.Text = hName
	btn.TextSize = 12
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = (hName == SelectedHub) and Color3.fromRGB(255, 120, 35) or Color3.fromRGB(36, 40, 54)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	hubButtons[hName] = btn

	btn.MouseButton1Click:Connect(function()
		SelectedHub = hName
		AuthorLabel.Text = "Tac gia: Hirose x Miyanno | Hub da chon: " .. SelectedHub
		for k, b in pairs(hubButtons) do
			b.BackgroundColor3 = (k == SelectedHub) and Color3.fromRGB(255, 120, 35) or Color3.fromRGB(36, 40, 54)
		end
	end)
end

local FpsBtn = Instance.new("TextButton")
FpsBtn.Parent = MainFrame
FpsBtn.Position = UDim2.new(0, 12, 0, 104)
FpsBtn.Size = UDim2.new(1, -24, 0, 32)
FpsBtn.BackgroundColor3 = Color3.fromRGB(45, 130, 85)
FpsBtn.Font = Enum.Font.GothamBold
FpsBtn.Text = "FPS Boost & Fix Lag: BAT"
FpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsBtn.TextSize = 12
Instance.new("UICorner", FpsBtn).CornerRadius = UDim.new(0, 8)
FpsBtn.MouseButton1Click:Connect(function()
	FpsBoostEnabled = not FpsBoostEnabled
	FpsBtn.Text = "FPS Boost & Fix Lag: " .. (FpsBoostEnabled and "BAT" or "TAT")
	FpsBtn.BackgroundColor3 = FpsBoostEnabled and Color3.fromRGB(45, 130, 85) or Color3.fromRGB(60, 64, 78)
end)

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Parent = MainFrame
DiscordBtn.Position = UDim2.new(0, 12, 0, 144)
DiscordBtn.Size = UDim2.new(1, -24, 0, 32)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.Text = "SAO CHEP LINK DISCORD"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 12
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)
DiscordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		pcall(function() setclipboard(DISCORD_LINK) end)
		DiscordBtn.Text = "DA SAO CHEP DISCORD!"
		task.delay(1.5, function()
			if DiscordBtn then DiscordBtn.Text = "SAO CHEP LINK DISCORD" end
		end)
	end
end)

local RunBtn = Instance.new("TextButton")
RunBtn.Parent = MainFrame
RunBtn.Position = UDim2.new(0, 12, 0, 315)
RunBtn.Size = UDim2.new(1, -24, 0, 38)
RunBtn.BackgroundColor3 = Color3.fromRGB(255, 110, 25)
RunBtn.Font = Enum.Font.GothamBold
RunBtn.Text = "CHAY SCRIPT"
RunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RunBtn.TextSize = 14
Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0, 10)
RunBtn.MouseButton1Click:Connect(function()
	if FpsBoostEnabled then
		ApplyFixLag()
	end
	local codeStr = SCRIPTS[SelectedHub]
	if codeStr then
		local ok, err = pcall(function()
			local fn = loadstring(codeStr)
			if fn then fn() end
		end)
		if not ok then
			warn("Loi chay hub: " .. tostring(err))
		end
	end
end)

local ChatPill = Instance.new("TextButton")
ChatPill.Name = "ChatPill"
ChatPill.Parent = ScreenGui
ChatPill.Position = UDim2.new(0.03, 0, 0.78, 0)
ChatPill.Size = UDim2.new(0, 96, 0, 28)
ChatPill.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
ChatPill.Font = Enum.Font.GothamBold
ChatPill.Text = "V13 CHAT"
ChatPill.TextColor3 = Color3.fromRGB(255, 200, 110)
ChatPill.TextSize = 12
ChatPill.ZIndex = 9
Instance.new("UICorner", ChatPill).CornerRadius = UDim.new(1, 0)
MakeDraggable(ChatPill)

local ChatBox = Instance.new("Frame")
ChatBox.Name = "ChatBox"
ChatBox.Parent = ScreenGui
ChatBox.Size = UDim2.new(0, 275, 0, 235)
ChatBox.Position = UDim2.new(0.03, 0, 0.22, 0)
ChatBox.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
ChatBox.BackgroundTransparency = 0.1
ChatBox.BorderSizePixel = 0
ChatBox.Active = true
ChatBox.Visible = false
ChatBox.ZIndex = 9
ChatBox.ClipsDescendants = true
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
ChatBg.ImageTransparency = 0.2
ChatBg.ZIndex = 9
Instance.new("UICorner", ChatBg).CornerRadius = UDim.new(0, 12)

local ChatDim = Instance.new("Frame")
ChatDim.Parent = ChatBox
ChatDim.Size = UDim2.new(1, 0, 1, 0)
ChatDim.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
ChatDim.BackgroundTransparency = 0.45
ChatDim.BorderSizePixel = 0
ChatDim.ZIndex = 9
Instance.new("UICorner", ChatDim).CornerRadius = UDim.new(0, 12)
local ChatHeader = Instance.new("TextLabel")
ChatHeader.Parent = ChatBox
ChatHeader.Position = UDim2.new(0, 10, 0, 4)
ChatHeader.Size = UDim2.new(1, -40, 0, 22)
ChatHeader.BackgroundTransparency = 1
ChatHeader.Font = Enum.Font.GothamBold
ChatHeader.Text = "CHAT XUYEN SERVER"
ChatHeader.TextColor3 = Color3.fromRGB(255, 205, 130)
ChatHeader.TextSize = 12
ChatHeader.TextXAlignment = Enum.TextXAlignment.Left
ChatHeader.ZIndex = 11

local HideChatBtn = Instance.new("TextButton")
HideChatBtn.Parent = ChatBox
HideChatBtn.Position = UDim2.new(1, -28, 0, 5)
HideChatBtn.Size = UDim2.new(0, 20, 0, 20)
HideChatBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 62)
HideChatBtn.Font = Enum.Font.GothamBold
HideChatBtn.Text = "-"
HideChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideChatBtn.TextSize = 13
HideChatBtn.ZIndex = 11
Instance.new("UICorner", HideChatBtn).CornerRadius = UDim.new(0, 6)

local MsgScroll = Instance.new("ScrollingFrame")
MsgScroll.Parent = ChatBox
MsgScroll.Position = UDim2.new(0, 6, 0, 28)
MsgScroll.Size = UDim2.new(1, -12, 1, -64)
MsgScroll.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
MsgScroll.BackgroundTransparency = 0.55
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
local function getAvatarUrl(userId)
	local idNum = tonumber(userId)
	if not idNum or idNum <= 0 then
		return "rbxasset://textures/ui/GuiImagePlaceholder.png"
	end
	if avatarCache[idNum] then
		return avatarCache[idNum]
	end
	local ok, url = pcall(function()
		return Players:GetUserThumbnailAsync(idNum, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if ok and url then
		avatarCache[idNum] = url
		return url
	end
	return "rbxasset://textures/ui/GuiImagePlaceholder.png"
end

local msgOrder = 0
local function appendChatLine(username, text, userId, textColor)
	msgOrder += 1
	local row = Instance.new("Frame")
	row.Name = "MsgRow_" .. tostring(msgOrder)
	row.Parent = MsgScroll
	row.LayoutOrder = msgOrder
	row.Size = UDim2.new(1, 0, 0, 0)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
	row.BackgroundTransparency = 0.45
	row.BorderSizePixel = 0
	row.ZIndex = 10
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Parent = row
	avatarImg.Position = UDim2.new(0, 5, 0, 5)
	avatarImg.Size = UDim2.new(0, 26, 0, 26)
	avatarImg.BackgroundTransparency = 1
	avatarImg.Image = getAvatarUrl(userId)
	avatarImg.ZIndex = 11
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

	local msgLabel = Instance.new("TextLabel")
	msgLabel.Parent = row
	msgLabel.Position = UDim2.new(0, 36, 0, 3)
	msgLabel.Size = UDim2.new(1, -42, 0, 0)
	msgLabel.AutomaticSize = Enum.AutomaticSize.Y
	msgLabel.BackgroundTransparency = 1
	msgLabel.RichText = true
	msgLabel.Font = Enum.Font.GothamMedium
	local safeUser = tostring(username or "Player")
	local safeText = tostring(text or "")
	msgLabel.Text = '<font size="13"><b>' .. safeUser .. '</b></font>\n<font size="12">' .. safeText .. "</font>"
	msgLabel.TextColor3 = textColor or Color3.fromRGB(245, 247, 255)
	msgLabel.TextSize = 12
	msgLabel.TextWrapped = true
	msgLabel.TextXAlignment = Enum.TextXAlignment.Left
	msgLabel.ZIndex = 11

	local rowPad = Instance.new("UIPadding")
	rowPad.Parent = row
	rowPad.PaddingBottom = UDim.new(0, 4)

	task.defer(function()
		MsgScroll.CanvasPosition = Vector2.new(0, math.max(0, MsgScroll.AbsoluteCanvasSize.Y - MsgScroll.AbsoluteSize.Y))
	end)
end

local ChatInput = Instance.new("TextBox")
ChatInput.Parent = ChatBox
ChatInput.Position = UDim2.new(0, 6, 1, -29)
ChatInput.Size = UDim2.new(1, -62, 0, 24)
ChatInput.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
ChatInput.BackgroundTransparency = 0.15
ChatInput.Font = Enum.Font.Gotham
ChatInput.PlaceholderText = "Nhap tin nhan..."
ChatInput.PlaceholderColor3 = Color3.fromRGB(165, 170, 185)
ChatInput.Text = ""
ChatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatInput.TextSize = 11
ChatInput.ClearTextOnFocus = false
ChatInput.ZIndex = 11
Instance.new("UICorner", ChatInput).CornerRadius = UDim.new(0, 7)

local SendChatBtn = Instance.new("TextButton")
SendChatBtn.Parent = ChatBox
SendChatBtn.Position = UDim2.new(1, -52, 1, -29)
SendChatBtn.Size = UDim2.new(0, 46, 0, 24)
SendChatBtn.BackgroundColor3 = Color3.fromRGB(255, 145, 35)
SendChatBtn.Font = Enum.Font.GothamBold
SendChatBtn.Text = "GUI"
SendChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendChatBtn.TextSize = 11
SendChatBtn.ZIndex = 11
Instance.new("UICorner", SendChatBtn).CornerRadius = UDim.new(0, 7)

ChatPill.MouseButton1Click:Connect(function()
	ChatBox.Visible = not ChatBox.Visible
end)
HideChatBtn.MouseButton1Click:Connect(function()
	ChatBox.Visible = false
end)

local isSending = false
local function sendCrossChat()
	if isSending or not reqFunc then return end
	local rawText = ChatInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if rawText == "" then return end
	if #rawText > 200 then rawText = string.sub(rawText, 1, 200) end
	isSending = true
	SendChatBtn.Text = "..."
	ChatInput.Text = ""

	local uid = (LocalPlayer and LocalPlayer.UserId) or 0
	local uname = (LocalPlayer and LocalPlayer.Name) or "Player"
	local payload = safeEncode({
		user = uname,
		userId = uid,
		text = rawText,
		server = CHAT_SERVER_TAG
	})

	task.spawn(function()
		local ok, res = pcall(function()
			return reqFunc({
				Url = CHAT_API_URL .. "/send",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = payload
			})
		end)
		isSending = false
		SendChatBtn.Text = "GUI"
		if not (ok and res and (res.StatusCode == 200 or res.Success)) then
			appendChatLine("He thong", "Gui loi, thu lai sau", 0, Color3.fromRGB(255, 120, 120))
		end
	end)
end

SendChatBtn.MouseButton1Click:Connect(sendCrossChat)
ChatInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then sendCrossChat() end
end)

local lastMsgId = 0
task.spawn(function()
	if not reqFunc then return end
	appendChatLine("Hirose x Miyanno", "Da ket noi chat xuyen server!", 0, Color3.fromRGB(130, 255, 185))
	while true do
		local url = CHAT_API_URL .. "/messages" .. (lastMsgId > 0 and ("?after=" .. tostring(lastMsgId)) or "")
		local ok, res = pcall(function()
			return reqFunc({ Url = url, Method = "GET" })
		end)
		if ok and res and (res.StatusCode == 200 or res.Success) then
			local data = safeDecode(res.Body)
			if type(data) == "table" and data.ok and type(data.messages) == "table" then
				for _, m in ipairs(data.messages) do
					local mid = tonumber(m.id) or 0
					if mid > lastMsgId then
						lastMsgId = mid
						appendChatLine(tostring(m.user or "Player"), tostring(m.text or ""), m.userId)
					end
				end
			end
		end
		task.wait(2)
	end
end)
