extends Area2D


@export var tile_length := 64
@export var tile_height := 64


func _ready():
	$CollisionShape.shape.size.x = tile_length
	$CollisionShape.shape.size.y = tile_height


func _on_area_entered(area):
	if area.name == "PlayerArea":
		area.owner.death()
