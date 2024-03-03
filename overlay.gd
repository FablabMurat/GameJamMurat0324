extends Node2D

var displays = {}


func _ready():
	$PauseMenu/PauseButton.pressed.connect(toggle_pause)
	$PauseMenu/QuitButton.pressed.connect(quit_game)
	$PauseMenu/RestartButton.pressed.connect(restart_game)
	$PauseMenu/StartButton.pressed.connect(start_game)
	
	$PauseMenu/RestartButton.visible = false
	$PauseMenu/PauseButton.visible = false
	$PauseMenu/GameOver.visible = false
	$PauseMenu/StartButton.visible = true
	get_tree().paused = true
	
	init_displays()


func _process(delta):
	if Input.is_action_just_pressed("pause_toggle"):
		toggle_pause()

func start_game():
	get_tree().paused = false
	$PauseMenu.visible = false
	$PauseMenu/PauseButton.visible = true
	$PauseMenu/StartButton.visible = false
	
	
	

func toggle_pause():
	get_tree().paused = not get_tree().paused
	$PauseMenu.visible = get_tree().paused
	$PauseMenu/PauseButton.visible = get_tree().paused

func gameover():
	$GameOverStreamPlayer.play()
	get_tree().paused = true
	$PauseMenu.visible = true
	$PauseMenu/RestartButton.visible = true
	$PauseMenu/GameOver.visible = true
	$PauseMenu/PauseButton.visible = false

func restart_game():
	get_tree().reload_current_scene()
	get_tree().paused = false
	$PauseMenu.visible = false
	$PauseMenu/RestartButton.visible = false
	$PauseMenu/GameOver.visible = false
	$PauseMenu/PauseButton.visible = true

func quit_game():
	get_tree().quit()

func init_displays():
	displays["buche"] = $buchesCountDisplay
	displays["hache"] = $hacheCountDisplay
