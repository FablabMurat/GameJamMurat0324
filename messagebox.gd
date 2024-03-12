extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# ("theme_override_colors/font_color")
	pass # Replace with function body.

func message(text : String, icone : Texture = null):
	self.show()
	if icone != null :
		$PanelContainer/VBoxMessage/MsgTexture.set_texture(icone)
	$PanelContainer/VBoxMessage/MsgLabelBottom.text = text
	$Timer.start()

func _on_message_timer_timeout():
	self.hide()
