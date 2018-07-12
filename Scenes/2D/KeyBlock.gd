extends Node2D

export (int, "green", "red", "blue") var key_color = 0;
export (bool) var faceless = false;

func _ready():
	# Get the third child, because the loaded scene is placed after auto load scripts!
	var level_controller = get_tree().root.get_child(2);
	
	if (key_color == 0):
		level_controller.green_key_blocks.append(self);
		get_node("Sprite").frame = 0;
	
	if (key_color == 1):
		level_controller.red_key_blocks.append(self);
		get_node("Sprite").frame = 1;
	
	if (key_color == 2):
		level_controller.blue_key_blocks.append(self);
		get_node("Sprite").frame = 2;
	
	if (faceless == true):
		get_node("Sprite").frame = 3;


func key_gotten():
	get_node("StaticBody2D").collision_layer = 0;
	get_node("StaticBody2D").collision_mask = 0;
	
	get_node("Sprite").visible = false;
	
