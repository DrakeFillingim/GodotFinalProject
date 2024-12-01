extends CharacterBody2D

@export var knockback := 16000
@export var damage := 2
@export var health := 15

@export var max_spawns = 3
var current_spawns = 0

var player_node
@export var miniboss02_spawns : PackedScene
@export var miniboss02_projectile : PackedScene
@export var next_level_teleporter : PackedScene

var attack_sound = load("res://Assests/Music/EnemyProjectileSwoosh.mp3")

signal gravity_warning
signal gravity_warning_delete

func _ready():
	player_node = get_parent().get_node("Player")


func _on_spawn_timer_timeout():
	if current_spawns < max_spawns:
		current_spawns += 1
		var new_spawn = miniboss02_spawns.instantiate()
		new_spawn.global_position = global_position
		new_spawn.died.connect(on_spawn_died)
		get_parent().add_child(new_spawn)


func on_spawn_died():
	current_spawns -= 1


func _on_gravity_reverse_timeout():
	player_node.gravity_factor *= -1
	player_node.get_node("CheckJumpReset").start()
	if player_node.gravity_factor == -1:
		player_node.gravity = -8000
		player_node.up_direction = Vector2(0, 1)
	else:
		player_node.gravity = 8000
		player_node.up_direction = Vector2(0, -1)
	gravity_warning_delete.emit()
	$gravity_reverse_warning.start()


func _on_enemy_miniboss_02_area_area_entered(area):
	if area.is_in_group("rangs"):
		$AnimatedSprite.modulate = Color(1.0, 0.5, 0.5)
		$DamageTakenTimer.start()
		health -= 1
		if health <= 0:
			var next_level_door = next_level_teleporter.instantiate()
			next_level_door.position = global_position
			next_level_door.level_number = "04"
			owner.call_deferred("add_child", next_level_door)
			if player_node.gravity_factor == -1:
				player_node.gravity = 8000
				player_node.up_direction = Vector2(0, -1)
				player_node.gravity_factor *= -1
			queue_free()
	if area.name == "PlayerArea":
		deal_damage(area.owner)

func deal_damage(player):
	player.take_damage(damage, get_knockback_amount(player))


func get_knockback_amount(player):
	if global_position.x > player.global_position.x:
		return knockback * -1
	return knockback


func _on_projectile_timer_timeout():
	var new_projectile = miniboss02_projectile.instantiate()
	get_parent().add_child(new_projectile)
	new_projectile.global_position = global_position
	var target_vector = global_position.direction_to(get_parent().get_node("Player").global_position)
	new_projectile.direction = target_vector
	new_projectile.get_node("Sprite2D").rotation = target_vector.angle()
	new_projectile.player_node = player_node
	$AudioStreamPlayer.stream = attack_sound
	$AudioStreamPlayer.play()


func _on_gravity_reverse_warning_timeout():
	gravity_warning.emit()


func _on_boss_teleporter_player_teleported():
	$spawn_timer.start()
	$projectile_timer.start()


func _on_damage_taken_timer_timeout():
	$AnimatedSprite.modulate = Color(1.0,1.0,1.0)
