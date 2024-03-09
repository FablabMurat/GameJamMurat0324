extends Node2D

var displays = {}
var score = 0

func _ready():
	init_displays()
	
	%PauseButton.pressed.connect(toggle_pause)
	%QuitButton.pressed.connect(quit_game)
	%RestartButton.pressed.connect(restart_game)
	%StartButton.pressed.connect(start_game)
	
	%RestartButton.visible = false
	%PauseButton.visible = false
	%GameOver.visible = false
	%StartButton.visible = true
	get_tree().paused = true
	
	set_margins()
	
	get_viewport().size_changed.connect(resized.bind())
	resized()

func resized():
	var vp : Viewport = get_viewport()
	$PanelContainer.size = vp.size
	$PauseMenu/PanelContainer.size = vp.size
	#$PauseMenu/PanelContainer/TransparencyOverlay.size = vp.size

func set_margins():
	const MARGIN_VALUE = 5
	for dir in ["top","left","bottom","right"]:
		$PanelContainer/MarginContainer.add_theme_constant_override("margin_%s" % dir, MARGIN_VALUE)
	
func _process(delta):
	if Input.is_action_just_pressed("pause_toggle"):
		toggle_pause()

func start_game():
	get_tree().paused = false
	$PauseMenu.visible = false
	%PauseButton.visible = true
	%StartButton.visible = false
	
func updateCounter(type, nb, nbmax):
	self.displays[type].text = "%d / %d" % [nb, nbmax]

func updateScore(nbpts : int):
	score += nbpts
	%Score.text = "%03d" % score

func toggle_pause():
	get_tree().paused = not get_tree().paused
	$PauseMenu.visible = get_tree().paused
	%PauseButton.visible = get_tree().paused

func gameover():
	$GameOverStreamPlayer.play()
	get_tree().paused = true
	$PauseMenu.visible = true
	%RestartButton.visible = true
	%GameOver.visible = true
	%PauseButton.visible = false

func restart_game():
	get_tree().reload_current_scene()
	get_tree().paused = false
	$PauseMenu.visible = false
	%RestartButton.visible = false
	%GameOver.visible = false
	%PauseButton.visible = true

func quit_game():
	get_tree().quit()

func init_displays():
	displays["buche"] = %buchesCountDisplay
	displays["hache"] = %hacheCountDisplay
