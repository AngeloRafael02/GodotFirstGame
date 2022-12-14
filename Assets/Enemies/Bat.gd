extends KinematicBody2D

var knockback = Vector2.ZERO

onready var stats = $Stats
func _ready() -> void:
	print(stats.max_health)
	print(stats.health)
func _on_HurtBox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	print(stats.health)
	knockback = area.knockback_vector * 125
func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	knockback == move_and_slide(knockback)
func _on_Stats_no_health() -> void:
	queue_free()
