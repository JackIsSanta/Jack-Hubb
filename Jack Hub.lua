local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Mouse = LocalPlayer:GetMouse()

local WorldToScreenPoint = Camera.WorldToScreenPoint
local GetPlayers = Players.GetPlayers
local FindFirstChild = game.FindFirstChild

local function GetOnScreenPosition(V3)
	local Position, IsVisible = WorldToScreenPoint(Camera, V3)
	return Vector2.new(Position.X, Position.Y), IsVisible
end

local function GetDirection(Origin, Position)
    return (Position - Origin).Unit * (Origin - Position).Magnitude
end

local function GetMousePosition()
    return Vector2.new(Mouse.X, Mouse.Y)
end

local function GetClosestPlayer()
	local Closest, Distance = nil, 10000

	for _, Player in next, GetPlayers(Players) do
		if Player ~= LocalPlayer then
			local Character = Player.Character
			local Head = Character and FindFirstChild(Character, "Head")
			local Humanoid = Character and FindFirstChild(Character, "Humanoid")
			if Head and (Humanoid and Humanoid.Health > 0) then
				local ScreenPos, IsVisible = GetOnScreenPosition(Head.Position)
				if IsVisible then
					local _Distance = (GetMousePosition() - ScreenPos).Magnitude
					if _Distance <= Distance then
						Closest = Head
						Distance = _Distance
					end
				end
			end
		end
	end

	return Closest, Distance
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(...)
	local Method = getnamecallmethod()
	local Arguments = {...}

	if Arguments[1] == workspace and Method == "Raycast" then
		if typeof(Arguments[#Arguments]) ~= "RaycastParams" then
			return oldNamecall(...)
		end

		local HitPart = GetClosestPlayer()

		if HitPart then
			Arguments[3] = GetDirection(Arguments[2], HitPart.Position)
			return oldNamecall(unpack(Arguments))
		end
	end

	return oldNamecall(...)
end)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = tostring("Jack Hub"), HidePremium = true, SaveConfig = false})

local Tab = Window:MakeTab({
        Name = "Esp+SilentAim",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
})

getgenv().cham = false


getgenv().esp_loaded = false
getgenv().Visibility = false


Tab:AddToggle({
    Name = "Visual",
    Default = getgenv().Visibility,
    Callback = function(Value)
        if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
        getgenv().Visibility = Value
    end   
})

Tab:AddToggle({
    Name = "Chams",
    Default = getgenv().Visibility,
    Callback = function(Value)
        if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
        getgenv().cham = Value
    end   
})


function SendNote(message : string, time)
    OrionLib:MakeNotification({
        Name = "Title!",
        Content = message,
        Image = "rbxassetid://4483345998",
        Time = time or 3
    })
end



local orionion = game:GetService("CoreGui"):FindFirstChild("Orion")



OrionLib:Init()