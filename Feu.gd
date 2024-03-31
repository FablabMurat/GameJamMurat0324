extends Node3D

var fireSize = 0.5
var timeLeft
var windDirection
var windForce = 0.02

var rotation_speed = 1

signal firetimeleft
signal firedeath
signal getWindDirection

const ENERGY_PER_TIMELEFT = 10.0 / 60
const ENERGY_MIN = 160.0 / 60
const RANGE_PER_TIMELEFT = 30.0 / 60
const RANGE_MIN = 250.0 / 60

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeLeft = $Timer.time_left
	firetimeleft.emit(timeLeft)
	
	var omnirange = max (RANGE_PER_TIMELEFT * timeLeft, \
								RANGE_MIN)
	if timeLeft > 60 : omnirange *= timeLeft*timeLeft / 3600
	$OmniLight3D.omni_range = omnirange
	var energy = max (ENERGY_PER_TIMELEFT * timeLeft, \
								ENERGY_MIN)
	if timeLeft > 60 : energy *= timeLeft*timeLeft / 3600
	$OmniLight3D.light_energy = energy
	
	$Feu1.lifetime = timeLeft/3
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
	# Effet visuel de l'alimentation du feu
	$Feu4.emitting = true
	
	# Rajout de temps de brulage
	timeLeft = timeLeft + amount
	$Timer.start(timeLeft)
	# Adaptation de l'effet visuel du feu
#	print("fire radius avant: %f" % $Feu1.process_material.emission_ring_radius)
	var new_radius = timeLeft*(0.75/50.0)
	$Feu1.process_material.emission_ring_radius = max(0.34,min(1.0,new_radius))
	#print("fire added: %d" % amount)
#	print("fire timeleft: %f" % timeLeft)
#	print("fire radius après: %f" % $Feu1.process_material.emission_ring_radius)


func getwindDirection():
	var windRotation = $WindDirection.rotation
	return Vector3(sin(windRotation[1])*windForce,0,cos(windRotation[1])*windForce)
	
	
func _on_timer_timeout():
	firedeath.emit()


