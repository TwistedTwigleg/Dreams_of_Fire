extends Control

const PATH_TO_TITLESCREEN = "res://Scenes/TitleScreen.tscn";

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	get_node("Button_Jam_Entries").connect("pressed", self, "button_pressed", ["Jam_Entries"]);
	get_node("Button_Github_Repo").connect("pressed", self, "button_pressed", ["Github_Repo"]);
	get_node("Button_Return_Title").connect("pressed", self, "button_pressed", ["Return_Title"]);
	get_node("Button_Quit").connect("pressed", self, "button_pressed", ["Quit"]);
	
	Background_Music.change_music("Ice_BG", true);


func button_pressed(button_name):
	if (button_name == "Jam_Entries"):
		OS.shell_open("https://itch.io/jam/godotjam062018");
	elif (button_name == "Github_Repo"):
		OS.shell_open("https://github.com/TwistedTwigleg/Dreams_of_Fire")
	elif (button_name == "Return_Title"):
		get_tree().change_scene(PATH_TO_TITLESCREEN);
	elif (button_name == "Quit"):
		get_tree().quit();
