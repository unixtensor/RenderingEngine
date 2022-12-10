local Screen = script.Parent:WaitForChild("Screen")
local _2D_Render = script.Parent:WaitForChild("2D_Render")
local _3D_Render = script.Parent:WaitForChild("3D_Render")
local MakeCube = script.Parent:WaitForChild("MakeCube")
local MakeSquare = script.Parent:WaitForChild("MakeSquare")
local RemoveRender = script.Parent:WaitForChild("RemoveRender")
local RenderRotate = script.Parent:WaitForChild("RenderRotate")
local RenderRotateAnimate = script.Parent:WaitForChild("RenderRotateAnimate")
local Frame = script.Parent:WaitForChild("Frame")
local SpinRate = script.Parent:WaitForChild("SpinRate")
local SpinDelta = script.Parent:WaitForChild("SpinDelta")
local Shadows = script.Parent:WaitForChild("Shadows")
local Brightness = script.Parent:WaitForChild("Brightness")
local SpinDivision = script.Parent:WaitForChild("SpinDivision")
local ColorField = script.Parent.Color

local Render = require(script:WaitForChild("Render"))
local Color = {r=255,g=0,b=0}
local Spin = false
local Spin_Rate = 0.01
local Spin_Delta = 5
local Spin_Division = 0
local _Shadows = false
local Dark = false
local Frames, Cal, COLOR_LERP

local max, min = math.max, math.min

local function E_clamp(n1, n2, n3) --Error-less clamp
	return max(n1, min(n2, n3))
end

local function ReColor()

end

_3D_Render.MouseButton1Click:Connect(function()
	local Screen = Render.new(Screen.void, Color)
	local Object = Screen:Cube()
	Frames = Object.Frames
	Cal = Object.Cal
	COLOR_LERP = Object.COLOR_LERP
end)
ColorField.FocusLost:Connect(function()
	local s = ColorField.Text:split(",")
	if s then
		Color.r = tonumber(s[1])
		Color.g = tonumber(s[2])
		Color.b = tonumber(s[3])
	end
end)
SpinRate.FocusLost:Connect(function()
	Spin_Rate = tonumber(SpinRate.Text) or Spin_Rate
end)
SpinDelta.FocusLost:Connect(function()
	Spin_Delta = tonumber(SpinDelta.Text) or Spin_Delta
end)
Shadows.MouseButton1Click:Connect(function()
	_Shadows = not _Shadows
	if _Shadows then
		for i = 1, Cal do
			local c = E_clamp(0,i/COLOR_LERP,255)
			for f = 1, #Frames do
				Frames[f].BackgroundColor3 = Color3.new(
					Color.r~=0 and c/255 or 0,
					Color.g~=0 and c/255 or 0,
					Color.b~=0 and c/255 or 0
				)
			end
		end
		Shadows.Text = '[Shadows]'
	else
		for i = 1, Cal do
			local c = E_clamp(0,i/COLOR_LERP,255)
			for f = 1, #Frames do
				Frames[f].BackgroundColor3 = Color3.new(
					Color.r~=0 and c/255 or 0,
					Color.g~=0 and c/255 or 0,
					Color.b~=0 and c/255 or 0
				)
			end
		end
		Shadows.Text = 'Shadows'
	end
end)
RemoveRender.MouseButton1Click:Connect(function()
	Screen.void.Bin:Destroy()
	Frames = nil
end)
RenderRotate.MouseButton1Click:Connect(function()
	for i = 1, #Frames do
		Frame.Text = 'Frame: ' .. tostring(i)
		for r = 1, 30 do
			Frames[i].Rotation += r/Spin_Delta
		end
	end
end)
SpinDivision.FocusLost:Connect(function()
	Spin_Division = tonumber(SpinDelta.Text) or Spin_Division
end)
RenderRotateAnimate.MouseButton1Click:Connect(function()
	Spin = not Spin
	if Spin then
		RenderRotateAnimate.Text = '[Spin (Animated)]'
		while true do
			if not Spin then
				RenderRotateAnimate.Text = 'Spin (Animated)'
				break
			end
			for i = 1, #Frames do
				Frame.Text = 'Frame: ' .. tostring(i)
				for r = 1, 30 do
					Frames[i].Rotation += r/Spin_Delta
				end
				if Spin_Division ~= 0 then
					task.wait(Spin_Division/1e10)
				end
			end
			task.wait(Spin_Rate)
		end
	end
end)
Brightness.MouseButton1Click:Connect(function()
	Dark = not Dark
	if Dark then
		Screen.void.BackgroundColor3 = Color3.new(0,0,0)
		Brightness.Text = 'Dark'
	else
		Screen.void.BackgroundColor3 = Color3.new(1,1,1)
		Brightness.Text = 'Light'
	end
end)