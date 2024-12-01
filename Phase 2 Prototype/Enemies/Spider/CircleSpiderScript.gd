#Enemy Circle Spider Script

extends CharacterBody2D

@export var speed := 40000
@export var health := 1
@export var direction := 1

@export var damage := 1
@export var knockback := 500

@export var movement_vector = Vector2(1, 0)

var vel_offset = Vector2()
var was_on_wall = false
var was_on_floor = false
var was_on_ceiling = false


func _physics_process(delta):
	velocity.x = speed * delta * direction
	velocity = movement_vector * speed * delta
	velocity += vel_offset
	was_on_floor = is_on_floor()
	was_on_wall = is_on_wall()
	was_on_ceiling = is_on_ceiling()
	move_and_slide()
	check_change()

func check_change():
	if (was_on_floor and !is_on_floor()) or (was_on_wall and !is_on_wall()) or (was_on_ceiling and !is_on_ceiling()):
		change_direction()

func change_direction():
	if movement_vector.x == 1:
		movement_vector = Vector2(0, 1)
		vel_offset.x = -1000
		vel_offset.y = 0
	elif movement_vector.y == 1:
		movement_vector = Vector2(-1, 0)
		vel_offset.x = 0
		vel_offset.y = -1000
	elif movement_vector.x == -1:
		movement_vector = Vector2(0, -1)
		vel_offset.x = 1000
		vel_offset.y = 0
	elif movement_vector.y == -1:
		movement_vector = Vector2(1, 0)
		vel_offset.x = 0
		vel_offset.y = 1000


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		$EnemySpiderAnimatedSprite.modulate = Color(1,0.5,0.5)
		$RedTimer.start()
		health -= 1
		if health <= 0:
			queue_free()


func _on_red_timer_timeout():
	$EnemySpiderAnimatedSprite.modulate = Color(1,1,1)
