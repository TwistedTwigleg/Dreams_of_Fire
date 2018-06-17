extends Sprite

var limit_left = -10000;
var limit_right = 10000;
var limit_top = -10000;
var limit_bottom = 10000;

var width;
var height;

export (NodePath) var path_to_target;
var target;

func _ready():
	target = get_node(path_to_target);
	
	width = texture.get_width();
	height = texture.get_height();

func _process(delta):
	global_position = target.global_position;
	
	if global_position.x - (width/2) < limit_left:
		global_position.x = limit_left + (width/2);
	
	if global_position.x + (width/2) > limit_right:
		global_position.x = limit_right - (width/2);
	
	if global_position.y - (height/2) < limit_top:
		global_position.y = limit_top + (height/2);
	
	if global_position.y + (height/2) > limit_bottom:
		global_position.y = limit_bottom - (height/2);
