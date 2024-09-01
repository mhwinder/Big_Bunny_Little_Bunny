extends Node2D

var bg_text_scene: PackedScene = load("res://scenes/background.tscn")
var speedrun_time =0

var game_just_started = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for n in 10:
		var scrolltext = bg_text_scene.instantiate()
		scrolltext.position.y = n*70+1400
		scrolltext.position.x = -n*200
		scrolltext.rotation = deg_to_rad(-70)
		$Background_scene.add_child(scrolltext)
		
	for n in 10:
		var scrolltext = bg_text_scene.instantiate()
		scrolltext.rotation = deg_to_rad(20)
		scrolltext.position.y = n*70-700
		scrolltext.position.x = -n*200
		$Background_scene.add_child(scrolltext)
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Background_scene.position = $Player.position
	
	if $Player.game_is_on:
		if game_just_started:
			$music/title_song.stop()
			$music/gameplay_song.play()
			var tween = create_tween()
			tween.tween_property($music/gameplay_song, 'volume_db', -10,2).from(-100)
			game_just_started = false
		speedrun_time += delta
	
	var minutes = int(speedrun_time/60)
	var seconds = speedrun_time-minutes*60
	if seconds < 10:
		seconds = "0"+str(snapped(seconds,00.01))
	else:
		seconds = str(snapped(seconds,00.01))
	
	$speedrun_timer_canvas/timer_label.text = "   " + str(minutes) + ":" + seconds
	



func _on_end_zone_body_entered(body):
	$Player.game_is_on = false
	$Player.position = Vector2(10858,1130)
	$Player.visible = false
	$music/title_song.play()
	$music/gameplay_song.stop()
	$speedrun_timer_canvas/timer_label.set("theme_override_colors/font_color",Color(1,1,1,1))
	
