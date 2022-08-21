extends Object

const TILE_SIZE = 256;
const EARTH_RADIUS = 6378137;
const EARTH_CIRCUMFERENCE = 2 * PI * EARTH_RADIUS;


func latLng2WebMercator(latLng : Vector2):
	var lat = latLng.x
	var lng = latLng.y
	var x = (lng * PI / 180.0) * EARTH_RADIUS;
	var a = lat * PI / 180.0;
	var y = EARTH_RADIUS / 2 * log(1.0 + sin(a)) / (1.0 - sin(a))
	return Vector2(x, y);


func webMercator2LngLat(point : Vector2):
	var x = point.x;
	var y = point.y;
	var lng = x / (PI / 180.0) * EARTH_RADIUS;
	var a = y / EARTH_RADIUS;
	var b = pow(2.71828, a)
	var c = atan(b);
	var radianLat = 2 * c - PI / 2;
	var lat = radianLat / (PI / 180.0);
	return Vector2(lat, lng); 


func webMercator2TileCoord(point: Vector2, zoom : int):
	var world_size = pow(2, zoom) * TILE_SIZE;
	var tile_size = pow(2, zoom - int(zoom)) * TILE_SIZE; 
	
	var meter_per_pixel = EARTH_CIRCUMFERENCE / world_size
	var w_x = point.x / meter_per_pixel;
	var w_y = point.y / meter_per_pixel;
	
	var tx = (w_x + world_size / 2) / tile_size;
	var ty = (-w_y + world_size / 2) / tile_size
	
	return Vector3(int(tx), int(ty), zoom)
