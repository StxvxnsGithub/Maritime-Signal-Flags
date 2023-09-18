-- External
local GetFlagData = game:GetService("ReplicatedStorage").FederalsSystems.Remotes:WaitForChild("GetFlagData")
local flagIndices = {69, 69, 69, 69, 69}

----------------------------------------------

function checkRepeat(repeatToCheck, flagNumber)
	local newIndex = repeatToCheck
	
	for index = 1, flagNumber do
		if flagIndices[index] == newIndex then
			newIndex = index
		end
		--print("Loop " .. index .. " " .. flagIndices[index])
	end
	
	if newIndex ~= repeatToCheck then
		return newIndex
	end

	return repeatToCheck
end

function getFlagIndex(Flags, flagText, flagNumber) 
	for i, flag in Flags do
		if string.lower(string.sub(flagText, 1, 2)) == string.lower(string.sub(flag[1], 1, 2)) then
			for index = 1, flagNumber do
				--print(flagIndex .. " " .. i)
				if flagIndices[index] == i then
					return checkRepeat(index, flagNumber) -- i will be the flag position to repeat
				end
			end
			
			return i
		end
	end
	
	return 69
end

GetFlagData.OnClientEvent:Connect(function(Flags, signalFlags)
	local flag1Text = script.Parent.Frame.Flag1.Text
	local flag2Text = script.Parent.Frame.Flag2.Text
	local flag3Text = script.Parent.Frame.Flag3.Text
	local flag4Text = script.Parent.Frame.Flag4.Text
	local flag5Text = script.Parent.Frame.Flag5.Text
	
	--for i = 1, 4 do
	--	print(i)
	--end
	
	if flag1Text ~= "" then
		flagIndices = {getFlagIndex(Flags, flag1Text, 1), flagIndices[2], flagIndices[3], flagIndices[4], flagIndices[5]}
	end
	
	if flag2Text ~= "" then
		flagIndices = {flagIndices[1], getFlagIndex(Flags, flag2Text, 2), flagIndices[3], flagIndices[4], flagIndices[5]}
	end
	
	if flag3Text ~= "" then
		flagIndices = {flagIndices[1], flagIndices[2], getFlagIndex(Flags, flag3Text, 3), flagIndices[4], flagIndices[5]}
	end
	
	if flag4Text ~= "" then
		flagIndices = {flagIndices[1], flagIndices[2], flagIndices[3], getFlagIndex(Flags, flag4Text, 4), flagIndices[5]}
	end
	
	if flag5Text ~= "" then
		flagIndices = {flagIndices[1], flagIndices[2], flagIndices[3], flagIndices[4], getFlagIndex(Flags, flag5Text, 5)}
	end
	
	--print("Debug: " .. flagIndices[1] .. " " .. flagIndices[2] .. " " .. flagIndices[3] .. " " .. flagIndices[4] .. " " .. flagIndices[5])
	
	print(
		"You submitted: " 
			.. Flags[flagIndices[1]][1] .. Flags[flagIndices[2]][1] 
			.. Flags[flagIndices[3]][1] .. Flags[flagIndices[4]][1] 
			.. Flags[flagIndices[5]][1] 
			.. " to " .. signalFlags.Name
	)
	
	GetFlagData:FireServer(signalFlags, flagIndices)
end)
