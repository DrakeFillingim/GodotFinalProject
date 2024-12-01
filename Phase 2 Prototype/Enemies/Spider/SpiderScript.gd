#Enemy Spider Script

extends CharacterBody2D

@export var speed := 40000
@export var gravity := 8000
@export var gravity_factor := 1
@export var health := 2
@export var direction := 1

@export var damage := 1
@export var knockback := 500
@export var patrol_time := 1.0

var start_mark
var end_mark

func _ready():
	start_mark = get_parent().get_node("EnemyMovementMarkers/SpiderStartMarker" + name.substr(11, 2))
	end_mark = get_parent().get_node("EnemyMovementMarkers/SpiderEndMarker" + name.substr(11, 2))
	start_mark.body_name = name
	end_mark.body_name = name
	start_mark.entered.connect(on_mark_entered)
	end_mark.entered.connect(on_mark_entered)


func _physics_process(delta):
	velocity.x = speed * delta * direction
	if is_on_wall():
		velocity.y += 2000 * gravity_factor * delta * -1
	else:
		velocity.y += gravity * gravity_factor * delta
	move_and_slide()

func on_mark_entered():
	direction = -direction


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		$EnemySpiderAnimatedSprite.modulate = Color(1,0.5,0.5)
		$RedTimer.start()
		health -= 1
		if health <= 0:
			queue_free()


func _on_red_timer_timeout():
	$EnemySpiderAnimatedSprite.modulate = Color(1,1,1)
