extends Node

var audio_player;

var audio_streams = {
	"Fire_BG":preload("res://Audio/GameSounds_XYZ/Public_Domain_Ambient/Ambient_A_Zyow.ogg"),
	"Ice_BG":preload("res://Audio/GameSounds_XYZ/Public_Domain_Ambient/I.ogg"),
	};

var audio_positions = {
	"Fire_BG":0,
	"Ice_BG":0,
};

var current_audio_name = null;

func _ready():
	audio_player = AudioStreamPlayer.new();
	add_child(audio_player);

func change_music(new_audio_name, force_from_start = false):
	if (new_audio_name != current_audio_name):
		if (new_audio_name in audio_streams):
			
			# Get the old position
			if (current_audio_name != null):
				audio_positions[current_audio_name] = audio_player.get_playback_position();
			
			audio_player.stop();
			audio_player.stream = audio_streams[new_audio_name];
			
			if (force_from_start == true):
				audio_positions[new_audio_name] = 0;
			
			audio_player.play(audio_positions[new_audio_name]);
			
			current_audio_name = new_audio_name;
	else:
		print ("Error: Cannot play unkown background music: ", new_audio_name);
