extends Node3D

const NBBUCHES = 50



# Sapins générique
const NBSAPINS = 100
const Sapin_Scene = preload("res://paper_sapin.tscn")
var resSapin1 = load("res://Ressources/Environnement/Arbre_4.png")
var resSapin2 = load("res://Ressources/Environnement/Arbre_2.png")
var resSapin3 = load("res://Ressources/Environnement/Arbre_3.png")
var resSapins = [resSapin1, resSapin2,resSapin3]

# rochers génériques
const NBROCHERS = 80
const Rocher0_Scene = preload("res://paper_rocher_00.tscn")
const Rocher1_Scene = preload("res://paper_rocher_01.tscn")
const Rocher2_Scene = preload("res://paper_rocher_02.tscn")
const RocherScenes = [Rocher0_Scene, Rocher1_Scene, Rocher2_Scene]

const BucheScene = preload("res://paper_buche.tscn")
const HacheScene = preload("res://hache.tscn")

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

const Step_Scene = preload("res://step.tscn")

var inventory = {
	"buche": 0,
	"hache": 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$WindStreamPlayer.play()
	
	createdecorsfromList(Sapin_Scene, resSapins, NBSAPINS)
	
	#createobjs(SapinScene,NBSAPINS)
	createobjs(BucheScene,NBBUCHES)
	#createobjs(RocherScene,NBROCHERS)
	
	createobjlist(RocherScenes,NBROCHERS)
	createobjlist(NeigeScenes,NBNEIGE)
	createobjlist(HerbeScenes,NBHERBES)

	createobjs(HacheScene,50)
	createobj(HacheScene,3,3)
	
	$Player.collected.connect(update_overlay.bind())
	$Player.increaseFire.connect(increaseFire.bind())
	$Player.stepSpawn.connect(stepSpawn.bind())
	
	$Feu.firedeath.connect($Overlay.gameover)
	
	init_overlays()
	
func init_overlays():
	for item in inventory:
		update_overlay(item, 0)

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
	return obs
	
func createobjlist(scenelist, nbmax : int):
	var x: float
	var z: float
	for i in range(nbmax):
		var sceneindex = randi_range(0, scenelist.size()-1)
		x = randf()*198.0-99.0
		z = randf()*198.0-99.0
		if abs(x) < 3 and abs(z) < 3:
			return
		createobj(scenelist[sceneindex],x,z)

func createdecorsfromList(scene : PackedScene, spriteList : Array, nbmax : int):
	for i in range(nbmax):
		if spriteList != null and spriteList.size() > 0:
			var index = randi_range(0, spriteList.size()-1)
			createundecor(Sapin_Scene,spriteList[index])
		else:
			createundecor(Sapin_Scene)

func createundecor(scenemodel, resTexture = null):
	var x = randf()*198.0-99.0
	var z = randf()*198.0-99.0
	if abs(x) < 5 and abs(z) < 5:
		return
	var decor = scenemodel.instantiate()
	if resTexture != null :
		decor.set_sprite3D(resTexture)
	decor.position.x = x
	decor.position.z = z
	add_child(decor)
	return decor
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("debug")):
		$Overlay.gameover()
	pass

func update_overlay(type, nb):
	inventory[type] += nb
	if inventory[type] < 0:
		inventory[type] = 0
	elif inventory[type] > $Player.NBMAX[type]:
		inventory[type] = $Player.NBMAX[type]
	
	$Overlay.displays[type].text = "%d / %d" % [inventory[type], $Player.NBMAX[type]]
	
	
func increaseFire(nb):
	print("test increasefire %d" % nb)
	if inventory["buche"] != 0:
		$Feu/Feu4.emitting = true
	update_overlay("buche",-1)
	$Feu.fireGestion(10*nb)
	
func stepSpawn():
	createobj(Step_Scene, $Player.position.x, $Player.position.z)
	print("Spawn step")
