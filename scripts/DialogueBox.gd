# TODO: 
extends Control

onready var txtName = $MarginContainer/DialogueBox/TextMargin/VBoxContainer/NameLabel
onready var txtChat = $MarginContainer/DialogueBox/TextMargin/VBoxContainer/TextLabel
onready var nextTextTimer = $MarginContainer/DialogueBox/TextMargin/nextTextTimer

export(String, "normal", "fast", "veryfast") var textSpeed = "normal"
export(String, FILE, "*.json") var path_of_dialogue_file
export(int) var dialogueID = 0

var speedType = {
	"normal": 0.05,
	"fast": 0.03,
	"veryfast": 0.01
}

# var dialoguePath = "res://jsonFIles/"

var phraseNum = 0
var finished = false

var dialog


func _ready():
	nextTextTimer.wait_time = speedType[textSpeed]
	dialog = getDialogue()
	assert(dialog, "No dialogue!")
	nextPhrase()


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			txtChat.visible_characters = len(txtChat.text)


# Give output to TextString
func getDialogue() -> Array:
	# Gets a file (the json dialogue)
	var file = File.new()
	assert(file.file_exists(path_of_dialogue_file),"No real file")

	# Convert it into a Godot Dictionary
	file.open(path_of_dialogue_file,File.READ)
	var file_as_text = file.get_as_text()
	var file_as_dictionary = parse_json(file_as_text)
	return file_as_dictionary
	
	
	# Print to label
func nextPhrase() -> void:
	if phraseNum >= len(dialog[dialogueID]):
		queue_free()
		return
		
	finished = false
	
	# txtName.text = dialog[phraseNum]["name"]
	# txtChat.text = dialog[phraseNum]["text"]
	txtName.text = dialog[dialogueID][phraseNum]["name"]
	txtChat.text = dialog[dialogueID][phraseNum]["text"]
	
	txtChat.visible_characters = 0
	
	while txtChat.visible_characters < len(txtChat.text):
		txtChat.visible_characters += 1

		nextTextTimer.start()
		yield(nextTextTimer, "timeout")
	
	finished = true
	phraseNum += 1

