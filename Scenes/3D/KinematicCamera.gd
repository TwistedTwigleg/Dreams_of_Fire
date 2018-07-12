extends KinematicBody

export (NodePath) var path_to_target;
export (NodePath) var path_to_camera_origin;
export (float) var max_length_from_target = 9;

var target;
var camera_origin;

func _ready():
	target = get_node(path_to_target);
	camera_origin = get_node(path_to_camera_origin);
	
	add_collision_exception_with(get_parent());
	get_parent().add_collision_exception_with(self);

func _physics_process(delta):
	
	var relative_vector = (target.global_transform.origin - global_transform.origin);
	
	if (relative_vector.length() >= max_length_from_target):
		global_transform.origin += relative_vector;
	else:
		global_transform = camera_origin.global_transform;
		var new_dir_vector = (target.global_transform.origin - global_transform.origin);
		move_and_collide(new_dir_vector);
		
	global_transform.basis = target.global_transform.basis;
