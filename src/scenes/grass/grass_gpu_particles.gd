extends GPUParticles3D

@export var extents: Vector2 = Vector2.ONE
@export var spawn_outside_circle: bool = false
@export var radius: float = 12.0
@export var character_path: NodePath

var character: CharacterBody3D

func _ready() -> void:
	self.character = get_node(self.character_path)

func _process(_delta: float) -> void:
	self.update_character_position()

func update_character_position() -> void:
#	TODO: Need to not update if character above a certain height
	self.material_override.set(
		"character_position", 
		character.global_transform.origin
	)
