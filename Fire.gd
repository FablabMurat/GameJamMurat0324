@tool
extends Node
var fireSize = 0.5


func _process(delta):
	#print($Timer.time_left)
	var timeLeft = $Timer.time_left
	#if Input.is_action_just_pressed("addLog"):
	#	$Timer.start(timeLeft + 2.0)
	$GPUParticles3D.lifetime = timeLeft/4

func _on_timer_timeout():
	pass # Replace with function body.

func _ready():
	$Timer.start()
