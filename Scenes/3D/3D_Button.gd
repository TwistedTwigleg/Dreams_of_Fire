extends Spatial

export (int, "green", "red", "blue") var key_color = 0;

var moving_down = false;
const DOWN_Y_TRANSLATION = -0.45;
const UP_Y_TRANSLATION = 0;

const BUTTON_TIME_MOD = 0.8;

var level_controller;
var button_meshes;

func _ready():
	
	button_meshes = get_node("Button_Meshes");
	
	button_meshes.get_node("Green_Button").visible = false;
	button_meshes.get_node("Red_Button").visible = false;
	button_meshes.get_node("Blue_Button").visible = false;
	
	if key_color == 0:
		button_meshes.get_node("Green_Button").visible = true;
	if key_color == 1:
		button_meshes.get_node("Red_Button").visible = true;
	if key_color == 2:
		button_meshes.get_node("Blue_Button").visible = true;
	
	# Get the second child, because the background music is the first child!
	level_controller = get_tree().root.get_child(1);
	
	get_node("Area").connect("body_entered", self, "body_entered");
	get_node("Area").connect("body_exited", self, "body_exitied");


func _physics_process(delta):
	if moving_down == true:
		if (button_meshes.translation.y > DOWN_Y_TRANSLATION):
			button_meshes.translation.y -= delta * BUTTON_TIME_MOD;
			if (button_meshes.translation.y <= DOWN_Y_TRANSLATION):
				if key_color == 0:
					level_controller.update_button("3D", "green", true);
				elif key_color == 1:
					level_controller.update_button("3D", "red", true);
				elif key_color == 2:
					level_controller.update_button("3D", "blue", true);
	else:
		if (button_meshes.translation.y < UP_Y_TRANSLATION):
			button_meshes.translation.y += delta * BUTTON_TIME_MOD;
			if (button_meshes.translation.y >= UP_Y_TRANSLATION):
				if key_color == 0:
					level_controller.update_button("3D", "green", false);
				elif key_color == 1:
					level_controller.update_button("3D", "red", false);
				elif key_color == 2:
					level_controller.update_button("3D", "blue", false);


func body_entered(body):
	if "IS_PLAYER" in body:
		moving_down = true;

func body_exitied(body):
	if "IS_PLAYER" in body:
		moving_down = false;
