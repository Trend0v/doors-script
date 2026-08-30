-- KonataHub | Doors Ultimate (Aqua Edition)
-- Featuring kyksikoid's ESPLibrary, Bypasses, Speed (75 Max), Manipulation, Keybinds HUD, and Archives Entities (Bash, Honcho, Ransom, Alma, Teller)

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

-- Fluent UI & Addons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- kyksikoid's ESPLibrary
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/ESPLibrary"))()

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
local CurrentLang = "English"

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
        DoorESP = "Doors & Keys",
        DoorESPDesc = "Highlight doors, keys, and electrical locks",
        ItemESP = "Items",
        ItemESPDesc = "Crucifix, Lockpicks, Flashlight, Vitamins, etc.",
        GoldESP = "Gold / Coins",
        GoldESPDesc = "Coins, gold piles with value, and chests",
        WardrobeESP = "Hiding Places",
        WardrobeESPDesc = "Wardrobes, closets, lockers, beds, vents",
        ObjectiveESP = "Objectives & Puzzles",
        ObjectiveESPDesc = "Levers, Breakers, Books, Fuses, Anchors",
        EntityESP = "Entities (All Monsters)",
        EntityESPDesc = "Rush, Ambush, Figure, Seek, Archives monsters, etc.",
        PlayerESP = "Players",
        PlayerESPDesc = "Other players and health percentage",
        
        -- ESP Settings
        ESPMode = "ESP Render Mode",
        ShowDistance = "Show Distance",
        ShowTracers = "Show Tracers",
        ShowRainbow = "Rainbow ESP",
        
        -- Movement
        Noclip = "Noclip",
        NoclipDesc = "Walk through walls and barriers",
        BypassSpeed = "Bypass Speed",
        BypassSpeedDesc = "Bypassed speed up to 75 without lagbacks",
        SpeedVal = "Movement Speed",
        Fly = "Flight (Fly)",
        FlySpeed = "Fly Speed",
        InfJump = "Infinite Jump",
        Manipulation = "Anti-Cheat Manipulation",
        ManipulationMethod = "Manipulation Method",
        
        -- Bypasses
        AntiScreech = "Anti Screech Damage",
        AntiA90 = "Anti A90 Damage",
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
        
        -- HUDs
        HUDToggle = "Show Player HUD State",
        HUDDesc = "Toggle Profile, FPS, Ping and Playtime",
        KeybindsHUD = "Show Keybinds HUD Overlay",
        KeybindsHUDDesc = "Floating card showing current active keybind states"
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
        DoorESP = "Двери и Ключи",
        DoorESPDesc = "Подсветка дверей, номеров комнат и ключей",
        ItemESP = "Предметы",
        ItemESPDesc = "Кресты, отмычки, фонари, витамины и т.д.",
        GoldESP = "Золото и Монеты",
        GoldESPDesc = "Подсветка золота с указанием суммы",
        WardrobeESP = "Укрытия / Шкафы",
        WardrobeESPDesc = "Подсветка шкафов, кроватей и вентиляций",
        ObjectiveESP = "Задания и Пазлы",
        ObjectiveESPDesc = "Рычаги, книги, предохранители, рубильники",
        EntityESP = "Монстры (Включая Архив)",
        EntityESPDesc = "Rush, Ambush, Figure, Seek, Bash, Honcho, Ransom, Alma, Teller и др.",
        PlayerESP = "Игроки",
        PlayerESPDesc = "Подсветка других игроков и здоровья",
        
        -- ESP Settings
        ESPMode = "Режим отрисовки ESP",
        ShowDistance = "Отображать дистанцию",
        ShowTracers = "Трейсеры (Линии)",
        ShowRainbow = "Радужный ESP",
        
        -- Movement
        Noclip = "Ноклип (Сквозь стены)",
        NoclipDesc = "Свободное прохождение через стены и двери",
        BypassSpeed = "Скорость (Обход Античита)",
        BypassSpeedDesc = "Разгон до 75 без откатов назад",
        SpeedVal = "Скорость движения",
        Fly = "Полет (Fly)",
        FlySpeed = "Скорость полета",
        InfJump = "Бесконечный прыжок",
        Manipulation = "Манипуляция (Manipulation)",
        ManipulationMethod = "Метод Манипуляции",
        
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
        
        -- HUDs
        HUDToggle = "HUD Статус игрока",
        HUDDesc = "Отображение профиля, FPS, пинга и времени игры",
        KeybindsHUD = "Оверлей Кейбиндов (Keybinds HUD)",
        KeybindsHUDDesc = "Плавающее окно со статусом всех горячих клавиш"
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
    Size = UDim2.fromOffset(630, 510),
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

-- ==================== KEYBINDS HUD OVERLAY ====================

local keybindsFrame = Instance.new("Frame")
keybindsFrame.Name = "KeybindsOverlay"
keybindsFrame.Size = UDim2.new(0, 210, 0, 165)
keybindsFrame.Position = UDim2.new(0.02, 0, 0.20, 0)
keybindsFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
keybindsFrame.BackgroundTransparency = 0.25
keybindsFrame.BorderSizePixel = 0
keybindsFrame.Active = true
keybindsFrame.Draggable = true
keybindsFrame.Parent = hudGui

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 10)
kbCorner.Parent = keybindsFrame

local kbStroke = Instance.new("UIStroke")
kbStroke.Color = Color3.fromRGB(0, 225, 255)
kbStroke.Thickness = 1.5
kbStroke.Transparency = 0.2
kbStroke.Parent = keybindsFrame

local kbTitle = Instance.new("TextLabel")
kbTitle.Size = UDim2.new(1, -20, 0, 24)
kbTitle.Position = UDim2.new(0, 10, 0, 6)
kbTitle.BackgroundTransparency = 1
kbTitle.Font = Enum.Font.GothamBold
kbTitle.TextSize = 13
kbTitle.TextColor3 = Color3.fromRGB(0, 225, 255)
kbTitle.TextXAlignment = Enum.TextXAlignment.Left
kbTitle.Text = "⚡ Keybinds State"
kbTitle.Parent = keybindsFrame

local kbList = Instance.new("UIListLayout")
kbList.SortOrder = Enum.SortOrder.LayoutOrder
kbList.Padding = UDim.new(0, 4)

local kbContainer = Instance.new("Frame")
kbContainer.Size = UDim2.new(1, -20, 1, -38)
kbContainer.Position = UDim2.new(0, 10, 0, 32)
kbContainer.BackgroundTransparency = 1
kbContainer.Parent = keybindsFrame
kbList.Parent = kbContainer

local keybindLabels = {}
local function createKeybindEntry(id, name, defaultKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 20)
    row.BackgroundTransparency = 1
    row.Parent = kbContainer

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.65, 0, 1, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = Color3.fromRGB(220, 230, 240)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = string.format("[%s] %s", defaultKey, name)
    nameLbl.Parent = row

    local stateLbl = Instance.new("TextLabel")
    stateLbl.Size = UDim2.new(0.35, 0, 1, 0)
    stateLbl.Position = UDim2.new(0.65, 0, 0, 0)
    stateLbl.BackgroundTransparency = 1
    stateLbl.Font = Enum.Font.GothamBold
    stateLbl.TextSize = 11
    stateLbl.TextColor3 = Color3.fromRGB(255, 75, 75)
    stateLbl.TextXAlignment = Enum.TextXAlignment.Right
    stateLbl.Text = "[OFF]"
    stateLbl.Parent = row

    keybindLabels[id] = { Row = row, State = stateLbl, Key = defaultKey, Name = name }
end

createKeybindEntry("Noclip", "Noclip", "N")
createKeybindEntry("Fly", "Flight", "F")
createKeybindEntry("Mani", "Manipulation", "V")
createKeybindEntry("Interact", "Auto Interact", "R")
createKeybindEntry("Menu", "Toggle Menu", "RShift")

local function updateKeybindState(id, isActive)
    if keybindLabels[id] then
        keybindLabels[id].State.Text = isActive and "[ON]" or "[OFF]"
        keybindLabels[id].State.TextColor3 = isActive and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 75, 75)
    end
end
updateKeybindState("Menu", true)

-- ==================== KYKSIKOID ESPLIBRARY INTEGRATION ====================

function AddESP(part, txt, color)
    if not part then return end
    ESPLibrary:AddESP({
        Object = part,
        Text = txt,
        Color = color
    })
end

function AddEntityESP(part, txt, color)
    if not part then return end
    if part:IsA("Model") then
        if not part.PrimaryPart then
            for _, v in pairs(part:GetChildren()) do
                if v:IsA("BasePart") then
                    part.PrimaryPart = v
                    break
                end
            end
        end
        if part.PrimaryPart then
            pcall(function() part.PrimaryPart.Transparency = 0.99 end)
        end
        if not part:FindFirstChildOfClass("Humanoid") then
            Instance.new("Humanoid", part)
        end
    end
    if part.Name == "FigureRig" or part.Name == "FigureRagdoll" then
        local root = part:FindFirstChild("Root")
        if root then root.Size = Vector3.new(0.001, 0.001, 0.001) end
    end
    ESPLibrary:AddESP({
        Object = part,
        Text = txt,
        Color = color
    })
end

-- Цвета категорий ESP
local DoorColor        = Color3.fromRGB(0, 225, 255)
local ItemsColor       = Color3.fromRGB(0, 255, 120)
local HidingPlaceColor = Color3.fromRGB(150, 100, 255)
local LeverColor       = Color3.fromRGB(255, 160, 50)
local BookColor        = Color3.fromRGB(0, 180, 255)
local BreakerColor     = Color3.fromRGB(0, 180, 255)
local GoldColor        = Color3.fromRGB(255, 215, 0)
local LadderColor      = Color3.fromRGB(0, 191, 255)
local FuseColor        = Color3.fromRGB(255, 170, 0)
local EntityColor      = Color3.fromRGB(255, 50, 50)
local PlayerColor      = Color3.fromRGB(100, 200, 255)

-- База всех предметов (включая Archives & Mines)
local Items = {
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
    ["GoldGun"] = "Golden Gun",
    ["Candy"] = "Candy",
    ["WaterPump"] = "Water Pump",
    ["VineGuillotine"] = "Vine Lever",
    ["Shakelight"] = "Shake Light",
    ["HolyGrenade"] = "Holy Grenade",
    ["ShieldMini"] = "Mini Shield",
    ["ShieldBig"] = "Big Shield",
    ["LotusPetalPickup"] = "Lotus Petal"
}

local HidingPlaces = {
    ["Wardrobe"] = "Closet",
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

-- База монстров с новыми сущностями из ARCHIVES: Bash, Honcho, Ransom, Alma, Teller!
local EntityAll = {
    -- Archives Monsters
    ["Bash"] = "Bash",
    ["BashMoving"] = "Bash",
    ["Honcho"] = "Honcho",
    ["HonchoRig"] = "Honcho",
    ["Ransom"] = "Ransom",
    ["RansomMoving"] = "Ransom",
    ["Alma"] = "Alma",
    ["Teller"] = "Teller",
    
    -- Hotel & Mines & Retro & Rooms Monsters
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
    ["DoorFake"] = "Dupe",
    ["GiggleCeiling"] = "Giggle",
    ["GrumbleRig"] = "Grumble",
    ["A60"] = "A-60",
    ["A120"] = "A-120",
    ["GlitchRush"] = "Glitch Rush",
    ["GlitchAmbush"] = "Glitch Ambush",
    ["JeffTheKiller"] = "Jeff",
    ["Groundskeeper"] = "Groundskeeper",
    ["LiveEntityBramble"] = "Bramble",
    ["MandrakeLive"] = "Mandrake",
    ["Mandrake"] = "Mandrake"
}

local DoorActiveESP = {}
local function RemoveDoorESP(part)
    if part and DoorActiveESP[part] then
        DoorActiveESP[part] = nil
        ESPLibrary:RemoveESP(part)
    end
end

local function UpdateDoorESP()
    if not (Options.DoorEsp and Options.DoorEsp.Value) then return end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if not rooms then return end
    for _, room in ipairs(rooms:GetChildren()) do
        local doorModel = room:FindFirstChild("Door")
        if doorModel then
            local doorPart = doorModel:FindFirstChild("Door") or doorModel:FindFirstChildWhichIsA("BasePart")
            if doorPart and not DoorActiveESP[doorPart] then
                DoorActiveESP[doorPart] = true
                AddESP(doorPart, "Door " .. room.Name, DoorColor)
            end
        end
        for _, v in ipairs(room:GetDescendants()) do
            if v.Name == "KeyObtain" and not DoorActiveESP[v] then
                DoorActiveESP[v] = true
                AddESP(v, "Key", Color3.fromRGB(0, 255, 180))
            elseif v.Name == "ElectrialKeyObtain" and not DoorActiveESP[v] then
                DoorActiveESP[v] = true
                AddESP(v, "Electrical Key", Color3.fromRGB(0, 255, 180))
            end
        end
    end
end

local function ClearAllDoorESP()
    for part in pairs(DoorActiveESP) do
        ESPLibrary:RemoveESP(part)
    end
    table.clear(DoorActiveESP)
end

local ItemActiveESP = {}
local function UpdateItemESP()
    if not (Options.ItemEsp and Options.ItemEsp.Value) then return end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if not rooms then return end
    for _, room in ipairs(rooms:GetChildren()) do
        for _, v in ipairs(room:GetDescendants()) do
            if Items[v.Name] and not ItemActiveESP[v] then
                ItemActiveESP[v] = true
                AddESP(v, Items[v.Name], ItemsColor)
            end
        end
    end
end

local function ClearAllItemESP()
    for part in pairs(ItemActiveESP) do
        ESPLibrary:RemoveESP(part)
    end
    table.clear(ItemActiveESP)
end

local GoldActiveESP = {}
local function UpdateGoldESP()
    if not (Options.GoldEsp and Options.GoldEsp.Value) then return end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if not rooms then return end
    for _, room in ipairs(rooms:GetChildren()) do
        for _, v in ipairs(room:GetDescendants()) do
            if v.Name == "GoldPile" or v.Name == "Gold" or v.Name == "ChestBox" or v.Name == "ChestBoxLocked" then
                if not GoldActiveESP[v] then
                    GoldActiveESP[v] = true
                    local val = v:GetAttribute("GoldValue")
                    local label = val and ("Gold (" .. val .. ")") or "Gold / Chest"
                    AddESP(v, label, GoldColor)
                end
            end
        end
    end
end

local function ClearAllGoldESP()
    for part in pairs(GoldActiveESP) do
        ESPLibrary:RemoveESP(part)
    end
    table.clear(GoldActiveESP)
end

local HidingActiveESP = {}
local function UpdateHidingESP()
    if not (Options.WardrobeEsp and Options.WardrobeEsp.Value) then return end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if not rooms then return end
    for _, room in ipairs(rooms:GetChildren()) do
        for _, v in ipairs(room:GetDescendants()) do
            if HidingPlaces[v.Name] and not HidingActiveESP[v] then
                HidingActiveESP[v] = true
                AddESP(v, HidingPlaces[v.Name], HidingPlaceColor)
            end
        end
    end
end

local function ClearAllHidingESP()
    for part in pairs(HidingActiveESP) do
        ESPLibrary:RemoveESP(part)
    end
    table.clear(HidingActiveESP)
end

local ObjectiveActiveESP = {}
local function UpdateObjectiveESP()
    if not (Options.ObjectiveEsp and Options.ObjectiveEsp.Value) then return end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if not rooms then return end
    for _, room in ipairs(rooms:GetChildren()) do
        for _, v in ipairs(room:GetDescendants()) do
            local n = v.Name
            if n == "LiveHintBook" and not ObjectiveActiveESP[v] then
                ObjectiveActiveESP[v] = true
                AddESP(v, "Library Book", BookColor)
            elseif (n == "LiveBreakerPolePickup" or n == "BreakerSwitch") and not ObjectiveActiveESP[v] then
                ObjectiveActiveESP[v] = true
                AddESP(v, "Breaker", BreakerColor)
            elseif (n == "LeverForGate" or n == "TimerLever") and not ObjectiveActiveESP[v] then
                ObjectiveActiveESP[v] = true
                AddESP(v, "Gate Lever", LeverColor)
            elseif n == "FuseObtain" and not ObjectiveActiveESP[v] then
                ObjectiveActiveESP[v] = true
                AddESP(v, "Fuse", FuseColor)
            elseif n == "MinesGenerator" and not ObjectiveActiveESP[v] then
                ObjectiveActiveESP[v] = true
                AddESP(v, "Generator", FuseColor)
            elseif n == "MinesAnchor" and not ObjectiveActiveESP[v] then
                ObjectiveActiveESP[v] = true
                local sign = v:FindFirstChild("Sign")
                local signText = sign and sign:FindFirstChild("TextLabel") and sign.TextLabel.Text or ""
                AddESP(v, "Anchor " .. signText, Color3.fromRGB(0, 200, 255))
            end
        end
    end
end

local function ClearAllObjectiveESP()
    for part in pairs(ObjectiveActiveESP) do
        ESPLibrary:RemoveESP(part)
    end
    table.clear(ObjectiveActiveESP)
end

local EntityActiveESP = {}
local notifiedEntities = {}
local function CheckEntity(v)
    local n = v.Name
    local label = EntityAll[n]
    if not label then
        for key, val in pairs(EntityAll) do
            if n:find(key) then label = val break end
        end
    end

    if label then
        if not EntityActiveESP[v] and Options.EntityEsp and Options.EntityEsp.Value then
            EntityActiveESP[v] = true
            AddEntityESP(v, "⚠ " .. label .. " ⚠", EntityColor)
        end
        if not notifiedEntities[v] then
            notifiedEntities[v] = true
            local sound = Instance.new("Sound", workspace)
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = 1.5
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 3)

            Fluent:Notify({
                Title = "⚠ ENTITY SPAWNED!",
                Content = label .. " is approaching / spawned!",
                Duration = 6
            })
            v.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    notifiedEntities[v] = nil
                    if EntityActiveESP[v] then
                        EntityActiveESP[v] = nil
                        ESPLibrary:RemoveESP(v)
                    end
                end
            end)
        end
    end
end

local function UpdateEntityESP()
    if not (Options.EntityEsp and Options.EntityEsp.Value) then return end
    for _, v in ipairs(workspace:GetChildren()) do CheckEntity(v) end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if rooms then
        for _, room in ipairs(rooms:GetChildren()) do
            for _, v in ipairs(room:GetDescendants()) do CheckEntity(v) end
        end
    end
end

local function ClearAllEntityESP()
    for part in pairs(EntityActiveESP) do
        ESPLibrary:RemoveESP(part)
    end
    table.clear(EntityActiveESP)
end

workspace.ChildAdded:Connect(function(v)
    task.wait(0.05)
    CheckEntity(v)
end)

local function UpdateAllESP()
    UpdateDoorESP()
    UpdateItemESP()
    UpdateGoldESP()
    UpdateHidingESP()
    UpdateObjectiveESP()
    UpdateEntityESP()
end

local roomsFolder = workspace:FindFirstChild("CurrentRooms")
if roomsFolder then
    roomsFolder.ChildAdded:Connect(function(room)
        task.wait(0.2)
        UpdateAllESP()
        room.DescendantAdded:Connect(function()
            task.wait(0.1)
            UpdateAllESP()
        end)
    end)
    for _, room in ipairs(roomsFolder:GetChildren()) do
        room.DescendantAdded:Connect(function()
            task.wait(0.1)
            UpdateAllESP()
        end)
    end
end
task.spawn(UpdateAllESP)

-- Игроки ESP
local PlayerActiveESP = {}
local function UpdatePlayerESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if Options.PlayerEsp and Options.PlayerEsp.Value then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    ESPLibrary:RemoveESP(plr.Character)
                    AddESP(plr.Character, plr.DisplayName .. " [" .. math.floor(hum.Health) .. "%]", PlayerColor)
                    PlayerActiveESP[plr.Character] = true
                end
            else
                if PlayerActiveESP[plr.Character] then
                    ESPLibrary:RemoveESP(plr.Character)
                    PlayerActiveESP[plr.Character] = nil
                end
            end
        end
    end
end

-- ==================== BYPASSES & MOVEMENT ====================

-- 1. Noclip
local noclipConn
local function setNoclip(enabled)
    updateKeybindState("Noclip", enabled)
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

-- 2. Bypass Speed (Max 75) + Crouch remote loop
local speedConn
local crouchBypassLoop
local function setBypassSpeed(enabled)
    if enabled then
        speedConn = RunService.RenderStepped:Connect(function(delta)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    local targetSpeed = Options.SpeedSlider and Options.SpeedSlider.Value or 22
                    local speedMultiplier = targetSpeed - 15
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

-- 3. Flight
local flyConn
local function setFly(enabled)
    updateKeybindState("Fly", enabled)
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
            local speed = Options.FlySpeedSlider and Options.FlySpeedSlider.Value or 25
            
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

-- 4. Manipulation (AntiCheatMani from kyksikoid)
local function setManipulation(enabled)
    updateKeybindState("Mani", enabled)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if enabled then
        local method = Options.AntiCheatManiMethod and Options.AntiCheatManiMethod.Value or "Velocity"
        if method == "Velocity" then
            if not (Options.NoclipToggle and Options.NoclipToggle.Value) then
                setNoclip(true)
            end
            local BodyVelocity = root:FindFirstChild("VelocityMani") or Instance.new("BodyVelocity", root)
            local LookingVector = root.CFrame.LookVector * 2
            BodyVelocity.Velocity = Vector3.new(LookingVector.X, LookingVector.Y, LookingVector.Z)
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Name = "VelocityMani"
        else
            local currentPivot = char:GetPivot()
            char:PivotTo(currentPivot * CFrame.new(0, 0, 10000))
        end
    else
        if root:FindFirstChild("VelocityMani") then
            root.VelocityMani:Destroy()
        end
        if not (Options.NoclipToggle and Options.NoclipToggle.Value) then
            setNoclip(false)
        end
    end
end

-- 5. Anti Entity Bypasses
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

-- ==================== ВКЛАДКА: ESP ====================

local DoorToggle = Tabs.ESP:AddToggle("DoorEsp", { Title = T("DoorESP"), Description = T("DoorESPDesc"), Default = true })
DoorToggle:OnChanged(function(state)
    if state then UpdateDoorESP() else ClearAllDoorESP() end
end)

local ItemToggle = Tabs.ESP:AddToggle("ItemEsp", { Title = T("ItemESP"), Description = T("ItemESPDesc"), Default = true })
ItemToggle:OnChanged(function(state)
    if state then UpdateItemESP() else ClearAllItemESP() end
end)

local GoldToggle = Tabs.ESP:AddToggle("GoldEsp", { Title = T("GoldESP"), Description = T("GoldESPDesc"), Default = true })
GoldToggle:OnChanged(function(state)
    if state then UpdateGoldESP() else ClearAllGoldESP() end
end)

local WardrobeToggle = Tabs.ESP:AddToggle("WardrobeEsp", { Title = T("WardrobeESP"), Description = T("WardrobeESPDesc"), Default = true })
WardrobeToggle:OnChanged(function(state)
    if state then UpdateHidingESP() else ClearAllHidingESP() end
end)

local ObjectiveToggle = Tabs.ESP:AddToggle("ObjectiveEsp", { Title = T("ObjectiveESP"), Description = T("ObjectiveESPDesc"), Default = true })
ObjectiveToggle:OnChanged(function(state)
    if state then UpdateObjectiveESP() else ClearAllObjectiveESP() end
end)

local EntityToggle = Tabs.ESP:AddToggle("EntityEsp", { Title = T("EntityESP"), Description = T("EntityESPDesc"), Default = true })
EntityToggle:OnChanged(function(state)
    if state then UpdateEntityESP() else ClearAllEntityESP() end
end)

local PlayerToggle = Tabs.ESP:AddToggle("PlayerEsp", { Title = T("PlayerESP"), Description = T("PlayerESPDesc"), Default = false })
PlayerToggle:OnChanged(function(_)
    UpdatePlayerESP()
end)

Tabs.ESP:AddDropdown("ESPModeDropdown", {
    Title = T("ESPMode"),
    Values = { "Highlight/Text", "Text", "Highlight" },
    Default = "Highlight/Text",
    Callback = function(val)
        ESPLibrary:SetESPMode(val)
    end
})

Tabs.ESP:AddToggle("ShowDistanceToggle", {
    Title = T("ShowDistance"),
    Default = true,
    Callback = function(val)
        ESPLibrary:SetShowDistance(val)
    end
})

Tabs.ESP:AddToggle("ShowTracersToggle", {
    Title = T("ShowTracers"),
    Default = false,
    Callback = function(val)
        ESPLibrary:SetTracers(val)
    end
})

Tabs.ESP:AddToggle("ShowRainbowToggle", {
    Title = T("ShowRainbow"),
    Default = false,
    Callback = function(val)
        ESPLibrary:SetRainbow(val)
    end
})

-- ==================== ВКЛАДКА: BYPASSES ====================

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

-- ==================== ВКЛАДКА: MOVEMENT ====================

local NoclipTog = Tabs.Movement:AddToggle("NoclipToggle", { Title = T("Noclip"), Description = T("NoclipDesc"), Default = false })
NoclipTog:OnChanged(setNoclip)

local SpeedTog = Tabs.Movement:AddToggle("SpeedToggle", { Title = T("BypassSpeed"), Description = T("BypassSpeedDesc"), Default = false })
SpeedTog:OnChanged(setBypassSpeed)

Tabs.Movement:AddSlider("SpeedSlider", {
    Title = T("SpeedVal"),
    Default = 22,
    Min = 16,
    Max = 75, -- Установлен максимум 75 как в оригинале kyksikoid!
    Rounding = 0,
    Callback = function(_) end
})

local FlyTog = Tabs.Movement:AddToggle("FlyToggle", { Title = T("Fly"), Default = false })
FlyTog:OnChanged(setFly)

Tabs.Movement:AddSlider("FlySpeedSlider", {
    Title = T("FlySpeed"),
    Default = 25,
    Min = 15,
    Max = 75,
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

Tabs.Movement:AddDropdown("AntiCheatManiMethod", {
    Title = T("ManipulationMethod"),
    Values = { "Velocity", "Anticheat" },
    Default = "Velocity"
})

local ManiTog = Tabs.Movement:AddToggle("AntiCheatMani", {
    Title = T("Manipulation"),
    Description = "Bypassed anti-cheat velocity / position manipulation",
    Default = false
})
ManiTog:OnChanged(setManipulation)

-- Горячие клавиши (Keybinds)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.N then
        if Options.NoclipToggle then
            Options.NoclipToggle:SetValue(not Options.NoclipToggle.Value)
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        if Options.FlyToggle then
            Options.FlyToggle:SetValue(not Options.FlyToggle.Value)
        end
    elseif input.KeyCode == Enum.KeyCode.V then
        if Options.AntiCheatMani then
            Options.AntiCheatMani:SetValue(not Options.AntiCheatMani.Value)
        end
    end
end)

-- ==================== ВКЛАДКА: VISUALS ====================

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

-- ==================== ВКЛАДКА: AUTO & SOLVERS ====================

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

-- ==================== ВКЛАДКА: SETTINGS ====================

local HudToggle = Tabs.Settings:AddToggle("HUDToggle", {
    Title = T("HUDToggle"),
    Description = T("HUDDesc"),
    Default = true
})
HudToggle:OnChanged(function(state)
    hudFrame.Visible = state
end)

local KeybindsHudToggle = Tabs.Settings:AddToggle("KeybindsHUDToggle", {
    Title = T("KeybindsHUD"),
    Description = T("KeybindsHUDDesc"),
    Default = true
})
KeybindsHudToggle:OnChanged(function(state)
    keybindsFrame.Visible = state
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
