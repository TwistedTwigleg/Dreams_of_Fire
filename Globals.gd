extends Node

# For now this is only used for saving the config file!
# Maybe in the future this will be used for the level select screen...

const CONFIG_FILE_PATH = "user://Dreams_of_Fire.cfg";
var config_file;

func _ready():
	config_file = ConfigFile.new();
	
	if File.new().file_exists(CONFIG_FILE_PATH):
		config_file.load(CONFIG_FILE_PATH);


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_file();


func load_file():
	if File.new().file_exists(CONFIG_FILE_PATH):
		if config_file.load(CONFIG_FILE_PATH) != OK:
			print ("Error: Could not load config file");

func save_file():
	if config_file.save(CONFIG_FILE_PATH) != OK:
		print ("Error: Could not save config file");