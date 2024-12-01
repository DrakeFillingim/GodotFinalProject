#Walking Bird Script

extends CharacterBody2D

@export var speed := 40000
@export var gravity := 2000
@export var health := 2
@export var direction := 1

@export var damage := 1
@export var knockback := 7500
@export var patrol_time := 1.0

var start_mark
var end_mark

func _ready():
	start_mark = get_parent().get_node("EnemyMovementMarkers/WalkingBirdStartMarker" + name.substr(16, 2))
	end_mark = get_parent().get_node("EnemyMovementMarkers/WalkingBirdEndMarker" + name.substr(16, 2))
	start_mark.body_name = name
	end_mark.body_name = name
	start_mark.entered.connect(on_mark_entered)
	end_mark.entered.connect(on_mark_entered)

func _physics_process(delta):
	velocity.x = speed * delta * direction
	velocity.y += gravity * delta
	move_and_slide()


func _process(_delta):
	if direction >= 1:
		$EnemyWalkingBirdAnimatedSprite.flip_h = true
	elif direction <= -1:
		$EnemyWalkingBirdAnimatedSprite.flip_h = false
	$EnemyWalkingBirdAnimatedSprite.play("default")


func on_mark_entered():
	direction = -direction


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		$EnemyWalkingBirdAnimatedSprite.modulate = Color(1,0.5,0.5)
		$RedTimer.start()
		health -= 1
		if health <= 0:
			queue_free()


func _on_red_timer_timeout():
	$EnemyWalkingBirdAnimatedSprite.modulate = Color(1,1,1)
