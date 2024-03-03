extends Node3D

var fireSize = 0.5
var timeLeft
var windDirection

var rotation_speed = 1

signal firedeath

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeLeft = $Timer.time_left
	$GPUParticles3D.lifetime = timeLeft/4
	if Input.is_action_just_pressed("addLog"):
		fireGestion(2.0)
		#print($Timer.time_left)
		print($GPUParticles3D.draw_pass_1.material.albedo_texture.pause)
		
		
	$WindDirection.rotate_y(0.002)
	
	$GPUParticles3D.process_material.gravity = getwindDirection()

func fireGestion(amount):
	$Timer.start(timeLeft + amount)
	print("fire ammount: %d" % timeLeft)
	

func getwindDirection():
	var windRotation = $WindDirection.rotation
	var windForce = 0.2
	return Vector3(sin(windRotation[1])*windForce,0,cos(windRotation[1])*windForce)


func _on_timer_timeout():
	firedeath.emit()


