extends Control

var assest_path = "res://Assests/Other/"
var heart_dict = {
	5 : load(assest_path + "heart 5.png"),
	4 : load(assest_path + "heart 4.png"),
	3 : load(assest_path + "heart 3.png"),
	2 : load(assest_path + "heart 2.png"),
	1 : load(assest_path + "heart 1.png")
}


@onready var health_label = $MarginContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var warning_label = $MarginContainer/VBoxContainer/HBoxContainer/WarningImage
@onready var dash_image = $MarginContainer/VBoxContainer/HBoxContainer/DashImage

func update_health(new_value):
	if new_value > 0:
		health_label.texture = heart_dict[new_value]

func _on_player_player_health_changed(player_health):
	update_health(player_health)


func _on_enemy_miniboss_02_gravity_warning():
	warning_label.visible = true


func _on_enemy_miniboss_02_gravity_warning_delete():
	warning_label.visible = false


func _on_player_dash_used():
	dash_image.visible = false


func _on_player_dash_ready():
	dash_image.visible = true
