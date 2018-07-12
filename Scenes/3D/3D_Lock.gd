extends Spatial

export (int, "green", "red", "blue") var key_color = 0;

func _ready():
	
	# Get the third child, because the loaded scene is placed after auto load scripts!
	var level_controller = get_tree().root.get_child(2);
	
	get_node("Lock_Tile_Green").visible = false;
	get_node("Lock_Tile_Red").visible = false;
	get_node("Lock_Tile_Blue").visible = false;
	
	if (key_color == 0):
		level_controller.green_key_blocks.append(self);
		get_node("Lock_Tile_Green").visible = true;
	
	if (key_color == 1):
		level_controller.red_key_blocks.append(self);
		get_node("Lock_Tile_Red").visible = true;
	
	if (key_color == 2):
		level_controller.blue_key_blocks.append(self);
		get_node("Lock_Tile_Blue").visible = true;


func key_gotten():
	get_node("StaticBody").collision_layer = 0;
	get_node("StaticBody").collision_mask = 0;
	
	get_node("Lock_Tile_Green").visible = false;
	get_node("Lock_Tile_Red").visible = false;
	get_node("Lock_Tile_Blue").visible = false;