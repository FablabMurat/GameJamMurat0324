extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().size_changed.connect(resized.bind())
	resized()

# Repositionnement du Control en cas de redimensionnement de la fenêtre
func resized():
	var vp : Viewport = get_viewport()
	self.size = vp.size
	self.size = vp.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_fermer_pressed():
	self.queue_free()
	pass # Replace with function body.
