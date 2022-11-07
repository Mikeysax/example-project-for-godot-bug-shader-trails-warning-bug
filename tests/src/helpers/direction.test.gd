extends WAT.Test

var Direction = preload("res://src/helpers/direction.gd")

func test_x() -> void:
	asserts.is_equal(Direction.X, "x")

func test_y() -> void:
	asserts.is_equal(Direction.Y, "y")

func test_north_name() -> void:
	asserts.is_equal(Direction.NORTH_NAME, "NORTH")

func test_south_name() -> void:
	asserts.is_equal(Direction.SOUTH_NAME, "SOUTH")

func test_west_name() -> void:
	asserts.is_equal(Direction.WEST_NAME, "WEST")

func test_east_name() -> void:
	asserts.is_equal(Direction.EAST_NAME, "EAST")

func test_northwest_name() -> void:
	asserts.is_equal(Direction.NORTHWEST_NAME, "NORTHWEST")

func test_northeast_name() -> void:
	asserts.is_equal(Direction.NORTHEAST_NAME, "NORTHEAST")

func test_southwest_name() -> void:
	asserts.is_equal(Direction.SOUTHWEST_NAME, "SOUTHWEST")

func test_southeast_name() -> void:
	asserts.is_equal(Direction.SOUTHEAST_NAME, "SOUTHEAST")

func test_none() -> void:
	asserts.is_equal(Direction.NONE, Vector2(0, 0))

func test_north() -> void:
	asserts.is_equal(Direction.NORTH, Vector2(0, -1))

func test_south() -> void:
	asserts.is_equal(Direction.SOUTH, Vector2(0, 1))

func test_west() -> void:
	asserts.is_equal(Direction.WEST, Vector2(-1, 0))

func test_east() -> void:
	asserts.is_equal(Direction.EAST, Vector2(1, 0))

func test_northwest() -> void:
	asserts.is_equal(Direction.NORTHWEST, Vector2(-1, -1))

func test_northeast() -> void:
	asserts.is_equal(Direction.NORTHEAST, Vector2(1, -1))

func test_southwest() -> void: 
	asserts.is_equal(Direction.SOUTHWEST, Vector2(-1, 1))

func test_southeast() -> void: 
	asserts.is_equal(Direction.SOUTHEAST, Vector2(1, 1))

func test_cardinal_directions() -> void:
	var cardinal_directions: Dictionary = Direction.CARDINAL_DIRECTIONS
	asserts.is_equal(cardinal_directions.NORTH, Vector2(0, -1))
	asserts.is_equal(cardinal_directions.SOUTH, Vector2(0, 1))
	asserts.is_equal(cardinal_directions.EAST, Vector2(1, 0))
	asserts.is_equal(cardinal_directions.WEST, Vector2(-1, 0))

func test_cardinal_direction_names() -> void:
	var cardinal_direction_names: Dictionary = Direction.CARDINAL_DIRECTION_NAMES
	asserts.is_equal(cardinal_direction_names.NORTH, "NORTH")
	asserts.is_equal(cardinal_direction_names.SOUTH, "SOUTH")
	asserts.is_equal(cardinal_direction_names.EAST, "EAST")
	asserts.is_equal(cardinal_direction_names.WEST, "WEST")

func test_ordinal_directions() -> void:
	var ordinal_directions: Dictionary = Direction.ORDINAL_DIRECTIONS
	asserts.is_equal(ordinal_directions.NORTHWEST, Vector2(-1, -1))
	asserts.is_equal(ordinal_directions.SOUTHWEST, Vector2(-1, 1))
	asserts.is_equal(ordinal_directions.NORTHEAST, Vector2(1, -1))
	asserts.is_equal(ordinal_directions.SOUTHEAST, Vector2(1, 1))
	
func test_ordinal_direction_names() -> void:
	var ordinal_direction_names: Dictionary = Direction.ORDINAL_DIRECTION_NAMES
	asserts.is_equal(ordinal_direction_names.NORTHWEST, "NORTHWEST")
	asserts.is_equal(ordinal_direction_names.SOUTHWEST, "SOUTHWEST")
	asserts.is_equal(ordinal_direction_names.NORTHEAST, "NORTHEAST")
	asserts.is_equal(ordinal_direction_names.SOUTHEAST, "SOUTHEAST")

func test_get_coordinate_type_from_direction() -> void:
	asserts.is_equal(Direction.get_coordinate_type_from_direction("NORTH"), "y")
	asserts.is_equal(Direction.get_coordinate_type_from_direction("SOUTH"), "y")
	asserts.is_equal(Direction.get_coordinate_type_from_direction("WEST"), "x")
	asserts.is_equal(Direction.get_coordinate_type_from_direction("EAST"), "x")

func test_get_opposite_coordinate_type_from_direction() -> void:
	asserts.is_equal(Direction.get_opposite_coordinate_type_from_direction("NORTH"), "x")
	asserts.is_equal(Direction.get_opposite_coordinate_type_from_direction("SOUTH"), "x")
	asserts.is_equal(Direction.get_opposite_coordinate_type_from_direction("WEST"), "y")
	asserts.is_equal(Direction.get_opposite_coordinate_type_from_direction("EAST"), "y")

func test_get_opposite_direction_names_from_direction() -> void:
	asserts.is_equal(Direction.get_opposite_direction_names_from_direction("NORTH"), ["EAST", "WEST"])
	asserts.is_equal(Direction.get_opposite_direction_names_from_direction("SOUTH"), ["EAST", "WEST"])
	asserts.is_equal(Direction.get_opposite_direction_names_from_direction("WEST"), ["NORTH", "SOUTH"])
	asserts.is_equal(Direction.get_opposite_direction_names_from_direction("EAST"), ["NORTH", "SOUTH"])

func test_add_or_subtract_from_cardinal_direction() -> void:
	var vector_origin: Vector2 = Vector2(2, 2)
	var vector_modifier: Vector2 = Vector2(1, 1)
	asserts.is_equal(Direction.add_or_subtract_from_cardinal_direction("NORTH", vector_origin, vector_modifier), Vector2(1, 1))
	asserts.is_equal(Direction.add_or_subtract_from_cardinal_direction("WEST", vector_origin, vector_modifier), Vector2(1, 1))
	asserts.is_equal(Direction.add_or_subtract_from_cardinal_direction("SOUTH", vector_origin, vector_modifier), Vector2(3, 3))
	asserts.is_equal(Direction.add_or_subtract_from_cardinal_direction("EAST", vector_origin, vector_modifier), Vector2(3, 3))

func test_get_bounds() -> void:
	var centroid = Vector2(5, 5)
	var segments = Vector2(1, 1)
	var bounds = Direction.get_bounds(centroid, segments)
	asserts.is_equal(bounds.NORTH, Vector2(5, 4))
	asserts.is_equal(bounds.SOUTH, Vector2(5, 6))
	asserts.is_equal(bounds.EAST, Vector2(6, 5))
	asserts.is_equal(bounds.WEST, Vector2(4, 5))
