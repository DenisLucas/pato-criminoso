extends KinematicBody2D

export (int) var speed = 1200
export (int) var gravity = 4000
export (int) var jump_speed = -1800

var Velocity = Vector2.ZERO
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var Deacc = 0.1
export (float, 0, 1.0) var acceleration = 0.25
export (float, 0, 1.0) var fallbreak = 0.1
var Cjump = true
var OnStair = false

signal hit()

func GetInput():
	var dir = 0
	if Input.is_action_pressed("Move-Right"):
		dir += 1
		$"patinho criminoso".flip_h = true
	if Input.is_action_pressed("Move-Left"):
		dir -= 1
		$"patinho criminoso".flip_h = false

	if OnStair:
		if Input.is_action_pressed("Move-Down"):
			Velocity.y = lerp(Velocity.y, speed, fallbreak)
		if Input.is_action_pressed("Jump"):
			Velocity.y = lerp(Velocity.y, -speed, fallbreak)
		if Input.is_action_just_released("Jump") or Input.is_action_just_released("Move-Down"):
			Velocity.y = 0
		if Input.is_action_just_released("Move-Left") or Input.is_action_just_released("Move-Right"):
			Velocity.x = 0
	if dir != 0:
		if Cjump:
			$AnimationPlayer.play("walk")
		Velocity.x = lerp(Velocity.x, dir * speed, acceleration)
	if dir == 0 and Cjump:
		Velocity.x = lerp(Velocity.x, 0, friction)
	if dir == 0 and not Cjump:
		Velocity.x = lerp(Velocity.x, 0, Deacc)
	if dir == 0:
		$AnimationPlayer.stop()
		$"patinho criminoso".frame = 0
func _physics_process(delta):
	GetInput()
	if is_on_floor():
		Cjump = true
	if not OnStair:
		Velocity.y += gravity * delta
	Velocity = move_and_slide(Velocity, Vector2.UP)
	if Input.is_action_just_pressed("Jump"):
		if Cjump and !OnStair:
			Velocity.y = jump_speed
	if Input.is_action_just_released("Jump"):
		if Velocity.y < 0:
			Velocity.y = lerp(Velocity.y, 0, fallbreak)

func _on_Timer_timeout():
	Cjump = false
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("ground"):
		Cjump = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("ground"):
		$JumpSave.start()

func _on_stairs_body_entered(body):
	if body.is_in_group("player"):
			OnStair = true
			Velocity.y = 0


func _on_stairs_body_exited(body):
	if body.is_in_group("player"):
		OnStair = false
		Cjump = true
		Velocity.y = 0


func _on_hit_body_entered(body):
	if body.is_in_group("damage"):
		emit_signal("hit")


func _on_hit_area_entered(area):
	if area.is_in_group("damage"):
		emit_signal("hit")
