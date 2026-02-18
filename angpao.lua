-- Auto Claim Angpao CDI - Full Version
-- Teleport + Hold E + Fly/Noclip + Camera Rotate + Render Delay Slider
-- Executor: Ronix

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- =====================
--        GUI
-- =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AngpaoGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 290)
frame.Position = UDim2.new(0.5, -135, 0.02, 0)
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
title.Text = "🧧 Auto Claim Angpao By Garskirtz AKA BIANCA"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

local progressLabel = Instance.new("TextLabel")
progressLabel.Size = UDim2.new(1, -20, 0, 22)
progressLabel.Position = UDim2.new(0, 10, 0, 67)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "Progress: -"
progressLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
progressLabel.TextScaled = true
progressLabel.Font = Enum.Font.Gotham
progressLabel.Parent = frame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -20, 0, 22)
resultLabel.Position = UDim2.new(0, 10, 0, 91)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Platform: " .. (isMobile and "📱 Android" or "💻 PC")
resultLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
resultLabel.TextScaled = true
resultLabel.Font = Enum.Font.Gotham
resultLabel.Parent = frame

-- Toggle Fly+Noclip
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(1, -20, 0, 28)
flyToggle.Position = UDim2.new(0, 10, 0, 118)
flyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
flyToggle.BorderSizePixel = 0
flyToggle.Text = "🚀 Fly + Noclip: OFF"
flyToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
flyToggle.TextScaled = true
flyToggle.Font = Enum.Font.GothamBold
flyToggle.Parent = frame
Instance.new("UICorner", flyToggle).CornerRadius = UDim.new(0, 6)

-- Toggle Camera
local camToggle = Instance.new("TextButton")
camToggle.Size = UDim2.new(1, -20, 0, 28)
camToggle.Position = UDim2.new(0, 10, 0, 150)
camToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
camToggle.BorderSizePixel = 0
camToggle.Text = "📷 Auto Camera: OFF"
camToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
camToggle.TextScaled = true
camToggle.Font = Enum.Font.GothamBold
camToggle.Parent = frame
Instance.new("UICorner", camToggle).CornerRadius = UDim.new(0, 6)

-- Render Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(1, -20, 0, 20)
delayLabel.Position = UDim2.new(0, 10, 0, 184)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "⏱ Jeda Render: 2.0 detik"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.TextScaled = true
delayLabel.Font = Enum.Font.Gotham
delayLabel.Parent = frame

-- Slider Track
local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -20, 0, 10)
sliderTrack.Position = UDim2.new(0, 10, 0, 208)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = frame
Instance.new("UICorner", sliderTrack).CornerRadius = UDim.new(1, 0)

-- Slider Fill
local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.25, 0, 1, 0) -- default 2 detik (25% dari range 1-5)
sliderFill.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

-- Slider Knob
local sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.Position = UDim2.new(0.25, -10, 0.5, -10)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Text = ""
sliderKnob.Parent = sliderTrack
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

-- Start & Stop
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 120, 0, 35)
startBtn.Position = UDim2.new(0, 10, 0, 228)
startBtn.BackgroundColor3 = Color3.fromRGB(30, 160, 60)
startBtn.BorderSizePixel = 0
startBtn.Text = "▶ Start"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
startBtn.Parent = frame
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 120, 0, 35)
stopBtn.Position = UDim2.new(0, 140, 0, 228)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
stopBtn.BorderSizePixel = 0
stopBtn.Text = "⏹ Stop"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextScaled = true
stopBtn.Font = Enum.Font.GothamBold
stopBtn.Parent = frame
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

-- =====================
--      SLIDER LOGIC
-- =====================
local renderDelay = 2.0 -- default
local isDragging = false
local minDelay = 1.0
local maxDelay = 5.0

local function updateSlider(inputX)
    local trackPos = sliderTrack.AbsolutePosition.X
    local trackSize = sliderTrack.AbsoluteSize.X
    local relative = math.clamp((inputX - trackPos) / trackSize, 0, 1)

    renderDelay = math.floor((minDelay + relative * (maxDelay - minDelay)) * 10) / 10

    sliderFill.Size = UDim2.new(relative, 0, 1, 0)
    sliderKnob.Position = UDim2.new(relative, -10, 0.5, -10)
    delayLabel.Text = "⏱ Jeda Render: " .. string.format("%.1f", renderDelay) .. " detik"
end

sliderKnob.MouseButton1Down:Connect(function()
    isDragging = true
end)

UIS.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input.Position.X)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Touch support (Android)
sliderKnob.TouchLongPress:Connect(function()
    isDragging = true
end)

UIS.TouchMoved:Connect(function(input)
    if isDragging then
        updateSlider(input.Position.X)
    end
end)

UIS.TouchEnded:Connect(function()
    isDragging = false
end)

-- =====================
--       VARIABLES
-- =====================
local isRunning = false
local isFlyEnabled = false
local isCamEnabled = false
local maxRecheckLoop = 3
local HOLD_DURATION = 2.2
local flyConnection = nil
local noclipConnection = nil

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

-- =====================
--     FLY + NOCLIP
-- =====================
local function enableFly()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.PlatformStand = true

    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVel.Parent = hrp

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 1e4
    bodyGyro.Parent = hrp

    noclipConnection = RunService.Stepped:Connect(function()
        if not isFlyEnabled then return end
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    flyConnection = {bodyVel, bodyGyro}
end

local function disableFly()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if humanoid then humanoid.PlatformStand = false end
        if hrp then
            for _, v in ipairs(hrp:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                    v:Destroy()
                end
            end
        end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    flyConnection = nil
end

-- =====================
--    AUTO CAMERA
-- =====================
local function pointCameraAt(targetPosition)
    if not isCamEnabled then return end
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 2, 0), targetPosition)
    task.wait(0.1)
    camera.CameraType = Enum.CameraType.Custom
end

-- =====================
--     CLAIM LOGIC
-- =====================
local function holdE(duration)
    pcall(function()
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(duration)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

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
                if centerX > screenSize.X * 0.2 and centerX < screenSize.X * 0.8
                    and centerY > screenSize.Y * 0.2 and centerY < screenSize.Y * 0.8 then
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

    local part = angpaoModel:FindFirstChildWhichIsA("BasePart")
    if not part then return false end

    local prompt = part:FindFirstChild("Collect")
    if not prompt then return false end

    -- Teleport ke angpao
    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
    task.wait(0.3)

    -- Arahkan kamera
    pointCameraAt(part.Position)
    task.wait(0.2)

    -- Tunggu render map sesuai slider
    setStatus("⏳ Menunggu render... " .. string.format("%.1f", renderDelay) .. "s", Color3.fromRGB(150, 150, 255))
    task.wait(renderDelay)

    -- Hold E / tap
    simulateCollect()
    task.wait(0.5)

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

    if isFlyEnabled then enableFly() end

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

    if isFlyEnabled then disableFly() end
    camera.CameraType = Enum.CameraType.Custom

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

-- =====================
--     BUTTON EVENTS
-- =====================
flyToggle.MouseButton1Click:Connect(function()
    isFlyEnabled = not isFlyEnabled
    if isFlyEnabled then
        flyToggle.Text = "🚀 Fly + Noclip: ON"
        flyToggle.BackgroundColor3 = Color3.fromRGB(30, 100, 180)
    else
        flyToggle.Text = "🚀 Fly + Noclip: OFF"
        flyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        disableFly()
    end
end)

camToggle.MouseButton1Click:Connect(function()
    isCamEnabled = not isCamEnabled
    if isCamEnabled then
        camToggle.Text = "📷 Auto Camera: ON"
        camToggle.BackgroundColor3 = Color3.fromRGB(30, 100, 180)
    else
        camToggle.Text = "📷 Auto Camera: OFF"
        camToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        camera.CameraType = Enum.CameraType.Custom
    end
end)

startBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        task.spawn(startClaim)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    disableFly()
    camera.CameraType = Enum.CameraType.Custom
    setStatus("⏹ Dihentikan", Color3.fromRGB(255, 80, 80))
    setResult("")
end)

print("[AngpaoGUI] Loaded! Platform: " .. (isMobile and "Android" or "PC"))
