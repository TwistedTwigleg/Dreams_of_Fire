extends KinematicBody

const IS_PLAYER = true;

const GRAVITY = -14.8
var increased_gravity = 0;
const INCREASED_GRAVIY_STEP = -8;

const DASH_SPEED = 20;
const DASH_TIME = 0.18;
var dash_timer = 0;
var is_dashing = false;
var can_dash = false;
var dash_direction = Vector2();

var vel = Vector3()
const MAX_SPEED = 10
const JUMP_SPEED = 10
const ACCEL= 4.5
var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var camera_holder_y;
var camera_holder_x;
var camera_target;

var MOUSE_SENSITIVITY = 0.05

const MAX_ZOOM = -12;
const MIN_ZOOM = -20;
const ZOOM_SPEED = 2;


var animation_player;

var level_controller;

const MAX_Y_VALUE = -20;

func _ready():
	camera = get_node("KinematicCamera/Camera");
	camera_holder_y = get_node("Camera_Holder_Y");
	camera_holder_x = get_node("Camera_Holder_Y/Camera_Holder_X");
	camera_target = get_node("Camera_Holder_Y/Camera_Holder_X/Target");
	
	animation_player = get_node("Scene Root/AnimationPlayer");
	animation_player.connect("animation_finished", self, "animation_finished");
	animation_player.play("Idle");
	
	# Get the third child, because the loaded scene is placed after auto load scripts!
	level_controller = get_tree().root.get_child(2);


func _physics_process(delta):
	if (level_controller.ice_level_visible == true):
		if (global_transform.origin.y > -20):
			process_input(delta)
			process_movement(delta)


func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if (animation_player.current_animation == "Idle" or animation_player.current_animation == "Walk"
		or animation_player.current_animation == "Jump_Mid_Air"):
		if Input.is_action_pressed("Move_Up"):
			input_movement_vector.y += 1
		if Input.is_action_pressed("Move_Down"):
			input_movement_vector.y -= 1
		if Input.is_action_pressed("Move_Left"):
			input_movement_vector.x -= 1
		if Input.is_action_pressed("Move_Right"):
			input_movement_vector.x = 1

	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
	dir += cam_xform.basis.x.normalized() * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping and Dashing
	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			play_animation("Jump_Start", 0.2, 4);
		
		can_dash = true;
	
	else:
		if Input.is_action_just_pressed("Sprint"):
			if can_dash == true:
				is_dashing = true;
				dash_direction = dir;
				can_dash = false;
				dash_timer = 0;
				play_animation("Dash", -1, 3);
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	if (is_dashing == false):
		vel.y += delta*GRAVITY
		
		if (is_on_floor() == true):
			increased_gravity = 0;
		else:
			increased_gravity += delta * INCREASED_GRAVIY_STEP;
			vel.y += delta*increased_gravity
	
		var hvel = vel
		hvel.y = 0
	
		var target = dir
		target *= MAX_SPEED
	
		var accel
		if dir.dot(hvel) > 0:
			accel = ACCEL
		else:
			accel = DEACCEL
	
		hvel = hvel.linear_interpolate(target, accel*delta)
		vel.x = hvel.x
		vel.z = hvel.z
		vel = move_and_slide(vel, Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
		
		if (dir.dot(hvel) > 0):
			get_node("Scene Root").rotation_degrees.y = camera_holder_y.rotation_degrees.y;
		
		if (is_on_floor()):
			if (animation_player.current_animation == "Idle" or animation_player.current_animation == "Walk"):
				if (dir.x != 0 or dir.z != 0):
					play_animation("Walk", 0.2, 4);
				else:
					play_animation("Idle", 0.2);
			elif (animation_player.current_animation == "Jump_Mid_Air"):
				play_animation("Jump_Land", 0.2, 4);
	
	
	else:
		
		dash_timer += delta;
		if (dash_timer <= DASH_TIME):
			if (is_on_wall() == false):
				
				if (dash_direction.x == 0 and dash_direction.z == 0):
					dash_direction = -camera.global_transform.basis.z.normalized();
				
				dash_direction.normalized();
				
				vel = dash_direction * MAX_SPEED * 3;
				vel.y = 0;
				
				get_node("Scene Root").rotation_degrees.y = camera_holder_y.rotation_degrees.y;
				
		else:
			is_dashing = false;
			play_animation("Jump_Mid_Air", 0.2, 1);
		
		vel = move_and_slide(vel, Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))


func _input(event):
	if (level_controller.ice_level_visible == true):
		
		if event is InputEventMouseMotion:
			camera_holder_y.rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
			
			camera_holder_x.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY));
			camera_holder_x.rotation_degrees.x = clamp(camera_holder_x.rotation_degrees.x, -80, 80);
		
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_WHEEL_UP:
				if (camera_target.translation.z < MAX_ZOOM):
					if (event.factor != 0):
						camera_target.translation.z += ZOOM_SPEED * event.factor;
					else:
						camera_target.translation.z += ZOOM_SPEED / 2;
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if (camera_target.translation.z > MIN_ZOOM):
					if (event.factor != 0):
						camera_target.translation.z -= ZOOM_SPEED * event.factor;
					else:
						camera_target.translation.z -= ZOOM_SPEED / 2;


func animation_finished(animation_name):
	if (animation_name == "Idle"):
		animation_player.play("Idle");
	if (animation_name == "Walk"):
		animation_player.play("Walk", -1, 4);
	if (animation_name == "Jump_Start"):
		vel.y = JUMP_SPEED
		animation_player.play("Jump_Mid_Air", 0.2);
	if (animation_name == "Jump_Mid_Air"):
		animation_player.play("Jump_Mid_Air");
	if (animation_name == "Jump_Land"):
		animation_player.play("Idle");


func play_animation(animation_name, blend_time = -1, speed = 1):
	if animation_name != animation_player.current_animation:
		animation_player.play(animation_name, blend_time, speed);

