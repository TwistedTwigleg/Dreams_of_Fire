extends Node2D

export (int, "green", "red", "blue") var block_color = 0;

func _ready():
	# Get the second child, because the background music is the first child!
	var level_controller = get_tree().root.get_child(1);
	
	if (block_color == 0):
		level_controller.green_button_blocks.append(self);
		get_node("Sprite").frame = 6;
	
	if (block_color == 1):
		level_controller.red_button_blocks.append(self);
		get_node("Sprite").frame = 7;
	
	if (block_color == 2):
		level_controller.blue_button_blocks.append(self);
		get_node("Sprite").frame = 5;


func button_down():
	get_node("StaticBody2D").collision_layer = 0;
	get_node("StaticBody2D").collision_mask = 0;
	
	get_node("Sprite").visible = false;

func button_not_down():
	get_node("StaticBody2D").collision_layer = 1;
	get_node("StaticBody2D").collision_mask = 1;
	
	get_node("Sprite").visible = true;