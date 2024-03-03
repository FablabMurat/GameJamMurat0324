extends GPUParticles3D

func _process(delta):
	$GPUParticles3D.process_material.gravity = getWindDirection()

func getWindDirection(dir):
	
