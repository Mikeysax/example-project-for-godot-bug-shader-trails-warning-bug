extends Reference
class_name ProceduralLevelDoor

var id: int setget , get_id
var width: int
var length: int
var dimensions: Vector2
var segments: Vector2
var centroid: Vector2
var bounds: Dictionary
var direction_name: String
var from_room_id: int
var to_room_id: int

func _init(width: int, length: int, direction_name: String, from_room: ProceduralLevelRoom) -> void:
	self.width = width
	self.length = length
	self.direction_name = direction_name
	self.dimensions = create_door_dimensions(self.width, self.length, self.direction_name)
	self.segments = create_door_segments(self.dimensions)
	self.centroid = get_door_centroid(from_room, self.segments, self.direction_name)
	self.bounds = Direction.get_bounds(self.centroid, self.segments)
	self.from_room_id = from_room.id
	self.to_room_id
	
func get_id() -> int:
	return self.get_instance_id()

func create_door_dimensions(width: int, length: int, direction_name: String) -> Vector2:
	var cardinal_direction_names: Dictionary = Direction.CARDINAL_DIRECTION_NAMES
	var x: int = length
	var y: int = width
	if direction_name == cardinal_direction_names.NORTH or direction_name == cardinal_direction_names.SOUTH:
		x = self.width
		y = self.length
	return Vector2(x, y)

func create_door_segments(dimensions: Vector2) -> Vector2:
	var segments: Vector2 = Util.rounded_halved_vector2(dimensions)
	# TODO: We might not have to minus 1 from the door segments
	# because I was getting negative vector2s ie -1 -1
	return segments #if segments == Vector2(0, 0) else segments - Vector2(1, 1)

func get_wall_centroid(from_room_centroid: Vector2, from_room_bounds: Dictionary, direction_name: String) -> Vector2:
	return from_room_centroid + from_room_bounds[direction_name] + Direction.CARDINAL_DIRECTIONS[direction_name]

func randomize_wall_centroid(wall_centroid: Vector2, direction_name: String, room_segments: Vector2) -> Vector2:
	randomize()
	var opposite_coordinate_type: String = Direction.get_opposite_coordinate_type_from_direction(direction_name)
	var segment: int = room_segments[opposite_coordinate_type]
	# NOTE: Not sure why 1 is added to the segment range
	var segment_range: Array = range(-segment, abs(segment) + 1)
	var segment_random_index: int = randi() % segment_range.size()
	var random_wall_cell: Vector2 = Vector2(0, 0)
	random_wall_cell[opposite_coordinate_type] = segment_range[segment_random_index]
	return wall_centroid + random_wall_cell

func get_door_centroid(from_room: ProceduralLevelRoom, segments: Vector2, direction_name: String) -> Vector2:
	var wall_centroid: Vector2 = get_wall_centroid(from_room.centroid, from_room.bounds, direction_name)
	var random_wall_centroid: Vector2 = randomize_wall_centroid(wall_centroid, direction_name, from_room.segments)
	return Direction.add_or_subtract_from_cardinal_direction(direction_name, random_wall_centroid, segments)
