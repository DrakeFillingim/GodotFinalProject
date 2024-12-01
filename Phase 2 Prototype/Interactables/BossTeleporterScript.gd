#Teleporter Script

extends Area2D

@export var teleport_position = Vector2(2048.0, 0.5)
@export var level_num = "00"

signal player_teleported


func _ready():
	$AnimatedSprite.play("idle")

func _on_area_entered(area):
	if area.name == "PlayerArea":
		var autoload = get_node("/root/AutoloadScript")
		autoload.play_level_music("Level" + level_num + "Boss")
		autoload.current_level = "Level" + level_num + "Boss"
		var player = area.get_owner()
		player.position = teleport_position
		if player.current_boomerang != null:
			player.current_boomerang.queue_free()
			player.can_throw = true
		player_teleported.emit()
