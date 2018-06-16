extends Node2D

export (int, "green", "red", "blue") var key_color = 0;

var moving_down = false;
var starting_frame = 0;

const FRAME_TIME = 0.4;
var frame_timer = 0;

var level_controller;
var sprite;

func _ready():
	
	sprite = get_node("Sprite");
	
	if key_color == 0:
		sprite.frame = 4;
	if key_color == 1:
		sprite.frame = 0;
	if key_color == 2:
		sprite.frame = 8;
	
	starting_frame = sprite.frame;
	
	level_controller = get_tree().root.get_child(0);
	
	get_node("Area2D").connect("body_entered", self, "body_entered");
	get_node("Area2D").connect("body_exited", self, "body_exitied");


func _physics_process(delta):
	if moving_down == true:
		if (sprite.frame != starting_frame + 3):
			frame_timer += delta;
			if (frame_timer >= FRAME_TIME):
				sprite.frame += 1;
				frame_timer -= FRAME_TIME;
				
				if (sprite.frame == starting_frame + 3):
					if key_color == 0:
						level_controller.update_button("2D", "green", true);
					elif key_color == 1:
						level_controller.update_button("2D", "red", true);
					elif key_color == 2:
						level_controller.update_button("2D", "blue", true);
	else:
		if (sprite.frame != starting_frame):
			frame_timer += delta;
			if (frame_timer >= FRAME_TIME):
				sprite.frame -= 1;
				frame_timer -= FRAME_TIME;
				
				if (sprite.frame == starting_frame):
					if key_color == 0:
						level_controller.update_button("2D", "green", false);
					elif key_color == 1:
						level_controller.update_button("2D", "red", false);
					elif key_color == 2:
						level_controller.update_button("2D", "blue", false);


func body_entered(body):
	if "IS_PLAYER" in body:
		moving_down = true;
		frame_timer = 0;

func body_exitied(body):
	if "IS_PLAYER" in body:
		moving_down = false;
		frame_timer = 0;

