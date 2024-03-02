extends Node2D

var displays = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	displays["buche"] = $buchesCountDisplay
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
