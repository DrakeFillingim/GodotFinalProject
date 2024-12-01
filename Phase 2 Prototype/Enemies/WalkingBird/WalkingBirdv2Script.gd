extends Enemy

var sound_list = [
	load(sound_path + "Awk.mp3"),
	load(sound_path + "Caw.mp3"),
	load(sound_path + "Cacaw.mp3")
]

func _ready():
	super._ready()
	$AnimatedSprite.play("walk")


func _on_damage_taken_timer_timeout():
	$AnimatedSprite.modulate = Color(1.0, 1.0, 1.0)


func _on_area_area_entered(area):
	if area.is_in_group("rangs"):
		play_sound(sound_list)
		take_damage(area.damage)
		check_death()
	if area.owner == player_node:
		deal_damage()


func _on_audio_stream_player_finished():
	if killed:
		sound_finished = true
