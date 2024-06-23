class_name Player extends CharacterBody2D
@onready var muzzle=$Muzzle
@onready var sprite=$Sprite2D
signal laser_shot(laser)
signal died

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var shoot_cd=false
var alive=true
func _process(delta):
	if !shoot_cd:
		shoot_cd = true
		shoot_laser()
		await get_tree().create_timer(0.3).timeout
		shoot_cd=false
	   
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var laser_scene=preload("res://scenes/laser.tscn")

func _physics_process(delta):
	var vel: Vector2=(get_global_mouse_position()-global_position)*50
	velocity=vel
	
	move_and_slide()
	
	var screen_size=get_viewport_rect().size
	if global_position.y<0:
		global_position.y=0
	elif global_position.y> screen_size.y:
		global_position.y=screen_size.y	
	if global_position.x<0:
		global_position.x=0
	elif global_position.x> screen_size.x:
		global_position.x=screen_size.x		
		
func shoot_laser():
	var l=laser_scene.instantiate()
	l.global_position =muzzle.global_position
	emit_signal("laser_shot",l)
func die():
	if alive==true:
		alive=false
		emit_signal("died")
		#process_mode=Node.PROCESS_MODE_DISABLED
		
		
func respawn(poss):
	if alive ==false:
		sprite.visible=false
		await get_tree().create_timer(0.2).timeout
		sprite.visible=true
		await get_tree().create_timer(0.2).timeout
		sprite.visible=false
		await get_tree().create_timer(0.2).timeout
		sprite.visible=true
		await get_tree().create_timer(0.2).timeout
		sprite.visible=false
		await get_tree().create_timer(0.2).timeout
		#global_position=poss
		alive=true
		velocity=Vector2.ZERO
		sprite.visible=true
