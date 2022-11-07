extends WAT.Test

var config = preload("res://tests/mocks/config.gd").MOCK_CONFIG

var room: Room
var door: Door

func start() -> void:
	print('CONFIG: ', config)
	room = Room.new(
		config.rooms.size.minimum, 
		config.rooms.size.maximum
	)
	door = Door.new(
		config.doors.size.width, 
		config.doors.size.length, 
		Direction.CARDINAL_DIRECTION_NAMES.keys()[
			Util.get_random_int(4, true)
		], 
		room
	)

func end() -> void:
	pass

func pre() -> void:
	pass

func post() -> void:
	pass

func test_get_id() -> void:
	var id: int = room.id
	asserts.is_true(id > 0)
	asserts.is_true(typeof(id) == TYPE_INT)

func test_create_door_dimensions() -> void:
	# Runs when a doom is instantiated
	var dimensions: Vector2 = door.dimensions
	asserts.is_true(typeof(dimensions) == TYPE_VECTOR2)
	asserts.is_true(dimensions.x > 0)
	asserts.is_true(dimensions.y > 0)
	asserts.is_true(dimensions.x > door.segments.x)
	asserts.is_true(dimensions.y > door.segments.y)

func test_create_door_segments() -> void:
	# Runs when a door is instantiated
	var segments: Vector2 = door.segments
	asserts.is_true(typeof(segments) == TYPE_VECTOR2)
	asserts.is_true(segments.x >= 0)
	asserts.is_true(segments.y >= 0)
	asserts.is_true(segments.x <= door.dimensions.x)
	asserts.is_true(segments.y <= door.dimensions.y)

func test_get_wall_centroid() -> void:
	var wall_centroid: Vector2 = door.get_wall_centroid(room.centroid, room.bounds, door.direction_name)
	var expected_value: Vector2 = room.bounds[door.direction_name] + Direction.CARDINAL_DIRECTIONS[door.direction_name]
	asserts.is_true(wall_centroid == expected_value)

func test_randomize_wall_centroid() -> void:
	var wall_centroid: Vector2 = door.get_wall_centroid(room.centroid, room.bounds, door.direction_name)
	var randomized_wall_centroid: Vector2 = door.randomize_wall_centroid(wall_centroid, door.direction_name, room.segments)
	var opposite_coordinate_type: String = Direction.get_opposite_coordinate_type_from_direction(door.direction_name)
	var coordinate_expected_to_change: int = randomized_wall_centroid[opposite_coordinate_type]
	var min_potential_coordinate: int = wall_centroid[opposite_coordinate_type] - room.segments[opposite_coordinate_type]
	var max_potential_coordinate: int = wall_centroid[opposite_coordinate_type] + room.segments[opposite_coordinate_type]
	# NOTE: Expected outputs are within range of potential 
	#  coordinates that can be selected
	#  due to some randomness when selected 
	#  a wall coordinate from the wall centroid.
	var expected_output: bool = coordinate_expected_to_change >= min_potential_coordinate
	var expected_output_2: bool = coordinate_expected_to_change <= max_potential_coordinate
	asserts.is_true(expected_output and expected_output_2)

func test_get_door_centroid() -> void:
	var centroid: Vector2 = door.centroid
	var opposite_coordinate_type: String = Direction.get_opposite_coordinate_type_from_direction(door.direction_name)
	var expected_centroid_general_coordinates: Vector2 = room.bounds[door.direction_name] 
	expected_centroid_general_coordinates[opposite_coordinate_type] += Util.rounded_halved_int(door.length)
	var min_potential_coordinate: int = expected_centroid_general_coordinates[opposite_coordinate_type] - room.segments[opposite_coordinate_type]
	var max_potential_coordinate: int = expected_centroid_general_coordinates[opposite_coordinate_type] + room.segments[opposite_coordinate_type]
	# NOTE: Expected outputs are within range of potential 
	#  coordinates that can be selected
	#  due to some randomness when selected 
	#  a wall coordinate from the wall centroid.
	var expected_output: bool = expected_centroid_general_coordinates[opposite_coordinate_type] >= min_potential_coordinate
	var expected_output_2: bool = expected_centroid_general_coordinates[opposite_coordinate_type] <= max_potential_coordinate
	asserts.is_true(expected_output and expected_output_2)
