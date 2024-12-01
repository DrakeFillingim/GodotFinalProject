#Movement Marker Script

extends Area2D

signal entered

var body_name


func _on_area_entered(area):
	if area.get_parent().name == body_name:
		entered.emit()
