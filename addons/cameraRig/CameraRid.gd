extends KinematicBody


var camera_angle = 0
var mouse_sensitivity_bearing = 0.5
var mouse_sensitivity_tilt = 0.5

var velocity = Vector3()
var direction = Vector3()

const FLY_SPEED = 50
const FLY_ACCEL = 1

var gravity = -9.8
const MAX_RUNNING_SPEED = 12

func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseMotion:
		$Head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity_bearing))
		
		var change = -event.relative.y * mouse_sensitivity_tilt
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
		


func _physics_process(delta):
	direction = get_direction()
	
	var target
	if Input.is_action_pressed("move_sprint"):
		target = direction * FLY_SPEED * 12
	else:
		target = direction * FLY_SPEED
	
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	move_and_slide(velocity)



func get_direction():
	direction = Vector3()
	
	var aim = $Head/Camera.get_global_transform().basis
	
	if Input.is_action_pressed("ui_up"):
			direction -= aim.z
	if Input.is_action_pressed("ui_down"):
			direction += aim.z
	if Input.is_action_pressed("ui_left"):
			direction -= aim.x
	if Input.is_action_pressed("ui_right"):
			direction += aim.x
	if Input.is_action_pressed("height_up"):
			direction += aim.y * 0.1
	if Input.is_action_pressed("height_down"):
			direction -= aim.y * 0.1
	
	return direction.normalized()
