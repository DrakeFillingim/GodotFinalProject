extends ParallaxBackground


func _ready():
	get_tree().root.get_node("Level01/Player").camera_offset.connect(on_camera_moved)

func on_camera_moved(camera_offset):
	scroll_offset = camera_offset
	print(scroll_offset)
