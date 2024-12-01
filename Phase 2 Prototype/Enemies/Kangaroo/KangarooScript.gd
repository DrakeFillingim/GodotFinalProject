extends CharacterBody2D

@export var speed := 40000
@export var gravity := 8000
@export var health := 2
@export var direction := 1.0
@export var jump_speed := 120000

@export var damage := 1
@export var knockback := 4000

@export var time_between_jumps := 2.0
@export var jump_length_time := 0.5
@export var jumps_to_switch := 2
var current_jumps := 0

var on_floor = true
var check_floor = false
var can_move = false

func _ready():
	$jump_timer.wait_time = time_between_jumps

func _physics_process(delta):
	if can_move:
		check_floor = false
		velocity.x = speed * delta * direction
		velocity.y -= jump_speed * delta
		can_move = false
		$check_floor.start()
	if check_floor:
		if is_on_floor():
			velocity.x = 0
	velocity.y += gravity * delta
	if current_jumps >= jumps_to_switch:
		switch_direction()
	move_and_slide()

func _process(_delta):
	if direction >= 1:
		$EnemyKangarooAnimatedSprite.flip_h = true
	if direction <= -1:
		$EnemyKangarooAnimatedSprite.flip_h = false
	$EnemyKangarooAnimatedSprite.play("idle")


func switch_direction():
	current_jumps = 0
	direction = -direction


func _on_jump_timer_timeout():
	can_move = true


func _on_enemy_prototype_2_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		$EnemyKangarooAnimatedSprite.modulate = Color(1,0.5,0.5)
		$RedTimer.start()
		health -= 1
		if health <= 0:
			queue_free()


func _on_check_floor_timeout():
	current_jumps += 1
	check_floor = true


func _on_red_timer_timeout():
	$EnemyKangarooAnimatedSprite.modulate = Color(1,1,1)
