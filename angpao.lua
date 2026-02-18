-- Auto Claim Angpao CDI + GUI + ProximityPrompt
-- Executor: Ronix | Android Compatible

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =====================
--        GUI
-- =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AngpaoGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 180)
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
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

local progressLabel = Instance.new("TextLabel")
progressLabel.Size = UDim2.new(1, -20, 0, 25)
progressLabel.Position = UDim2.new(0, 10, 0, 78)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "Progress: -"
progressLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
progressLabel.TextScaled = true
progressLabel.Font = Enum.Font.Gotham
progressLabel.Parent = frame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -20, 0, 25)
resultLabel.Position = UDim2.new(0, 10, 0, 108)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
resultLabel.TextScaled = true
resultLabel.Font = Enum.Font.Gotham
resultLabel.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 110, 0, 35)
startBtn.Position = UDim2.new(0, 10, 0, 138)
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
stopBtn.Position = UDim2.new(0, 138, 0, 138)
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
local claimDelay = 1.0
local maxRecheckLoop = 3
local teleportOffset = Vector3.new(0, 3, 0)

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

local function claimAngpao(angpaoModel)
    if not isRunning then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Cari Part dalam model (namanya sama dengan model)
    local part = angpaoModel:FindFirstChildWhichIsA("BasePart") 
        or angpaoModel:FindFirstChild(angpaoModel.Name)

    if not part then return end

    -- Cari ProximityPrompt bernama "Collect"
    local prompt = part:FindFirstChild("Collect")

    if not prompt then return end

    -- Teleport ke angpao
    hrp.CFrame = CFrame.new(part.Position + teleportOffset)
    task.wait(0.6)

    -- Fire ProximityPrompt (Android & PC compatible)
    pcall(function()
        fireproximityprompt(prompt)
    end)

    task.wait(claimDelay)
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

    -- Scan pertama
    local missed = {}
    setStatus("🔍 Scanning...", Color3.fromRGB(255, 215, 0))

    for i = 1, 77 do
        if not isRunning then break end
        local angpaoName = "Angpao" .. i
        local angpao = angpaoFolder:FindFirstChild(angpaoName)
        setProgress(i, 77)

        if angpao then
            setStatus("🧧 Claiming " .. angpaoName, Color3.fromRGB(255, 215, 0))
            claimAngpao(angpao)
            -- Cek apakah masih ada setelah claim
            if angpaoFolder:FindFirstChild(angpaoName) then
                table.insert(missed, angpaoName)
            end
        end
    end

    -- Re-check loop
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
                claimAngpao(angpao)
                if angpaoFolder:FindFirstChild(angpaoName) then
                    table.insert(stillMissed, angpaoName)
                end
            end
        end
        missed = stillMissed
    end

    -- Hasil akhir
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
end)

print("[AngpaoGUI] Loaded! Klik Start untuk mulai.")
