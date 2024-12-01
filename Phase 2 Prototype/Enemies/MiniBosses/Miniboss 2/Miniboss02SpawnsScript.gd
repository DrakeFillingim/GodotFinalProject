#Enemy Miniboss 2 Spawn Script

extends CharacterBody2D

@export var speed := 50000
@export var gravity_factor := 1
@export var gravity := 16000
@export var health := 2
@export var direction := 1

@export var damage := 1
@export var knockback := 4000

var start_mark
var end_mark

signal died

func _ready():
	start_mark.body_name = name
	end_mark.body_name = name
	start_mark.entered.connect(on_mark_entered)
	end_mark.entered.connect(on_mark_entered)


func on_mark_entered():
	direction = -direction


func _physics_process(delta):
	velocity.x = speed * delta * direction
	if is_on_wall():
		velocity.y += 2000 * gravity_factor * delta * -1
	else:
		velocity.y += gravity * gravity_factor * delta
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		health -= 1
		if health <= 0:
			died.emit(gravity)
			queue_free()
