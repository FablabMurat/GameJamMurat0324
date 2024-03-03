extends StaticBody3D

const MAXSIZE = 10
const COUPSAVANTCUT = 5
var size = 10
var resteacouper = 10
var nbcoupsrecus = 0
var isplayerhere = false

# Called when the node enters the scene tree for the first time.
func _ready():
	size = MAXSIZE
	pass # Replace with function body.

func cut():
	nbcoupsrecus += 1
	if nbcoupsrecus >= COUPSAVANTCUT:
		nbcoupsrecus = 0
		unebuche()
		
	size -= 1
	if size <= 0:
		print("plus de sapin")
		queue_free()
		return
	else:
		self.set_scale(Vector3(size/MAXSIZE,size/MAXSIZE,size/MAXSIZE))

func unebuche():
	var buchescene = load("res://paper_buche.tscn")
	var buche = buchescene.instantiate()
	buche.global_position.x = self.position.x + 2 * size
	buche.global_position.z = self.position.z + 2 * size
	# on ajoute la buche dans le terrain
	self.get_parent().add_child(buche)


func _input(event : InputEvent):
	if isplayerhere:
#		print("input with player")
#		print(event)
		if event.is_action_pressed("ui_hache") and event.echo == false :
			# coupe d'un arbre
			print ("cut")
			cut()

func _on_area_3d_body_entered(body):
	print("enter body sapin")
	if body.is_in_group("player"):
		isplayerhere = true
	pass # Replace with function body.

func _on_area_3d_body_exited(body):
	print("out body sapin")
	if body.is_in_group("player"):
		isplayerhere = false
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
