extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func create_grass_effect():
	var GrassEffect = load("res://Assets/Effects/GrassFX.tscn") #scene
	var grassEffect = GrassEffect.instance() #instance of scene (node)
	var world = get_tree().current_scene #gets root scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position
func _on_HurtBox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()
