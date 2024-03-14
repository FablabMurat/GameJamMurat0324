extends CharacterBody3D

@export var PLAYER_SPEED = 500
var camrot = 0.0

var direction = Vector3.ZERO
const COS45 = sqrt(2)/2
const NBMAX = {
	"buche": 3,
	"hache": 1
}
var nbbuche = 0

const MIN_ENERGIE = 20.0
const MAX_ENERGIE = 50.0
const FATIGUE_PAR_SECONDE = 0.2
var energie : float = MAX_ENERGIE

# Une hache permet de couper 3 sapins
const PTS_MAX_HACHE = 150

var nbhache = 0
var listPtsHaches = []
const IMG_HACHE = preload("res://Ressources/Environnement/Hache.png")
const IMG_SAPIN = preload("res://Ressources/Environnement/Arbre_4.png")

var sapinsProches = {}
var flagPresDuFeu = false

signal collected
signal increaseFire
signal stepSpawn
signal score
signal message
signal fatigue

func _ready():
	$PlayerCenter/Camera3D.set_current(true)

func _physics_process(delta):
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")
	
	velocity = direction.normalized().rotated(Vector3.UP,$PlayerCenter.rotation.y) * PLAYER_SPEED
	set_velocity(velocity * delta * min(1.0,energie/MAX_ENERGIE))
	move_and_slide()
	
	var dejaunehache = false
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body = collision.get_collider()
		if body.is_in_group("buche")  and  nbbuche < NBMAX["buche"]:
			#print("player collect buche")
			nbbuche += 1
			body.queue_free()
			# mettre à jour l'UI
			collected.emit("buche",1)
			score.emit(1)
		
		elif body.is_in_group("hache") and not dejaunehache :
			# Attention, on peut avoir 2 collisions : une par Body3D...
			#print("player collect hache")
			nbhache += 1
			dejaunehache = true
			body.queue_free()
			listPtsHaches.append(PTS_MAX_HACHE)
			collected.emit("hache",1)
			score.emit(5)
		
		elif body.is_in_group("feu") and nbbuche > 0 :
			#print("mettre une buche dans le feu")
			increaseFire.emit(nbbuche)
			nbbuche = 0
			score.emit(2)
		else:
			# contact avec un élément du décor avec mask=2 (sinon on passe à travers)
			pass #prints("autre collision avec (arbre, sol ou rocher ?) ",body)
		

func _process(delta):
	#var tmprot = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	#if abs(tmprot) > 0.1:
	#	camrot += tmprot * 0.05
	#	$PlayerCenter.set_rotation(Vector3(0, camrot, 0))
	#	print("Camera3D Rotation: ", camrot)
	$PlayerCenter.set_rotation(Vector3(0, camrot, 0))
	
	animate()

func animate():
	if(velocity != Vector3.ZERO):
		$PlayerCenter/PlayerSprite3D.play()
		var realdirection = velocity.rotated(Vector3.UP,-$PlayerCenter.rotation.y)
		if(realdirection.x > COS45):
			$PlayerCenter/PlayerSprite3D.animation = "side"
			$PlayerCenter/PlayerSprite3D.flip_h = false
		elif(realdirection.x < -COS45):
			$PlayerCenter/PlayerSprite3D.animation = "side"
			$PlayerCenter/PlayerSprite3D.flip_h = true
		elif(realdirection.z <= -COS45):
			$PlayerCenter/PlayerSprite3D.animation = "front"
		elif(realdirection.z >= COS45):
			$PlayerCenter/PlayerSprite3D.animation = "back"
		else:
			pass
			# On est inanimé car bloqué
			#print("animate impossible %d/%d" % [realdirection.x,realdirection.z])
	else:
		$PlayerCenter/PlayerSprite3D.stop()

func has_hache():
	return nbhache > 0

func _on_step_timer_timeout():
	if(velocity != Vector3.ZERO):
		# on brule de l'énergie
		energie -= FATIGUE_PAR_SECONDE
		if energie < MIN_ENERGIE: energie = MIN_ENERGIE
		fatigue.emit(energie)
		# on marque un pas
		stepSpawn.emit()
		$StepStreamPlayer.play()


func _on_area_3d_body_entered(body):
	if body.is_in_group("arbre"):
		#print ("près d'un arbre ")
		sapinsProches[body.get_rid()] = body
	elif body.is_in_group("feu"):
		# on est suffisamment proche du feu
		flagPresDuFeu = true
		$PresDuFeuTimer.start()
		#print ("près du feu ")
		#$FoyerStreamPlayer.start()
	else:
		pass
		#prints ("autre body :", body)
		
func _on_area_3d_body_exited(body):
	if body.is_in_group("arbre"):
		#print("loin d'un' sapin")
		sapinsProches.erase(body.get_rid())
	elif body.is_in_group("feu"):
		$PresDuFeuTimer.stop()
		#$FoyerStreamPlayer.stop()

func _on_pres_du_feu_timer_timeout():
	if velocity.x == 0  and  velocity.z == 0:
		# on gagne des points
		score.emit(10)
		# on réduit la fatigue
		energie += 5
		fatigue.emit(energie)

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & (MOUSE_BUTTON_MASK_MIDDLE + MOUSE_BUTTON_MASK_RIGHT):
			camrot += event.relative.x * 0.005
			print("Camera3D Rotation: ", camrot)

	if event.is_action_pressed("ui_hache"):
		if not sapinsProches.is_empty():
			if has_hache():
				# coupe d'un arbre
				sapinsProches.values()[0].cutwood()
				useHache()
			else:
				message.emit("il faut d'abord une hache !",IMG_HACHE)
		else:
			message.emit("pas de sapin ici !",IMG_SAPIN)

func useHache():
	if listPtsHaches.size() > 0:
		# Utilise la hache qui s'use
		listPtsHaches[0] -= 1
		# On perd de l'énergie à chaque coup de hache
		energie -= 1
		if energie < MIN_ENERGIE: energie = MIN_ENERGIE
		fatigue.emit(energie)
		
		if listPtsHaches[0] == 0 :
			listPtsHaches.remove_at(0)
			nbhache -= 1
			collected.emit("hache",-1)
			# on avertit de la perte de la hache
			message.emit("La hache est cassée !", IMG_HACHE)
			# En rebalancer une ailleurs
			get_parent().recreatehache()

func _on_foyer_stream_player_finished():
	$FoyerStreamPlayer.start()
	pass # Replace with function body.

