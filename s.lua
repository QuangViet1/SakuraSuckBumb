local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Check if the local player is whitelisted
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
	Name = "TWEN ARC",
	Icon = 0,
	LoadingTitle = "Rayfield Interface Suite",
	LoadingSubtitle = "by Sirius",
	ShowText = "Rayfield",
	Theme = {
		TextColor = Color3.fromRGB(255, 230, 230),
		Background = Color3.fromRGB(25, 10, 10),
		Topbar = Color3.fromRGB(50, 15, 15),
		Shadow = Color3.fromRGB(20, 5, 5),

		NotificationBackground = Color3.fromRGB(60, 20, 20),
		NotificationActionsBackground = Color3.fromRGB(255, 120, 120),

		TabBackground = Color3.fromRGB(130, 40, 40),
		TabStroke = Color3.fromRGB(200, 60, 60),
		TabBackgroundSelected = Color3.fromRGB(255, 90, 90),
		TabTextColor = Color3.fromRGB(255, 190, 190),
		SelectedTabTextColor = Color3.fromRGB(50, 10, 10),

		ElementBackground = Color3.fromRGB(70, 25, 25),
		ElementBackgroundHover = Color3.fromRGB(90, 30, 30),
		SecondaryElementBackground = Color3.fromRGB(50, 20, 20),
		ElementStroke = Color3.fromRGB(200, 70, 70),
		SecondaryElementStroke = Color3.fromRGB(150, 60, 60),

		SliderBackground = Color3.fromRGB(255, 90, 90),
		SliderProgress = Color3.fromRGB(255, 60, 60),
		SliderStroke = Color3.fromRGB(255, 130, 130),

		ToggleBackground = Color3.fromRGB(80, 25, 25),
		ToggleEnabled = Color3.fromRGB(255, 70, 70),
		ToggleDisabled = Color3.fromRGB(140, 60, 60),
		ToggleEnabledStroke = Color3.fromRGB(255, 120, 120),
		ToggleDisabledStroke = Color3.fromRGB(160, 80, 80),
		ToggleEnabledOuterStroke = Color3.fromRGB(255, 150, 150),
		ToggleDisabledOuterStroke = Color3.fromRGB(90, 40, 40),

		DropdownSelected = Color3.fromRGB(120, 40, 40),
		DropdownUnselected = Color3.fromRGB(90, 30, 30),

		InputBackground = Color3.fromRGB(70, 20, 20),
		InputStroke = Color3.fromRGB(200, 70, 70),
		PlaceholderColor = Color3.fromRGB(255, 180, 180)
	},
	ToggleUIKeybind = Enum.KeyCode.Tab,
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "Twen Arc"
	},
	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},
	KeySystem = false,
	KeySettings = {
		Title = "Twen ARC",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided",
		FileName = "Key",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"keocondeptrai"}
	}
})

local Locationsss = workspace:WaitForChild("Locations")
local Blacklist = {
	["WutheringHeights"] = true,
    ["AlleyCave2"] = true,
    ["AlleyCaveEntrance"] = true,
    ["Atlantis"] = true,
    ["AzureLatch2"] = true,
    ["BladeCemetery"] = true,
    ["CalmWater"] = true,
    ["Cave"] = true,
    ["DarkAlley"] = true,
    ["DullahanArena"] = true,
    ["Ethrixlame"] = true,
    ["Forest2"] = true,
    ["GrailRoom"] = true,
    ["HolyCheckPart"] = true,
    ["Hueco"] = true,
    ["Keter"] = true,
    ["La Manchaland"] = true,
    ["LasNoches"] = true,
    ["MenosForest"] = true,
    ["NothingThere"] = true,
    ["Office"] = true,
    ["Office2"] = true,
    ["Office3"] = true,
    ["P2"] = true,
    ["Pit"] = true,
    ["Rip"] = true,
    ["RokaLab"] = true,
    ["Shop"] = true,
    ["Sigil"] = true,
    ["TallestPeak"] = true,
    ["UPODRoom"] = true,
    ["Urahara"] = true,
    ["WutheringHeights2"] = true,
    ["infcastle"] = true,
    ["Beach"] = true,
}
local OptionsList = {}
local LocationMap = {}
for _, obj in pairs(Locationsss:GetChildren()) do
if (obj:IsA("BasePart") or obj:IsA("Model")) and not Blacklist[obj.Name] then
	table.insert(OptionsList, obj.Name)
	LocationMap[obj.Name] = obj
end
end
local SelectedPlace = nil









local autoFarmTab = Window:CreateTab("Auto Farm", "package")
local itemSection = autoFarmTab:CreateSection("Auto Farm")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local LEVEL_ITEM_NAMES = {"Box", "Barrel", "BoxDrop","Chest"} 
local COLLECT_IGNORE = {"Box", "Barrel", "BoxDrop", "Chest", "A Nest", "PerceptionMask"}

local autoFarmEnabled = false
local autoCollectEnabled = false
local retryItems = {}

-- Update character
local function updateCharacter()
	character = plr.Character or plr.CharacterAdded:Wait()
	hrp = character:WaitForChild("HumanoidRootPart", 5)
end
plr.CharacterAdded:Connect(updateCharacter)

local function isLevelItem(itemName)
	for _, word in ipairs(LEVEL_ITEM_NAMES) do
		if string.lower(itemName) == string.lower(word) then return true end
	end
	return false
end

local function isCollectIgnored(itemName)
	for _, word in ipairs(COLLECT_IGNORE) do
		if string.lower(itemName) == string.lower(word) then return true end
	end
	return false
end

local function interactPrompt(prompt)
	if not prompt then return end
	pcall(function()
		fireproximityprompt(prompt, 1)
	end)
end

local function collectPrompt(prompt)
	if not prompt or not prompt.Parent or not hrp then return end
	local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
	if targetPart then
		hrp.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
		task.wait(0.1)  -- ลด delay เพื่อวาปเร็ว
		prompt.HoldDuration = 0
		interactPrompt(prompt)
	end
end

local function getValidLevelPrompts()
	local results = {}
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") and v.Parent and v.Enabled and isLevelItem(v.Parent.Name) then
			table.insert(results, v)
		end
	end
	return results
end

local function tryCollectItem(item)
	if not item:IsDescendantOf(Workspace) then return false end
	if isCollectIgnored(item.Name) then return false end

	local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
	if not prompt or not prompt.Enabled then
		if not table.find(retryItems, item) then table.insert(retryItems, item) end
		return false
	end

	prompt.HoldDuration = 0

	local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or item
	if hrp then
		hrp.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
	end

	task.wait(0.1)  -- ลด delay เพื่อวาปเร็ว
	interactPrompt(prompt)
	task.wait(0.05)

	if not item:IsDescendantOf(Workspace) then
		for i = #retryItems, 1, -1 do
			if retryItems[i] == item then table.remove(retryItems, i) end
		end
		return true
	else
		if not table.find(retryItems, item) then
			table.insert(retryItems, item)
		end
		return false
	end
end

-- Main Auto Loop
task.spawn(function()
	while true do
		task.wait(0.15)  -- loop เร็วขึ้น

		-- Auto Farm Level
		if autoFarmEnabled then
			local levelPrompts = getValidLevelPrompts()
			for _, prompt in ipairs(levelPrompts) do
				if not autoFarmEnabled then break end
				collectPrompt(prompt)
				task.wait(0.15)  -- delay สั้นสุดที่ยังเก็บติด
			end
		end

		-- Auto Collect Items
		if autoCollectEnabled and Workspace:FindFirstChild("Item") then
			for _, item in ipairs(Workspace.Item:GetChildren()) do
				if not isCollectIgnored(item.Name) then
					tryCollectItem(item)
					task.wait(0.1)
				end
			end

			-- Retry Items
			for i = #retryItems, 1, -1 do
				local item = retryItems[i]
				if item and item:IsDescendantOf(Workspace) then
					tryCollectItem(item)
					task.wait(0.1)
				else
					table.remove(retryItems, i)
				end
			end
		end
	end
end)

-- UI Toggles
autoFarmTab:CreateToggle({
	Name = "Auto Farm Level",
	CurrentValue = false,
	Callback = function(state)
		autoFarmEnabled = state
	end
})

autoFarmTab:CreateToggle({
	Name = "Auto Collect Item",
	CurrentValue = false,
	Callback = function(state)
		autoCollectEnabled = state
	end
})


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart", 5)

local autoDungeonEnabled = false
local followDelay = 0.2 -- เวลาระหว่างเช็คตำแหน่งมอน
local dungeonCFrame = CFrame.new(-9287.55078, 802.958313, 9028.80469)
local currentTarget = nil

-- อัปเดต HRP เวลารีเกิด
plr.CharacterAdded:Connect(function(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart", 5)
end)

-- ฟังก์ชันกด ProximityPrompt
local function interactPrompt(prompt)
	if fireproximityprompt then
		fireproximityprompt(prompt)
	else
		prompt.HoldDuration = 0
		prompt:InputHoldBegin()
		task.wait(0.1)
		prompt:InputHoldEnd()
	end
end

local autoUpgradeMaster = false
local autoBreakthrough = false

-- RemoteEvents
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradeRemote = ReplicatedStorage:WaitForChild("GlobalUsedRemotes"):WaitForChild("UpgradeMas")
local BreakthroughRemote = ReplicatedStorage:WaitForChild("GlobalUsedRemotes"):WaitForChild("Breakthrough")

-- Auto UpgradeMas Loop
task.spawn(function()
	while true do
		task.wait(0.5)
		if autoUpgradeMaster then
			pcall(function()
				UpgradeRemote:FireServer()
			end)
		end
	end
end)

-- Auto Breakthrough Loop
task.spawn(function()
	while true do
		task.wait(0.5)
		if autoBreakthrough then
			pcall(function()
				BreakthroughRemote:FireServer()
			end)
		end
	end
end)

-- UI Toggles
autoFarmTab:CreateToggle({
	Name = "Auto Upgrade Master",
	CurrentValue = false,
	Callback = function(state)
		autoUpgradeMaster = state
	end
})

autoFarmTab:CreateToggle({
	Name = "Auto Breakthrough",
	CurrentValue = false,
	Callback = function(state)
		autoBreakthrough = state
	end
})



local Remote = game:GetService("ReplicatedStorage"):WaitForChild("GlobalUsedRemotes"):WaitForChild("ArcadePurchase")
local args = {false, false, 10}
local autoEat = false


autoFarmTab:CreateButton({
	Name = "Random Skin x10",
	Callback = function()
		local args = {
			false,
			false,
			10
		}
		game:GetService("ReplicatedStorage"):WaitForChild("GlobalUsedRemotes"):WaitForChild("ArcadePurchase"):FireServer(unpack(args))
	end,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local autoBlockEnabled = false
local followDistance = 3 -- ระยะห่างจาก Dummy

-- Remote ของแบบที่ 1
local ReliableRemote = ReplicatedStorage:WaitForChild("ABC - First Priority")
	:WaitForChild("Utility"):WaitForChild("Modules"):WaitForChild("Warp")
	:WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable")

-- Remote ของแบบที่ 2
local BlockRemote = ReplicatedStorage:WaitForChild("SummerTimeRemote"):WaitForChild("Block")

-- ฟังก์ชันบล็อกแบบที่ 1
local function holdBlockType1()
	local args = {
		"\016",
		"\254\002\000\006\001F\005\001"
	}
	while autoBlockEnabled do
		pcall(function()
			ReliableRemote:FireServer(unpack(args))
		end)
		task.wait(0.05)
	end
end

-- ฟังก์ชันบล็อกแบบที่ 2
local function holdBlockType2()
	local args = {true}
	while autoBlockEnabled do
		pcall(function()
			BlockRemote:FireServer(unpack(args))
		end)
		task.wait(0.05)
	end
end
--t4m

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalRemotes = ReplicatedStorage:WaitForChild("GlobalUsedRemotes")

-- ฟังก์ชัน
local function TokenToMoney()
	local args = {"T4C"}
	GlobalRemotes:WaitForChild("TokenExchange"):FireServer(unpack(args))

end

local function MoneyToToken()
	local args = {"C4T"}
	GlobalRemotes:WaitForChild("TokenExchange"):FireServer(unpack(args))

end

local function GetDailyQuest()
	GlobalRemotes:WaitForChild("GetDailyQuest"):FireServer()

end


-- สร้างปุ่ม Button เรียกใช้ฟังก์ชัน
autoFarmTab:CreateButton({
	Name = "Tokens for Money",
	Callback = function()
		TokenToMoney()
	end
})

autoFarmTab:CreateButton({
	Name = "Money for Tokens",
	Callback = function()
		MoneyToToken()
	end
})

autoFarmTab:CreateButton({
	Name = "Get Daily Quest",
	Callback = function()
		GetDailyQuest()
	end
})

local autoSellTab = Window:CreateTab("Auto Sell", "shopping-cart")
local autoSellSection = autoSellTab:CreateSection("Sell")

local sellableItems = {
	"Arrow", "Mysterious Camera", "Hamon Manual", "Rokakaka", "Stop Sign", "Stone Mask",
	"Haunted Sword", "Spin Manual", "Barrel", "Bomu Bomu Devil Fruit",
	"Mochi Mochi Devil Fruit", "Bari Bari Devil Fruit"
}

local keepItems = {} -- ตารางเก็บไอเทมที่ผู้เล่นเลือก "จะเก็บไว้"
local sellToggleRunning = false
local sellToggleTask = nil

-- Function: เช็คว่าไอเทมขายได้หรือไม่
local function shouldSell(itemName)
	-- ถ้าอยู่ใน keepItems (เลือกเก็บไว้) → ไม่ขาย
	if keepItems[itemName] then
		return false
	end

	-- ถ้าอยู่ใน sellableItems → ขายได้
	for _, v in ipairs(sellableItems) do
		if v == itemName then
			return true
		end
	end
	return false
end

-- Function: ขายของในกระเป๋า
local function autoSellBackpackFast()
	local backpack = plr:FindFirstChild("Backpack")
	if not backpack then return end
	local sellRemote = game:GetService("ReplicatedStorage"):WaitForChild("GlobalUsedRemotes"):WaitForChild("SellItem")

	for _, item in ipairs(backpack:GetChildren()) do
		if shouldSell(item.Name) then
			pcall(function()
				sellRemote:FireServer(item.Name)
			end)
			task.wait(0.05)
		end
	end
end

-- กดคุยกับ NPC
local function interactNPC(npc)
	if not npc or not npc:IsDescendantOf(workspace) then return end
	local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
	if prompt then
		pcall(function() prompt:InputHoldBegin() end)
		task.wait(prompt.HoldDuration or 1.5)
		pcall(function() prompt:InputHoldEnd() end)
		return true
	end
	return false
end

-- วนลูป Auto Sell
local function autoSellLoop()
	sellToggleTask = task.spawn(function()
		while sellToggleRunning do
			local npc = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("NPCs") and workspace.Map.NPCs:FindFirstChild("Chxmei")
			if npc then
				interactNPC(npc)
				autoSellBackpackFast()
			else
				warn("❌ NPC 'Chxmei' ไม่พบ")
			end
			task.wait(3)
		end
	end)
end

-- Toggle เปิด/ปิด Auto Sell
autoSellTab:CreateToggle({
	Name = "Auto Sell Items",
	CurrentValue = false,
	Callback = function(state)
		if state then
			sellToggleRunning = true
			autoSellLoop()
		else
			sellToggleRunning = false
			if sellToggleTask then
				task.cancel(sellToggleTask)
				sellToggleTask = nil
			end
		end
	end
})


for _, itemName in ipairs(sellableItems) do
	autoSellTab:CreateToggle({
		Name = "Keep " .. itemName,
		CurrentValue = false,
		Callback = function(state)
			if state then
				keepItems[itemName] = true

			else
				keepItems[itemName] = nil

			end
		end
	})
end

--Tabs
local Tab = Window:CreateTab("TOOL", 4483362458)

-- Button to Load IE
local Button = Tab:CreateButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
	end,
})

--rs--
local Button = Tab:CreateButton({
	Name = "Reset Character",
	Callback = function()
		game.Players.LocalPlayer.Character.Humanoid.Health = 0
	end,
})
--INSTANTLOOT--
local Button = Tab:CreateButton({
	Name = "IsantL00t",
	Callback = function()
		for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				v["HoldDuration"] = 0
			end
		end


		game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(v)
			v["HoldDuration"] = 0
		end)
	end,
})

-- Button to Load SIRIUSSIRIUS
local Button = Tab:CreateButton({
	Name = "HiddenPlaceFinder",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/twennyalbert-alt/tes1/refs/heads/main/sirius.lua'))()
	end,
})

local Button = Tab:CreateButton({
	Name = "Mimicry (Yuta Only)",
	Callback = function()
		game:GetService("ReplicatedStorage"):WaitForChild("SkillRemote"):WaitForChild("YutaRemote"):WaitForChild("Mimic"):FireServer()
	end,
})

local Dropdown = Tab:CreateDropdown({
   Name = "Select Place",
   Options = OptionsList,
   CurrentOption = {},
   MultipleOptions = false,
   Flag = "Dropdown1",

   Callback = function(Options)
       SelectedPlace = Options[1]
   end,
})

local Button = Tab:CreateButton({
   Name = "Teleport to Selected Place",
   Callback = function()
       if SelectedPlace then
           local obj = LocationMap[SelectedPlace]
           
           if obj then
               local player = game.Players.LocalPlayer
               local char = player.Character or player.CharacterAdded:Wait()
               local hrp = char:WaitForChild("HumanoidRootPart")

               if obj:IsA("BasePart") then
                   hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)

               elseif obj:IsA("Model") and obj.PrimaryPart then
                   hrp.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
               end
           end
       else
           warn("selecct place first")
       end
   end,
})


-- Toggle for Auto One Shot
local OneShotToggle = Tab:CreateToggle({
	Name = "OneShot",
	CurrentValue = false,
	Flag = "OneShotToggle",
	Callback = function(Value)
		getgenv().AutoOneShotting = Value
		if Value then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/twennyalbert-alt/tes1/refs/heads/main/2da.lua"))()
		end
	end,
})
--stealofa--
local OneShotToggle = Tab:CreateToggle({
	Name = "Stealofa (use standless)",
	CurrentValue = false,
	Flag = "OneShotToggle",
	Callback = function(Value)
		getgenv().AutoOneShotting = Value
		if Value then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/twennyalbert-alt/twendasigma/refs/heads/main/stealofa.lua"))()
		end
	end,
})
--// AUTO TP PLAYER
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local selectedPlayer = nil
local tpDelay = 1
local autoTP = false

-- Update character
local character = plr.Character or plr.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

plr.CharacterAdded:Connect(function(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart")
end)

-- Get player list
local function getPlayerList()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= plr then
			table.insert(list, p.Name)
		end
	end
	return list
end

-- Dropdown chọn player
local playerDropdown = Tab:CreateDropdown({
	Name = "Select Player",
	Options = getPlayerList(),
	CurrentOption = {},
	MultipleOptions = false,
	Flag = "SelectPlayerTP",
	Callback = function(option)
		selectedPlayer = option[1]
	end
})

-- Refresh player list (khi có người vào/ra)
Players.PlayerAdded:Connect(function()
	playerDropdown:Refresh(getPlayerList())
end)

Players.PlayerRemoving:Connect(function()
	playerDropdown:Refresh(getPlayerList())
end)

-- Slider chỉnh delay
Tab:CreateSlider({
	Name = "TP Delay",
	Range = {1, 20},
	Increment = 0.05,
	Suffix = "s",
	CurrentValue = tpDelay,
	Flag = "TPDelay",
	Callback = function(value)
		tpDelay = value
	end
})

-- Toggle Auto TP
Tab:CreateToggle({
	Name = "Auto TP Player",
	CurrentValue = false,
	Flag = "AutoTPPlayer",
	Callback = function(state)
		autoTP = state
		if state then
			task.spawn(function()
				while autoTP do
					pcall(function()
						if selectedPlayer then
							local target = Players:FindFirstChild(selectedPlayer)
							if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
								if hrp then
									hrp.CFrame = target.Character.HumanoidRootPart.CFrame
								end
							end
						end
					end)
					task.wait(tpDelay)
				end
			end)
		end
	end
})


-- 🌀 Auto Use Skills & Attacking M1 Tab (Rayfield)
local AutoTab = Window:CreateTab("Auto Use Skills & Attacking M1", 4483362458)

-- Keys to auto-press
local skillKeys = {"Q","E","R","T","Y","G","H","J","Z","X","V","B"}

-- Global states
getgenv().AutoSkillState = getgenv().AutoSkillState or {}
getgenv().AutoSkillInterval = getgenv().AutoSkillInterval or 0.35
getgenv().AutoM1 = getgenv().AutoM1 or false
getgenv().AutoM1Interval = getgenv().AutoM1Interval or 0.12

-- Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local VIM = nil
pcall(function() VIM = game:GetService("VirtualInputManager") end)
local localPlayer = Players.LocalPlayer
local Mouse
pcall(function() Mouse = localPlayer:GetMouse() end)

-- Helper: map key string → Enum.KeyCode
local keyMap = {}
for _, kc in ipairs(Enum.KeyCode:GetEnumItems()) do
	keyMap[tostring(kc):gsub("Enum.KeyCode.", "")] = kc
end

-- Safe key press
local function safePressKey(keyStr)
	local ok, err = pcall(function()
		if VIM then
			VIM:SendKeyEvent(true, keyStr, false, game)
			task.wait(0.02)
			VIM:SendKeyEvent(false, keyStr, false, game)
			return
		end
		local UIS = game:GetService("UserInputService")
		local kc = keyMap[keyStr] or Enum.KeyCode.Unknown
		pcall(function()
			UIS.InputBegan:Fire({KeyCode = kc, UserInputType = Enum.UserInputType.Keyboard}, false)
			task.wait(0.02)
			UIS.InputEnded:Fire({KeyCode = kc, UserInputType = Enum.UserInputType.Keyboard}, false)
		end)
	end)
end

-- ✅ FIXED: Auto M1 - không click GUI
local function safeClickMouse()
	local ok, err = pcall(function()
		local player = game.Players.LocalPlayer
		if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") then
			return
		end
		VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(0.02)
		VirtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end

-- 🧮 Input box cho Skill Interval
AutoTab:CreateInput({
	Name = "Skill Interval (s)",
	PlaceholderText = tostring(getgenv().AutoSkillInterval),
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		local num = tonumber(text)
		if num and num > 0 then
			getgenv().AutoSkillInterval = num
		end
	end
})

-- 🧮 Input box cho M1 Interval
AutoTab:CreateInput({
	Name = "M1 Interval (s)",
	PlaceholderText = tostring(getgenv().AutoM1Interval),
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		local num = tonumber(text)
		if num and num > 0 then
			getgenv().AutoM1Interval = num
		end
	end
})

-- Skill key toggles
for _, key in ipairs(skillKeys) do
	getgenv().AutoSkillState[key] = getgenv().AutoSkillState[key] or false
	local k = key
	AutoTab:CreateToggle({
		Name = "Auto "..k,
		CurrentValue = getgenv().AutoSkillState[k],
		Flag = "AutoSkill_"..k,
		Callback = function(state)
			getgenv().AutoSkillState[k] = state
			if state then
				task.spawn(function()
					while getgenv().AutoSkillState[k] do
						pcall(safePressKey, k)
						task.wait(tonumber(getgenv().AutoSkillInterval) or 0.35)
					end
				end)
			end
		end
	})
end

-- ✅ FIXED Auto M1 toggle
AutoTab:CreateToggle({
	Name = "Auto M1 (Left Click)",
	CurrentValue = getgenv().AutoM1,
	Flag = "AutoM1Toggle",
	Callback = function(state)
		getgenv().AutoM1 = state
		if state then
			task.spawn(function()
				while getgenv().AutoM1 do
					pcall(safeClickMouse)
					task.wait(tonumber(getgenv().AutoM1Interval) or 0.12)
				end
			end)
		end
	end
})

-- Disable All button
AutoTab:CreateButton({
	Name = "Disable All Auto Skills & M1",
	Callback = function()
		for _, k in ipairs(skillKeys) do
			getgenv().AutoSkillState[k] = false
		end
		getgenv().AutoM1 = false
		pcall(function() Rayfield:LoadConfiguration() end)
	end
})

local Tab1 = Window:CreateTab("Buy Items", 4483362458)
local Arrow = Tab1:CreateButton({
	Name = "Buy Arrow",
	Callback = function()
		local args = {
			""
		}
		game:GetService("ReplicatedStorage"):WaitForChild("BuyItemRemote"):WaitForChild("Arrow"):FireServer(unpack(args))

	end,
})

local Rokak = Tab1:CreateButton({
	Name = "Buy Roka",
	Callback = function()
		local args = {
			""
		}
		game:GetService("ReplicatedStorage"):WaitForChild("BuyItemRemote"):WaitForChild("Rokakaka"):FireServer(unpack(args))
	end,
})

local stopsi = Tab1:CreateButton({
	Name = "Buy Stop Sign",
	Callback = function()
		local args = {
			""
		}
		game:GetService("ReplicatedStorage"):WaitForChild("BuyItemRemote"):WaitForChild("StopSign"):FireServer(unpack(args))
	end,
})

local Tab = Window:CreateTab("Monster & Dummy")
local DummySection = Tab:CreateSection("Monster & Dummy Section")

local stickyEnemies = {
	"Dummy",
	"Attacking Dummy",
	"Blocking Dummy",
	"Counter Dummy",
	"Adjuchas",
	"Deku",
	"Toji",
	"Thug",
	"Spider Curse",
	"Mosquito Curse",
	"Bandit",
	"Frog Hollow",
	"Fishbone",
	"Glutton Curse",
	"Contorted Curse",
	"Menos",
	"Jotaro Kujo",
	"Mimicry",
	"The Red Mist",
	"Dog",
	"Monkey",
	"Space Curse",
	"Paper Final Boss",
	"Paper Curse",
	"Paper Curse Half",
	"Paper Curse Quarter",
	"Evilest Rest",
	"BarraganWorldBoss"

}

local stickyEnabled = {}
local attackDistance = 5 -- ค่าเริ่มต้น

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart")
end)

-- ✅ Attack Distance อยู่บนสุด
Tab:CreateSlider({
	Name = "Attack Distance",
	Range = {1, 15},
	Increment = 1,
	Suffix = " studs",
	CurrentValue = attackDistance,
	Flag = "AttackDistance",
	Callback = function(value)
		attackDistance = value
	end,
})

-- ✅ Toggle สำหรับเลือกมอน/ดัมมี่
for _, name in ipairs(stickyEnemies) do
	Tab:CreateToggle({
		Name = name,
		CurrentValue = false,
		Flag = "Sticky_" .. name,
		Callback = function(state)
			stickyEnabled[name] = state
		end,
	})
end

-- ✅ ระบบหาตัวที่ใกล้ที่สุดที่เปิด Toggle
RunService.RenderStepped:Connect(function()
	local closestTarget = nil
	local closestDistance = math.huge

	for _, obj in pairs(workspace.Living:GetChildren()) do
		if obj:IsA("Model")
			and obj ~= character
			and obj:FindFirstChild("Humanoid")
			and obj:FindFirstChild("HumanoidRootPart")
			and obj.Humanoid.Health > 0
			and stickyEnabled[obj.Name] then
			local dist = (obj.HumanoidRootPart.Position - hrp.Position).Magnitude
			if dist < closestDistance then
				closestDistance = dist
				closestTarget = obj
			end
		end
	end

	if closestTarget then
		hrp.CFrame = CFrame.new(
			closestTarget.HumanoidRootPart.Position - closestTarget.HumanoidRootPart.CFrame.LookVector * attackDistance,
			closestTarget.HumanoidRootPart.Position
		)
	end
end)


local Tab = Window:CreateTab("Stand Tracking")

AutoTab:CreateLabel({
	Name = "Note: If keys or clicks don't trigger, your executor may not support VirtualInputManager. VirtualUser M1 won't click GUI."
})
