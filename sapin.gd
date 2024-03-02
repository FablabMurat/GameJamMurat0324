extends StaticBody3D

const MAXSIZE = 10
var size = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	size = MAXSIZE
	pass # Replace with function body.

func cut():
	size -= 1
	if size == 0:
		queue_free()
	else:
		self.set_scale(Vector3(size/MAXSIZE,size/MAXSIZE,size/MAXSIZE))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
