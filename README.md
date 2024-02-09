# Map Changer API
A small pack of functions for server-side lua that helps to change server map.

## Config
The addon has a configuration file where you can specify a blacklist of maps and a map to start the server with, which will be immediately replaced with a random map when the server starts.

## Functions
- game.ChangeMap( `string` mapName )
- `table` `number` game.GetMaps()
- `boolean` game.SelectRandomMap()
