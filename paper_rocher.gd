extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sprite3D(image : Texture):
	$Sprite3D.texture = image
