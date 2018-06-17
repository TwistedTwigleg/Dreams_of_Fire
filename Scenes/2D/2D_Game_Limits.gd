extends Node2D

export (NodePath) var path_to_player;
export (NodePath) var path_to_background;

func _ready():
	var player = get_node(path_to_player);
	var background = get_node(path_to_background);
	
	player.camera.limit_left = get_node("BL").global_transform.origin.x;
	player.camera.limit_right = get_node("TR").global_transform.origin.x;
	
	player.camera.limit_bottom = get_node("BL").global_transform.origin.y;
	player.camera.limit_top = get_node("TR").global_transform.origin.y;
	
	
	
	background.limit_left = get_node("BL").global_transform.origin.x;
	background.limit_right = get_node("TR").global_transform.origin.x;
	
	background.limit_bottom = get_node("BL").global_transform.origin.y;
	background.limit_top = get_node("TR").global_transform.origin.y;
