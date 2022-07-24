extends Control

const filepath:String = "res://jsonFiles/save.json"

onready var p_name_lbl = $ColorRect/CenterContainer/Slot/labelPName
onready var p_level_lbl = $ColorRect/CenterContainer/Slot/labelPLevel
onready var map_name_lbl = $ColorRect/CenterContainer/Slot/labelMapName
onready var p_position_lbl = $ColorRect/CenterContainer/Slot/labelPosition

var player_slot:int = 0
var player_name:String
var player_lvl:int
var last_level_name:String
var player_position:Vector2

var data:Dictionary

func _ready():
	data = json_to_dict(filepath)


func json_to_dict(filepath) -> Dictionary:
	var new_file = File.new()
	new_file.open(filepath, File.READ)
	var file_content = new_file.get_as_text()
	new_file.close()
	var file_dictionary = JSON.parse(file_content).result
	return file_dictionary

func load_data(data) -> void:
	player_name = data[player_slot]['player']['name']
	player_lvl = data[player_slot]['player']['level']
	last_level_name = data[player_slot]['level']['map_name']
	player_position.x = data[player_slot]['level']['player_position']['x']
	player_position.y = data[player_slot]['level']['player_position']['y']


func change_slot_info() -> void:

	p_name_lbl.text = player_name
	p_level_lbl.text = str(player_lvl)
	map_name_lbl.text = last_level_name
	p_position_lbl.text = str(player_position)
	
	
func _on_btnLoadData_pressed():
	player_slot = 0
	load_data(data)
	change_slot_info()

func _on_btnLoadData2_pressed():
	player_slot = 1
	load_data(data)
	change_slot_info()


func _on_btnLoadData3_pressed():
	player_slot = 2
	load_data(data)
	change_slot_info()

