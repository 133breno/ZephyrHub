-- Zephyr ADM HUB Visual Completo
-- Desenvolvido por by botzinYT12 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Criar GUI
local MainGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
MainGui.Name = "ZephyrAdvancedHub"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Barra superior
local TopBar = Instance.new("Frame", Frame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- Botões: Minimizar, Maximizar, Fechar
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -90, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local MaxBtn = Instance.new("TextButton", TopBar)
MaxBtn.Size = UDim2.new(0, 30, 1, 0)
MaxBtn.Position = UDim2.new(1, -60, 0, 0)
MaxBtn.Text = "+"
MaxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)


-- Minimizar
local contentVisible = true
MinBtn.MouseButton1Click:Connect(function()
    contentVisible = false
    for _, obj in pairs(Frame:GetChildren()) do
        if obj ~= TopBar and obj:IsA("GuiObject") then
            obj.Visible = false
        end
    end
    TopBar.Visible = true
end)

-- Maximizar
MaxBtn.MouseButton1Click:Connect(function()
    contentVisible = true
    for _, obj in pairs(Frame:GetChildren()) do
        obj.Visible = true
    end
end)


-- Fechar
CloseBtn.MouseButton1Click:Connect(function()
    MainGui:Destroy()
end)


-- Caixa de texto para digitar o nome do jogador
local PlayerNameBox = Instance.new("TextBox", Frame)
PlayerNameBox.Size = UDim2.new(0, 200, 0, 25)
PlayerNameBox.Position = UDim2.new(0, 10, 0, 65)
PlayerNameBox.PlaceholderText = "Digite o nome do jogador..."
PlayerNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerNameBox.TextColor3 = Color3.new(1, 1, 1)

-- Botão para verificar jogador
local VerifyBtn = Instance.new("TextButton", Frame)
VerifyBtn.Size = UDim2.new(0, 100, 0, 25)
VerifyBtn.Position = UDim2.new(0, 220, 0, 65)
VerifyBtn.Text = "Verificar"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)

-- Label de resultado
local ResultLabel = Instance.new("TextLabel", Frame)
ResultLabel.Size = UDim2.new(0, 380, 0, 25)
ResultLabel.Position = UDim2.new(0, 10, 0, 95)
ResultLabel.BackgroundTransparency = 1
ResultLabel.TextColor3 = Color3.new(1, 1, 1)
ResultLabel.Text = ""

VerifyBtn.MouseButton1Click:Connect(function()
    local name = PlayerNameBox.Text
    local found = Players:FindFirstChild(name)
    if found then
        SelectedPlayer = found
        ResultLabel.Text = "✅ Jogador encontrado: " .. found.Name
    else
        ResultLabel.Text = "❌ Jogador '" .. name .. "' não encontrado no servidor."
    end
end)

-- Campo para procurar jogador manualmente

    ScrollFrame:ClearAllChildren()
    local y = 0
    for _, player in ipairs(Players:GetPlayers()) do
        local Btn = Instance.new("TextButton", ScrollFrame)
        Btn.Size = UDim2.new(1, -10, 0, 30)
        Btn.Position = UDim2.new(0, 5, 0, y)
        Btn.Text = player.Name
        Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        y = y + 35
    end
end

UpdatePlayerList()

-- Substituído por sistema de busca manual
-- Remove botão antigo
-- local UpdateBtn = Instance.new("TextButton", Frame)
UpdateBtn.Size = UDim2.new(0, 150, 0, 25)
UpdateBtn.Position = UDim2.new(0, 10, 1, -30)
UpdateBtn.Text = "Atualizar Lista de Players"
UpdateBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
UpdateBtn.TextColor3 = Color3.new(1, 1, 1)

UpdateBtn.MouseButton1Click:Connect(UpdatePlayerList)


-- Funções reais aplicáveis aos jogadores
local SelectedPlayer = nil

-- Seleção de player ao clicar no botão na lista
local function SelectPlayer(name)
    for _, btn in ipairs(ScrollFrame:GetChildren()) do
        if btn:IsA("TextButton") and btn.Text == name then
            SelectedPlayer = Players:FindFirstChild(name)
        end
    end
end

for _, btn in ipairs(ScrollFrame:GetChildren()) do
    if btn:IsA("TextButton") then
        btn.MouseButton1Click:Connect(function()
            SelectPlayer(btn.Text)
        end)
    end
end

-- Criação dos botões de comandos
local CommandNames = {
    "Explode", "KillItem", "Kill", "Jail", "Freeze", "Unfreeze", "Crash",
    "Kick", "Ban", "Fling", "MsgControl", "Control", "Message", "RemoveItems"
}

local CommandFunctions = {}

-- Explode o player
CommandFunctions["Explode"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        local exp = Instance.new("Explosion")
        exp.Position = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart").Position
        exp.BlastRadius = 10
        exp.BlastPressure = 500000
        exp.Parent = workspace
    end
end

-- KillItem: envia player ao void usando parte
CommandFunctions["KillItem"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        local part = Instance.new("Part", workspace)
        part.Anchored = true
        part.Position = Vector3.new(0, -500, 0)
        SelectedPlayer.Character:MoveTo(part.Position)
    end
end

-- Kill: reseta o player
CommandFunctions["Kill"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        SelectedPlayer.Character:BreakJoints()
    end
end

-- Jail: prende o player num cubo azul transparente
CommandFunctions["Jail"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        local jail = Instance.new("Part", workspace)
        jail.Name = "Jail_" .. SelectedPlayer.Name
        jail.Anchored = true
        jail.Size = Vector3.new(6, 10, 6)
        jail.Position = SelectedPlayer.Character.HumanoidRootPart.Position
        jail.Color = Color3.fromRGB(0, 100, 255)
        jail.Transparency = 0.5
        local weld = Instance.new("WeldConstraint", jail)
        weld.Part0 = jail
        weld.Part1 = SelectedPlayer.Character.HumanoidRootPart

        SelectedPlayer.CharacterAdded:Connect(function(char)
            char:WaitForChild("HumanoidRootPart").CFrame = jail.CFrame
        end)
    end
end

-- Freeze player (remove movimentação)
CommandFunctions["Freeze"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        local hrp = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
        end
    end
end

-- Unfreeze
CommandFunctions["Unfreeze"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        local hrp = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = false
        end
    end
end

-- Crash (trava o jogador com spam de mensagens)
CommandFunctions["Crash"] = function()
    if SelectedPlayer then
        for i = 1, 100 do
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                string.rep("💥", 50),
                "All"
            )
            wait(0.05)
        end
    end
end

-- Kick
CommandFunctions["Kick"] = function()
    if SelectedPlayer then
        SelectedPlayer:Kick("Hahaha Se-Fud3u")
    end
end

-- Ban temporário (kick + tag)
CommandFunctions["Ban"] = function()
    if SelectedPlayer then
        local banTag = Instance.new("BoolValue", ReplicatedStorage)
        banTag.Name = "BANNED_" .. SelectedPlayer.UserId
        SelectedPlayer:Kick("Banido por 1 minuto.")
        delay(60, function()
            if ReplicatedStorage:FindFirstChild(banTag.Name) then
                ReplicatedStorage[banTag.Name]:Destroy()
            end
        end)
    end
end

-- Fling
CommandFunctions["Fling"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        local hrp = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 1000, 0)
        end
    end
end

-- MsgControl (simular chat do player)
CommandFunctions["MsgControl"] = function()
    if SelectedPlayer then
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
            "[Controlado] Isso foi digitado por mim.",
            "All"
        )
    end
end

-- Control (move o jogador controlado junto com você)
CommandFunctions["Control"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        local char = SelectedPlayer.Character
        while wait() do
            if not SelectedPlayer.Character then break end
            char:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
        end
    end
end

-- Message na tela do jogador
CommandFunctions["Message"] = function()
    if SelectedPlayer then
        local m = Instance.new("Message", SelectedPlayer:WaitForChild("PlayerGui"))
        m.Text = "Você foi pego pelo ADM!"
        wait(3)
        m:Destroy()
    end
end

-- Remove items
CommandFunctions["RemoveItems"] = function()
    if SelectedPlayer and SelectedPlayer.Character then
        for _, v in pairs(SelectedPlayer.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Tool") then
                v:Destroy()
            end
        end
    end
end

-- Criar os botões dos comandos no Frame principal
local y = 0
for _, cmd in ipairs(CommandNames) do
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = ";"..cmd
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1, 1, 1)
    y = y + 35

    btn.MouseButton1Click:Connect(function()
        if CommandFunctions[cmd] then
            CommandFunctions[cmd]()
        end
    end)
end
