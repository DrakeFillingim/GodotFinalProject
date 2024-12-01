extends Node

var audio_player = AudioStreamPlayer.new()
var current_level = null
var music_dict = {
	"Level01" : load_audio_file("CloudLevel.mp3"),
	"Level02" : load_audio_file("CliffLevel.mp3"),
	"Level02Boss" : load_audio_file("CliffBoss.mp3"),
	"Level03" : load_audio_file("CaveLevel.mp3"),
	"Level03Boss" : load_audio_file("CaveBoss.mp3"),
	"Level04" : load_audio_file("WaterLevel.mp3")}


func _ready():
	current_level = "setTheLevel"
	audio_player.finished.connect(on_audio_player_finished)
	add_child(audio_player)

func load_audio_file(file):
	var path = "res://Assests/Music/"
	return load(path + file)


func play_level_music(music):
	audio_player.stream = music_dict[music]
	audio_player.play()


func on_audio_player_finished():
	play_level_music(current_level)
