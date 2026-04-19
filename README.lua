local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function createESP(target)
	if target == player then return end
	
	local function addBillboard(char)
		if char:FindFirstChild("Head") then
			if char.Head:FindFirstChild("ESP") then return end
			
			local billboard = Instance.new("BillboardGui")
			billboard.Name = "ESP"
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.AlwaysOnTop = true
			billboard.Adornee = char.Head
			billboard.Parent = char.Head
			
			local text = Instance.new("TextLabel")
			text.Size = UDim2.new(1, 0, 1, 0)
			text.BackgroundTransparency = 1
			text.Text = target.Name
			text.TextColor3 = Color3.fromRGB(0, 255, 0)
			text.TextStrokeTransparency = 0
			text.TextScaled = true
			text.Parent = billboard
		end
	end
	
	if target.Character then
		addBillboard(target.Character)
	end
	
	target.CharacterAdded:Connect(function(char)
		task.wait(1)
		addBillboard(char)
	end)
end

for _, p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(function(p)
	createESP(p)
end)
