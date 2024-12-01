extends Area2D

@export var health_amount := 1

func _on_area_entered(area):
	print(area)
	if area.name == "PlayerArea":
		var delete = area.owner.heal(health_amount)
		if delete:
			queue_free()
