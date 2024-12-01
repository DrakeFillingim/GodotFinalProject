#Miniboss 2 Projectile

extends Area2D

@export var speed := 2500
@export var knockback := 0
@export var damage := 1
@export var stun_length := 1.5

var player_node

var direction := Vector2(0,0)

func _ready():
	add_to_group("enemies")


func _physics_process(delta):
	position += direction * speed * delta


func _on_area_entered(area):
	if area.is_in_group("rangs"):
		queue_free()
	if area.name == "PlayerArea":
		player_node.root(stun_length)
		deal_damage()
		queue_free()

func deal_damage():
	player_node.take_damage(damage, 0)


func _on_body_entered(body):
	if body.name == "TileMap":
		queue_free()
