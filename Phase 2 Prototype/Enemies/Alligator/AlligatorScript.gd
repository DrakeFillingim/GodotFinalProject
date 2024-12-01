#Enemy Alligator Script

extends CharacterBody2D

@export var speed := 5000
@export var gravity := 0
@export var health := 9223372036854775806
@export var direction := 1

@export var damage := 3
@export var knockback := 500

@export var can_move := true

var start_mark
var end_mark

func _ready():
	if can_move:
		start_mark = get_parent().get_node("EnemyMovementMarkers/WalkingBirdStartMarker" + name.substr(16, 2))
		end_mark = get_parent().get_node("EnemyMovementMarkers/WalkingBirdEndMarker" + name.substr(16, 2))
		start_mark.body_name = name
		end_mark.body_name = name
		start_mark.entered.connect(on_mark_entered)
		end_mark.entered.connect(on_mark_entered)


func on_mark_entered():
	direction = -direction


func _physics_process(delta):
	if can_move:
		velocity.x = speed * delta * direction
		velocity.y += gravity * delta
		move_and_slide()


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		health -= 1
		if health <= 0:
			queue_free()
