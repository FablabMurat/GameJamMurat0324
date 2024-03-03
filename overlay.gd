extends Node2D

var displays = {}


func _ready():
	$PauseMenu/PauseButton.pressed.connect(toggle_pause)
	init_displays()


func _process(delta):
	if Input.is_action_just_pressed("pause_toggle"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = not get_tree().paused
	$PauseMenu.visible = get_tree().paused


func init_displays():
	displays["buche"] = $buchesCountDisplay
	displays["hache"] = $hacheCountDisplay
