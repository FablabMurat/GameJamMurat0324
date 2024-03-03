extends GPUParticles3D

var passFeu = draw_pass_1




func _on_ready():
	var materialFeu = passFeu.material
	var textureFeu = materialFeu.albedo_texture
	textureFeu.set_current_frame (5)
