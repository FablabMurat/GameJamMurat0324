extends DirectionalLight3D
var rotation_speed = 1
func _process(delta):
	self.rotate_y(0.002)
