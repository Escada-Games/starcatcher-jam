extends KinematicBody2D
class_name GravityBall

onready var nCollisionShape2d:CollisionShape2D = $collisionShape2D
export(float) var fSpeed := PI/2.0

func _ready() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	self.rotation += fSpeed * delta

func groundPounded() -> void:
	self.visible = false
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	yield(get_tree().create_timer(1.0), 'timeout')
	self.visible = true
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
