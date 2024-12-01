extends Area2D

signal player_overlaps(is_overlapped)

func _physics_process(_delta):
	var overlaps = overlaps_area(get_parent().get_parent().get_node("Player/PlayerArea"))
	if overlaps:
		player_overlaps.emit(true)
	else:
		player_overlaps.emit(false)
