extends Node2D

var scroll_speed = 30

func _process(delta):
	$BgText.position.x -= scroll_speed * delta
	$BgText2.position.x -= scroll_speed * delta
	$BgText3.position.x -= scroll_speed * delta
	
	if $BgText.position.x < -2600:
		$BgText.position.x = 0
		$BgText2.position.x = 2600
		$BgText3.position.x = 5200




