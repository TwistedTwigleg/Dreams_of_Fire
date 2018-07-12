extends Node2D

export (int, "green", "red", "blue") var key_color = 0;

func _ready():
	if key_color == 0:
		get_node("Sprite").frame = 1;
	if key_color == 1:
		get_node("Sprite").frame = 2;
	if key_color == 2:
		get_node("Sprite").frame = 0;
	
	get_node("Area2D").connect("body_entered", self, "body_entered");
	
	set_physics_process(false);


func _physics_process(delta):
	get_node("Area2D").monitoring = false;
	queue_free();


func body_entered(body):
	if "IS_PLAYER" in body:
		
		# Get the third child, because the loaded scene is placed after auto load scripts!
		var level_controller = get_tree().root.get_child(2);
		
		if key_color == 0:
			level_controller.key_gotten("green");
		if key_color == 1:
			level_controller.key_gotten("red");
		if key_color == 2:
			level_controller.key_gotten("blue");
		
		set_physics_process(true);
