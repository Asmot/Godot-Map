extends Node

var Mercator = preload("res://scripts/proj/Mercator.gd")
var TileNode = preload("res://assets/Tile.tscn")

# center latlng
export var latlng = Vector2(39, 116);
export var zoom = 10;

# center mercator pos and tilecoord
var centerWorldPos;
var centerWorldTileCoord;
var mercatorTool = Mercator.new()

var currentTileCoords = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTileCoords = cal_current_tiles();
	
	print (currentTileCoords)
	
	var tile = TileNode.instance()
	tile.tile_coord = centerWorldTileCoord;
	
	add_child(tile)
	
	


func cal_current_tiles():
	var tileCoords = []
	centerWorldPos = mercatorTool.latLng2WebMercator(latlng)
	centerWorldTileCoord = mercatorTool.webMercator2TileCoord(centerWorldPos, zoom);
	print ("center tilecoord:")
	print (centerWorldTileCoord)
	
	for i in range(2):
		for j in range(2):
			var offset = Vector3(i - 1, j - 1, 0);
			tileCoords.append(centerWorldTileCoord + offset);
	
	return tileCoords;
	
