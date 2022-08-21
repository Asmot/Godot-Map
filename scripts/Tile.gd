extends Spatial

var TerrainMaterial = preload("res://assets/tile_terrain_material.tres")

# TODO: need feat the camera height
#  change camera height to terrain height

export var tile_coord = Vector3(6743, 3105,13)
export var sourceType = 0
const URL_FORMAT = "https://webst03.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}"
const URL_FORMAT_MAPBOX = "https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}@2x.pngraw?access_token=pk.eyJ1Ijoienh5enh5IiwiYSI6ImNqNWMzYW5zczA2Y3EycXA4YnBzdTBxMHoifQ.XFCVd9cQzroE1vCoCvrixA"
const HEIGHT_MAP_URL_FORMAT_MAPBOX = "https://api.mapbox.com/v4/mapbox.terrain-rgb/{z}/{x}/{y}.pngraw?access_token=pk.eyJ1Ijoienh5enh5IiwiYSI6ImNqNWMzYW5zczA2Y3EycXA4YnBzdTBxMHoifQ.XFCVd9cQzroE1vCoCvrixA"
const TERRAIN_TILE_SIZE = 256;

func format_satellite_url():
	return URL_FORMAT_MAPBOX.format({'x':tile_coord.x, 'y':tile_coord.y, 'z':tile_coord.z })
	
func format_height_url():
	return HEIGHT_MAP_URL_FORMAT_MAPBOX.format({'x':tile_coord.x, 'y':tile_coord.y, 'z':tile_coord.z })

# Called when the node enters the scene tree for the first time.
func _ready():
	$TerrainTile/MeshInstance.material_override = TerrainMaterial
	loadTile()
	
	# for test
#	var image = Image.new()
#	image.load("res://imports/terrain.png")
#	var height_offset = getAverageTerrainHeight(image)
	

func loadTile():
	$TerrainHTTPRequest.request(format_height_url())
	$SatelliteHTTPRequest.request(format_satellite_url())
		
	print ("request %s" %(format_height_url()))
	print ("request %s" %(format_satellite_url()))
	
	
func download_to_Texture(body):
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		print ("Couldn't load the image.")
		return null;

	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture;

#tile downloaded
func _on_TileLoad_request_completed(result, response_code, headers, body):
	print ("laod complete size %s" %(str(len(body))))
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		print ("Couldn't load the image.")
		return;

	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	$MeshInstance.material_override.albedo_texture = texture
	print ("laod complete and set texture success", $MeshInstance.material_override, texture)


func _on_SatelliteHTTPRequest_request_completed(result, response_code, headers, body):
	var texture = download_to_Texture(body);
	if texture:
		$TerrainTile/MeshInstance.material_override.set_shader_param("groundTexture", texture);


func getTerrainHeight(pos: Vector2, image :Image):
	image.lock()
	var rgb = image.get_pixel(int(pos.x), int(pos.y));
	image.unlock()
	var R = rgb.r * TERRAIN_TILE_SIZE;
	var G = rgb.g * TERRAIN_TILE_SIZE;
	var B = rgb.b * TERRAIN_TILE_SIZE;
	# -10000 + ((R * 256 * 256 + G * 256 + B) * 0.1)
	return -10000.0 + ((R * TERRAIN_TILE_SIZE * TERRAIN_TILE_SIZE + G * TERRAIN_TILE_SIZE + B) * 0.1);


func getAverageTerrainHeight(image: Image):
	var cx = image.get_width() / 2;
	var cy = image.get_height() / 2;
	var height = 0;
	var sample_count = 0
	for i in range(3):
		for j in range(3):
			height += getTerrainHeight(Vector2(cx + i, cy + j),image)
			sample_count += 1;
	return height / sample_count

func _on_TerrainHTTPRequest_request_completed(result, response_code, headers, body):
	var texture = download_to_Texture(body);
	if texture:
		var height_offset = getAverageTerrainHeight(texture.get_data())
		print ("height_offset is ", height_offset)
		$TerrainTile/MeshInstance.material_override.set_shader_param("height_offset", height_offset);
		$TerrainTile/MeshInstance.material_override.set_shader_param("heightTexture", texture);
