extends Spatial

export var tile_coord = Vector3(6743, 3105,13)
const URL_FORMAT = "https://webst03.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}"

func format_url():
	return URL_FORMAT.format({'x':tile_coord.x, 'y':tile_coord.y, 'z':tile_coord.z })

# Called when the node enters the scene tree for the first time.
func _ready():
	loadTile()
	$MeshInstance.material_override = SpatialMaterial.new()

func loadTile():
	var url = format_url()
	$TileLoad.request(url)
	print ("request %s" %(url))

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


