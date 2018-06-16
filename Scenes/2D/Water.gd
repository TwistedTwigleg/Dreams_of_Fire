extends Node2D

const FRAME_TIME = 0.3;
var frame_timer = 0;

func _ready():
	get_node("Area2D").connect("body_entered", self, "water_entered");

func _process(delta):
	frame_timer += delta;
	if (frame_timer >= FRAME_TIME):
		frame_timer -= FRAME_TIME;
		if (get_node("Sprite").frame == 0):
			get_node("Sprite").frame = 1
		else:
			get_node("Sprite").frame = 0

func water_entered(body):
	if "velocity" in body:
			body.velocity.y = -300;
	if "increased_gravity" in body:
		body.increased_gravity = 0;
	if "can_dash" in body:
		body.can_dash = true;