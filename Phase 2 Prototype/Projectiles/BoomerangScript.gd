extends Area2D

@export var speed := 2000
@export var direction := Vector2(0,0)
var is_returning = false

@export var damage := 1

var can_return := true
var can_rotate := true
var return_frames := 0

signal returned

func _ready():
	add_to_group("rangs")
	$return_timer.start()

func get_canvas_position():
	return get_global_transform_with_canvas().get_origin()

func _physics_process(delta):
	if can_rotate:
		$Sprite2D.rotation += .5
	if can_return:
		position += Vector2(direction.x * speed * delta, direction.y * speed * delta)
	if overlaps_area(get_parent().get_node("Player/PlayerArea")) and (is_returning or not can_rotate):
		return_frames += 1
	check_overlap()


func check_overlap():
	if return_frames >= 5:
		returned.emit()
		queue_free()


func _on_return_timer_timeout():
	is_returning = true


func _on_body_entered(body):
	if body.name == "TileMap":
		if is_returning:
			can_return = false
			can_rotate = false
		if not is_returning:
			is_returning = true
			$return_timer.stop()


func _on_pickup_area_entered(area):
	if not can_return and area.name == "PlayerArea":
		returned.emit()
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		is_returning = true
		$return_timer.paused = true
