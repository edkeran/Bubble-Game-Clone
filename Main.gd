extends Node2D

func _ready():
	pass 

func _on_Button_pressed():
	#Change the player scene
	get_tree().change_scene("res://Game.tscn");
	pass
