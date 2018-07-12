extends Control

const BUTTON_TO_ACTION_DICTIONARY = {
	"BTN_Move_Up": "Move_Up",
	"BTN_Move_Down": "Move_Down",
	"BTN_Move_Left": "Move_Left",
	"BTN_Move_Right": "Move_Right",
	"BTN_Dash": "Sprint",
	"BTN_Jump": "Jump",
	"BTN_Awake": "Change_Dimension",
	"BTN_Restart": "Restart",
};

const BUTTON_TO_NODE_DICTIONARY = {
	"BTN_Move_Up": null,
	"BTN_Move_Down": null,
	"BTN_Move_Left": null,
	"BTN_Move_Right": null,
	"BTN_Dash": null,
	"BTN_Jump": null,
	"BTN_Awake": null,
	"BTN_Restart": null,
};

var listing_for_rebind = false;
var rebind_label = null;
var rebind_button = "Move_Up";

func _ready():
	get_node("Button_MoveUp").connect("pressed", self, "rebind_button_pressed", ["BTN_Move_Up"]);
	get_node("Button_MoveDown").connect("pressed", self, "rebind_button_pressed", ["BTN_Move_Down"]);
	get_node("Button_MoveLeft").connect("pressed", self, "rebind_button_pressed", ["BTN_Move_Left"]);
	get_node("Button_MoveRight").connect("pressed", self, "rebind_button_pressed", ["BTN_Move_Right"]);
	get_node("Button_Dash").connect("pressed", self, "rebind_button_pressed", ["BTN_Dash"]);
	get_node("Button_Jump").connect("pressed", self, "rebind_button_pressed", ["BTN_Jump"]);
	get_node("Button_Awake").connect("pressed", self, "rebind_button_pressed", ["BTN_Awake"]);
	get_node("Button_Restart").connect("pressed", self, "rebind_button_pressed", ["BTN_Restart"]);
	
	BUTTON_TO_NODE_DICTIONARY["BTN_Move_Up"] = get_node("Button_MoveUp");
	BUTTON_TO_NODE_DICTIONARY["BTN_Move_Down"] = get_node("Button_MoveDown");
	BUTTON_TO_NODE_DICTIONARY["BTN_Move_Left"] = get_node("Button_MoveLeft");
	BUTTON_TO_NODE_DICTIONARY["BTN_Move_Right"] = get_node("Button_MoveRight");
	BUTTON_TO_NODE_DICTIONARY["BTN_Dash"] = get_node("Button_Dash");
	BUTTON_TO_NODE_DICTIONARY["BTN_Jump"] = get_node("Button_Jump");
	BUTTON_TO_NODE_DICTIONARY["BTN_Awake"] = get_node("Button_Awake");
	BUTTON_TO_NODE_DICTIONARY["BTN_Restart"] = get_node("Button_Restart");
	
	rebind_label = get_node("Rebind_Label");
	get_node("Options_Label_Sub").text = "Config file is saved at " + OS.get_user_data_dir();
	
	get_node("Button_Vsync").connect("pressed", self, "other_button_pressed", ["VSync"]);
	get_node("Button_Reset").connect("pressed", self, "other_button_pressed", ["Reset"]);
	get_node("Button_Fullscreen").connect("pressed", self, "other_button_pressed", ["Fullscreen"]);
	get_node("Button_Back").connect("pressed", self, "other_button_pressed", ["Back"]);
	
	load_input_from_file();
	update_binding_buttons();


func rebind_button_pressed(button_name):
	if (listing_for_rebind == true):
		return;
	
	
	listing_for_rebind = true;
	rebind_button = button_name;
	rebind_label.visible = true;
	
	BUTTON_TO_NODE_DICTIONARY[button_name].text = "...";


func _input(event):
	if (listing_for_rebind == true):
		if event is InputEventKey:
			if event.pressed == true and event.echo == false:
				InputMap.erase_action(BUTTON_TO_ACTION_DICTIONARY[rebind_button]);
				InputMap.add_action(BUTTON_TO_ACTION_DICTIONARY[rebind_button]);
				InputMap.action_add_event(BUTTON_TO_ACTION_DICTIONARY[rebind_button], event);
				
				listing_for_rebind = false;
				rebind_label.visible = false;
				
				BUTTON_TO_NODE_DICTIONARY[rebind_button].text = event.as_text();



func other_button_pressed(button_name):
	
	if (listing_for_rebind == true):
		return;
	
	
	if (button_name == "Back"):
		get_parent().get_node("Start_Screen").visible = true;
		visible = false;
		
		save_input_to_file();
		
		# Save the configuration in case the user made a change
		Globals.save_file();
	
	elif (button_name == "Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen;
		
		if (OS.window_fullscreen == true):
			get_node("Button_Fullscreen").text = "Windowed";
		else:
			get_node("Button_Fullscreen").text = "Fullscreen";
	
	elif (button_name == "Reset"):
		InputMap.load_from_globals();
		get_node("HScrollBar_Shader_Blur").value = 50;
		update_binding_buttons();
	
	elif (button_name == "VSync"):
		OS.vsync_enabled = !OS.vsync_enabled;
		
		if (OS.vsync_enabled == true):
			get_node("Button_Vsync").text = "VSync: ON";
		else:
			get_node("Button_Vsync").text = "VSync: OFF";


func update_binding_buttons():
	# Probably should find a more elegant way to do this...
	get_node("Button_MoveUp").text = InputMap.get_action_list("Move_Up")[0].as_text();
	get_node("Button_MoveDown").text = InputMap.get_action_list("Move_Down")[0].as_text();
	get_node("Button_MoveLeft").text = InputMap.get_action_list("Move_Left")[0].as_text();
	get_node("Button_MoveRight").text = InputMap.get_action_list("Move_Right")[0].as_text();
	get_node("Button_Dash").text = InputMap.get_action_list("Sprint")[0].as_text();
	get_node("Button_Jump").text = InputMap.get_action_list("Jump")[0].as_text();
	get_node("Button_Awake").text = InputMap.get_action_list("Change_Dimension")[0].as_text();
	get_node("Button_Restart").text = InputMap.get_action_list("Restart")[0].as_text();


func save_input_to_file():
	# Save inputs.
	# Adpated from (https://github.com/akien-mga/dynadungeons/blob/master/scripts/global.gd#L93)
	for action_name in BUTTON_TO_ACTION_DICTIONARY.values():
		var action = InputMap.get_action_list(action_name)[0];
		if action is InputEventKey:
			Globals.config_file.set_value("Input_Mapping", action_name, OS.get_scancode_string(action.scancode));
	
	var shader_value = get_node("HScrollBar_Shader_Blur").value;
	Globals.config_file.set_value("Shader_Values", "Shader_Blur", shader_value);


func load_input_from_file():
	if (Globals.config_file.has_section("Input_Mapping")):
		for action_name in Globals.config_file.get_section_keys("Input_Mapping"):
			var scan_code = OS.find_scancode_from_string(Globals.config_file.get_value("Input_Mapping", action_name));
			
			var new_event = InputEventKey.new();
			new_event.scancode = scan_code;
			
			InputMap.erase_action(action_name);
			InputMap.add_action(action_name);
			InputMap.action_add_event(action_name, new_event);
	
	if (Globals.config_file.has_section("Shader_Values")):
		if (Globals.config_file.has_section_key("Shader_Values", "Shader_Blur")):
			get_node("HScrollBar_Shader_Blur").value = Globals.config_file.get_value("Shader_Values", "Shader_Blur", 50);
	

