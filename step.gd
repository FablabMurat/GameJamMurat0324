extends Sprite3D

var is_fading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_fading):
		self.set_scale(Vector3($FadeTimer.time_left/10, $FadeTimer.time_left/10, $FadeTimer.time_left/10))


func _on_timer_before_start_timeout():
	$FadeTimer.start()
	is_fading = true

func _on_fade_timer_timeout():
	self.queue_free()
