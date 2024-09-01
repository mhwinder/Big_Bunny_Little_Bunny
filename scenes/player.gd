extends CharacterBody2D

var speed = 600
var jump_v = 1000
var gravity = 10

var my_scale = 1
var min_scale = 0.85
var max_scale = 15
var scale_slope = 0.036
var scale_intercept = -2.5

var camera_scale = 0.5

var game_is_on = false

var in_air = true
var just_fell = false
var is_damaging


var my_checkpoint = Vector2(45,210)

# debug start position
#var my_checkpoint =  Vector2(8350,180)


# Called when the node enters the scene tree for the first time.
func _ready():
	# debug start position
	#position = Vector2(8350,180)
	
	# Title screen start Position
	position = Vector2(-2030,-400)
	$Camera2D.zoom = Vector2(0.95,0.95)
	print("READY")
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if game_is_on:
		action_loop()
	if not game_is_on:
		if Input.is_action_pressed("bite"):
			get_started()
			game_is_on = true
			position = my_checkpoint
			visible = true
	
	
	
func action_loop():
	# Get player input
	var direction = 0
	if not is_damaging:
		if Input.is_action_pressed("left"):
			direction += -1
			$bun_sprite.flip_h = false
			if is_on_floor():
				$bun_sprite.play("walk")
		if Input.is_action_pressed("right"):
			direction += 1
			$bun_sprite.flip_h = true
			if is_on_floor():
				$bun_sprite.play("walk")
			
	if not Input.is_anything_pressed():
		if not in_air:
			$bun_sprite.play("walk")
			$bun_sprite.stop()
	
	#debug_scale()
		
	velocity.x = direction * speed  / my_scale
	velocity.y += gravity  / my_scale
	
	if Input.is_action_pressed("bite"):
		if(is_on_floor()):
			if not is_damaging:
				velocity.y = -jump_v / my_scale
				$jump_sound.play()
				$bun_sprite.play("jump_start")
	if Input.is_action_just_released("bite"):
		if velocity.y < 0:
			velocity.y = velocity.y/4
		if not is_damaging:
			$bun_sprite.play("jump_end")
			
	if not is_on_floor():
		in_air = true
		if velocity.y > 0:
			if just_fell:
				if not is_damaging:
					$bun_sprite.play("jump_end")
					just_fell = false
	
		
	if is_on_floor() :
		if in_air:
			$land_sound.play()
			in_air = false
			just_fell = true
	
	
	move_and_slide()
	
	# Reset scale to new Y
	my_scale = position.y*scale_slope+scale_intercept
	if(my_scale < min_scale):
		my_scale = min_scale
	
	scale = Vector2(1/my_scale,1/my_scale)
	$Camera2D.zoom = Vector2(my_scale,my_scale) * camera_scale

func debug_scale():
	# change scale
	if Input.is_action_pressed("debug_grow"):
		my_scale -= 0.1
	if Input.is_action_pressed("debug_shrink"):
		my_scale += 0.1
	if(my_scale < min_scale):
		my_scale = min_scale
	if(my_scale > max_scale):
		my_scale = max_scale
		
	#print(my_scale)
	
func get_rekt():
	#Disable collision
	$CollisionShape2D.set_deferred("disabled", true)
	
	is_damaging = true
	
	$damage_timer.start()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($".", 'position', my_checkpoint,1.5).from(position)
	tween.tween_property($".", 'rotation', 12.566,1.5).from(0)
	position = my_checkpoint
	$bun_sprite.play("hurt")
	$damage_sound.play()
	
func get_started():
	
	position = Vector2(10,90)
	$bun_sprite.flip_h = true
	
	#Disable collision
	$CollisionShape2D.set_deferred("disabled", true)
	
	is_damaging = true
	
	$damage_timer.start()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($".", 'position', my_checkpoint,1.5).from(position)
	tween.tween_property($".", 'rotation', 12.566,1.5).from(0)
	position = my_checkpoint
	$bun_sprite.play("win")
	$damage_sound.play()


func _on_damage_timer_timeout():
	is_damaging = false
	$bun_sprite.play("win")
	print("damage done")
	
	#Enable collision
	$CollisionShape2D.set_deferred("disabled", false)
