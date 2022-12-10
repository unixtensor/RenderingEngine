local Renderer = {}
Renderer.__index = Renderer

local max, abs, floor, min = math.max, math.abs, math.floor, math.min
local insert = table.insert

local function MakePixel(w, h, dpi)
	local h, l = max(w+h)+.0, .0
	while abs(h-l)>1e-6 do
		local mid = (l+h)/2.0
		local midval = floor(w/mid)*floor(h/mid)
		if midval>=dpi then
			l=mid
		elseif midval<dpi then
			h=mid
		end
	end
	return min(w/floor(w/l), h/floor(h/l))
end
local function E_clamp(n1, n2, n3) --Error-less clamp
	return max(n1, min(n2, n3))
end

function Renderer.new(Parent, COLOR, DPI, SCALE, DENSITY, SHIFT_FACTOR)
	local self = {}
	self.Parent = Parent
	self.COLOR = COLOR or {r=255,g=0,b=0}
	self.DPI = DPI or 10 --how many pixels (more = further/zoom, also more color space)
	self.SCALE = SCALE or 30
	self.DENSITY = DENSITY or .1 --how much detail
	self.SHIFT_FACTOR = SHIFT_FACTOR or 5 --the size of 3D (can be dangerous depending on DPI,)
	self.COLOR_LERP = self.SCALE/(self.DPI-self.SHIFT_FACTOR/2) --(lower = starts off darker)
	return setmetatable(self, Renderer)
end

function Renderer:Cube()
	local Size = {x = 2000, y = 2000}
	local Pos = {x = 50, y = 100}
	local Cal = floor((Size.y/(MakePixel(Size.x, Size.y, self.DPI))*self.SCALE)*self.SHIFT_FACTOR)
	local Frames = {}

	local Bin = Instance.new("Folder", self.Parent)
	Bin.Name = "Bin"
	for i = 1, Cal do
		local c = E_clamp(0,i/self.COLOR_LERP,255)
		local S = MakePixel(Size.x, Size.y, self.DPI)
		local Frame = Instance.new("Frame", Bin)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.fromOffset(S,S)
		Frame.BackgroundColor3 = Color3.new(
			self.COLOR.r~=0 and c/255 or 0,
			self.COLOR.g~=0 and c/255 or 0,
			self.COLOR.b~=0 and c/255 or 0
		)
		Frame.Position = UDim2.fromOffset(Pos.x+(S+i)*self.DENSITY,Pos.y+(S+i)*self.DENSITY)
		insert(Frames, Frame)
	end
	return {Frames=Frames, Cal=Cal, COLOR_LERP=self.COLOR_LERP}
end

return Renderer