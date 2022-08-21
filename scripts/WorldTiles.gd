extends Node

var Mercator = preload("res://scripts/proj/Mercator.gd")
var TileNode = preload("res://assets/Tile.tscn")

# center latlng
export var latlng = Vector2(32.6141, 114.34411);
export var zoom = 13

# center mercator pos and tilecoord
var centerWorldPos;
var centerWorldTileCoord;
var mercatorTool = Mercator.new()

var currentTileCoords = [];

# TOTAL tile count each side
const TILE_COUNT_EACH_SIDE = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTileCoords = cal_current_tiles();
	
	print (currentTileCoords)
	
	check_and_add_tiles();
	

func check_and_add_tiles():
	for tileCoord in currentTileCoords:
		
		var tile = TileNode.instance()
		
		var o_x = (tileCoord.x - centerWorldTileCoord.x) * tile.scale.x / 2;
		var o_y = (tileCoord.y - centerWorldTileCoord.y) * tile.scale.z / 2;
		tile.tile_coord = tileCoord;
		tile.translation = Vector3(o_x, 0, o_y);
		
		add_child(tile)


func cal_current_tiles():
	var tileCoords = []
	centerWorldPos = mercatorTool.latLng2WebMercator(latlng)
	centerWorldTileCoord = mercatorTool.webMercator2TileCoord(centerWorldPos, zoom);
	print ("center tilecoord:")
	print (centerWorldTileCoord)

	for i in range(TILE_COUNT_EACH_SIDE):
		for j in range(TILE_COUNT_EACH_SIDE):
			var offset = Vector3(i - 1, j - 1, 0);
			tileCoords.append(centerWorldTileCoord + offset);
	
	return tileCoords;
	
