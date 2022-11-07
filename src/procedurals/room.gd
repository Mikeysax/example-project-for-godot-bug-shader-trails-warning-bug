extends Reference
class_name ProceduralLevelRoom

var id: int setget , get_id
var min_size: int
var max_size: int
var dimensions: Vector2
var segments: Vector2
var centroid: Vector2
var bounds: Dictionary
var is_valid: bool
var door_ids: Array # TODO door_ids is int array

func _init(minimum_size: int, maximum_size: int) -> void:
	self.min_size = minimum_size
	self.max_size = maximum_size
#	self.centroid = null # TODO: Used to be passed in, maybe when the add option nullable types
	self.dimensions = create_room_dimensions(self.min_size, self.max_size)
	self.segments = create_room_segments(self.dimensions)
	self.bounds = Direction.get_bounds(self.centroid, self.segments)
	self.is_valid = true
	self.door_ids = []

func get_id() -> int:
	return self.get_instance_id()

func create_room_dimension(minimum: int, maximum: int) -> int:
	randomize()
	var value: int = floor(randi() % maximum)
	return Util.even_to_odd_int(value, minimum)
	
func create_room_dimensions(minimum: int, maximum: int) -> Vector2:
	return Vector2(
		create_room_dimension(minimum, maximum),
		create_room_dimension(minimum, maximum)
	)

func create_room_segments(dimensions: Vector2) -> Vector2:
	return Vector2(
		Util.bisect_odd_int(dimensions.x),
		Util.bisect_odd_int(dimensions.y)
	)
