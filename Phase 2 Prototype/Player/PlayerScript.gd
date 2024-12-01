#Player Base Script

extends CharacterBody2D

@export var speed := 800
@export var gravity := 8000
@export var gravity_factor := 1
@export var jump_speed := 2500
@export var dash_speed := 3000
@export var direction := 0.0

@export var max_health := 5
@export var health := 5

@export var friction := 0.2
@export var acceleration := 0.5

@export var Boomerang : PackedScene
var current_boomerang = null

var is_jumping := false
var can_jump := true
var can_dash := true
var is_dashing := false
var can_throw := true
var boomerang_hits = 0

var can_take_damage := true

var is_stunned := false
var is_rooted := false

var check_reset := false
var was_on_floor := false

var rng_gen = RandomNumberGenerator.new()
var sound_path = "res://Assests/Music/"
var sound_dict = {
	"grunt1" : load(sound_path + "grunt1.mp3"),
	"grunt2" : load(sound_path + "grunt2.mp3")
}
var boomerang_sound = load("res://Assests/Music/boomerang sound 22.mp3")

signal player_health_changed
signal dash_used
signal dash_ready

func get_canvas_position():
	return get_global_transform_with_canvas().get_origin()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot(event.position)
	if event.is_action_pressed("dash")  and not is_rooted:
		dash(get_viewport().get_mouse_position())
	if event.is_action_pressed("jump") and can_jump and not is_rooted:
		jump()


func get_input():
	if Input.is_action_pressed("move_right"):
		direction = 1
	elif Input.is_action_pressed("move_left"):
		direction = -1
	else:
		direction = 0


func _physics_process(delta):
	if is_on_floor() and check_reset:
		is_jumping = false
		can_jump = true
		check_reset = false
	if not is_dashing and not is_rooted:
		get_input()
	apply_forces(delta)

	was_on_floor = is_on_floor()
	move_and_slide()
	check_coyote_time()

func _process(_delta):
	change_animation()
	if current_boomerang != null and current_boomerang.is_returning:
		var v = get_global_transform_with_canvas().get_origin().direction_to(current_boomerang.get_canvas_position())
		current_boomerang.direction = -v

func check_coyote_time():
	if was_on_floor and !is_on_floor():
		$CoyoteTimer.start()

func apply_forces(delta):
	velocity.y += gravity * delta
	if not is_dashing:
		if direction != 0:
			velocity.x = lerp(velocity.x, direction * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, direction * speed, friction)

func change_animation():
	if direction > 0:
		$AnimatedSprite.flip_h = false
	elif direction < 0:
		$AnimatedSprite.flip_h = true

	if gravity_factor >= 1:
		$AnimatedSprite.flip_v = false
	elif gravity_factor <= -1:
		$AnimatedSprite.flip_v = true
	if is_rooted:
		$AnimatedSprite.play("rooted")
	elif is_dashing:
		$AnimatedSprite.play("dash")
	elif is_jumping:
		$AnimatedSprite.play("jump")
	elif direction == 0:
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("walk")

func jump():
	is_jumping = true
	can_jump = false
	velocity.y = -jump_speed * gravity_factor
	$CheckJumpReset.start()

func dash(mouse_pos):
	if can_dash:
		var v = get_global_transform_with_canvas().get_origin().direction_to(mouse_pos)
		if v.x < 0:
			direction = -1
		if v.x > 0:
			direction = 1
		var rotate_angle = v.angle()
		if rotate_angle < -PI/2:
			rotate_angle += PI
		if rotate_angle > PI/2:
			rotate_angle -= PI
		$AnimatedSprite.rotation = rotate_angle
		velocity = v * dash_speed
		gravity = 4000 * gravity_factor
		can_dash = false
		is_dashing = true
		dash_used.emit()
		$Sprite2D.visible = false
		$DashLengthTimer.start()
		$DashCooldownTimer.start()

func shoot(mouse_pos):
	if can_throw:
		$Sprite2D.visible = false
		current_boomerang = Boomerang.instantiate()
		var v = get_global_transform_with_canvas().get_origin().direction_to(mouse_pos)
		current_boomerang.returned.connect(on_boomerang_returned)
		current_boomerang.direction = v
		owner.add_child(current_boomerang)
		current_boomerang.transform = $Marker.global_transform
		can_throw = false
		$LostRang.start()
		$AudioStreamPlayer.stream = boomerang_sound
		$AudioStreamPlayer.play()

func check_health():
	if health <= 0:
		health = max_health
		death()

func on_boomerang_returned():
	$LostRang.stop()
	current_boomerang = null
	$Sprite2D.visible = true
	if not is_rooted:
		can_throw = true

func take_damage(damage_amount, knockback_amount):
	if can_take_damage:
		knockback(knockback_amount)
		health -= damage_amount
		player_health_changed.emit(health)
		check_health()
		can_take_damage = false
		$iFrameTimer.start()
		var sound_number = rng_gen.randi_range(0,1)
		$AudioStreamPlayer.stream = sound_dict[sound_dict.keys()[sound_number]]
		$AudioStreamPlayer.play()

func heal(amount):
	if health + amount <= max_health:
		health += amount
		player_health_changed.emit(health)
		return true
	return false

func knockback(knockback_amount):
	velocity.x = knockback_amount
	direction = -direction


func root(duration):
	$RootTimer.wait_time = duration
	$RootTimer.start()
	is_rooted = true
	velocity = Vector2(0, 0)
	direction = 0
	can_throw = false

func death():
	var autonode = get_node("/root/AutoloadScript")
	if autonode.current_level.length() >= 7 and autonode.current_level.substr(7) == "Boss":
		autonode.current_level = autonode.current_level.substr(0, 7)
		autonode.play_level_music(autonode.current_level)
	get_tree().reload_current_scene()

func _on_dash_timer_timeout():
	can_dash = true
	if current_boomerang == null:
		$Sprite2D.visible = true
	dash_ready.emit()

func _on_dash_length_timeout():
	$AnimatedSprite.rotation = 0
	is_dashing = false
	gravity = 8000 * gravity_factor

func _on_root_timer_timeout():
	is_rooted = false
	can_throw = true
	if current_boomerang != null and  not current_boomerang.can_rotate:
		current_boomerang.queue_free()
		$LostRang.stop()

func _on_i_frame_timer_timeout():
	can_take_damage = true

func _on_lost_rang_timeout():
	current_boomerang.queue_free()
	can_throw = true

func _on_check_jump_reset_timeout():
	check_reset = true

func _on_coyote_timer_timeout():
	can_jump = false
	check_reset = true
