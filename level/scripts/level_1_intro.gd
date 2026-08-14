extends Node2D

@onready var smoke1=$CanvasLayer/Smoke1
@onready var smoke2=$CanvasLayer/Smoke2
@onready var player=$Player
@onready var animation_player = $AnimationPlayer
@onready var audio_player =$AudioStreamPlayer2D

@export var sound1: AudioStream
@export var sound2: AudioStream
@export var sound3: AudioStream

var siren_loop_id: int = -1
var screams_loop_id: int=-1

func _ready():
	player.can_move=false
	player.animated_sprite_2d.stop()
	audio_player.play()
	animation_player.play("Intro")
	Dialogic.start("Intro")
	
func startdialogue():
	Dialogic.start("AfterWaking")
	
func startdialogue2():
	smoke1.visible=true
	smoke2.frame=5
	smoke1.play("smoke")
	smoke2.visible=true
	smoke2.frame=11
	smoke2.play("smoke")
	Dialogic.start("Flashback")
	
func startdialogue3():
	Dialogic.start("AfterFlashback")
	
func play_sound1():
	if siren_loop_id != -1: 
		return 
	var playback = audio_player.get_stream_playback()
	if playback:
		siren_loop_id = playback.play_stream(sound1,0,-10)

func play_sound2():
	if screams_loop_id != -1: 
		return 
	var playback = audio_player.get_stream_playback()
	if playback:
		screams_loop_id = playback.play_stream(sound2,0,10)

func play_sound3():
	smoke1.visible=false
	smoke2.visible=false
	var playback = audio_player.get_stream_playback()
	if playback:
		playback.play_stream(sound3)
	
func stop_sound1():
	if siren_loop_id != -1:
		var playback = audio_player.get_stream_playback()
		if playback:
			playback.stop_stream(siren_loop_id)
		siren_loop_id = -1

func stop_sound2():
	if screams_loop_id != -1:
		var playback = audio_player.get_stream_playback()
		if playback:
			playback.stop_stream(screams_loop_id)
		screams_loop_id = -1
	
