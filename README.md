local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,300)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Players"
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.TextColor3 = Color3.new(1,1,1)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0,0,0,30)
scroll.Size = UDim2.new(1,0,1,-30)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,4)

-------------------------------------------------
-- PEGAR CAMINHÃO
-------------------------------------------------

local function getTruck()

	for _,v in pairs(workspace:GetDescendants()) do
		if v.Name == "Caminhao de Lixo" then
			return v
		end
	end

end

-------------------------------------------------
-- PEGAR SEATS
-------------------------------------------------

local function getAnimSeats(truck)

	local seats = {}

	for _,v in pairs(truck:GetDescendants()) do
		if v:IsA("Seat") and string.find(v.Name,"AnimatieSeat") then
			table.insert(seats,v)
		end
	end

	return seats

end

-------------------------------------------------
-- SENTAR
-------------------------------------------------

local function sitSeat(seat)

	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")

	if not hum or not hrp then return end

	hrp.CFrame = seat.CFrame + Vector3.new(0,2,0)

	task.wait()

	seat:Sit(hum)

end

-------------------------------------------------
-- SISTEMA PRINCIPAL
-------------------------------------------------

local function pullPlayer(target)

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local originalPos = hrp.CFrame

	local truck = getTruck()
	if not truck then return end

	local seats = getAnimSeats(truck)
	if #seats < 2 then return end

	local mySeat = seats[1]
	local targetSeat = seats[2]

	-------------------------------------------------
	-- SENTAR
	-------------------------------------------------

	sitSeat(mySeat)

	-------------------------------------------------
	-- DESANCORAR
	-------------------------------------------------

	for _,v in pairs(truck:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = false
		end
	end

	-------------------------------------------------
	-- MOVER CAMINHÃO
	-------------------------------------------------

	local connection

	connection = RunService.Heartbeat:Connect(function()

		if not target.Character then return end

		local thrp = target.Character:FindFirstChild("HumanoidRootPart")
		if not thrp then return end

		-- teleporta caminhão
		truck:PivotTo(thrp.CFrame)

		-- passa seat no player
		targetSeat.CFrame = thrp.CFrame

		-- verifica se sentou
		local hum = target.Character:FindFirstChildOfClass("Humanoid")

		if hum and hum.SeatPart == targetSeat then

			connection:Disconnect()

			task.wait(0.2)

			truck:PivotTo(originalPos)

		end

	end)

end

-------------------------------------------------
-- LISTA PLAYERS
-------------------------------------------------

local function updateList()

	for _,v in pairs(scroll:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	for _,plr in pairs(Players:GetPlayers()) do

		if plr ~= player then

			local button = Instance.new("TextButton")
			button.Parent = scroll
			button.Size = UDim2.new(1,-5,0,30)
			button.Text = plr.Name
			button.BackgroundColor3 = Color3.fromRGB(60,60,60)
			button.TextColor3 = Color3.new(1,1,1)

			button.MouseButton1Click:Connect(function()

				pullPlayer(plr)

			end)

		end

	end

	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 5)

end

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

updateList()
