extends Spatial

export (int, "green", "red", "blue") var key_color = 0;

func _ready():
	
	get_node("Key_Blue").visible = false;
	get_node("Key_Red").visible = false;
	get_node("Key_Green").visible = false;
	
	if key_color == 0:
		get_node("Key_Green").visible = true;
	if key_color == 1:
		get_node("Key_Red").visible = true;
	if key_color == 2:
		get_node("Key_Blue").visible = true;
	
	get_node("Area").connect("body_entered", self, "body_entered");
	set_physics_process(false);


func _physics_process(delta):
	get_node("Area").monitoring = false;
	queue_free();


func body_entered(body):
	if "IS_PLAYER" in body:
		var level_controller = get_tree().root.get_child(0);
		
		if key_color == 0:
			level_controller.key_gotten("green");
		if key_color == 1:
			level_controller.key_gotten("red");
		if key_color == 2:
			level_controller.key_gotten("blue");
		
		set_physics_process(true);
