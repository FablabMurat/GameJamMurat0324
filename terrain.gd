extends Node3D

const NBSAPINS = 100
const NBBUCHES = 40
const NBROCHERS = 80
const SapinScene = preload("res://sapin.tscn")
const BucheScene = preload("res://buche.tscn")
const RocherScene = preload("res://buche.tscn")

var camrot = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	createsapins()
	createbuches()
	pass # Replace with function body.

func createsapins():
	var x: int
	var z: int
	for i in range(NBSAPINS):
		x = randf()*198-99
		z = randf()*198-99
		createsapin(x,z)
		
func createsapin(x,z):
	if abs(x) < 3 and abs(z) < 3:
		return
	var obs = SapinScene.instantiate()
	obs.position.x = x
	obs.position.z = z
	add_child(obs)


func createbuches():
	var x: int
	var z: int
	for i in range(NBBUCHES):
		x = randf()*198-99
		z = randf()*198-99
		createbuche(x,z)
		
func createbuche(x,z):
	if abs(x) < 3 and abs(z) < 3:
		return
	var buche = BucheScene.instantiate()
	buche.position.x = x
	buche.position.z = z
	add_child(buche)


func createrochers():
	var x: int
	var z: int
	for i in range(NBROCHERS):
		x = randf()*198-99
		z = randf()*198-99
		createbuche(x,z)
		
func createrocher(x,z):
	if abs(x) < 3 and abs(z) < 3:
		return
	var buche = RocherScene.instantiate()
	buche.position.x = x
	buche.position.z = z
	add_child(buche)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & (MOUSE_BUTTON_MASK_MIDDLE + MOUSE_BUTTON_MASK_RIGHT):
			camrot += event.relative.x * 0.005
			get_node("Center").set_rotation(Vector3(0, camrot, 0))
			#print("Camera3D Rotation: ", camrot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
