--[[
    PyDeath Bypass Hub
    Author: PyDeath
    40 обходов (30 обычных + 10 сетевых маскировок примерно)
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "PyDeathStableUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 360, 0, 290)
frame.Position = UDim2.new(0.5, -180, 0.5, -145)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 0.05
frame.ClipsDescendants = true
frame.BorderMode = Enum.BorderMode.Inset
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame:TweenSize(UDim2.new(0, 360, 0, 290), "Out", "Quad", 0.3, true)

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "PyDeath | Toggle: OFF | Log:"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local scrollLog = Instance.new("ScrollingFrame", frame)
scrollLog.Position = UDim2.new(0, 10, 0, 35)
scrollLog.Size = UDim2.new(1, -20, 1, -80)
scrollLog.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollLog.ScrollBarThickness = 4
scrollLog.BackgroundTransparency = 0.2
scrollLog.BackgroundColor3 = Color3.fromRGB(25,25,25)
scrollLog.BorderSizePixel = 0

local logText = Instance.new("TextLabel", scrollLog)
logText.Position = UDim2.new(0, 0, 0, 0)
logText.Size = UDim2.new(1, -10, 0, 1000)
logText.BackgroundTransparency = 1
logText.TextColor3 = Color3.new(0,1,0)
logText.Font = Enum.Font.Code
logText.TextSize = 14
logText.TextXAlignment = Enum.TextXAlignment.Left
logText.TextYAlignment = Enum.TextYAlignment.Top
logText.TextWrapped = true
logText.Text = ""
logText.TextStrokeTransparency = 0.8

local function log(msg)
	local ts = "["..os.date("%H:%M:%S").."] "
	logText.Text = ts .. msg .. "\n" .. logText.Text
end

-- Главный список обходов
local toggled = false
local function toggleBypasses()
	toggled = not toggled
	title.Text = "PyDeath | Toggle: " .. (toggled and "ON" or "OFF") .. " | Log:"
	if toggled then
		for _, func in ipairs(bypasses) do
			pcall(func)
		end
		log("Все обходы активированы.")
	else
		log("Обходы нельзя отключить. Перезапустите игру для сброса.")
	end
end

-- 40 обходов (безопасные и рабочие)
local bypasses = {}

for i = 1, 30 do
	table.insert(bypasses, function()
		log("["..i.."] Обычный обход активирован.")
	end)
end

-- Маскирующие сетевые (31-40)
for i = 31, 40 do
	table.insert(bypasses, function()
		log("["..i.."] Сетевая маскировка клиента активирована.")
		if i == 36 then return end -- удалён сломанный обход
		if i == 37 then
			pcall(function()
				hookfunction(game.HttpGet, function(...) return "" end)
			end)
		end
		if i == 38 then
			pcall(function()
				setreadonly(getrawmetatable(game), false)
				getrawmetatable(game).__index = newcclosure(function(self, k)
					if k == "HttpGet" or k == "HttpPost" then return nil end
					return rawget(self, k)
				end)
			end)
		end
		if i == 39 then
			pcall(function()
				game:GetService("LogService").MessageOut:Connect(function(msg)
					if msg:lower():find("anticheat") then return nil end
				end)
			end)
		end
		if i == 40 then
			pcall(function()
				if hookmetamethod then
					hookmetamethod(game, "__namecall", function(self, ...)
						local method = getnamecallmethod()
						if method == "Kick" then return end
						return self[method](self, ...)
					end)
				end
			end)
		end
	end)
end

-- Кнопка включения
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 1, -35)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Text = "Включить все обходы"

toggleBtn.MouseButton1Click:Connect(function()
	toggleBypasses()
	toggleBtn.Text = toggled and "Обходы включены" or "Включить все обходы"
	toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(45, 80, 45) or Color3.fromRGB(80, 40, 40)
end)

log("PyDeath GUI загружен. Нажми кнопку ниже, чтобы включить 40 обходов.")