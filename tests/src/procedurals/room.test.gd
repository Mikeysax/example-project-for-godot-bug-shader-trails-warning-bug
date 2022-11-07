extends WAT.Test

var config = preload("res://tests/mocks/config.gd").MOCK_CONFIG
var room: Room

func start() -> void:
	room = Room.new(
		config.rooms.size.minimum, 
		config.rooms.size.maximum
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

func test_create_room_segments() -> void:
	# Runs when a room is instantiated
	var segments: Vector2 = room.segments
	asserts.is_true(typeof(segments) == TYPE_VECTOR2)
	asserts.is_true(segments.x > 0)
	asserts.is_true(segments.y > 0)
	asserts.is_true(segments.x < room.dimensions.x)
	asserts.is_true(segments.y < room.dimensions.y)

func test_create_room_dimensions() -> void:
	# Runs when a room is instantiated
	var dimensions: Vector2 = room.dimensions
	asserts.is_true(typeof(dimensions) == TYPE_VECTOR2)
	asserts.is_true(dimensions.x > 0)
	asserts.is_true(dimensions.y > 0)
	asserts.is_true(dimensions.x > room.segments.x)
	asserts.is_true(dimensions.y > room.segments.y)

func test_create_room_dimension() -> void:
	var minimum: int = config.rooms.size.minimum
	var maximum: int = config.rooms.size.maximum
	var dimension: int = room.create_room_dimension(minimum, maximum)
	if minimum % 2 != 0 or maximum % 2 != 0:
		asserts.is_true(dimension >= minimum - 1 and dimension <= maximum + 1)
	else:
		asserts.is_true(dimension >= minimum and dimension <= maximum)
