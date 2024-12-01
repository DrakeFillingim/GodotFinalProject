extends Area2D

var path_to_levels := "res://Levels/Level"
@export var level_number = "00"

func _ready():
	$AnimatedSprite.play("idle")

func _on_area_entered(area):
	if area.name == "PlayerArea":
		var autoload = get_node("/root/AutoloadScript")
		autoload.play_level_music("Level" + level_number)
		autoload.current_level = "Level" + level_number
		var path_to_next_level = path_to_levels + level_number + ".tscn"
		get_tree().change_scene_to_file(path_to_next_level)
