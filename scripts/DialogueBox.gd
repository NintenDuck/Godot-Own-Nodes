extends Control

onready var txtName = $MarginContainer/DialogueBox/TextMargin/VBoxContainer/NameLabel
onready var txtChat = $MarginContainer/DialogueBox/TextMargin/VBoxContainer/TextLabel
onready var nextTextTimer = $MarginContainer/DialogueBox/TextMargin/nextTextTimer
onready var arrowTexture = $MarginContainer/DialogueBox/ArrowMargin/ArrowTexture

export(String, "normal", "fast", "veryfast") var textSpeed = "normal"
export(Array, Texture) var arrowStates
# export(Array, Texture, "normal", "last") var arrowStates
export(String, FILE, "*.json") var path_of_dialogue_file
export(int) var dialogueID = 0

var speedType = {
	"normal": 0.05,
	"fast": 0.03,
	"veryfast": 0.01
}

var phraseNum = 0
var finished = false

var dialog


func _ready():
	nextTextTimer.wait_time = speedType[textSpeed]
	arrowTexture.visible = false
	dialog = getDialogue()
	assert(dialog, "No dialogue!")
	nextPhrase()


# warning-ignore:unused_argument
func _process(delta):
	arrowTexture.visible = finished
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

	
	# If phrases are finished, then queue_free()
	if phraseNum >= len(dialog[dialogueID]):
		queue_free()
		return
	# Else

	
	finished = false
	
	# Assign the json dialog to the node's text
	txtName.text = dialog[dialogueID][phraseNum]["name"]
	txtChat.text = dialog[dialogueID][phraseNum]["text"]
	
	txtChat.visible_characters = 0
	
	
	# Loop to make text appear at a certain speed
	while txtChat.visible_characters < len(txtChat.text):
		txtChat.visible_characters += 1
		
		nextTextTimer.start()
		yield(nextTextTimer, "timeout")
		
	# Makes textIcon a or b depending if it's the last sentence
	if phraseNum == len(dialog[dialogueID]) - 1:
		arrowTexture.texture = arrowStates[1]
	else:
		arrowTexture.texture = arrowStates[0]

	# Phrase finished, next sentence
	finished = true
	phraseNum += 1
