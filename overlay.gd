extends Node2D

@onready var displays = {"buche" : %buchesCountDisplay, \
				"hache" : %hacheCountDisplay}
var score = 0
const HIGH_SCORES_FILE = "user://gamejamhiver2024-scores.json"
const MAX_HI_SCORES = 20
var hi_scores = null
var isgameover = false

const MONTHS = ["","janvier","février","mars","avril","mai","juin","juillet","aout","septembre", "octobre","novembre","decembre"]

const RESTART_FILE = "user://restart.flag"

func _ready():
	$PanelContainer/HBoxContainer.hide()
	
	%PauseButton.pressed.connect(toggle_pause)
	%QuitButton.pressed.connect(quit_game)
	%RestartButton.pressed.connect(restart_game)
	%StartButton.pressed.connect(start_game)
	%StartButton.grab_focus()
	
	%LabelHiScore.visible = false
	%HBoxName.visible = false
	%RestartButton.visible = false
	%PauseButton.visible = false
	%GameOver.visible = false
	%StartButton.visible = true
	%HiScoresButton.visible = true
	
	%MessageBox.hide()
	%MessageInfo.hide()
	
	get_tree().paused = true
	
	set_margins()
	
	get_viewport().size_changed.connect(resized.bind())
	resized()
	
	if FileAccess.file_exists(RESTART_FILE):
		var dir = DirAccess.open("user://")
		dir.remove(RESTART_FILE)
		start_game()
		
	#test_hi_scores()

func resized():
	var vp : Viewport = get_viewport()
	$PanelContainer.size = vp.size
	$Menu/PanelContainer.size = vp.size

func set_margins():
	const MARGIN_VALUE = 5
	for dir in ["top","left","bottom","right"]:
		$PanelContainer/MarginContainer.add_theme_constant_override("margin_%s" % dir, MARGIN_VALUE)

func _process(_delta):  #FIXME ce n'est peut-être la meilleure fonction
	if Input.is_action_just_pressed("pause_toggle") and not %StartButton.visible:
		toggle_pause()
	elif Input.is_action_just_pressed("help") and $PopUp.get_child_count() == 0:
		if not get_tree().paused :
			toggle_pause()
		show_aide()

func start_game():
	get_tree().paused = false
	$Menu.visible = false
	%PauseButton.visible = true
	%StartButton.visible = false
	%HiScoresButton.visible = true
	
	$PanelContainer/HBoxContainer.show()
	
func updateCounter(type, nb, nbmax):
	self.displays[type].text = "%d / %d" % [nb, nbmax]

func updateScore(nbpts : int):
	score += nbpts
	%Score.text = "%03d" % score

func setBarFatigue(energie : int):
	%BarEnergie.value = energie
	if energie <= 10:
		%BarEnergie.set_theme_type_variation("ProgressBarAlert")
	elif energie <= 30:
		%BarEnergie.set_theme_type_variation("ProgressBarWarning")
	else:
		%BarEnergie.set_theme_type_variation("")

func setBarFeu(timeleft : float):
	%BarFeu.value = timeleft
	if timeleft <= 10:
		%BarFeu.set_theme_type_variation("ProgressBarAlert")
	elif timeleft <= 25:
		%BarFeu.set_theme_type_variation("ProgressBarWarning")
	else:
		%BarFeu.set_theme_type_variation("")

func test_hi_scores():
#	var f = FileAccess.open(HIGH_SCORES_FILE, FileAccess.WRITE)
#	f.close()
	load_hi_scores()
	for i in range(1, 25):
		load_hi_scores()
		var pts = randi_range(1,500)
		if is_hi_score(pts):
			add_hi_score("joueur%d" % i, pts)
		save_hi_scores()
	load_hi_scores()
	
func load_hi_scores():
	var file = FileAccess.open(HIGH_SCORES_FILE, FileAccess.READ)
	if file == null:
		file = FileAccess.open(HIGH_SCORES_FILE, FileAccess.WRITE)
		if file != null :
			hi_scores = Array()
			file.close()
	else:
		hi_scores = Array()
			
		while file.get_position() < file.get_length():
			var content = file.get_line()
			# Creates the helper class to interact with JSON
			var json = JSON.new()
			# Check if there is any error while parsing the JSON string, skip in case of failure
			var parse_result = json.parse(content)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())
				# On ne va pas gérer les hiscores pour cette partie.
				file.close()
				return
			else:
				hi_scores.append(json.get_data())
		#print (hi_scores)
	
func save_hi_scores():
	var file = FileAccess.open(HIGH_SCORES_FILE, FileAccess.WRITE)
	for sc in hi_scores:
		if sc.has("pts") :
			var json_string = JSON.stringify(sc)
			file.store_line(json_string)
	file.close()

## Vérifie si l'on ferait partie des nouveaux hi-score
func is_hi_score(pts):
	if pts <= 0 : return false  # Un score de 0 ne peut pas être un hi-score
	if hi_scores.size() < MAX_HI_SCORES:
		# On n'a pas encore de hiscore donc on en est
		return true
	# On boucle sur tous les hiscores pour voir si on est meilleur
	for sc in hi_scores:
		if (not sc.has("pts")): continue
		if pts > sc["pts"] :
			return true
	return false

# Ajoute dans les hi-score (en supposant qu'on en fait partie)
func add_hi_score(joueur, pts):
	if hi_scores != null and hi_scores is Array :
		var dateInDict = Time.get_datetime_dict_from_system()
		var dateFormat = "%d %s %d à %02d:%02d" % \
				[dateInDict["day"], \
				MONTHS[dateInDict["month"]], \
				dateInDict["year"], \
				dateInDict["hour"], \
				dateInDict["minute"], \
				]
		var newscore = {"player" : joueur, \
						"pts" : pts, \
						"unixtime" : Time.get_unix_time_from_system(),\
						"date" : dateFormat }
		hi_scores.append(newscore)
		hi_scores.sort_custom(func (a,b): return a["pts"] > b["pts"] or (a["pts"] == b["pts"] && a["unixtime"] > b["unixtime"]))
		if hi_scores.size() > MAX_HI_SCORES:
			hi_scores.resize(MAX_HI_SCORES)

func toggle_pause():
	if isgameover: return
	var onpause = not get_tree().paused
	get_tree().paused = onpause
	$Menu.visible = onpause
	%RestartButton.visible = onpause
	%PauseButton.visible = onpause
	if onpause: %PauseButton.grab_focus()

func gameover():
	isgameover = true
	$GameOverStreamPlayer.play()
	get_tree().paused = true
	$Menu.visible = true
	%PauseButton.visible = false
	%GameOver.visible = true
	load_hi_scores()
	if is_hi_score(score):
		%LabelHiScore.text = "Vous rentrez dans le Top %d !" % MAX_HI_SCORES
		%HBoxName.visible = true
		%HBoxName/NameButton.disabled = true
		%RestartButton.visible = true
		%HBoxName/PlayerName.grab_focus()
		%HBoxName/NameButton.grab_click_focus()
	else:
		if score == 0 :
			%LabelHiScore.text = "0 point, ça doit pouvoir s'améliorer"
		else :
			%LabelHiScore.text = "%d point%s, c'est pas si mal !" % [score, "s" if score > 1 else ""]
		%LabelHiScore.visible = true
		%RestartButton.visible = true
		%RestartButton.grab_focus()
		%RestartButton.grab_click_focus()
	%LabelHiScore.visible = true

func activate_namebutton(newText : String):
	if newText != "":
		%HBoxName/NameButton.disabled = (newText == "")
	pass

func submit_hi_score(playername : String):
	if playername == "" : return
	valid_hi_score()

func valid_hi_score():
	var playername = %HBoxName/PlayerName.text
	add_hi_score(playername,score)
	save_hi_scores()
	show_hi_scores(playername)
	%HBoxName.visible = false
	%RestartButton.visible = true
	%LabelHiScore.visible = false
		
		
func restart_game():
	var f = FileAccess.open(RESTART_FILE, FileAccess.WRITE)
	f.close()
	get_tree().reload_current_scene()
	get_tree().paused = false
	$Menu.visible = false
	%RestartButton.visible = false
	%GameOver.visible = false
	%PauseButton.visible = true

func quit_game():
	get_tree().quit()

func show_hi_scores(player : String = ""):
	const hiScene = preload("res://hiscores.tscn")
	$Menu.hide()
	var hicontrol = hiScene.instantiate()
	load_hi_scores()
	hicontrol.display(hi_scores, player)
	$PopUp.add_child(hicontrol)

func message(text : String, icone : Texture = null):
	if false :
		%MessageBox.message(text, icone)
	else:
		%MessageInfo.text = text
		%MessageInfo.show()
		%MessageInfo/Timer.timeout.connect(func (): %MessageInfo.hide() )
		%MessageInfo/Timer.start()

func _on_hi_scores_button_pressed():
	show_hi_scores()

func _on_hi_scores_child_exiting_tree(_node):
	$Menu.show()
	%StartButton.grab_focus()

func show_aide():
	const aideScene = preload("res://aide.tscn")
	$Menu.hide()
	$PopUp.add_child(aideScene.instantiate())

func show_credits():
	const creditsScene = preload("res://credits.tscn")
	$Menu.hide()
	$PopUp.add_child(creditsScene.instantiate())
