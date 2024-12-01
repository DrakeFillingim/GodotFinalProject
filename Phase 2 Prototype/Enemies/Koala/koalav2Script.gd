extends Enemy

var sound_list = [
	load("res://Assests/Music/Koalagrunt.mp3")
]

var attack_sound = load("res://Assests/Music/EnemyProjectileSwoosh.mp3")

@export var koala_projectile : PackedScene

@export var attack_range := 1150

var animate_windup := false
var animate_throw := false
var attack_player = false

func _ready():
	super._ready()
	$AttackRange/CollisionShape2D.shape.radius = attack_range

func _physics_process(_delta):
	if killed:
		$Area.remove_from_group("enemies")
		$AttackTimer.stop()
		$TelegraphTimer.stop()
		$ThrowTimer.stop()
		alpha -= 0.04
		$AnimatedSprite.modulate.a = alpha
		if alpha <= 0 and sound_finished:
			queue_free()


func _process(_delta):
	if player_node.global_position.x > global_position.x:
		$AnimatedSprite.flip_h = true
	if player_node.global_position.x < global_position.x:
		$AnimatedSprite.flip_h = false

	if animate_windup:
		$AnimatedSprite.play("windup")
	elif animate_throw:
		$AnimatedSprite.play("throw")
	else:
		$AnimatedSprite.play("idle")


func _on_attack_range_area_entered(area):
	if area.name == "PlayerArea":
		attack_player = true


func _on_attack_range_area_exited(area):
	if area.name == "PlayerArea":
		attack_player = false

func _on_attack_timer_timeout():
	if attack_player:
		animate_windup = false
		animate_throw = true
		var new_projectile = koala_projectile.instantiate()
		get_parent().add_child(new_projectile)
		new_projectile.global_position = global_position
		new_projectile.direction = global_position.direction_to(get_parent().get_node("Player").global_position)
		$TelegraphTimer.start()
		$ThrowTimer.start()
		$AudioStreamPlayer.stream = attack_sound
		$AudioStreamPlayer.play()


func _on_throw_timer_timeout():
	animate_throw = false


func _on_telegraph_timer_timeout():
	if attack_player:
		animate_windup = true


func _on_damage_taken_timer_timeout():
	$AnimatedSprite.modulate = Color(1.0, 1.0, 1.0)


func _on_audio_stream_player_finished():
	if killed:
		sound_finished = true


func _on_area_area_entered(area):
	if area.is_in_group("rangs") and not killed:
		play_sound(sound_list)
		take_damage(area.damage)
		check_death()
	if area.owner == player_node:
		deal_damage()
