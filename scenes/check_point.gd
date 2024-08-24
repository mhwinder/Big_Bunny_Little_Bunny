extends Area2D

var is_active = false

func _on_body_entered(body):
	body.my_checkpoint = Vector2(position.x,position.y-10)
	if not is_active:
		is_active = true
		$flag.visible = true
	
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property($flag, 'position', Vector2(3,-50),1.5).from(Vector2(3,0))
		tween.tween_property($flag, 'scale', Vector2(1,1),1.5).from(Vector2(0,0))
	
	$checkpoint_sound.play()
	print("Checkpoint Entered")
