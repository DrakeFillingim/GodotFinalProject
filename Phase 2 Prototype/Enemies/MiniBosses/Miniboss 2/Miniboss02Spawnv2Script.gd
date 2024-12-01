extends Enemy

signal died

func _ready():
	super._ready()
	direction *= -1
	$AnimatedSprite.play("walk")


func _on_damage_taken_timer_timeout():
	$AnimatedSprite.modulate = Color(1.0, 1.0, 1.0)


func _on_area_area_entered(area):
	if area.is_in_group("rangs"):
		take_damage(area.damage)
		check_death(died)
	if area.owner == player_node:
		deal_damage()
