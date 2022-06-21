extends Node
# Audio module to play
# and fade music into one and other

# TODO: Make audio stop by fading to 0
onready var music_channel = $Channel1

var music_path = "res://resources/Sound/Music/"
export(float, 0.005, 0.05) var fadeTime

var MusicList = {
	'sample1': load(music_path + 'sample_1.wav'),
	'sample2': load(music_path + 'sample_2.wav'),
	'sample3': load(music_path + 'sample_3.wav')
}


func play(Song_Name=''):
	"""Function to play music with a specific song
		:param1 Song_Name: takes a the name of a song as a string
	"""
	print("Entering play()")

	if not music_channel.is_playing():
		music_channel.stream = MusicList[Song_Name]
		music_channel.play()
	else:
		fade_to_song(Song_Name)

# FIXME: Song doesn't play when you call play() function multiple times
func fade_to_song(NewSong=''):
	print("Entering fade_to_song()")
	while music_channel.volume_db >= -60:
		music_channel.volume_db -= 1
		yield(get_tree().create_timer(fadeTime),"timeout")
	
	music_channel.stop()
	music_channel.stream = MusicList[NewSong]
	music_channel.play()
	
	while music_channel.volume_db < 0:
		music_channel.volume_db += 1
		yield(get_tree().create_timer(fadeTime),"timeout")
