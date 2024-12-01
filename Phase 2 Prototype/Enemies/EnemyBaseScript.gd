#Base Enemy Script

extends CharacterBody2D
class_name Enemy

@onready var patrol_path = $Path2D/PathFollow2D
@onready var player_node = get_parent().get_node("Player")

@export var health := 10

@export var speed := 500
@export var gravity := 2000
@export var direction := 1
@export var gravity_factor := 1
@export var inverse_direction := false
var inverter

@export var tile_length := 8
var start_position

@export var damage := 1
@export var knockback := 4000

var rng_gen = RandomNumberGenerator.new()
var sound_path = "res://Assests/Music/"
var killed = false
var sound_finished = false
var alpha = 1


func _ready():
	inverter = set_inverter()
	$Path2D.curve.add_point(Vector2(tile_length * 64, 0))
	start_position = global_position
	$Area.add_to_group("enemies")


func _physics_process(delta):
	if not killed:
		change_direction()
		patrol_path.progress += speed * delta * direction
		global_position.x = (inverter * patrol_path.progress) + start_position.x
		velocity.y += gravity * delta * gravity_factor
		move_and_slide()
	elif killed:
		alpha -= 0.04
		$AnimatedSprite.modulate.a = alpha
		if alpha <= 0 and sound_finished:
			queue_free()


func _process(_delta):
	if direction * inverter == 1:
		$AnimatedSprite.flip_h = true
	if direction * inverter == -1:
		$AnimatedSprite.flip_h = false

func set_inverter():
	if inverse_direction:
		return -1
	return 1

func change_direction():
	if patrol_path.progress_ratio == 1.0:
		direction = -1
	if patrol_path.progress_ratio == 0:
		direction = 1

func play_sound(sound_list):
	$AudioStreamPlayer.stream = sound_list[rng_gen.randi_range(0, len(sound_list) - 1)]
	$AudioStreamPlayer.play()

func take_damage(amount):
	$AnimatedSprite.modulate = Color(1.0, 0.5, 0.5)
	$DamageTakenTimer.start()
	health -= amount

func check_death(death_signal = null):
	if health <= 0:
		killed = true
		$AnimatedSprite.stop()
		if death_signal != null:
			death_signal.emit()

func deal_damage():
	if not killed:
		player_node.take_damage(damage, get_knockback_amount())

func get_knockback_amount():
	if global_position.x > player_node.global_position.x:
		return knockback * -1
	return knockback
