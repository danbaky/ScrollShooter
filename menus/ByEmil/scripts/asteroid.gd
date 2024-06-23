class_name Asteroid extends Area2D

signal exploded(poss,size,points)

var movement_vector:= Vector2(0,1)

enum AsteroidSize{LARGE,MEDIUM,SMALL}
@export var size:= AsteroidSize.LARGE
var speed:=50
@onready var sprite =$Sprite2D
@onready var cshape = $CollisionShape2D

var points: int:
	get:
		match size:
			AsteroidSize.LARGE:
				return 100
			AsteroidSize.MEDIUM:
				return 50
			AsteroidSize.SMALL:
				return 25
			_:
				return 0			
func _ready():
	rotation=randf_range(-PI/6,PI/6)
	match size:
		AsteroidSize.LARGE:
			speed = 100
			sprite.texture=preload("res://assets/meteorBrown_med1.png")
			cshape.set_deferred("shape",preload("res://resourses/asteroidBig.tres"))
		AsteroidSize.MEDIUM:
			speed = 150
			sprite.texture=preload("res://assets/meteorBrown_small1.png")
			cshape.set_deferred("shape",preload("res://resourses/asteroidMed.tres"))			
		AsteroidSize.SMALL:
			speed = 200
			sprite.texture=preload("res://assets/meteorGrey_tiny1.png")
			cshape.set_deferred("shape",preload("res://resourses/asteroidTiny.tres"))
			
func _physics_process(delta):
	if size==AsteroidSize.LARGE:
		global_position+=movement_vector*speed*delta
	elif AsteroidSize.MEDIUM:
		global_position+=movement_vector.rotated(rotation)*speed*delta
	elif AsteroidSize.SMALL:	
		global_position+=movement_vector.rotated(rotation)*speed*delta	
	var screen_size=get_viewport_rect().size
	#if global_position.y<0:
	#	queue_free()
	if global_position.y> screen_size.y:
		queue_free()
		print("gg")
	#if global_position.x<0:
	#	queue_free()
	if global_position.x> screen_size.x:
		queue_free()
		print("hh")		
	
func explode():
	emit_signal("exploded",global_position,size,points)
	queue_free()


func _on_body_entered(body):
	if body is Player:
		var player=body
		player.die()
