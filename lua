local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

----------------------------------------------------------------
-- Main Screen GUI
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ForceDonateUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- Main Frame (Liit na size)
----------------------------------------------------------------
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 180) -- liit na
Frame.Position = UDim2.new(0.5, -140, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

-- Drag system
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

----------------------------------------------------------------
-- Title
----------------------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Force Robux Donate"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

----------------------------------------------------------------
-- Username Input
----------------------------------------------------------------
local UsernameBox = Instance.new("TextBox")
UsernameBox.Size = UDim2.new(1, -30, 0, 35)
UsernameBox.Position = UDim2.new(0, 15, 0, 40)
UsernameBox.PlaceholderText = "Enter Target Username"
UsernameBox.Text = ""
UsernameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UsernameBox.ClearTextOnFocus = false
UsernameBox.Parent = Frame
Instance.new("UICorner", UsernameBox).CornerRadius = UDim.new(0, 8)

----------------------------------------------------------------
-- Robux Amount Input
----------------------------------------------------------------
local AmountBox = Instance.new("TextBox")
AmountBox.Size = UDim2.new(1, -30, 0, 35)
AmountBox.Position = UDim2.new(0, 15, 0, 80)
AmountBox.PlaceholderText = "Enter Robux Amount"
AmountBox.Text = ""
AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AmountBox.ClearTextOnFocus = false
AmountBox.Parent = Frame
Instance.new("UICorner", AmountBox).CornerRadius = UDim.new(0, 8)

----------------------------------------------------------------
-- Force Donate Button
----------------------------------------------------------------
local DonateButton = Instance.new("TextButton")
DonateButton.Size = UDim2.new(1, -30, 0, 40)
DonateButton.Position = UDim2.new(0, 15, 0, 125)
DonateButton.Text = "Force Donate Robux"
DonateButton.TextSize = 16
DonateButton.Font = Enum.Font.GothamBold
DonateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DonateButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
DonateButton.Parent = Frame
Instance.new("UICorner", DonateButton).CornerRadius = UDim.new(0, 8)

----------------------------------------------------------------
-- Button Logic
----------------------------------------------------------------
DonateButton.MouseButton1Click:Connect(function()
	local targetPlayerName = UsernameBox.Text
	local robuxAmount = tonumber(AmountBox.Text) or 0

	print("Target:", targetPlayerName, "Robux:", robuxAmount)

	local function formatNumber(number)
		local formatted = tostring(number)
		while true do
			local formatted2 = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
			if formatted2 == formatted then break end
			formatted = formatted2
		end
		return formatted
	end

	if player.PlayerGui:FindFirstChild("UITemplates") and player.PlayerGui.UITemplates:FindFirstChild("donationPopup") then
		-- Ayusin text para lowercase lahat
		local donationText = string.lower("YOU DONATED "..formatNumber(robuxAmount).." TO "..targetPlayerName.."!")

		local ScreenGui2 = player.PlayerGui:FindFirstChild("ScreenGui")
		if not ScreenGui2 then
			ScreenGui2 = Instance.new("ScreenGui")
			ScreenGui2.Name = "ScreenGui"
			ScreenGui2.Parent = player.PlayerGui

			local popups = Instance.new("Frame")
			popups.Name = "Popups"
			popups.BackgroundTransparency = 1
			popups.Size = UDim2.new(1, 0, 1, 0)
			popups.Parent = ScreenGui2
		end

		local clone = player.PlayerGui.UITemplates.donationPopup:Clone()
		clone.Message.Text = donationText
		clone.Transparency = 1
		clone.UIScale.Scale = 0
		clone.Parent = ScreenGui2.Popups

		if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Raised") then
			player.leaderstats.Raised.Value = player.leaderstats.Raised.Value + robuxAmount
		end

		TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 0}):Play()
		TweenService:Create(clone.UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Scale = 1}):Play()
		TweenService:Create(clone.Message, TweenInfo.new(1, Enum.EasingStyle.Quint), {MaxVisibleGraphemes = #donationText}):Play()

		task.delay(4, function()
			TweenService:Create(clone, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
			TweenService:Create(clone.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 0}):Play()
			task.delay(0.5, function() clone:Destroy() end)
		end)
	end
end)
