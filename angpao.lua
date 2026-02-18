-- Auto Claim Angpao CDI - Final Version
-- Teleport + Hold E (2 detik) | PC & Android
-- Executor: Ronix

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

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
resultLabel.Text = "Platform: " .. (isMobile and "📱 Android" or "💻 PC")
resultLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
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
local maxRecheckLoop = 3
local HOLD_DURATION = 2.2  -- Sedikit lebih dari 2 detik untuk toleransi
local ACTIVATION_DISTANCE = 8  -- Dalam range 10, kita pakai 8 untuk aman

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

-- PC: Hold E selama HoldDuration
local function holdE(duration)
    pcall(function()
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(duration)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

-- Android: Hold tap pada tombol ProximityPrompt di CoreGui
local function holdTapProximityButton(duration)
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        for _, obj in ipairs(coreGui:GetDescendants()) do
            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible then
                local pos = obj.AbsolutePosition
                local size = obj.AbsoluteSize
                local screenSize = workspace.CurrentCamera.ViewportSize
                local centerX = pos.X + size.X / 2
                local centerY = pos.Y + size.Y / 2
                -- Hanya tap button di area tengah layar
                if centerX > screenSize.X * 0.2 and centerX < screenSize.X * 0.8
                    and centerY > screenSize.Y * 0.2 and centerY < screenSize.Y * 0.8 then
                    -- Hold tap
                    VIM:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
                    task.wait(duration)
                    VIM:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
                    return
                end
            end
        end
    end)
end

local function simulateCollect()
    if isMobile then
        holdTapProximityButton(HOLD_DURATION)
    else
        holdE(HOLD_DURATION)
    end
end

local function claimAngpao(angpaoModel)
    if not isRunning then return false end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Path: AngpaoFolder > Angpao# (Model) > Angpao# (Part) > Collect
    local part = angpaoModel:FindFirstChildWhichIsA("BasePart")
    if not part then return false end

    local prompt = part:FindFirstChild("Collect")
    if not prompt then return false end

    -- Teleport dalam range aktivasi
    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
    task.wait(0.6) -- Tunggu ProximityPrompt UI muncul

    -- Hold E / tap selama 2.2 detik
    simulateCollect()
    task.wait(0.5) -- Jeda setelah claim

    -- Cek berhasil (angpao hilang = sukses)
    return not angpaoModel.Parent or not part.Parent
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

    for i = 1, 77 do
        if not isRunning then break end
        local angpaoName = "Angpao" .. i
        local angpao = angpaoFolder:FindFirstChild(angpaoName)
        setProgress(i, 77)

        if angpao then
            setStatus("🧧 Claiming " .. angpaoName, Color3.fromRGB(255, 215, 0))
            local success = claimAngpao(angpao)
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
                local success = claimAngpao(angpao)
                if not success and angpaoFolder:FindFirstChild(angpaoName) then
                    table.insert(stillMissed, angpaoName)
                end
            end
        end
        missed = stillMissed
    end

    if #missed == 0 then
        setStatus("✅ Selesai!", Color3.fromRGB(100, 255, 100))
        setResult("Semua angpao berhasil diclaim!", Color3.fromRGB(100, 255, 100))
    else
        setStatus("⚠️ Ada yang gagal", Color3.fromRGB(255, 150, 50))
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

print("[AngpaoGUI] Loaded! Platform: " .. (isMobile and "Android" or "PC"))
