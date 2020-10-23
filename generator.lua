script.Parent = nil
local hb = game:GetService("RunService").Heartbeat
--main generation studf

CORRECTEDTIME = 0--dont edit
REALISTICSINE = 0--dont edit
WANTEDSTEP = 1/30--1/framerate, server is 30 and client is 60
ARTIFICIALRS = Instance.new("BindableEvent")

function ArtificialRsStuff(s)
	REALISTICSINE=REALISTICSINE+s
	while CORRECTEDTIME<REALISTICSINE do
		CORRECTEDTIME=CORRECTEDTIME+WANTEDSTEP
		ARTIFICIALRS:Fire()
	end
end

function sw(x)
	if type(x)~="number"then x=1 end
	for i = 1,x do
		ARTIFICIALRS.Event:Wait()
	end
end

local theyitthem = game:GetService("RunService").Heartbeat:Connect(ArtificialRsStuff)

local generation = {}
generation.__index = generation
function makepart(parent,props)
	local pt = Instance.new("FlagStand",parent)
	pt.Name = "Base"
	for i, v in next, props do
		pt[i]=v
	end
	return pt
end

local blocks = {
	grass = {col = Color3.new(0.00392157, 0.258824, 0), mat = "Grass"};
	stone = {col = Color3.new(0.427451, 0.427451, 0.427451), mat = "Granite"};
}

function generation.new(sizes)
	local noiseseed = math.random(15,75)
	local noiseseed1 = math.random(15,75)
	local noiseseed2 = math.random(15,75)
	local noiseseed3 = math.random(15,75)
	print("noiseseed is "..noiseseed.."\nnoiseseed1 is "..noiseseed1.."\nnoiseseed2 is "..noiseseed2.."\nnoiseseed3 is "..noiseseed3)
	if typeof(sizes) ~= "table" or not sizes.x or not sizes.z or not sizes.y then sizes = {x = 3, z = 3, y = 3} end
	local avgh = math.noise(sizes.x/noiseseed1, sizes.z/noiseseed1) * noiseseed + (noiseseed2/(noiseseed3/4))
	local chuk = {
		instances = {}
	}
	setmetatable(chuk, generation)
	local alignerpos = Vector3.new(-((sizes.x/2)*3), 0, -((sizes.z/2)*3))
	local finished = false
	local i1, i2, i3 = 0,0,0
	for X = 1, sizes.x do
		i2 = i2 + 1
		if i2 >= 800 then
			hb:wait()
			i2 = 0
		end
		coroutine.wrap(function()
			for z = 1, sizes.z do
				i1 = i1 + 1
				if i1 >= 800 then
					hb:wait()
					i1 = 0
				end
				local it = makepart(workspace, {Size = Vector3.new(3, 3, 3), Anchored = true, Position = alignerpos + Vector3.new(X*3, math.noise(X/noiseseed1, z/noiseseed1) * noiseseed + (noiseseed2/(noiseseed3/4)), z*3)})
				it.Material = blocks.grass.mat
				it.Color = blocks.grass.col
				coroutine.wrap(function()
					for y = 1, sizes.y do
						i3 = i3 + 1
						if i3 >= 800 then
							hb:wait()
							i3 = 0
						end
						local it1 = makepart(workspace, {Size = Vector3.new(3, 3, 3), Anchored = true, Position = it.Position-Vector3.new(0, y*3,0)})
						it1.Material = blocks.stone.mat
						it1.Color = blocks.stone.col
						table.insert(chuk.instances, it1)
					end finished = true end)()
				table.insert(chuk.instances, it)
			end finished = true end)()
	end
	repeat hb:wait() until finished
	return chuk
end
function generation:Destroy()
	local gege = 0
	for i = 1, #self.instances do
		if self.instances[i]~=nil then
		gege = gege + 1
		if gege >= 800 then
		sw()
		end
			for ind = 0, 11 do
				if self.instances[i+ind]~=nil then
				game:service'Debris':AddItem(self.instances[i+ind],0)
				self.instances[i+ind]=nil end
			end
	    end
	end
end

--the other stuff
local c = generation.new({x = 25, z = 25, y = 2})

local ssee = owner.Chatted:Connect(function(a)
	local p1 = string.split(a, ";")
	if p1[1]:find("gen") and p1[1]:find("en") and a:find(";") then
	c:Destroy()
		local p2 = string.split(p1[2], ",")
		if not p2[1] then p2={"3","3","3"}end
		if not p2[2] then local me = p2[1] p2={me,"3","3"}end
		if not p2[3] then local me,me1 = p2[1],p2[2] p2={me,me1,"3"}end
		c = generation.new({x = tonumber(p2[1]),y = tonumber(p2[2]),z = tonumber(p2[3])})
	end
end)
