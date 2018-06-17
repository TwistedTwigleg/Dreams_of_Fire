extends WindowDialog

export (String, FILE) var path_to_title;

var level_controller;

func _ready():
	get_node("Button_Quit").connect("pressed", self, "button_pressed", ["quit"]);
	get_node("Button_Resume").connect("pressed", self, "button_pressed", ["resume"]);
	
	connect("popup_hide", self, "button_pressed", ["resume"]);
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);


func button_pressed(button_name):
	if (button_name == "quit"):
		get_tree().paused = false;
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		get_tree().change_scene(path_to_title);
	elif (button_name == "resume"):
		get_tree().paused = false;
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		level_controller.pause_popup = null;
		queue_free();
