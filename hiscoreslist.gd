extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Détection du passage en plein écran
	get_viewport().size_changed.connect(resized.bind())
	resized()

# Repositionnement du Control en cas de redimensionnement de la fenêtre
func resized():
	var vp : Viewport = get_viewport()
	self.size = vp.size
	self.size = vp.size

func display(scores, player = ""):
	var first = true
	var firstplayer = true
	for sc in scores:
		var nom = Label.new()
		nom.text = sc["player"]
		if firstplayer and player == sc["player"]:
			# Highlight nom
			#nom.add_theme_font_override("bold",font)
			nom.add_theme_color_override("font_color", Color(255, 0, 0))
			pass
		%TabContainer.add_child(nom)
		var val : Label = Label.new()
		val.text = "%d" % sc["pts"]
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if firstplayer and player == sc["player"]:
			# Highlight nom
			val.add_theme_color_override("font_color", Color(255, 0, 0))
			pass
		#val.theme_override_font_sizes.font_size = 30
		#val.add_theme_color_override("font_color", Color(255, 0, 0))
		val.add_theme_font_size_override("font_size",25)
		%TabContainer.add_child(val)
		var date = Label.new()
		date.text = sc["date"]
		date.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		if firstplayer and player == sc["player"]:
			# Highlight nom
			date.add_theme_color_override("font_color", Color(255, 0, 0))
			pass
		%TabContainer.add_child(date)
		
		if firstplayer and player == sc["player"]:
			firstplayer = false
		
		if first:
			%TabContainer.add_child(HSeparator.new())
			%TabContainer.add_child(HSeparator.new())
			%TabContainer.add_child(HSeparator.new())
		first = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fermer_pressed():
	self.queue_free()
	pass # Replace with function body.
