extends Node3D

const NBSAPINS = 100
const NBBUCHES = 50
const NBROCHERS = 80


# SCENES SAPINS
const Sapin0_Scene = preload("res://paper_sapin_00.tscn")
const Sapin1_Scene = preload("res://paper_sapin_01.tscn")
const Sapin2_Scene = preload("res://paper_sapin_02.tscn")
const SapinScenes = [Sapin0_Scene, Sapin1_Scene, Sapin2_Scene]

const BucheScene = preload("res://paper_buche.tscn")
const RocherScene = preload("res://paper_rocher.tscn")

# SCENES NEIGE
const NBNEIGE = 20000
const Neige0_Scene = preload("res://neige_00.tscn")
const Neige1_Scene = preload("res://neige_01.tscn")
const Neige2_Scene = preload("res://neige_02.tscn")
const Neige3_Scene = preload("res://neige_03.tscn")
const NeigeScenes = [Neige0_Scene, Neige1_Scene, Neige2_Scene, Neige3_Scene]

# SCENES HERBES
const NBHERBES = 1000
const Herbe0_Scene = preload("res://herbe_00.tscn")
const Herbe1_Scene = preload("res://herbe_01.tscn")
const Herbe2_Scene = preload("res://herbe_02.tscn")
const Herbe3_Scene = preload("res://herbe_03.tscn")
const Herbe4_Scene = preload("res://herbe_04.tscn")
const HerbeScenes = [Herbe0_Scene, Herbe1_Scene, Herbe2_Scene, Herbe3_Scene, Herbe4_Scene]



var inventory = {
	"buche": 0,
	"hache": 0
}

var camrot = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#createobjs(SapinScene,NBSAPINS)
	createobjs(BucheScene,NBBUCHES)
	createobjs(RocherScene,NBROCHERS)
	
	createobjlist(NeigeScenes,NBNEIGE)
	createobjlist(SapinScenes,NBSAPINS)
	createobjlist(HerbeScenes,NBHERBES)
	pass # Replace with function body.
	$Player.collected.connect(update_overlay.bind())
	$Player.increaseFire.connect(increaseFire.bind())

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
	
func createobjlist(scenelist, nbmax):
	
	var x: float
	var z: float
	for i in range(nbmax):
		var sceneindex = randi_range(0, scenelist.size()-1)
		x = randf()*198.0-99.0
		z = randf()*198.0-99.0
		if abs(x) < 3 and abs(z) < 3:
			return
		createobj(scenelist[sceneindex],x,z)

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
	$Overlay.displays[type].text = "%d / %d" % [inventory[type], $Player.NBMAX[type]]
	

func increaseFire(nb):
	print("test increasefire %d" % nb)
	update_overlay("buche",0)
	$Area3D/CollisionShape3D/Feu.fireGestion(10*nb)
