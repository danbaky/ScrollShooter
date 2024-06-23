extends Node2D
@export var mob_scene: PackedScene
@onready var lasers=$Lasers
@onready var player=$Player
@onready var asteroids=$Asteroids
@onready var hud=$UI/HUD
@onready var game_over_screen=$UI/GameOverScreen
var lives: int:
	set(value):
		lives = value
		hud.init_lives(lives)

var asteroid_scene=preload("res://scenes/asteroid.tscn")
var score:=0:
	set(value):
		score= value
		hud.score=score
		
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = asteroid_scene.instantiate()
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath2D/MobSpawnLoc
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	mob.connect("exploded",_on_asteroid_exploded)
	add_child(mob)
		
				
func _ready():
	$MobTimer.start()
	game_over_screen.visible=false
	score=0
	lives=2
	player.connect("died",_on_player_died)
	player.connect("laser_shot",_on_player_laser_shot)
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
		
func _process(delta):
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	
func _on_player_laser_shot(laser):
	lasers.add_child(laser)
func _on_asteroid_exploded(poss,size,points):
	score+=points
	for i in range(2):	
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(poss,Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(poss,Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass						

func spawn_asteroid(poss,size):	
	var a = asteroid_scene.instantiate()
	a.global_position=poss
	a.size=size
	a.connect("exploded",_on_asteroid_exploded)
	asteroids.call_deferred("add_child",a)
func _on_player_died():
	lives-=1
	if lives<=0:
		game_over_screen.visible=true
		player.process_mode=Node.PROCESS_MODE_DISABLED
		player.visible=false
	else:
		#await get_tree().create_timer(1).timeout
		player.respawn(global_position)
