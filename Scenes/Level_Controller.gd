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

var dimension_changing = false;

export (String, FILE) var next_level;
export (String, FILE) var restart_level;
export (String) var level_name = "Legacy Code";
var level_name_fade = 1.0;
var level_name_label = null;
const LEVEL_NAME_FADE_STRENGTH = 0.5;

export (bool) var no_fire_level = false;
export (bool) var no_ice_level = false;

const PAUSE_POPUP_SCENE = preload("res://Scenes/Pause_Menu.tscn");
var pause_popup = null;


func _ready():
	texture_rectangle = get_node("TextureRect");
	fire_dimension_viewport = get_node("2D");
	ice_dimension_viewport = get_node("3D");
	
	shader_vignetee = get_node("Shader_Vignette");
	shader_strength = FIRE_VIGNETTE_STRENGTH;
	shader_vignetee.material.set_shader_param("fade_strength", shader_strength);
	
	if (no_fire_level == false):
		# Because of how we are entering, we need to have the opposite level/dimension
		# visible first, so we switch to the proper one
		fire_level_visible = false;
		ice_level_visible = true;
	else:
		# Because of how we are entering, we need to have the opposite level/dimension
		# visible first, so we switch to the proper one
		ice_level_visible = false;
		fire_level_visible = true;
	
	shader_strength = BLACK_VIGNETTE_STRENGTH;
	shader_vignetee.visible = true;
	shader_vignetee.material.set_shader_param("fade_strength", shader_strength);
	
	if (Globals.config_file.has_section("Shader_Values")):
		if (Globals.config_file.has_section_key("Shader_Values", "Shader_Blur")):
			shader_vignetee.material.set_shader_param("blur_strength", (Globals.config_file.get_value("Shader_Values", "Shader_Blur", 50) / 100) * 4);
		else:
			shader_vignetee.material.set_shader_param("blur_strength", 2);
	else:
		shader_vignetee.material.set_shader_param("blur_strength", 2);
	
	dimension_changing = true;
	
	if (no_fire_level == true):
		crystal_gotten("2D");
	if (no_ice_level == true):
		crystal_gotten("3D");
	
	level_name_label = get_node("Level_Name_Label");
	level_name_label.text = level_name;
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	# Changing dimensions
	if Input.is_action_just_pressed("Change_Dimension") and dimension_changing == false:
		# We do not want to be able to change dimensions if there is only one
		if (no_fire_level == true or no_ice_level == true):
			pass
		else:
			dimension_changing = true;
			shader_vignetee.visible = true;
			shader_vignetee.modulate.a = 1;
	
	# Opening the pause menu popup, if there is not one open
	if Input.is_action_just_pressed("ui_cancel"):
		if (pause_popup == null):
			pause_popup = PAUSE_POPUP_SCENE.instance();
			add_child(pause_popup);
			pause_popup.level_controller = self;
			pause_popup.popup_centered();
			get_tree().paused = true;
	
	
	if (level_name_label.modulate.a > 0):
		level_name_label.modulate.a -= delta * LEVEL_NAME_FADE_STRENGTH;
	
	if Input.is_action_just_pressed("Restart"):
		get_tree().change_scene(restart_level);
	
	if (dimension_changing == true):
		
		shader_strength -= delta;
		shader_vignetee.material.set_shader_param("fade_strength", shader_strength);
		
		if (shader_strength <= BLACK_VIGNETTE_STRENGTH):
			
			# Is the level done? Should we move on to the next level?
			if (fire_cystal_got == true and ice_crystal_got == true):
				get_tree().change_scene(next_level);
			
			
			if fire_level_visible == true:
				fire_level_visible = false;
				ice_level_visible = true;
				
				texture_rectangle.texture = ice_dimension_viewport.get_texture();
				dimension_changing = false;
				
				# Change the music
				Background_Music.change_music("Ice_BG");
			
			else:
				fire_level_visible = true;
				ice_level_visible = false;
				
				texture_rectangle.texture = fire_dimension_viewport.get_texture();
				dimension_changing = false;
				
				# Change the music
				Background_Music.change_music("Fire_BG");
	
	
	elif (dimension_changing == false):
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


func crystal_gotten(dimension="2D"):
	if (dimension == "3D"):
		fire_cystal_got = true;
		if (no_ice_level == false):
			get_node("Fire_Gem_Icon").visible = true;
			get_node("Gem_Panel").visible = true;
	elif (dimension == "2D"):
		ice_crystal_got = true;
		if (no_fire_level == false):
			get_node("Ice_Gem_Icon").visible = true;
			get_node("Gem_Panel").visible = true;
	
	if (fire_cystal_got == true and ice_crystal_got == true):
		dimension_changing = true;
		shader_vignetee.visible = true;
		shader_vignetee.modulate.a = 1;

