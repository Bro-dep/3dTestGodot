@tool 
extends SubViewport

@onready var text_file :String = $"..".text_file_location
#@onready var font_size:int = $"..".font_size
@onready var lable = $Label
#@onready var font_theme = $Label.theme
@onready var file = FileAccess.open(text_file,FileAccess.READ)
@onready var text_content = file.get_as_text()

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(text_content)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	lable.text = text_content
	#font_theme.theme_override_font_sizes/font_size
	self.size = lable.size
	
