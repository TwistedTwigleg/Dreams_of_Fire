extends Node

var button_red_down = {"2D":false, "3D":false};
var button_blue_down = {"2D":false, "3D":false};
var button_green_down = {"2D":false, "3D":false};

var red_button_blocks = [];
var blue_button_blocks = [];
var green_button_blocks = [];


var red_key_got = false;
var blue_key_got = false;
var green_key_got = false;

var red_key_blocks = [];
var blue_key_blocks = [];
var green_key_blocks = [];


var texture_rectangle;
var fire_dimension_viewport;
var ice_dimension_viewport;

var ice_crystal_got = false;
var fire_cystal_got = false;

var ice_level_visible = false;
var fire_level_visible = false;

const FIRE_VIGNETTE_STRENGTH = 0.3;
const ICE_VIGNETTE_STRENGTH = 0;
const BLACK_VIGNETTE_STRENGTH = -1;
var shader_strength;
var shader_vignetee;

var level_changing = false;

func _ready():
	texture_rectangle = get_node("TextureRect");
	fire_dimension_viewport = get_node("2D");
	ice_dimension_viewport = get_node("3D");
	
	shader_vignetee = get_node("Shader_Vignette");
	shader_strength = FIRE_VIGNETTE_STRENGTH;
	shader_vignetee.material.set_shader_param("fade_strength", shader_strength);
	
	fire_level_visible = true;
	texture_rectangle.texture = fire_dimension_viewport.get_texture();
	# Free the mouse (needed for the camera
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	if Input.is_action_just_pressed("Change_Dimension") and level_changing == false:
		level_changing = true;
		shader_vignetee.visible = true;
		shader_vignetee.modulate.a = 1;
	
	
	if (level_changing == true):
		
		shader_strength -= delta;
		shader_vignetee.material.set_shader_param("fade_strength", shader_strength);
		
		if (shader_strength <= BLACK_VIGNETTE_STRENGTH):
			if fire_level_visible == true:
				fire_level_visible = false;
				ice_level_visible = true;
				
				texture_rectangle.texture = ice_dimension_viewport.get_texture();
				
				# Capture the mouse (needed for the camera
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				
				level_changing = false;
			else:
				fire_level_visible = true;
				ice_level_visible = false;
				
				texture_rectangle.texture = fire_dimension_viewport.get_texture();
				
				# Free the mouse (needed for the camera
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
				level_changing = false;
	
	elif (level_changing == false):
		if (fire_level_visible == true):
			if (shader_strength < FIRE_VIGNETTE_STRENGTH):
				shader_strength += delta;
		else:
			if (shader_strength < ICE_VIGNETTE_STRENGTH):
				shader_strength += delta;
				shader_vignetee.modulate.a -= delta;
				if (shader_strength >= ICE_VIGNETTE_STRENGTH):
					shader_vignetee.visible = false;
		shader_vignetee.material.set_shader_param("fade_strength", shader_strength);


func _input(event):
	if (fire_level_visible == true):
		fire_dimension_viewport.input(event);
	elif (ice_level_visible == true):
		ice_dimension_viewport.input(event);


func update_button(dimension="2D", color="red", state=true):
	if (color == "red"):
		button_red_down[dimension] = state;
		
		if (button_red_down["2D"] == true or button_red_down["3D"] == true):
			for block in red_button_blocks:
				block.button_down();
		else:
			for block in red_button_blocks:
				block.button_not_down();
		
	
	elif (color == "blue"):
		button_blue_down[dimension] = state;
		
		if (button_blue_down["2D"] == true or button_blue_down["3D"] == true):
			for block in blue_button_blocks:
				block.button_down();
		else:
			for block in blue_button_blocks:
				block.button_not_down();
	
	
	elif (color == "green"):
		button_green_down[dimension] = state;
		
		if (button_green_down["2D"] == true or button_green_down["3D"] == true):
			for button in green_button_blocks:
				button.button_down();
		else:
			for button in green_button_blocks:
				button.button_not_down();


func key_gotten(color="red"):
	if color == "red":
		if (red_key_got == false):
			for block in red_key_blocks:
				block.key_gotten();
		red_key_got = true;
	elif color == "blue":
		if (blue_key_got == false):
			for block in blue_key_blocks:
				block.key_gotten();
		blue_key_got = true;
	elif color == "green":
		if (green_key_got == false):
			for block in green_key_blocks:
				block.key_gotten();
		green_key_got = true;
