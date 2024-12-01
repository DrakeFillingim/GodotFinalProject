#Enemy Base Script

extends CharacterBody2D

@export var speed := 25000
@export var gravity := 2000
@export var health := 2
@export var direction := 1

@export var damage := 2
@export var knockback := 5000

var hit_player = false


func _physics_process(delta):
	get_direction()
	velocity.x = speed * delta * direction
	velocity.y += gravity * delta
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		health -= 1
		if health <= 0:
			queue_free()

func get_direction():
	var direction_vector = get_parent().get_node("Player").get_canvas_position().direction_to(get_global_transform_with_canvas().get_origin())
	if direction_vector.x < 0:
		direction = 1
	if direction_vector.x > 0:
		direction = -1
	if hit_player == true:
		direction *= -1


func _on_hit_timer_timeout():
	hit_player = false
