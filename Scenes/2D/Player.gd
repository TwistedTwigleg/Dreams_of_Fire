extends KinematicBody2D

const IS_PLAYER = true;
var velocity = Vector2();

const SPEED = 80;
const JUMP_SPEED = 200;
const HOP_SPEED = 40;
const GRAVITY = 30;

var increased_gravity = 0;
const INCREASED_GRAVIY_STEP = 10;

const ACCEL = 16;
const DEACCEL = 14;

const DASH_SPEED = 20;
const DASH_TIME = 0.15;
var dash_timer = 0;
var is_dashing = false;
var can_dash = false;
var dash_direction = Vector2();
var up_dash = false;

var is_jumping = false;

const MERCY_TIME = 0.2;
var mercy_timer = 0;
var grounded = true;

var direction_movement = Vector2();

var camera;

var animation_player;
const ANIMATION_SPEEDS = {
	"Idle":1,
	"In_Air":1.5,
	"Jump_Start":3,
	"Jump_End":3,
}

var level_controller;

func _ready():
	animation_player = get_node("AnimationPlayer");
	animation_player.play("Idle");
	animation_player.connect("animation_finished", self, "animation_finished");
	
	camera = get_node("Camera2D");
	
	# Get the third child, because the loaded scene is placed after auto load scripts!
	level_controller = get_tree().root.get_child(2);


func _physics_process(delta):
	if (level_controller.fire_level_visible == true):
		if (self.global_position.y < camera.limit_bottom + 64):
			process_grounded(delta);
			process_input(delta);
			process_movement(delta);


func process_grounded(delta):
	get_node("RayCast2D").force_raycast_update();
	if get_node("RayCast2D").is_colliding():
		grounded = true;
		mercy_timer = 0;
		can_dash = true;
		up_dash = false;
		
		if (animation_player.current_animation == "In_Air"):
			change_animation("Jump_End");
		
	else:
		mercy_timer += delta;
		if mercy_timer >= MERCY_TIME:
			grounded = false;


func process_input(delta):
	# Directional movement
	direction_movement = Vector2();
	
	# We only want to be able to move while in the air, forcing the player to jump to move
	# for the majority of the game's movement. Feedback from the jam has shown me people
	# want to be able to move while on the ground.
	if (grounded == false and is_dashing == false):
		if Input.is_action_pressed("Move_Right"):
			direction_movement.x = 1;
		if Input.is_action_pressed("Move_Left"):
			direction_movement.x = -1;
		
		# Dashing
		if Input.is_action_pressed("Sprint") and can_dash == true:
			if (direction_movement.x != 0):
				is_dashing = true;
				dash_timer = 0;
				can_dash = false;
				dash_direction = direction_movement;
		
	else:
		
		if (animation_player.current_animation == "Idle"):
			if Input.is_action_pressed("Move_Up") or Input.is_action_pressed("Jump"):
				velocity.y = -HOP_SPEED;
				change_animation("Jump_Start");
				is_jumping = true;
		
		if (is_dashing == false and is_jumping == false):
			if Input.is_action_pressed("Move_Right"):
				direction_movement.x = 1;
			elif Input.is_action_pressed("Move_Left"):
				direction_movement.x = -1;


func process_movement(delta):
	
	direction_movement = direction_movement.normalized();
	
	if (grounded == false and is_dashing == false):
		increased_gravity += INCREASED_GRAVIY_STEP * delta;
		velocity.y += increased_gravity;
	else:
		increased_gravity = 0;
	
	if (is_dashing == true):
		
		dash_timer += delta;
		if (dash_timer <= DASH_TIME):
			if (is_on_wall() == false and up_dash == false):
				
				if (dash_direction.x == 0):
					#dash_direction.x = 1;
					pass
				
				velocity.y = 0;
				velocity.x = dash_direction.x * SPEED * 5;
				get_node("Sprite").rotation_degrees = 90 * sign(velocity.x);
			else:
				velocity.x = 0;
				velocity.y = -SPEED * 2;
				get_node("Sprite").rotation_degrees = 0;
				up_dash = true;
		else:
			is_dashing = false;
		
		move_and_slide(velocity, Vector2(0, -1));
	else:
		
		# add gravity
		velocity.y += GRAVITY * delta;
		
		# add movement
		var hvel = velocity;
		hvel.y = 0;
		var target = direction_movement;
		target *= SPEED;
		
		var accel;
		if direction_movement.dot(hvel) > 0:
			accel = ACCEL;
		else:
			accel = DEACCEL;
		
		hvel = hvel.linear_interpolate(target, accel*delta);
		velocity.x = hvel.x;
		
		velocity = move_and_slide(velocity, Vector2(0, -1));
		
		get_node("Sprite").rotation_degrees = clamp(velocity.x, -10, 10);


func animation_finished(animation_name):
	if (animation_name == "Idle"):
		change_animation("Idle");
	
	if (animation_name == "In_Air"):
		change_animation("In_Air");
	
	if (animation_name == "Jump_Start"):
		if (is_jumping == true):
			velocity.y = -JUMP_SPEED;
			is_jumping = false;
		
		change_animation("In_Air");
	
	if (animation_name == "Jump_End"):
		change_animation("Idle");

func change_animation(animation_name):
	if animation_player.current_animation == animation_name:
		pass
	else:
		animation_player.play(animation_name, -1, ANIMATION_SPEEDS[animation_name]);

