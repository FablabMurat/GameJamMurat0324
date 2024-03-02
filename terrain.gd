extends Node3D

const NBSAPINS = 100
const NBBUCHES = 40
const NBROCHERS = 80
const SapinScene = preload("res://paper_sapin.tscn")
const BucheScene = preload("res://paper_buche.tscn")
const RocherScene = preload("res://paper_rocher.tscn")

var inventory = {
	"buche": 0,
	"hache": 0
}

var camrot = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	createobjs(SapinScene,NBSAPINS)
	createobjs(BucheScene,NBBUCHES)
	createobjs(RocherScene,NBROCHERS)
	pass # Replace with function body.
	$Player.collected.connect(update_overlay.bind())

func createobjs(scene, nbmax):
	var x: float
	var z: float
	for i in range(nbmax):
		x = randf()*198.0-99.0
		z = randf()*198.0-99.0
		if abs(x) < 8 and abs(z) < 8:
			return
		createobj(scene,x,z)

func createobj(scene,x,z):
	var obs = scene.instantiate()
	obs.position.x = x
	obs.position.z = z
	add_child(obs)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & (MOUSE_BUTTON_MASK_MIDDLE + MOUSE_BUTTON_MASK_RIGHT):
			camrot += event.relative.x * 0.005
			get_node("Center").set_rotation(Vector3(0, camrot, 0))
			#print("Camera3D Rotation: ", camrot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_overlay(type, nb):
	inventory[type] += nb
	$Overlay/buchesCountDisplay.text = "%d" % inventory[type]
