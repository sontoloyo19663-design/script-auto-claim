-- Auto Claim Angpao CDI - Anti Kick Version
-- Metode: MoveTo + VirtualInput (PC & Android)
-- Executor: Ronix

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

-- =====================
--        GUI
-- =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AngpaoGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 200)
frame.Position = UDim2.new(0.5, -130, 0.02, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
title.BorderSizePixel = 0
title.Text = "🧧 Auto Claim Angpao CDI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 43)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

local progressLabel = Instance.new("TextLabel")
progressLabel.Size = UDim2.new(1, -20, 0, 25)
progressLabel.Position = UDim2.new(0, 10, 0, 76)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "Progress: -"
progressLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
progressLabel.TextScaled = true
progressLabel.Font = Enum.Font.Gotham
progressLabel.Parent = frame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -20, 0, 25)
resultLabel.Position = UDim2.new(0, 10, 0, 104)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
resultLabel.TextScaled = true
resultLabel.Font = Enum.Font.Gotham
resultLabel.Parent = frame

-- Speed setting
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 130)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Walk Speed: Normal"
speedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 110, 0, 35)
startBtn.Position = UDim2.new(0, 10, 0, 155)
startBtn.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
startBtn.BorderSizePixel = 0
startBtn.Text = "▶ Start"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
startBtn.Parent = frame
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 110, 0, 35)
stopBtn.Position = UDim2.new(0, 138, 0, 155)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
stopBtn.BorderSizePixel = 0
stopBtn.Text = "⏹ Stop"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextScaled = true
stopBtn.Font = Enum.Font.GothamBold
stopBtn.Parent = frame
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

-- =====================
--       LOGIC
-- =====================
local isRunning = false
local maxRecheckLoop = 3
local collectRange = 8 -- jarak trigger ProximityPrompt dalam stud

local function setStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

local function setProgress(current, total)
    progressLabel.Text = "Progress: " .. current .. " / " .. total
end

local function setResult(text, color)
    resultLabel.Text = text
    resultLabel.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
    return getCharacter():WaitForChild("Humanoid")
end

local function distanceTo(part)
    local hrp = getHRP()
    return (hrp.Position - part.Position).Magnitude
end

local function pressE()
    -- Simulasi tekan E (PC & Android via VirtualInputManager)
    pcall(function()
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.15)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

local function walkToAndClaim(angpaoModel)
    if not isRunning then return false end

    local character = getCharacter()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Cari part utama
    local part = angpaoModel:FindFirstChildWhichIsA("BasePart")
    if not part then return false end

    local prompt = part:FindFirstChild("Collect")
    if not prompt then return false end

    -- Set walkspeed sedikit lebih cepat tapi tidak mencurigakan
    humanoid.WalkSpeed = 24

    -- Jalan ke angpao
    humanoid:MoveTo(part.Position)

    -- Tunggu sampai dalam range collect
    local timeout = 15
    local elapsed = 0
    while isRunning and elapsed < timeout do
        local dist = distanceTo(part)
        if dist <= collectRange then
            break
        end
        -- Terus arahkan ke target (hindari stuck)
        humanoid:MoveTo(part.Position)
        task.wait(0.2)
        elapsed += 0.2
    end

    if not isRunning then return false end

    task.wait(0.3)

    -- Tekan E untuk collect
    pressE()
    task.wait(0.8)

    -- Reset walkspeed
    humanoid.WalkSpeed = 16

    -- Cek apakah berhasil (angpao hilang = berhasil)
    return not part.Parent or not angpaoModel.Parent
end

local function startClaim()
    isRunning = true
    setResult("")

    local angpaoFolder = workspace:FindFirstChild("Event")
        and workspace.Event:FindFirstChild("AngpaoFolder")

    if not angpaoFolder then
        setStatus("❌ AngpaoFolder tidak ditemukan!", Color3.fromRGB(255, 80, 80))
        isRunning = false
        return
    end

    local missed = {}

    -- Scan pertama
    setStatus("🚶 Berjalan ke angpao...", Color3.fromRGB(255, 215, 0))

    for i = 1, 77 do
        if not isRunning then break end
        local angpaoName = "Angpao" .. i
        local angpao = angpaoFolder:FindFirstChild(angpaoName)
        setProgress(i, 77)

        if angpao then
            setStatus("🧧 Menuju " .. angpaoName, Color3.fromRGB(255, 215, 0))
            local success = walkToAndClaim(angpao)
            if not success and angpaoFolder:FindFirstChild(angpaoName) then
                table.insert(missed, angpaoName)
            end
        end
    end

    -- Re-check
    for loop = 1, maxRecheckLoop do
        if not isRunning or #missed == 0 then break end
        setStatus("🔄 Re-check #" .. loop .. " | Sisa: " .. #missed, Color3.fromRGB(100, 180, 255))
        task.wait(1)

        local stillMissed = {}
        for idx, angpaoName in ipairs(missed) do
            if not isRunning then break end
            local angpao = angpaoFolder:FindFirstChild(angpaoName)
            setProgress(idx, #missed)
            if angpao then
                local success = walkToAndClaim(angpao)
                if not success and angpaoFolder:FindFirstChild(angpaoName) then
                    table.insert(stillMissed, angpaoName)
                end
            end
        end
        missed = stillMissed
    end

    -- Reset walkspeed pastikan normal
    pcall(function()
        getHumanoid().WalkSpeed = 16
    end)

    if #missed == 0 then
        setStatus("✅ Selesai!", Color3.fromRGB(100, 255, 100))
        setResult("Semua angpao berhasil diclaim!", Color3.fromRGB(100, 255, 100))
    else
        setStatus("⚠️ Selesai dengan sisa", Color3.fromRGB(255, 150, 50))
        setResult("Gagal: " .. #missed .. " angpao", Color3.fromRGB(255, 150, 50))
    end

    setProgress(77, 77)
    isRunning = false
end

startBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        task.spawn(startClaim)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    setStatus("⏹ Dihentikan", Color3.fromRGB(255, 80, 80))
    setResult("")
    pcall(function()
        getHumanoid().WalkSpeed = 16
    end)
end)

print("[AngpaoGUI] Loaded! Klik Start untuk mulai.")
