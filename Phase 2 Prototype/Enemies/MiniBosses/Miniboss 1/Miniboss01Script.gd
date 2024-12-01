#Enemy Miniboss Script

extends CharacterBody2D

@export var speed := 32000
@export var gravity := 2000
@export var health := 10
@export var direction := 1

@export var damage := 2
@export var knockback := 5000

@export var next_level_teleporter : PackedScene

var rng_gen = RandomNumberGenerator.new()

var player_has_teleported := false
var is_telegraphed := false
var is_dashing := false

func _physics_process(delta):
	if player_has_teleported:
		if not is_dashing or is_telegraphed:
			get_direction()
		velocity.x = speed * delta * direction
		velocity.y += gravity * delta
		move_and_slide()
	print($dash_timer.wait_time)


func _process(_delta):
	if direction >= 1:
		$EnemyMiniboss01AnimatedSprite.flip_h = true
	elif direction <= -1:
		$EnemyMiniboss01AnimatedSprite.flip_h = false
	if is_telegraphed:
		$EnemyMiniboss01AnimatedSprite.stop()
	else:
		$EnemyMiniboss01AnimatedSprite.play("walk")


func get_direction():
	var direction_vector = get_parent().get_node("Player").get_canvas_position().direction_to(get_global_transform_with_canvas().get_origin())
	if direction_vector.x < 0:
		direction = 1
	if direction_vector.x > 0:
		direction = -1


func dash():
	$dash_length.start()
	is_dashing = true
	speed = 175000


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		$EnemyMiniboss01AnimatedSprite.modulate = Color(1,0.5,0.5)
		$RedTimer.start()
		health -= 1
		if health <= 0:
			get_parent().get_node("NextLevelTeleporter").position = global_position
			queue_free()
	if area.name == "PlayerArea":
		deal_damage(area.owner)

func deal_damage(player_node):
	player_node.take_damage(damage, get_knockback_amount(player_node))


func get_knockback_amount(player_node):
	if global_position.x > player_node.global_position.x:
		return knockback * -1
	return knockback


func _on_boss_teleporter_player_teleported():
	player_has_teleported = true
	$dash_timer.start()


func _on_dash_length_timeout():
	is_dashing = false
	speed = 32000
	var rng_time = rng_gen.randf_range(0.77, 2)
	$dash_timer.wait_time = rng_time


func _on_dash_timer_timeout():
	$dash_telegraph.start()
	is_telegraphed = true
	speed = 0


func _on_dash_telegraph_timeout():
	is_telegraphed = false
	dash()


func _on_red_timer_timeout():
	$EnemyMiniboss01AnimatedSprite.modulate = Color(1,1,1)
