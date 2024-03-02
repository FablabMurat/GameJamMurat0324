extends GPUParticles3D
var fireSize = 0.5
var timeLeft
var windDirection
func _process(delta):
	timeLeft = $"../Timer".time_left
	self.lifetime = timeLeft/4
	if Input.is_action_just_pressed("addLog"):
		fireGestion(2.0)
		print($"../Timer".time_left)
	getwindDirection()
	self.process_material.gravity = windDirection

func _on_timer_timeout():
	pass # Replace with function body.


func fireGestion(amount):
	$"../Timer".start(timeLeft + amount)

func getwindDirection():
	var windRotation = $"../WindDirection".rotation
	print(windRotation)
	windDirection = Vector3(sin(windRotation[1]),0,cos(windRotation[1]))
	print(windDirection)

