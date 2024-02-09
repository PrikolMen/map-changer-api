local config = {
	["start-map"] = "gm_construct",
	["blacklist"] = { }
}
do
	if not file.Exists("map-changer-api.json", "DATA") then
		file.Write("map-changer-api.json", util.TableToJSON(config, true))
	end
	local json = file.Read("map-changer-api.json", "DATA")
	if json ~= nil then
		local data = util.JSONToTable(json)
		if data ~= nil then
			table.Merge(config, data)
		end
	end
end
game.ChangeMap = function(mapName)
	return RunConsoleCommand("changelevel", mapName)
end
local blacklist = config.blacklist
if istable(blacklist) then
	for _index_0 = 1, #blacklist do
		local mapName = blacklist[_index_0]
		blacklist[mapName] = true
	end
else
	blacklist = { }
end
local maps, mapCount = { }, 0
do
	local _list_0 = file.Find("maps/*.bsp", "GAME")
	for _index_0 = 1, #_list_0 do
		local fileName = _list_0[_index_0]
		mapCount = mapCount + 1
		maps[mapCount] = fileName:match("(.+).bsp")
	end
end
game.GetMaps = function()
	return maps, mapCount
end
local startMap = config["start-map"]
local random = math.random
game.SelectRandomMap = function()
	if mapCount == 0 then
		return false
	end
	if mapCount == 1 then
		local mapName = maps[1]
		if blacklist[mapName] ~= nil or mapName == startMap then
			return false
		end
		game.ChangeMap(mapName)
		return true
	end
	for i = 1, mapCount do
		local mapName = maps[random(1, mapCount)]
		if blacklist[mapName] == nil and mapName ~= startMap then
			game.ChangeMap(mapName)
			return true
		end
	end
	return false
end
return timer.Simple(0, function()
	if game.GetMap() == startMap then
		return game.SelectRandomMap()
	end
end)
