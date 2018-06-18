extends Spatial

export (String, MULTILINE) var text = "Placeholder";

func _ready():
	get_node("Viewport/Control/Label").text = text;
	
	var new_mat =  SpatialMaterial.new();
	
	new_mat.flags_unshaded = true;
	new_mat.albedo_texture = get_node("Viewport").get_texture();
	get_node("MeshInstance").set_surface_material(0, new_mat);
