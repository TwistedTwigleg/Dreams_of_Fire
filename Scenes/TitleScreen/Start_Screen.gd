extends Control

export (String, FILE) var first_level;

func _ready():
	get_node("Button_Start").connect("pressed", self, "button_pressed", ["start"])
	get_node("Button_Quit").connect("pressed", self, "button_pressed", ["quit"])
	
	Background_Music.change_music("Ice_BG", true);

func button_pressed(button_name):
	if (button_name == "start"):
		get_tree().change_scene(first_level);
	elif (button_name == "quit"):
		get_tree().quit();
