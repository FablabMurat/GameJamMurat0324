extends PanelContainer

const MAX_LINES = 10

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

func display(scores : Array, player = ""):
	var sz = scores.size()
	if sz == 0:
		return
	var me : bool = true
	var needvseparator = false  # ajouter un VSeparator avant ?
	for i in range(0,1+(sz-1)/MAX_LINES):
		if needvseparator:
			%HBox.add_child(VSeparator.new())
		var grid : GridContainer
		grid = newgrid()
		%HBox.add_child(grid)
		displayheader(grid)
		for isc in range(i*MAX_LINES, min(sz,(i+1)*MAX_LINES)):
			var highlightme = false
			if (me and player == scores[isc]["player"]) :
				me = false
				highlightme = true
			displayone(grid, isc+1, scores[isc], highlightme)
		needvseparator = true
	
func newgrid():
	var grid : GridContainer
	grid = GridContainer.new()
	grid.columns = 4
	return grid

func displayheader(grid : GridContainer):
	const HEADER_COLOR = Color(30, 80, 80)
	var label : Label
	label = Label.new()
	label.text = "#"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", HEADER_COLOR)
			
	grid.add_child(label)
	
	label = Label.new()
	label.text = "Joueur"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", HEADER_COLOR)
	grid.add_child(label)

	label = Label.new()
	label.text = "Score"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", HEADER_COLOR)
	grid.add_child(label)

	label = Label.new()
	label.text = "Date"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", HEADER_COLOR)
	grid.add_child(label)
	
	for i in grid.columns:
		grid.add_child(HSeparator.new())
		
func highlight(label : Label):
	label.add_theme_color_override("font_color", Color(255, 0, 0))
	
func highlightfirst(label : Label):
	label.add_theme_color_override("font_color", Color(0, 255, 0))
	
func displayone(grid : Container, rang : int, sc, \
				highlightme : bool):
	# Position dans le classement
	var pos = Label.new()
	pos.text = "%d" % rang
	if rang == 1 : highlightfirst(pos)
	if highlightme: highlight(pos)
	pos.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	grid.add_child(pos)
	
	# Nom du joueur
	var nom = Label.new()
	nom.text = sc["player"]
	if rang == 1 : highlightfirst(nom)
	if highlightme: highlight(nom)
	nom.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	grid.add_child(nom)
	
	# Nombre de points
	var val : Label = Label.new()
	val.text = "%d" % sc["pts"]
	val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if rang == 1 : highlightfirst(val)
	if highlightme: highlight(val)
	val.add_theme_font_size_override("font_size",25)
	grid.add_child(val)
	
	# Date du score enregistré
	var date = Label.new()
	date.text = sc["date"]
	date.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	if rang == 1 : highlightfirst(date)
	if highlightme: highlight(date)
	grid.add_child(date)

func _on_fermer_pressed():
	self.queue_free()
	pass # Replace with function body.
