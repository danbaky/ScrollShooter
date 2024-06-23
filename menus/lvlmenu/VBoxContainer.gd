extends VBoxContainer


func _on_button_pressed():
	get_tree().change_scene_to_file("res://menus/lvl1sublvlmenu/lvl1sublvlmenu.tscn")
	
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://menus/lvl2sublvlmenu/lvl2sublvlmenu.tscn") 


func _on_button_3_pressed():
	get_tree().change_scene_to_file('res://menus/menu/main_menu.tscn')  # #  # Replace with function body.
