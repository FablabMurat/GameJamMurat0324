extends Node2D

var displays = {}


func _ready():
	$PauseMenu/PauseButton.pressed.connect(toggle_pause)
	$PauseMenu/QuitButton.pressed.connect(quit_game)
	init_displays()


func _process(delta):
	if Input.is_action_just_pressed("pause_toggle"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = not get_tree().paused
	$PauseMenu.visible = get_tree().paused

func quit_game():
	get_tree().quit()

func init_displays():
	displays["buche"] = $buchesCountDisplay
	displays["hache"] = $hacheCountDisplay
