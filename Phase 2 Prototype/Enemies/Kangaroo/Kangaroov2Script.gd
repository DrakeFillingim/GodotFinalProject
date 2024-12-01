extends Enemy

@export var number_of_jumps := 1
var delta_t := 0.0
var point_array = []

var can_jump := true
@export var jump_cooldown := 1.0

@export var jump_speed := 1.5

var sound_list = [
	load(sound_path + "kangGrowl.mp3"),
	load(sound_path + "kangAngry.mp3"),
]


func _ready():
	super._ready()
	$JumpTimer.wait_time = jump_cooldown
	for i in $Path2D.curve.point_count:
		point_array.append($Path2D.curve.get_point_position(i))


func _physics_process(delta):
	if not killed:
		if can_jump:
			delta_t += delta * jump_speed * direction
			if delta_t >= 1 or delta_t <= 0:
				direction *= -1
				can_jump = false
				$JumpTimer.start()
		global_position = jump_cuve(point_array[0], point_array[1], point_array[2], delta_t) + start_position
	elif killed:
		$Area.remove_from_group("enemies")
		alpha -= 0.04
		$AnimatedSprite.modulate.a = alpha
		if alpha <= 0 and sound_finished:
			queue_free()


func jump_cuve(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r


func _on_area_area_entered(area):
	if area.is_in_group("rangs"):
		play_sound(sound_list)
		take_damage(area.damage)
		check_death()
	if area.owner == player_node:
		deal_damage()


func _on_jump_timer_timeout():
	can_jump = true


func _on_damage_taken_timer_timeout():
	$AnimatedSprite.modulate = Color(1.0, 1.0, 1.0)


func _on_audio_stream_player_finished():
	if killed:
		sound_finished = true
