-- KonataHub | Doors Ultimate (Aqua Edition)
-- Fully rewritten with kyksikoid's bypasses, advanced ESP & HUD State

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Ремоуты Doors
local RemotesFolder = ReplicatedStorage:FindFirstChild("EntityInfo") 
    or ReplicatedStorage:FindFirstChild("Bricks") 
    or ReplicatedStorage:FindFirstChild("RemotesFolder")
local MotorReplication = RemotesFolder and RemotesFolder:FindFirstChild("MotorReplication")
local ClientModules = ReplicatedStorage:FindFirstChild("ModulesClient") or ReplicatedStorage:FindFirstChild("ClientModules")
local LatestRoom = ReplicatedStorage:FindFirstChild("GameData") and ReplicatedStorage.GameData:FindFirstChild("LatestRoom")

-- Определение текущего этажа
local function getDoorsFloor()
    local placeId = game.PlaceId
    if placeId == 6516141723 or placeId == 6839171747 then
        return "The Hotel"
    elseif placeId == 11534440026 then
        return "The Mines"
    elseif placeId == 12552538292 then
        return "The Retro Mode"
    else
        local rooms = workspace:FindFirstChild("CurrentRooms")
        if rooms and rooms:FindFirstChild("0") and rooms["0"]:FindFirstChild("Assets") and rooms["0"].Assets:FindFirstChild("Archives") then
            return "The Archives"
        end
        return "The Hotel"
    end
end

local currentFloor = getDoorsFloor()

-- ==================== СИСТЕМА ЛОКАЛИЗАЦИИ ====================
local CurrentLang = "English" -- По умолчанию English

local LangData = {
    English = {
        WindowTitle = "KonataHub | Doors (" .. currentFloor .. ")",
        SubTitle = "Aqua Edition",
        TabESP = "ESP",
        TabVisuals = "Visuals",
        TabMovement = "Movement",
        TabBypasses = "Bypasses",
        TabAuto = "Auto & Solvers",
        TabSettings = "Settings",
        
        -- ESP
        DoorESP = "Doors & Keys ESP",
        DoorESPDesc = "Highlight doors, keys and locks",
        ItemESP = "Items ESP",
        ItemESPDesc = "Crucifix, Lockpicks, Flashlight, Vitamins, etc.",
        GoldESP = "Gold / Coins ESP",
        GoldESPDesc = "Highlight coins and chests with value",
        WardrobeESP = "Wardrobe & Closets ESP",
        WardrobeESPDesc = "Highlight safe hiding places",
        ObjectiveESP = "Objectives & Puzzles ESP",
        ObjectiveESPDesc = "Levers, Breakers, Books, Fuses, Anchors",
        EntityESP = "Entities ESP",
        EntityESPDesc = "Rush, Ambush, Figure, Seek, Eyes, etc.",
        PlayerESP = "Players ESP",
        PlayerESPDesc = "Highlight other players and health",
        
        -- Movement
        Noclip = "Noclip",
        NoclipDesc = "Walk through walls and barriers",
        BypassSpeed = "Speed (CFrame Bypass)",
        BypassSpeedDesc = "Bypassed speed without anticheat lagbacks",
        SpeedVal = "Speed Value",
        Fly = "Flight (Fly)",
        FlySpeed = "Fly Speed",
        InfJump = "Infinite Jump",
        
        -- Bypasses
        AntiScreech = "Anti Screech",
        AntiA90 = "Anti A90",
        AntiDread = "Anti Dread",
        AntiHalt = "Anti Halt",
        AntiEyes = "Anti Eyes & Lookman",
        AntiSnare = "Anti Snare Traps",
        AntiGiggle = "Anti Giggle",
        AntiDupe = "Anti Dupe (Fake Doors)",
        AntiFigureHearing = "Silent Walk (Anti Figure)",
        PromptReach = "Prompt Reach & Fast Interact",
        DoorReach = "Fast Open Next Door",
        
        -- Visuals
        FullBright = "Fullbright",
        NoFog = "No Fog",
        FOV = "Camera FOV",
        
        -- Auto
        AutoBreaker = "Auto Room 100 Breaker Solver",
        
        -- HUD
        HUDToggle = "Show HUD State",
        HUDDesc = "Toggle Profile, FPS, Ping and Playtime overlay"
    },
    Russian = {
        WindowTitle = "KonataHub | Doors (" .. currentFloor .. ")",
        SubTitle = "Aqua Издание",
        TabESP = "ESP (Подсветка)",
        TabVisuals = "Визуалы",
        TabMovement = "Движение",
        TabBypasses = "Обходы (Bypasses)",
        TabAuto = "Автоматизация",
        TabSettings = "Настройки",
        
        -- ESP
        DoorESP = "ESP Дверей и Ключей",
        DoorESPDesc = "Подсветка дверей, номеров комнат и ключей",
        ItemESP = "ESP Предметов",
        ItemESPDesc = "Кресты, отмычки, фонари, витамины и т.д.",
        GoldESP = "ESP Золота и Монет",
        GoldESPDesc = "Подсветка золота с указанием суммы",
        WardrobeESP = "ESP Шкафов / Укрытий",
        WardrobeESPDesc = "Подсветка шкафов, кроватей и вентиляций",
        ObjectiveESP = "ESP Заданий и Пазлов",
        ObjectiveESPDesc = "Рычаги, книги, предохранители, рубильники",
        EntityESP = "ESP Монстров",
        EntityESPDesc = "Rush, Ambush, Figure, Seek, Eyes и др.",
        PlayerESP = "ESP Игроков",
        PlayerESPDesc = "Подсветка других игроков и здоровья",
        
        -- Movement
        Noclip = "Ноклип (Сквозь стены)",
        NoclipDesc = "Свободное прохождение через стены и двери",
        BypassSpeed = "Скорость (Обход Античита)",
        BypassSpeedDesc = "Плавный разгон без откатов назад",
        SpeedVal = "Значение скорости",
        Fly = "Полет (Fly)",
        FlySpeed = "Скорость полета",
        InfJump = "Бесконечный прыжок",
        
        -- Bypasses
        AntiScreech = "Анти Скрич (Без урона)",
        AntiA90 = "Анти А90 (Без урона)",
        AntiDread = "Анти Дред",
        AntiHalt = "Анти Хальт",
        AntiEyes = "Анти Глаза / Лукмен (Авто-взгляд)",
        AntiSnare = "Анти Ловушки (Snare)",
        AntiGiggle = "Анти Гиггл",
        AntiDupe = "Анти Фальшивые Двери (Dupe)",
        AntiFigureHearing = "Бесшумный Шаг (Анти Фигура)",
        PromptReach = "Увеличенная дистанция взаимодействия",
        DoorReach = "Авто-открытие следующей двери",
        
        -- Visuals
        FullBright = "Фуллбрайт (Яркий свет)",
        NoFog = "Убрать Туман",
        FOV = "Поле зрения (FOV)",
        
        -- Auto
        AutoBreaker = "Авто-решение Рубильников (100 комната)",
        
        -- HUD
        HUDToggle = "HUD Статус игрока",
        HUDDesc = "Отображение профиля, FPS, пинга и времени игры"
    }
}

local function T(key)
    return LangData[CurrentLang][key] or LangData["English"][key] or key
end

-- ==================== ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ====================

local Window = Fluent:CreateWindow({
    Title = T("WindowTitle"),
    SubTitle = T("SubTitle"),
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 500),
    Acrylic = true,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    ESP = Window:AddTab({ Title = T("TabESP"), Icon = "eye" }),
    Bypasses = Window:AddTab({ Title = T("TabBypasses"), Icon = "shield-check" }),
    Movement = Window:AddTab({ Title = T("TabMovement"), Icon = "zap" }),
    Visuals = Window:AddTab({ Title = T("TabVisuals"), Icon = "sun" }),
    Auto = Window:AddTab({ Title = T("TabAuto"), Icon = "cpu" }),
    Settings = Window:AddTab({ Title = T("TabSettings"), Icon = "settings" })
}

local Options = Fluent.Options

-- ==================== HUD STATE OVERLAY ====================

local CoreGui = game:GetService("CoreGui")
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "Konata_HUD_State"
pcall(function() hudGui.Parent = CoreGui end)
if not hudGui.Parent then hudGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local hudFrame = Instance.new("Frame")
hudFrame.Name = "MainCard"
hudFrame.Size = UDim2.new(0, 270, 0, 80)
hudFrame.Position = UDim2.new(0.02, 0, 0.04, 0)
hudFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
hudFrame.BackgroundTransparency = 0.25
hudFrame.BorderSizePixel = 0
hudFrame.Active = true
hudFrame.Draggable = true
hudFrame.Parent = hudGui

local hudCorner = Instance.new("UICorner")
hudCorner.CornerRadius = UDim.new(0, 10)
hudCorner.Parent = hudFrame

local hudStroke = Instance.new("UIStroke")
hudStroke.Color = Color3.fromRGB(0, 225, 255)
hudStroke.Thickness = 1.5
hudStroke.Transparency = 0.2
hudStroke.Parent = hudFrame

-- Profile Avatar Image
local avatarImg = Instance.new("ImageLabel")
avatarImg.Name = "Avatar"
avatarImg.Size = UDim2.new(0, 56, 0, 56)
avatarImg.Position = UDim2.new(0, 12, 0, 12)
avatarImg.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
avatarImg.Parent = hudFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImg

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(0, 225, 255)
avatarStroke.Thickness = 1
avatarStroke.Parent = avatarImg

-- User Details
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 185, 0, 20)
nameLabel.Position = UDim2.new(0, 76, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
nameLabel.Parent = hudFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0, 185, 0, 18)
statsLabel.Position = UDim2.new(0, 76, 0, 32)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.TextSize = 12
statsLabel.TextColor3 = Color3.fromRGB(0, 225, 255)
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Text = "FPS: 60  |  Ping: 0 ms"
statsLabel.Parent = hudFrame

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 185, 0, 16)
timeLabel.Position = UDim2.new(0, 76, 0, 52)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 11
timeLabel.TextColor3 = Color3.fromRGB(180, 200, 215)
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Text = "Playtime: 00:00:00"
timeLabel.Parent = hudFrame

-- HUD Metrics Loop
local startTime = tick()
local fpsCount = 0
local lastFpsUpdate = tick()

RunService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
    local now = tick()
    if now - lastFpsUpdate >= 0.5 then
        local currentFPS = math.floor(fpsCount / (now - lastFpsUpdate))
        fpsCount = 0
        lastFpsUpdate = now
        
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        
        statsLabel.Text = string.format("FPS: %d  |  Ping: %d ms", currentFPS, ping)
        
        local elapsed = math.floor(now - startTime)
        local hours = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        local secs = elapsed % 60
        timeLabel.Text = string.format("Playtime: %02d:%02d:%02d", hours, mins, secs)
    end
end)

-- ==================== ESP ENGINE ====================

local espFolder = Instance.new("Folder")
espFolder.Name = "Konata_Doors_ESP"
pcall(function() espFolder.Parent = CoreGui end)
if not espFolder.Parent then espFolder.Parent = workspace end

local activeESP = {}

local function createESP(target, name, color, espType)
    if not target or activeESP[target] then return end
    local targetPart = target:IsA("BasePart") and target or target:FindFirstChildWhichIsA("BasePart")
    if not targetPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = espType .. "_" .. target.Name
    highlight.Adornee = target
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.45
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = espFolder

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ESP_Label"
    bgui.Adornee = targetPart
    bgui.Size = UDim2.new(0, 160, 0, 45)
    bgui.AlwaysOnTop = true
    bgui.LightInfluence = 0
    bgui.StudsOffset = Vector3.new(0, 2.5, 0)
    bgui.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = name
    label.Parent = bgui

    local record = {
        Highlight = highlight,
        Gui = bgui,
        Label = label,
        TargetPart = targetPart,
        Target = target,
        Type = espType,
        BaseName = name
    }
    activeESP[target] = record

    local isEnabled = false
    if espType == "Door" and Options.DoorEsp then isEnabled = Options.DoorEsp.Value
    elseif espType == "Item" and Options.ItemEsp then isEnabled = Options.ItemEsp.Value
    elseif espType == "Gold" and Options.GoldEsp then isEnabled = Options.GoldEsp.Value
    elseif espType == "Wardrobe" and Options.WardrobeEsp then isEnabled = Options.WardrobeEsp.Value
    elseif espType == "Objective" and Options.ObjectiveEsp then isEnabled = Options.ObjectiveEsp.Value
    elseif espType == "Entity" and Options.EntityEsp then isEnabled = Options.EntityEsp.Value
    elseif espType == "Player" and Options.PlayerEsp then isEnabled = Options.PlayerEsp.Value
    end

    highlight.Enabled = isEnabled
    bgui.Enabled = isEnabled

    target.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if activeESP[target] then
                highlight:Destroy()
                bgui:Destroy()
                activeESP[target] = nil
            end
        end
    end)
end

RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end

    for target, data in pairs(activeESP) do
        if data.Gui and data.Gui.Enabled and data.TargetPart and data.TargetPart.Parent then
            local dist = math.floor((cam.CFrame.Position - data.TargetPart.Position).Magnitude)
            data.Label.Text = string.format("%s\n[%d m]", data.BaseName, dist)
        end
    end
end)

-- База предметов и сущностей
local ItemsList = {
    ["Bandage"] = "Bandage",
    ["Flashlight"] = "Flashlight",
    ["Battery"] = "Battery",
    ["BatteryPack"] = "Battery Pack",
    ["SkeletonKey"] = "Skeleton Key",
    ["Crucifix"] = "Crucifix",
    ["CrucifixWall"] = "Crucifix",
    ["Straplight"] = "Strap Light",
    ["Lockpick"] = "Lockpick",
    ["Bulklight"] = "Bulk Light",
    ["Vitamins"] = "Vitamin",
    ["Shears"] = "Shears",
    ["LaserPointer"] = "Laser Pointer",
    ["Candle"] = "Candle",
    ["Smoothie"] = "Smoothie",
    ["StarJug"] = "Star Jug",
    ["StardustPickup"] = "Stardust",
    ["StarVial"] = "Star Vial",
    ["StarBottle"] = "Star Bottle",
    ["Glowsticks"] = "Glow Sticks",
    ["Compass"] = "Compass",
    ["Lantern"] = "Lantern",
    ["KeyIron"] = "Iron Key",
    ["Shakelight"] = "Shake Light",
    ["HolyGrenade"] = "Holy Grenade",
    ["ShieldMini"] = "Mini Shield",
    ["ShieldBig"] = "Big Shield"
}

local HidingList = {
    ["Wardrobe"] = "Wardrobe",
    ["Closet"] = "Closet",
    ["Rooms_Locker"] = "Locker",
    ["Rooms_Locker_Fridge"] = "Fridge",
    ["Locker_Large"] = "Locker",
    ["Backdoor_Wardrobe"] = "Closet",
    ["Bed"] = "Bed",
    ["Double_Bed"] = "Double Bed",
    ["Toolshed"] = "Toolshed",
    ["RetroWardrobe"] = "Closet",
    ["CircularVent"] = "Vent"
}

local EntityList = {
    ["RushMoving"] = "Rush",
    ["AmbushMoving"] = "Ambush",
    ["Eyes"] = "Eyes",
    ["Lookman"] = "Lookman",
    ["BackdoorLookman"] = "Lookman",
    ["BackdoorRush"] = "Blitz",
    ["Screech"] = "Screech",
    ["Halt"] = "Halt",
    ["FigureRig"] = "Figure",
    ["FigureRagdoll"] = "Figure",
    ["SeekMoving"] = "Seek",
    ["Snare"] = "Snare",
    ["DupeRoom"] = "Dupe",
    ["GiggleCeiling"] = "Giggle",
    ["GrumbleRig"] = "Grumble",
    ["A60"] = "A-60",
    ["A120"] = "A-120",
    ["GlitchRush"] = "Glitch Rush",
    ["GlitchAmbush"] = "Glitch Ambush",
    ["JeffTheKiller"] = "Jeff The Killer"
}

local function scanObject(obj, roomNum)
    local n = obj.Name

    if n == "Door" and obj:IsA("Model") then
        local doorPart = obj:FindFirstChild("Door") or obj:FindFirstChildWhichIsA("BasePart")
        if doorPart then
            createESP(obj, "Door " .. (roomNum or ""), Options.DoorColor and Options.DoorColor.Value or Color3.fromRGB(0, 225, 255), "Door")
        end
    elseif n == "KeyObtain" or n == "Key" then
        createESP(obj, "Key", Color3.fromRGB(0, 255, 180), "Door")
    elseif n == "ElectrialKeyObtain" then
        createESP(obj, "Electrical Key", Color3.fromRGB(0, 255, 180), "Door")
    end

    if ItemsList[n] then
        createESP(obj, ItemsList[n], Options.ItemColor and Options.ItemColor.Value or Color3.fromRGB(0, 255, 120), "Item")
    end

    if n == "GoldPile" or n == "Gold" or n == "ChestBox" or n == "ChestBoxLocked" then
        local val = obj:GetAttribute("GoldValue")
        local goldText = val and ("Gold (" .. val .. ")") or "Gold / Chest"
        createESP(obj, goldText, Options.GoldColor and Options.GoldColor.Value or Color3.fromRGB(255, 215, 0), "Gold")
    end

    if HidingList[n] then
        createESP(obj, HidingList[n], Options.WardrobeColor and Options.WardrobeColor.Value or Color3.fromRGB(150, 100, 255), "Wardrobe")
    end

    if n == "LiveHintBook" then
        createESP(obj, "Library Book", Color3.fromRGB(0, 180, 255), "Objective")
    elseif n == "LiveBreakerPolePickup" or n == "BreakerSwitch" then
        createESP(obj, "Breaker", Color3.fromRGB(0, 180, 255), "Objective")
    elseif n == "LeverForGate" or n == "TimerLever" then
        createESP(obj, "Gate Lever", Color3.fromRGB(255, 160, 50), "Objective")
    elseif n == "FuseObtain" then
        createESP(obj, "Fuse", Color3.fromRGB(255, 170, 0), "Objective")
    elseif n == "MinesGenerator" then
        createESP(obj, "Generator", Color3.fromRGB(255, 170, 0), "Objective")
    elseif n == "MinesAnchor" then
        local sign = obj:FindFirstChild("Sign")
        local signText = sign and sign:FindFirstChild("TextLabel") and sign.TextLabel.Text or ""
        createESP(obj, "Anchor " .. signText, Color3.fromRGB(0, 200, 255), "Objective")
    end
end

local notifiedEntities = {}
local function checkEntity(child)
    local n = child.Name
    local entityName = EntityList[n]

    if not entityName then
        for key, val in pairs(EntityList) do
            if n:find(key) then
                entityName = val
                break
            end
        end
    end

    if entityName and not notifiedEntities[child] then
        notifiedEntities[child] = true
        
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = "rbxassetid://4590662766"
        sound.Volume = 1.5
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)

        Fluent:Notify({
            Title = "⚠ ENTITY SPAWNED!",
            Content = entityName .. " is coming / appeared!",
            Duration = 6
        })

        task.wait(0.05)
        createESP(child, "⚠ " .. entityName .. " ⚠", Options.EntityColor and Options.EntityColor.Value or Color3.fromRGB(255, 50, 50), "Entity")
        
        child.AncestryChanged:Connect(function(_, parent)
            if not parent then notifiedEntities[child] = nil end
        end)
    end
end

workspace.ChildAdded:Connect(checkEntity)

local function initRooms()
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if rooms then
        for _, room in ipairs(rooms:GetChildren()) do
            for _, item in ipairs(room:GetDescendants()) do
                scanObject(item, room.Name)
            end
            room.DescendantAdded:Connect(function(item)
                scanObject(item, room.Name)
            end)
        end
        rooms.ChildAdded:Connect(function(room)
            task.wait(0.2)
            for _, item in ipairs(room:GetDescendants()) do
                scanObject(item, room.Name)
            end
            room.DescendantAdded:Connect(function(item)
                scanObject(item, room.Name)
            end)
        end)
    end
end
task.spawn(initRooms)

local function updatePlayersESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                createESP(plr.Character, plr.DisplayName .. " [" .. math.floor(hum.Health) .. "%]", Color3.fromRGB(100, 200, 255), "Player")
            end
        end
    end
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        updatePlayersESP()
    end)
end)

-- ==================== BYPASSES ====================

local FakeScreech = Instance.new("RemoteEvent")
FakeScreech.Name = "Screech_"

local FakeA90 = Instance.new("RemoteEvent")
FakeA90.Name = "A90_"

local function setAntiScreech(state)
    if RemotesFolder and RemotesFolder:FindFirstChild("Screech") then
        if state then
            RemotesFolder.Screech.Name = "Screech_Real"
            FakeScreech.Name = "Screech"
            FakeScreech.Parent = RemotesFolder
        else
            if RemotesFolder:FindFirstChild("Screech_Real") then
                RemotesFolder.Screech_Real.Name = "Screech"
                FakeScreech.Parent = nil
            end
        end
    end
end

local function setAntiA90(state)
    if RemotesFolder and RemotesFolder:FindFirstChild("A90") then
        if state then
            RemotesFolder.A90.Name = "A90_Real"
            FakeA90.Name = "A90"
            FakeA90.Parent = RemotesFolder
        else
            if RemotesFolder:FindFirstChild("A90_Real") then
                RemotesFolder.A90_Real.Name = "A90"
                FakeA90.Parent = nil
            end
        end
    end
end

local function setAntiDread(state)
    local dread = LocalPlayer:FindFirstChild("Dread", true) or LocalPlayer:FindFirstChild("_Dread", true)
    if dread then dread.Name = state and "_Dread" or "Dread" end
end

local function setAntiHalt(state)
    if ClientModules and ClientModules:FindFirstChild("EntityModules") then
        local shade = ClientModules.EntityModules:FindFirstChild("Shade", true) or ClientModules.EntityModules:FindFirstChild("_Shade", true)
        if shade then shade.Name = state and "_Shade" or "Shade" end
    end
end

local function setAntiTraps(state)
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if not rooms then return end
    for _, v in ipairs(rooms:GetDescendants()) do
        if v.Name == "Snare" and v:FindFirstChild("Hitbox") then
            v.Hitbox.CanTouch = not state
        elseif v.Name == "GiggleCeiling" and v:FindFirstChild("Hitbox") then
            v.Hitbox.CanTouch = not state
        elseif v.Name == "DoorFake" and v:FindFirstChild("Hidden") then
            v.Hidden.CanTouch = not state
        elseif v.Name == "Seek_Arm" or v.Name == "ChandelierObstruction" then
            if v:IsA("BasePart") then v.CanTouch = not state end
        end
    end
end

local antiEyesConn
local function setAntiEyes(state)
    if state then
        antiEyesConn = RunService.RenderStepped:Connect(function()
            if workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("Lookman") or workspace:FindFirstChild("BackdoorLookman") then
                if MotorReplication then
                    pcall(function()
                        MotorReplication:FireServer(0, -650, 0, false)
                    end)
                end
            end
        end)
    else
        if antiEyesConn then antiEyesConn:Disconnect() antiEyesConn = nil end
    end
end

local function setSilentStep(state)
    if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
        RemotesFolder.Crouch:FireServer(state)
    end
end

local noclipConn
local function setNoclip(enabled)
    if enabled then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end

local speedConn
local crouchBypassLoop
local function setBypassSpeed(enabled)
    if enabled then
        speedConn = RunService.RenderStepped:Connect(function(delta)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    local speedMultiplier = (Options.SpeedSlider and Options.SpeedSlider.Value or 20) - 15
                    if speedMultiplier > 0 then
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (hum.MoveDirection * (speedMultiplier * delta))
                    end
                end
            end
        end)
        
        crouchBypassLoop = task.spawn(function()
            while task.wait(0.2) do
                if not (Options.SpeedToggle and Options.SpeedToggle.Value) then break end
                if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
                    RemotesFolder.Crouch:FireServer(true, true)
                end
            end
        end)
    else
        if speedConn then speedConn:Disconnect() speedConn = nil end
        if crouchBypassLoop then task.cancel(crouchBypassLoop) crouchBypassLoop = nil end
    end
end

local flyConn
local function setFly(enabled)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if enabled then
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "Konata_FlyGyro"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame

        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "Konata_FlyVelocity"
        bv.velocity = Vector3.zero
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        flyConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam or not char:FindFirstChild("Humanoid") then return end
            bg.cframe = cam.CFrame
            local hum = char.Humanoid
            local speed = Options.FlySpeedSlider and Options.FlySpeedSlider.Value or 22
            
            if hum.MoveDirection.Magnitude > 0 then
                bv.velocity = cam.CFrame:VectorToWorldSpace(cam.CFrame:VectorToObjectSpace(hum.MoveDirection)) * speed
            else
                bv.velocity = Vector3.zero
            end
        end)
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if root:FindFirstChild("Konata_FlyGyro") then root.Konata_FlyGyro:Destroy() end
        if root:FindFirstChild("Konata_FlyVelocity") then root.Konata_FlyVelocity:Destroy() end
    end
end

-- ==================== UI TABS ====================

-- ESP Tab
local DoorToggle = Tabs.ESP:AddToggle("DoorEsp", { Title = T("DoorESP"), Description = T("DoorESPDesc"), Default = true })
DoorToggle:OnChanged(function(state)
    for _, data in pairs(activeESP) do
        if data.Type == "Door" then data.Highlight.Enabled = state data.Gui.Enabled = state end
    end
end)

local DoorColor = Tabs.ESP:AddColorpicker("DoorColor", { Title = "Door Color", Default = Color3.fromRGB(0, 225, 255) })
DoorColor:OnChanged(function(col)
    for _, data in pairs(activeESP) do
        if data.Type == "Door" then data.Highlight.FillColor = col data.Label.TextColor3 = col end
    end
end)

local ItemToggle = Tabs.ESP:AddToggle("ItemEsp", { Title = T("ItemESP"), Description = T("ItemESPDesc"), Default = true })
ItemToggle:OnChanged(function(state)
    for _, data in pairs(activeESP) do
        if data.Type == "Item" then data.Highlight.Enabled = state data.Gui.Enabled = state end
    end
end)

local ItemColor = Tabs.ESP:AddColorpicker("ItemColor", { Title = "Item Color", Default = Color3.fromRGB(0, 255, 120) })
ItemColor:OnChanged(function(col)
    for _, data in pairs(activeESP) do
        if data.Type == "Item" then data.Highlight.FillColor = col data.Label.TextColor3 = col end
    end
end)

local GoldToggle = Tabs.ESP:AddToggle("GoldEsp", { Title = T("GoldESP"), Description = T("GoldESPDesc"), Default = true })
GoldToggle:OnChanged(function(state)
    for _, data in pairs(activeESP) do
        if data.Type == "Gold" then data.Highlight.Enabled = state data.Gui.Enabled = state end
    end
end)

local GoldColor = Tabs.ESP:AddColorpicker("GoldColor", { Title = "Gold Color", Default = Color3.fromRGB(255, 215, 0) })
GoldColor:OnChanged(function(col)
    for _, data in pairs(activeESP) do
        if data.Type == "Gold" then data.Highlight.FillColor = col data.Label.TextColor3 = col end
    end
end)

local WardrobeToggle = Tabs.ESP:AddToggle("WardrobeEsp", { Title = T("WardrobeESP"), Description = T("WardrobeESPDesc"), Default = true })
WardrobeToggle:OnChanged(function(state)
    for _, data in pairs(activeESP) do
        if data.Type == "Wardrobe" then data.Highlight.Enabled = state data.Gui.Enabled = state end
    end
end)

local WardrobeColor = Tabs.ESP:AddColorpicker("WardrobeColor", { Title = "Wardrobe Color", Default = Color3.fromRGB(150, 100, 255) })
WardrobeColor:OnChanged(function(col)
    for _, data in pairs(activeESP) do
        if data.Type == "Wardrobe" then data.Highlight.FillColor = col data.Label.TextColor3 = col end
    end
end)

local ObjectiveToggle = Tabs.ESP:AddToggle("ObjectiveEsp", { Title = T("ObjectiveESP"), Description = T("ObjectiveESPDesc"), Default = true })
ObjectiveToggle:OnChanged(function(state)
    for _, data in pairs(activeESP) do
        if data.Type == "Objective" then data.Highlight.Enabled = state data.Gui.Enabled = state end
    end
end)

local EntityToggle = Tabs.ESP:AddToggle("EntityEsp", { Title = T("EntityESP"), Description = T("EntityESPDesc"), Default = true })
EntityToggle:OnChanged(function(state)
    for _, data in pairs(activeESP) do
        if data.Type == "Entity" then data.Highlight.Enabled = state data.Gui.Enabled = state end
    end
end)

local EntityColor = Tabs.ESP:AddColorpicker("EntityColor", { Title = "Entity Color", Default = Color3.fromRGB(255, 50, 50) })
EntityColor:OnChanged(function(col)
    for _, data in pairs(activeESP) do
        if data.Type == "Entity" then data.Highlight.FillColor = col data.Label.TextColor3 = col end
    end
end)

local PlayerToggle = Tabs.ESP:AddToggle("PlayerEsp", { Title = T("PlayerESP"), Description = T("PlayerESPDesc"), Default = false })
PlayerToggle:OnChanged(function(state)
    updatePlayersESP()
    for _, data in pairs(activeESP) do
        if data.Type == "Player" then data.Highlight.Enabled = state data.Gui.Enabled = state end
    end
end)

-- Bypasses Tab
local AntiScreechTog = Tabs.Bypasses:AddToggle("AntiScreech", { Title = T("AntiScreech"), Default = true })
AntiScreechTog:OnChanged(setAntiScreech)

local AntiA90Tog = Tabs.Bypasses:AddToggle("AntiA90", { Title = T("AntiA90"), Default = true })
AntiA90Tog:OnChanged(setAntiA90)

local AntiEyesTog = Tabs.Bypasses:AddToggle("AntiEyes", { Title = T("AntiEyes"), Default = true })
AntiEyesTog:OnChanged(setAntiEyes)

local AntiDreadTog = Tabs.Bypasses:AddToggle("AntiDread", { Title = T("AntiDread"), Default = true })
AntiDreadTog:OnChanged(setAntiDread)

local AntiHaltTog = Tabs.Bypasses:AddToggle("AntiHalt", { Title = T("AntiHalt"), Default = true })
AntiHaltTog:OnChanged(setAntiHalt)

local AntiTrapsTog = Tabs.Bypasses:AddToggle("AntiTraps", { Title = T("AntiSnare") .. " & " .. T("AntiDupe"), Default = true })
AntiTrapsTog:OnChanged(setAntiTraps)

local SilentStepTog = Tabs.Bypasses:AddToggle("SilentStep", { Title = T("AntiFigureHearing"), Default = false })
SilentStepTog:OnChanged(setSilentStep)

local PromptReachTog = Tabs.Bypasses:AddToggle("PromptReach", { Title = T("PromptReach"), Default = true })
PromptReachTog:OnChanged(function(state)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if state then
                v:SetAttribute("OldHold", v.HoldDuration)
                v:SetAttribute("OldDist", v.MaxActivationDistance)
                v.HoldDuration = 0
                v.MaxActivationDistance = v.MaxActivationDistance * 1.75
                v.RequiresLineOfSight = false
            else
                v.HoldDuration = v:GetAttribute("OldHold") or v.HoldDuration
                v.MaxActivationDistance = v:GetAttribute("OldDist") or v.MaxActivationDistance
                v.RequiresLineOfSight = true
            end
        end
    end
end)

local DoorReachTog = Tabs.Bypasses:AddToggle("DoorReach", { Title = T("DoorReach"), Default = false })
task.spawn(function()
    while task.wait(0.3) do
        if Options.DoorReach and Options.DoorReach.Value then
            local rooms = workspace:FindFirstChild("CurrentRooms")
            local curRoom = LatestRoom and LatestRoom.Value
            if rooms and curRoom then
                local room = rooms:FindFirstChild(tostring(curRoom))
                local door = room and room:FindFirstChild("Door")
                if door and door:FindFirstChild("ClientOpen") then
                    door.ClientOpen:FireServer()
                end
            end
        end
    end
end)

-- Movement Tab
local NoclipTog = Tabs.Movement:AddToggle("NoclipToggle", { Title = T("Noclip"), Description = T("NoclipDesc"), Default = false })
NoclipTog:OnChanged(setNoclip)

local SpeedTog = Tabs.Movement:AddToggle("SpeedToggle", { Title = T("BypassSpeed"), Description = T("BypassSpeedDesc"), Default = false })
SpeedTog:OnChanged(setBypassSpeed)

Tabs.Movement:AddSlider("SpeedSlider", {
    Title = T("SpeedVal"),
    Default = 21,
    Min = 16,
    Max = 45,
    Rounding = 0,
    Callback = function(_) end
})

local FlyTog = Tabs.Movement:AddToggle("FlyToggle", { Title = T("Fly"), Default = false })
FlyTog:OnChanged(setFly)

Tabs.Movement:AddSlider("FlySpeedSlider", {
    Title = T("FlySpeed"),
    Default = 22,
    Min = 15,
    Max = 60,
    Rounding = 0,
    Callback = function(_) end
})

local InfJumpTog = Tabs.Movement:AddToggle("InfJump", { Title = T("InfJump"), Default = false })
UserInputService.JumpRequest:Connect(function()
    if Options.InfJump and Options.InfJump.Value and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Visuals Tab
local FullBrightTog = Tabs.Visuals:AddToggle("FullBright", { Title = T("FullBright"), Default = false })
FullBrightTog:OnChanged(function(state)
    if state then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.Brightness = 1
    end
end)

local NoFogTog = Tabs.Visuals:AddToggle("NoFog", { Title = T("NoFog"), Default = false })
NoFogTog:OnChanged(function(state)
    if state then
        Lighting.FogEnd = 100000
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") then v.Density = 0 end
        end
    else
        Lighting.FogEnd = 1000
    end
end)

Tabs.Visuals:AddSlider("FOVSlider", {
    Title = T("FOV"),
    Default = 70,
    Min = 70,
    Max = 120,
    Rounding = 0,
    Callback = function(val)
        workspace.CurrentCamera.FieldOfView = val
    end
})

-- Auto Tab
local function runBreakerSolver(part)
    local label = part:WaitForChild("SurfaceGui", 5) and part.SurfaceGui:WaitForChild("Frame", 5) and part.SurfaceGui.Frame:WaitForChild("Code", 5)
    if not label then return end
    
    local function solve()
        task.wait(0.05)
        if not (Options.AutoBreaker and Options.AutoBreaker.Value) then return end
        local target = tonumber(label.Text)
        if target then
            for _, v in ipairs(part:GetChildren()) do
                if v.Name == "BreakerSwitch" and v:GetAttribute("ID") == target then
                    local trans = part.SurfaceGui.Frame.Code.Frame.BackgroundTransparency
                    local pc = v:FindFirstChild("PrismaticConstraint")
                    if trans == 0 then
                        v:SetAttribute("Enabled", true)
                        if pc then pc.TargetPosition = -0.2 end
                    elseif trans == 1 then
                        v:SetAttribute("Enabled", false)
                        if pc then pc.TargetPosition = 0.2 end
                    end
                    break
                end
            end
        end
    end
    label:GetPropertyChangedSignal("Text"):Connect(solve)
    solve()
end

Tabs.Auto:AddToggle("AutoBreaker", { Title = T("AutoBreaker"), Default = false }):OnChanged(function(state)
    if state then
        for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
            if v.Name == "ElevatorBreaker" then runBreakerSolver(v) end
        end
    end
end)

local function getLibraryCode()
    local slot = table.create(5, "_")
    local paper
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            paper = char:FindFirstChild("LibraryHintPaper") or char:FindFirstChild("LibraryHintPaperHard") 
                or (plr.Backpack and (plr.Backpack:FindFirstChild("LibraryHintPaper") or plr.Backpack:FindFirstChild("LibraryHintPaperHard")))
            if paper then break end
        end
    end
    if not paper then return nil end
    local hints = LocalPlayer.PlayerGui:FindFirstChild("PermUI") and LocalPlayer.PlayerGui.PermUI:FindFirstChild("Hints") and LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()
    if not hints then return nil end

    for _, i in ipairs(paper.UI:GetChildren()) do
        if i:IsA("ImageLabel") and i.Name ~= "Image" then
            local pos = tonumber(i.Name)
            if pos and slot[pos] then
                for _, v in ipairs(hints) do
                    if v.Name == "Icon" and v.ImageRectOffset.X == i.ImageRectOffset.X then
                        local lab = v:FindFirstChild("TextLabel")
                        if lab then slot[pos] = lab.Text end
                        break
                    end
                end
            end
        end
    end
    return table.concat(slot)
end

Tabs.Auto:AddButton({
    Title = "Get & Notify Library Code",
    Description = "Reads code from Hint Paper and shows notification",
    Callback = function()
        local code = getLibraryCode()
        if code then
            Fluent:Notify({ Title = "Library Code", Content = "Code: " .. code, Duration = 8 })
        else
            Fluent:Notify({ Title = "Library Code", Content = "Hint Paper not found in inventory!", Duration = 4 })
        end
    end
})

-- Settings Tab
local HudToggle = Tabs.Settings:AddToggle("HUDToggle", {
    Title = T("HUDToggle"),
    Description = T("HUDDesc"),
    Default = true
})
HudToggle:OnChanged(function(state)
    hudFrame.Visible = state
end)

local LangDropdown = Tabs.Settings:AddDropdown("LanguageSelect", {
    Title = "Language / Язык",
    Values = { "English", "Russian" },
    Default = "English"
})
LangDropdown:OnChanged(function(val)
    CurrentLang = val
    Fluent:Notify({
        Title = "Language Changed",
        Content = val == "Russian" and "Язык переключен на русский (перезапустите для полного обновления текста)" or "Language switched to English",
        Duration = 4
    })
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("KonataHub")
SaveManager:SetFolder("KonataHub/Doors")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "KonataHub Loaded",
    Content = "Doors (" .. currentFloor .. ") Aqua Edition Ready.\nToggle Key: Right Shift",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
