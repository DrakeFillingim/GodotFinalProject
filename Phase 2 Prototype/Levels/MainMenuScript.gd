extends MarginContainer

func _on_play_button_button_down():
	var autoload = get_node("/root/AutoloadScript")
	autoload.play_level_music("Level01")
	autoload.current_level = "Level01"
	get_tree().change_scene_to_file("res://Levels/Level01.tscn")


func _on_exit_button_button_down():
	get_tree().quit()
