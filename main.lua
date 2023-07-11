--[[
    This script is just multiple FPS Booster scripts scripted into one.

	Credits to parts of the script:
    Infinite Yield
	https://discord.gg/VtKMMKFQyY
    https://v3rmillion.net/showthread.php?tid=975134

	THE ORIGINAL FPS BOOSTER:
	https://github.com/CasperFlyModz/discord.gg-rips/blob/main/FPSBooster.lua
]]

Settings = getgenv().Settings
--------------------------------
if not game:IsLoaded() then
	game.Loaded:Wait()
end
if Settings["Disabled"] then
	return
end
--------------------------------
local oldprint = print
print = function(...)
	if not Settings.Other["Print"] then
		return
	end
	if printconsole then
		return printconsole(...)
	else
		return oldprint(...)
	end
end
--------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local NetworkSettings = settings():GetService("NetworkSettings")
local RenderSettings = settings():GetService("RenderSettings")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SetProperty = sethiddenproperty or set_hidden_property or set_hidden_prop or function(Instance, Property, Value) pcall(Closure(function() Instance[Property] = Value end)) end
local InstancesList = {"DataModelMesh", "FaceInstance", "ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles", "PostEffect", "SpotLight", "Explosion", "Clothing", "BasePart", "ForceField", "MeshPart", "Texture", "PartOperation", "UnionOperation", "Model", "NetworkClient"}
local EnabledList = {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles", "PostEffect", "SpotLight"}
local OriginalScanAmount = Settings.Scans.Amount
--------------------------------
local function PartOfCharacter(obj,lpcheck)
	if obj == nil then return end
	if lpcheck == true then
		if obj:IsDescendantOf(LocalPlayer.Character) then
			return true
		else
			return false
		end
	end
	for i, v in pairs(Players:GetPlayers()) do
		if v.Character and obj:IsDescendantOf(v.Character) then
			return true
		end
	end
	return false
end
local function returnDescendants()
	local List = {}
	local Num = 2500
	if Settings.Players["Ignore Everyone"] then
		for i,v in pairs(game:GetDescendants()) do
			if not v:IsDescendantOf(Players) and not PartOfCharacter(v) then
				for i2,v2 in pairs(InstancesList) do
					if v:IsA(v2) and v.ClassName ~= "Terrain" then
						table.insert(List, v)
					end
				end
			end
			if i == Num then
				RunService.Heartbeat:Wait()
				Num = Num + 2500
			end
		end
	elseif Settings.Players["Ignore LocalPlayer"] then
		for i,v in pairs(game:GetDescendants()) do
			if not v:IsDescendantOf(Players)  then
				for i2,v2 in pairs(InstancesList) do
					if v:IsA(v2) and v.ClassName ~= "Terrain" then
						if v:FindFirstAncestor(LocalPlayer.Name) == nil then
							table.insert(List, v)
						end
					end
				end
			end
			if i == Num then
				RunService.Heartbeat:Wait()
				Num = Num + 2500
			end
		end
	else
		for i,v in pairs(game:GetDescendants()) do
			if not v:IsDescendantOf(Players) then
				for i2,v2 in pairs(InstancesList) do
					if v:IsA(v2) and v.ClassName ~= "Terrain" then
						table.insert(List, v)
					end
				end
			end
			if i == Num then
				RunService.Heartbeat:Wait()
				Num = Num + 2500
			end
		end
	end
	return List
end
function Check(obj)
	local flagged = false
	if obj:FindFirstAncestor(LocalPlayer.Name) and Settings.Players["Ignore LocalPlayer"] then
		flagged = true
	elseif PartOfCharacter(obj) and Settings.Players["Ignore Everyone"] then
		flagged = true
	end
	if not obj:IsDescendantOf(Players) and flagged == false then
		if obj:IsA("Clothing") and Settings.Characters["No Clothes"] then
			RunService.Heartbeat:Wait()
			obj:Destroy()
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") and Settings.Main["No Particles"] then
			obj.Lifetime = NumberRange.new(0)
		elseif obj:IsA("Decal") then
			if Settings.Decals.Invisible then
				obj.Transparency = 1
			elseif Settings.Decals.Destroy then
				RunService.Heartbeat:Wait()
				obj:Destroy()
			end
		elseif obj:IsA("Model") and Settings.Main["Low Graphics"] then
			SetProperty(obj, "LevelOfDetail", 1)
		elseif obj:IsA("NetworkClient") then
			obj:SetOutgoingKBPSLimit(100)
		elseif obj:IsA("FaceInstance") then
			if Settings.Images.Destroy then
				RunService.Heartbeat:Wait()
				obj:Destroy()
			elseif Settings.Images.Invisible then
				obj.Transparency = 1
			elseif Settings.Images["Low Detail"] then
				obj.Shiny = 1
			end
		elseif obj:IsA("MeshPart") then
			obj.CollisionFidelity = "Hull"
			if Settings.Meshes.Destroy then
				RunService.Heartbeat:Wait()
				obj:Destroy()
			elseif Settings.Meshes["Remove Texture"] then
				obj.Material = "Plastic"
				obj.Reflectance = 0
				obj.TextureID = 10385902758728957
			end
		elseif obj:IsA("DataModelMesh") then
			if Settings.Meshes["Low Detail"] then
				SetProperty(obj, "LODX", Enum.LevelOfDetailSetting.Low)
				SetProperty(obj, "LODY", Enum.LevelOfDetailSetting.Low)
			elseif Settings.Meshes.Destroy then	
				RunService.Heartbeat:Wait()
				obj:Destroy()
			end
		elseif obj:IsA("Texture") then
			if Settings.Textures.Destroy then
			   	RunService.Heartbeat:Wait()
				obj:Destroy()
			elseif Settings.Textures.Invisible then
				obj.Texture = ""
			end
		elseif table.find(EnabledList,obj.ClassName) and Settings.Main["No Particles"] then
			obj.Enabled = false
		elseif obj:IsA("Explosion") and Settings.Main["No Explosions"] then
			obj.Visible = false
		elseif obj:IsA("BasePart") and Settings.Main["Low Quality Parts"] then
			obj.Material = Enum.Material.Plastic
			obj.Reflectance = 0
			if obj.ClassName == "UnionOperation" then
				obj.CollisionFidelity = "Hull"	
			end
		elseif table.find(InstancesList,obj.ClassName) then
			RunService.Heartbeat:Wait()
			obj:Destroy()
		end
	end
	return
end
function Notify(title,text,duration)
	if Settings.Other.Notification then
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = title;Text = text;Duration = duration;})
	end
end
function Scan(value)
	local Descendants = returnDescendants()
	local WaitNumber = 500
	if Settings.Scans.SlowerChecks then
	      WaitNumber = 100
	end
	Notify("FPS BOOSTER", "Scanning instances...", 3)
	
	print(#Descendants .." found.")
	if value == true then
		Notify("FPS BOOSTER", #Descendants .. " instances found! You may experience some lag...",5)
	end
	for i,v in pairs(Descendants) do
		Check(v)
		print("Checked "..i.."/"..#Descendants.." instances.")
		if i == WaitNumber then
			RunService.Heartbeat:Wait()
			if Settings.Scans.SlowerChecks then
				WaitNumber = WaitNumber + 100
			else
				WaitNumber = WaitNumber + 500
			end
		end
	end
	if value == true then
		Notify("FPS BOOSTER", "First scan completed, it might take another ".. Settings.Scans.Cooldown .." seconds for it to fully optimize!", 10)
	end
	return
end
--------------------------------
if Settings.Main["RedirectRenderSteppedToHeartbeat"] == true and hookmetamethod then
	local HeartBeat = RunService.Heartbeat
	local old 
	old = hookmetamethod(game, '__index', function(k, v) 
    		if (k == RunService and v == "RenderStepped") then
        		return HeartBeat
    		end
		return old(k, v)
	end)
end

local Terrain = workspace:FindFirstChildOfClass("Terrain")
if Settings.Main["Low Water Graphics"] and Terrain ~= nil then
	SetProperty(Terrain,"Decoration",false)
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 0
	Terrain.Elasticity = 0
end
if Settings.Main["Low Graphics"] then
	SetProperty(Lighting, "Technology", 2)
end
if Settings.Main["No Shadows"] then
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
end
if Settings.Main["Low Rendering"] and settings() then
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	settings().Rendering.EditQualityLevel = Enum.QualityLevel.Level01
	settings().Rendering.AutoFRMLevel = 1
	settings().Rendering.GraphicsMode = Enum.GraphicsMode.OpenGL
	if Settings.Main["Extreme Low Rendering"] then
        pcall(function()
            SetProperty(UserGameSettings, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
	   	    SetProperty(RenderSettings, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level01)
		    SetProperty(RenderSettings, "EagerBulkExecution", false)
		    SetProperty(NetworkSettings, "IncomingReplicationLag", -1000)
		    SetProperty(workspace, "LevelOfDetail", Enum.ModelLevelOfDetail.Disabled)
		    SetProperty(workspace, 'StreamingTargetRadius', 64)
            SetProperty(workspace, 'StreamingPauseMode', 2)
		    settings().Physics.PhysicsEnvironmentalThrottle = 1
		    workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
		    workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
        end)
	end
end
if Settings.Main["FPS Unlocker"] then
	if setfpscap and type(setfpscap) == "function" then
		setfpscap(9999)
	end
end
if Settings.Main["No Camera Effects"] then
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
			v.Enabled = false
            v.Changed:Connect(function()
                v.Enabled = false
            end)
        elseif v:IsA("Atmosphere") then
            v.Haze = 0
            v.Glare = 0
            v.Density = 0.39500001072883606
            v.Offset = 0
            v.Changed:Connect(function()
                v.Haze = 0
                v.Glare = 0
                v.Density = 0.39500001072883606
                v.Offset = 0
            end)
		end
	end
    Lighting.DescendantAdded:Connect(function(v)
        if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
			v.Enabled = false
            v.Changed:Connect(function()
                v.Enabled = false
            end)
        elseif v:IsA("Atmosphere") then
            v.Haze = 0
            v.Glare = 0
            v.Density = 0.39500001072883606
            v.Offset = 0
            v.Changed:Connect(function()
                v.Haze = 0
                v.Glare = 0
                v.Density = 0.39500001072883606
                v.Offset = 0
            end)
		end
    end)
end
if Settings.Main["Limit FPS When Unfocused"] then
	UserInputService.WindowFocused:Connect(function()
       	RunService:Set3dRenderingEnabled(true)
		if Settings.Main["FPS Unlocker"] and setfpscap and type(setfpscap) == "function" then
   			setfpscap(9999)
        elseif setfpscap and type(setfpscap) == "function" then
            setfpscap(60)
		end
	end)
	UserInputService.WindowFocusReleased:Connect(function()
       	RunService:Set3dRenderingEnabled(false)
   		if setfpscap and type(setfpscap) == "function" then
   			setfpscap(5)
		end
	end)
end
if Settings.Main["StreamingEnabled"] then
	workspace.StreamingEnabled = true
end
--------------------------------
Notify("FPS BOOSTER","Loaded Core Features!",5)
Scan(true)
print("Done with first scan, starting rescans now.")
spawn(function()
	while true do
		if Settings.Scans.Amount == 0 then
			print("Rescanning done, enjoy FPS Booster!")
			break
		end
		Scan(false)
		task.wait(Settings.Scans.Cooldown)
		Settings.Scans.Amount = Settings.Scans.Amount - 1
	end
end)
if Settings.Main["Fullbright"] then
    Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.TimeOfDay = 14
	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	Lighting.GlobalShadows = false
	Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	Lighting.Changed:Connect(function()
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.TimeOfDay = 14
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	end)
end
game.DescendantAdded:Connect(function(obj)
	if not obj:IsDescendantOf(Players) then
		Check(obj)
	end
end)
--------------------------------
