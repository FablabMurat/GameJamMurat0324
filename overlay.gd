extends Node2D

var displays = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	init_displays()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_displays():
	displays["buche"] = $buchesCountDisplay
	displays["hache"] = $hacheCountDisplay
