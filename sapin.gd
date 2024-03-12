extends StaticBody3D

const MAXSIZE : float = 10.0
const COUPSAVANTCUT = 5
var size : float = 10.0
var resteacouper = 10
var nbcoupsrecus = 0
var initialScaleX


# Called when the node enters the scene tree for the first time.
func _ready():
	size = MAXSIZE
	initialScaleX = $Sprite3D.scale.x
	pass # Replace with function body.

func set_sprite3D(image : Texture):
	$Sprite3D.texture = image
	
func cutwood():
	#if not $TheStreamPlayer.is_playing():   # pour éviter l'accumulation des sons
	$TheStreamPlayer.play()
		
	nbcoupsrecus += 1
	if nbcoupsrecus >= COUPSAVANTCUT:
		nbcoupsrecus = 0
		unebuche()
		
		size -= 1
		if size <= 0:
			#print("plus de sapin")
			queue_free()
			return
		else:
			#print (size/MAXSIZE)
			$Sprite3D.set_scale(Vector3(size/MAXSIZE*initialScaleX, \
								size/MAXSIZE*initialScaleX,size/MAXSIZE*initialScaleX))

func unebuche():
	var buchescene = load("res://paper_buche.tscn")
	var buche = buchescene.instantiate()
	
	# on ajoute la buche dans le terrain
	self.get_parent().add_child(buche)
	var angle = randf()*2*PI
	buche.global_position.x = self.position.x + cos(angle)*(2+randi_range(2,4))
	buche.global_position.z = self.position.z + sin(angle)*(2+randi_range(2,4))
