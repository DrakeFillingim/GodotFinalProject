extends Enemy

@export var point_array := []
@export var check_direction := true
@export var special_invert := 1
@export var looop := false


func _ready():
	if looop:
		patrol_path.loop = true
	start_position = global_position
	$Area.add_to_group("enemies")
	for length in point_array:
		length[0] *= 64
		length[1] *= 64
		$Path2D.curve.add_point(Vector2(length[0], length[1]))
	$AnimatedSprite.play("walk")
	flip_vertical()


func _physics_process(delta):
	if check_direction:
		change_direction()
	patrol_path.progress += speed * delta * direction
	global_position = patrol_path.position + start_position
	if killed:
		alpha -= 0.04
		$AnimatedSprite.modulate.a = alpha
		if alpha <= 0:
			queue_free()


func _process(_delta):
	if direction * special_invert == 1:
		$AnimatedSprite.flip_h = true
	if direction * special_invert == -1:
		$AnimatedSprite.flip_h = false


func flip_vertical():
	if gravity_factor == -1:
		$AnimatedSprite.flip_v = true


func _on_area_area_entered(area):
	if area.is_in_group("rangs"):
		take_damage(area.damage)
		check_death()
	if area.owner == player_node:
		deal_damage()


func _on_damage_taken_timer_timeout():
	$AnimatedSprite.modulate = Color(1.0, 1.0, 1.0)
