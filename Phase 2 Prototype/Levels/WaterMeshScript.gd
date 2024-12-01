extends Area2D

func _physics_process(_delta):
	var overlap = get_overlapping_areas()
	for i in overlap:
		if i.name == "PlayerArea":
			i.get_parent().speed = 250

func _on_area_exited(area):
	if area.name == "PlayerArea":
		var player_node = area.get_parent()
		player_node.speed = 800
