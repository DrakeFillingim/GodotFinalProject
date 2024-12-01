#Koala Script

extends CharacterBody2D

@export var speed := 5000
@export var gravity := 2000
@export var health := 3
@export var direction := 1

@export var damage := 1
@export var knockback := 20000
@export var koala_projectile : PackedScene

@export var attack_range := 1150

var animate_windup := false
var animate_throw := false
var attack_player = false

func _ready():
	$AttackRange/CollisionShape2D.shape.radius = attack_range

func _process(_delta):
	if animate_windup:
		$KoalaAnimatedSprite.play("windup")
	elif animate_throw:
		$KoalaAnimatedSprite.play("throw")
	else:
		$KoalaAnimatedSprite.play("idle")


func _on_area_2d_area_entered(area):
	if area.is_in_group("rangs"):
		$KoalaAnimatedSprite.modulate = Color(1,0.5,0.5)
		$RedTimer.start()
		health -= 1
		if health <= 0:
			queue_free()


func _on_attack_range_area_entered(area):
	if area.name == "PlayerArea":
		attack_player = true


func _on_attack_range_area_exited(area):
	if area.name == "PlayerArea":
		attack_player = false


func _on_attack_timer_timeout():
	if attack_player:
		animate_windup = false
		animate_throw = true
		var new_projectile = koala_projectile.instantiate()
		get_parent().add_child(new_projectile)
		new_projectile.global_position = global_position
		new_projectile.direction = global_position.direction_to(get_parent().get_node("Player").global_position)
		$TelegraphTimer.start()
		$ThrowTimer.start()


func _on_telegraph_timer_timeout():
	if attack_player:
		animate_windup = true


func _on_throw_timer_timeout():
	animate_throw = false


func _on_red_timer_timeout():
	$KoalaAnimatedSprite.modulate = Color(1,1,1)
