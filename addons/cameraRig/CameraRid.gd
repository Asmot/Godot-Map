extends KinematicBody


var camera_angle = 0
var mouse_sensitivity_bearing = 0.5
var mouse_sensitivity_tilt = 0.5

func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseMotion:
		$Head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity_bearing))
		
		var change = -event.relative.y * mouse_sensitivity_tilt
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
		
