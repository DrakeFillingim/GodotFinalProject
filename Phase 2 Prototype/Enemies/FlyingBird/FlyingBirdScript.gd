#Enemy Flying Bird Script

extends CharacterBody2D

@export var speed := 30000
@export var gravity := 0
@export var health := 5
@export var direction := 1

@export var damage := 1
@export var knockback := 2000
@export var patrol_time := 1.0

var can_dive := false
var is_diving := false
var recovering_on_ground := false
var recovering_in_air := false
var recovery_timer_started := false
var start_pos = null

var start_mark
var end_mark
var dive_area


func _ready():
	start_mark = get_parent().get_node("EnemyMovementMarkers/FlyingBirdStartMarker" + name.substr(15, 2))
	end_mark = get_parent().get_node("EnemyMovementMarkers/FlyingBirdEndMarker" + name.substr(15, 2))
	dive_area = get_parent().get_node("EnemyMovementMarkers/FlyingBirdDiveMarker" + name.substr(15,2))
	start_mark.body_name = name
	end_mark.body_name = name
	start_mark.entered.connect(on_start_mark_entered)
	end_mark.entered.connect(on_end_mark_entered)
	dive_area.player_overlaps.connect(on_player_overlap)


func _physics_process(delta):
	if not is_diving and not recovering_in_air and not recovering_on_ground:
		velocity.x = speed * direction * delta
	if is_on_floor() and not recovery_timer_started:
		is_diving = false
		recovering_on_ground = true
		velocity = Vector2(0,0)
		$dive_recovery_timer.start()
		recovery_timer_started = true
	move_and_slide()


func _process(_delta):
	if direction >= 1:
		$EnemyFlyingBirdAnimatedSprite.flip_h = true
	elif direction <= -1:
		$EnemyFlyingBirdAnimatedSprite.flip_h = false
	$EnemyFlyingBirdAnimatedSprite.play("flying")

func on_start_mark_entered():
	if recovering_in_air:
		velocity = Vector2(0,0)
		recovering_in_air = false
		global_position = start_mark.global_position
		direction = 1
		$dive_timer.start()
		recovery_timer_started = false
	else:
		direction = -direction

func on_end_mark_entered():
	if recovering_in_air:
		velocity = Vector2(0,0)
		recovering_in_air = false
		global_position = end_mark.global_position
		direction = -1
		$dive_timer.start()
		recovery_timer_started = false
	else:
		direction = -direction


func on_player_overlap(is_overlapped):
	can_dive = is_overlapped


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		$EnemyFlyingBirdAnimatedSprite.modulate = Color(1,0.5,0.5)
		$RedTimer.start()
		health -= 1
		if health <= 0:
			queue_free()


func _on_dive_timer_timeout():
	if can_dive:
		is_diving = true
		var direction_vector = global_position.direction_to(get_parent().get_node("Player").global_position)
		velocity = direction_vector * 3000
	else:
		$dive_timer.start()


func _on_dive_recovery_timer_timeout():
	var marker_to_travel = null
	if abs(global_position - end_mark.global_position) < abs(global_position - start_mark.global_position):
		marker_to_travel = end_mark
	else:
		marker_to_travel = start_mark
	var direction_vector = global_position.direction_to(marker_to_travel.global_position)
	velocity = direction_vector * 750
	recovering_on_ground = false
	recovering_in_air = true


func _on_red_timer_timeout():
	$EnemyFlyingBirdAnimatedSprite.modulate = Color(1,1,1)
