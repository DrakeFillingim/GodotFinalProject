#Koala Projectile Script

extends Area2D

@export var speed := 2500
@export var knockback := 5000
@export var damage := 1

var can_collide = false

var direction := Vector2(0,0)

func _ready():
	add_to_group("enemies")


func _physics_process(delta):
	position += direction * speed * delta


func _process(_delta):
	$Sprite2D.rotation += .5

func _on_body_entered(body):
	if can_collide and body.name == "TileMap":
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("rangs"):
		queue_free()
	if area.name == "PlayerArea":
		deal_damage()
		queue_free()


func _on_collision_timer_timeout():
	can_collide = true

func deal_damage():
	get_parent().get_node("Player").take_damage(damage, get_knockback_amount())

func get_knockback_amount():
	if global_position.x > get_parent().get_node("Player").global_position.x:
		return knockback * -1
	return knockback
