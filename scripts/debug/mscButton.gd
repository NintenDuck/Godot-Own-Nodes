extends Button

export(String) var song

func _on_Button_pressed() -> void:
	AudioSystem.play(song)
