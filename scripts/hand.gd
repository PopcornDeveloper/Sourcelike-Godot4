extends Node3D

var held_object
@export var sway_speed := 50.0

var desired_rotation = Vector3.ZERO
var desired_position = Vector3.ZERO

@onready var reach_cast = $ReachCast

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		desired_rotation.y = rotation.y + -event.relative.x * 0.001
		desired_rotation.x = rotation.x + -event.relative.y * 0.001

func _physics_process(delta: float) -> void:

	desired_rotation = lerp(desired_rotation, Vector3.ZERO, 20 * delta)
	var tween_rot = get_tree().create_tween()
	tween_rot.tween_property(self,"rotation", desired_rotation, 0.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
