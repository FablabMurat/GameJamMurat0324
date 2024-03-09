extends Node3D

var fireSize = 0.5
var timeLeft
var windDirection

var rotation_speed = 1

signal firedeath
signal getWindDirection
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeLeft = $Timer.time_left
	$Feu1.lifetime = timeLeft/4
#	if Input.is_action_just_pressed("addLog"):
#		fireGestion(2.0)
#		#print($Timer.time_left)
#		print($Feu1.draw_pass_1.material.albedo_texture.pause)
	if Input.is_action_just_pressed("abandon"):
		firedeath.emit()
		
	$WindDirection.rotate_y(0.002)
	
	$Feu1.process_material.gravity = getwindDirection()
	getWindDirection.emit(getwindDirection())

func fireGestion(amount):
	$Timer.start(timeLeft + amount)
	if $Feu1.process_material.emission_ring_radius <100:
		$Feu1.process_material.emission_ring_radius = timeLeft*0.004
	else:
		$Feu1.process_material.emission_ring_radius = 0.4
#	print("fire ammount: %d" % timeLeft)
#	print("fire added: %d" % amount)

func getwindDirection():
	var windRotation = $WindDirection.rotation
	var windForce = 0.1
	return Vector3(sin(windRotation[1])*windForce,0,cos(windRotation[1])*windForce)
	
	

func _on_timer_timeout():
	firedeath.emit()


