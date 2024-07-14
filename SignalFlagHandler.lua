-- External
local CollectionService = game:GetService("CollectionService")
local Maid = require(game:GetService("ServerScriptService").FederalsSystems.Utils:WaitForChild("Maid"))
local GetFlagData = game:GetService("ReplicatedStorage").FederalsSystems.Remotes:WaitForChild("GetFlagData")
local Flags = require(script.Flags)

----------------------------------------------

local function giveUI(signalFlags)
	local prompt = signalFlags.PromptPart.ProximityPrompt
	local firstMaid = Maid.new()
	local secondMaid = Maid.new()
	local currentIndices = {69, 69, 69, 69, 69}
	
	firstMaid:GiveTask(prompt.Triggered:Connect(function(player)
		if not player.PlayerGui:FindFirstChild("FlagUI") then
			local UI = script.FlagUI:Clone()
			UI.Frame.Flag1.Text = Flags[currentIndices[1]][1]
			UI.Frame.Flag2.Text = Flags[currentIndices[2]][1]
			UI.Frame.Flag3.Text = Flags[currentIndices[3]][1]
			UI.Frame.Flag4.Text = Flags[currentIndices[4]][1]
			UI.Frame.Flag5.Text = Flags[currentIndices[5]][1]
			UI.Parent = player.PlayerGui
			
			secondMaid:GiveTask(UI.Frame.Set.MouseButton1Click:Connect(function()
				GetFlagData:FireClient(player, Flags, signalFlags)
				
				local connection
				
				connection = GetFlagData.OnServerEvent:Connect(function(eventCaller, receivedSignalFlags, flagIndices)
					if receivedSignalFlags == signalFlags and eventCaller == player then
						currentIndices = flagIndices

						print(
							player.Name .. " has changed " .. signalFlags.Name .. " to display " 
								.. Flags[currentIndices[1]][1] .. Flags[currentIndices[2]][1] 
								.. Flags[currentIndices[3]][1] .. Flags[currentIndices[4]][1]
								.. Flags[currentIndices[5]][1]
						)
						
						if currentIndices[1] ~= "" then
							signalFlags.Flag1.FlagPort.Texture = Flags[currentIndices[1]][2]
							signalFlags.Flag1.FlagStbd.Texture = Flags[currentIndices[1]][3]
						end
						
						if currentIndices[2] ~= "" then
							signalFlags.Flag2.FlagPort.Texture = Flags[currentIndices[2]][2]
							signalFlags.Flag2.FlagStbd.Texture = Flags[currentIndices[2]][3]
						end
						
						if currentIndices[3] ~= "" then
							signalFlags.Flag3.FlagPort.Texture = Flags[currentIndices[3]][2]
							signalFlags.Flag3.FlagStbd.Texture = Flags[currentIndices[3]][3]
						end
						
						if currentIndices[4] ~= "" then
							signalFlags.Flag4.FlagPort.Texture = Flags[currentIndices[4]][2]
							signalFlags.Flag4.FlagStbd.Texture = Flags[currentIndices[4]][3]
						end
						
						if currentIndices[5] ~= "" then
							signalFlags.Flag5.FlagPort.Texture = Flags[currentIndices[5]][2]
							signalFlags.Flag5.FlagStbd.Texture = Flags[currentIndices[5]][3]
						end
						
						connection:Disconnect()
					end
				end)
				
				--secondMaid:Destroy()
				UI:Destroy()
			end))
			
			secondMaid:GiveTask(UI.Frame.Clear.MouseButton1Click:Connect(function()
				currentIndices = {69, 69, 69, 69, 69}
				
				signalFlags.Flag1.FlagPort.Texture = ""
				signalFlags.Flag1.FlagStbd.Texture = ""
				
				signalFlags.Flag2.FlagPort.Texture = ""
				signalFlags.Flag2.FlagStbd.Texture = ""
				
				signalFlags.Flag3.FlagPort.Texture = ""
				signalFlags.Flag3.FlagStbd.Texture = ""
				
				signalFlags.Flag4.FlagPort.Texture = ""
				signalFlags.Flag4.FlagStbd.Texture = ""
				
				signalFlags.Flag5.FlagPort.Texture = ""
				signalFlags.Flag5.FlagStbd.Texture = ""
				
				print(player.Name .. " has cleared " .. signalFlags.Name)
				UI:Destroy()
			end))
			
			secondMaid:GiveTask(UI.Frame.Exit.MouseButton1Click:Connect(function()
				print(player.Name .. " has exited " .. signalFlags.Name)
				UI:Destroy()
			end))
		end
	end))
	
	firstMaid:GiveTask(CollectionService:GetInstanceRemovedSignal("FedsSignalFlag"):Connect(function()
		print("Signal flags cleaned up")
		firstMaid:Destroy()
		secondMaid:Destroy()
	end))
end

CollectionService:GetInstanceAddedSignal("FedsSignalFlag"):Connect(function(instance) 
	giveUI(instance) 
end)
