extends Area2D

var movement_vector:= Vector2(0,-1)
@export var speed:=1000.0
func _physics_process(delta):
	global_position+=movement_vector*speed*delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
func _on_area_entered(area):
	if area is Asteroid:
		var asteroid=area
		asteroid.explode()
		queue_free()
