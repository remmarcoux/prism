extends Node

enum ELoopType {
	NoLoop,
	LoopLast,
	LoopAll,
}

var currentStream : AudioStreamPlayer
var musicStreams : Array = []
var musicLoopType : int

func _ready():
	_setup_audio_streams()

func _setup_audio_streams():
	currentStream = AudioStreamPlayer.new()
	currentStream.connect("finished", self, "_play_next_or_loop")
	currentStream.volume_db = -8
	add_child(currentStream)

func play_music(streams, loopMethod:int):
	if !streams :
		return
		
	musicLoopType = loopMethod
	if streams is Array:
		_play_music_list(streams)
	if streams is AudioStream:
		musicStreams = []
		_play_music_single(streams)

func _play_music_list(streams:Array):
	if currentStream.playing :
		currentStream.stop()
	musicStreams = streams
	_play_next_or_loop()

func _play_music_single(stream:AudioStream):
	if currentStream.stream == stream :
		return
	if currentStream.playing :
		currentStream.stop()
	currentStream.stream = stream
	currentStream.play()

func _play_next_or_loop():
	if musicStreams.size() == 0 && (musicLoopType == ELoopType.LoopLast || musicLoopType == ELoopType.LoopAll):
		currentStream.play(0)
	else :
		_play_music_single(musicStreams[0])
		if musicLoopType == ELoopType.LoopAll :
			musicStreams.push_back(musicStreams[0])
		musicStreams.remove(0)
