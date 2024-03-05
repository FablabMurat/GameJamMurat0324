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
const RocherScene = preload("res://paper_rocher.tscn")
var resRocher1 = preload("res://Ressources/Environnement/Rochers_1.png")
var resRocher2 = preload("res://Ressources/Environnement/Rochers_2.png")
var resRocher3 = preload("res://Ressources/Environnement/Rochers_3.png")
var resRochers = [resRocher1, resRocher2, resRocher3]

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
	
	createdecorswithSpriteList(Sapin_Scene, resSapins, NBSAPINS)
	createdecorswithSpriteList(BucheScene, null, NBBUCHES)
	createdecorswithSpriteList(RocherScene, resRochers, NBBUCHES)
	
	# On ne passe pas par un SpriteList car les Sprites3D n'ont pas tous la même position
	createdecorswithSceneList(NeigeScenes,NBNEIGE)
	createdecorswithSceneList(HerbeScenes,NBHERBES)
	
	# La première hache, facile à trouver
	createdecor(HacheScene,3,3,null)
	
	$Player.collected.connect(update_overlay.bind())
	$Player.increaseFire.connect(increaseFire.bind())
	$Player.stepSpawn.connect(stepSpawn.bind())
	
	$Feu.firedeath.connect($Overlay.gameover)
	
	init_overlays()
	
func init_overlays():
	for item in inventory:
		update_overlay(item, 0)

	
func createdecorswithSceneList(scenelist, nbmax : int):
	var x: float
	var z: float
	for i in range(nbmax):
		var sceneindex = randi_range(0, scenelist.size()-1)
		createrandomdecor(scenelist[sceneindex])

func createdecorswithSpriteList(scene : PackedScene, spriteList, nbmax : int):
	for i in range(nbmax):
		if spriteList != null and spriteList is Array and spriteList.size() > 0:
			var index = randi_range(0, spriteList.size()-1)
			createrandomdecor(scene,spriteList[index])
		else:
			createrandomdecor(scene)

func createrandomdecor(scenemodel, resTexture = null):
	var x
	var z
	x = randf()*198.0-99.0
	z = randf()*198.0-99.0
	if abs(x) < 5 and abs(z) < 5:
		return
	return createdecor(scenemodel,x,z,resTexture)

func createdecor(scenemodel, x, z, resTexture = null):
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
	createdecor(Step_Scene, $Player.position.x,$Player.position.z)
	print("Spawn step")
