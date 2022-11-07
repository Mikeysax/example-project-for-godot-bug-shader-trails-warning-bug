class_name Direction

const X: String = "x"
const Y: String = "y"

const NORTH_NAME: String = "NORTH"
const SOUTH_NAME: String = "SOUTH"
const WEST_NAME: String = "WEST"
const EAST_NAME: String = "EAST"
const NORTHWEST_NAME: String = NORTH_NAME + WEST_NAME
const NORTHEAST_NAME: String = NORTH_NAME + EAST_NAME
const SOUTHWEST_NAME: String = SOUTH_NAME + WEST_NAME
const SOUTHEAST_NAME: String = SOUTH_NAME + EAST_NAME

const NONE: Vector2 = Vector2(0, 0)
const NORTH: Vector2 = Vector2(0, -1)
const SOUTH: Vector2 = Vector2(0, 1)
const EAST: Vector2 = Vector2(1, 0)
const WEST: Vector2 = Vector2(-1, 0)
const NORTHWEST: Vector2 = NORTH + WEST
const NORTHEAST: Vector2 = NORTH + EAST
const SOUTHWEST: Vector2 = SOUTH + WEST
const SOUTHEAST: Vector2 = SOUTH + EAST

const CARDINAL_DIRECTION_NAMES: Dictionary = {
	NORTH_NAME: NORTH_NAME,
	SOUTH_NAME: SOUTH_NAME,
	EAST_NAME: EAST_NAME,
	WEST_NAME: WEST_NAME
}
const ORDINAL_DIRECTION_NAMES: Dictionary = {
	NORTHWEST_NAME: NORTHWEST_NAME,
	NORTHEAST_NAME: NORTHEAST_NAME,
	SOUTHWEST_NAME: SOUTHWEST_NAME,
	SOUTHEAST_NAME: SOUTHEAST_NAME
}

const CARDINAL_DIRECTIONS: Dictionary = {
	CARDINAL_DIRECTION_NAMES.NORTH: NORTH,
	CARDINAL_DIRECTION_NAMES.SOUTH: SOUTH,
	CARDINAL_DIRECTION_NAMES.EAST: EAST,
	CARDINAL_DIRECTION_NAMES.WEST: WEST
}
const ORDINAL_DIRECTIONS: Dictionary = {
	ORDINAL_DIRECTION_NAMES.NORTHWEST: NORTHWEST,
	ORDINAL_DIRECTION_NAMES.NORTHEAST: NORTHEAST,
	ORDINAL_DIRECTION_NAMES.SOUTHWEST: SOUTHWEST,
	ORDINAL_DIRECTION_NAMES.SOUTHEAST: SOUTHEAST
}

static func get_coordinate_type_from_direction(direction_name: String) -> String:
	if direction_name == CARDINAL_DIRECTION_NAMES.NORTH or direction_name == CARDINAL_DIRECTION_NAMES.SOUTH:
		return Y
	else:
		return X

static func get_opposite_coordinate_type_from_direction(direction_name: String) -> String:
	if direction_name == CARDINAL_DIRECTION_NAMES.NORTH or direction_name == CARDINAL_DIRECTION_NAMES.SOUTH:
		return X
	else:
		return Y

static func get_opposite_direction_names_from_direction(direction_name: String) -> Array:
	if direction_name == CARDINAL_DIRECTION_NAMES.NORTH or direction_name == CARDINAL_DIRECTION_NAMES.SOUTH:
		return [
			CARDINAL_DIRECTION_NAMES.EAST,
			CARDINAL_DIRECTION_NAMES.WEST
		]
	else:
		return [
			CARDINAL_DIRECTION_NAMES.NORTH,
			CARDINAL_DIRECTION_NAMES.SOUTH
		]

static func add_or_subtract_from_cardinal_direction(direction_name: String, vector_origin: Vector2, vector_modifier: Vector2) -> Vector2:
	if direction_name == CARDINAL_DIRECTION_NAMES.NORTH or direction_name == CARDINAL_DIRECTION_NAMES.WEST:
		return vector_origin - vector_modifier
	else:
		return vector_origin + vector_modifier

static func get_bounds(centroid: Vector2, segments: Vector2) -> Dictionary:
	return {
		CARDINAL_DIRECTION_NAMES.NORTH: Vector2(centroid.x, centroid.y - segments.y),
		CARDINAL_DIRECTION_NAMES.SOUTH: Vector2(centroid.x, centroid.y + segments.y),
		CARDINAL_DIRECTION_NAMES.EAST: Vector2(centroid.x + segments.x, centroid.y),
		CARDINAL_DIRECTION_NAMES.WEST: Vector2(centroid.x - segments.x, centroid.y),
	}
