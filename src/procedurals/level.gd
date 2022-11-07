extends Reference
class_name ProceduralLevel

var config: Dictionary
var data: Array
var rooms: Dictionary
var doors: Dictionary
var room_ids: Array
var door_ids: Array
var room_count: int
var door_count: int
var pending_rooms: Array
var pending_doors: Array
var placeable_door: ProceduralLevelDoor
var last_placed_room: ProceduralLevelRoom
var room_placement_failures: int

func _init(config: Dictionary) -> void:
	self.config = config
	self.data = initialize_data_structure()
	self.rooms = {}
	self.doors = {}
	self.room_ids = []
	self.door_ids = []
	self.room_count = 0
	self.door_count = 0
	self.pending_rooms = []
	self.pending_doors = []
	self.placeable_door = null
	self.last_placed_room = null
	self.room_placement_failures = 0
	create_level()

func initialize_data_structure() -> Array:
	var level_size: int = self.config.level.size
	var arr: Array = []
	for y in range(level_size):
		arr.append([])
		for _x in range(level_size):
			arr[y].append(0)
	return arr

func get_initial_centroid() -> Vector2:
	return Vector2(
		get_random_level_index(),
		get_random_level_index()
	)

func get_next_pending_door():
	self.placeable_door = self.pending_doors.pop_front()
	return self.placeable_door

func pending_doors_is_empty() -> bool:
	return self.pending_doors.size() == 0

func create_level():
	var rooms_total: int = self.config.rooms.total
	var max_room_placement_failures: int = self.config.rooms.max_placement_failures
	var room: ProceduralLevelRoom
	var is_initial: bool
	var is_valid: bool
	while self.room_count < rooms_total and self.room_placement_failures < max_room_placement_failures:
		is_initial = self.room_count == 0
		if not is_initial and pending_doors_is_empty():
			create_doors(self.last_placed_room)
			continue
		room = create_room(is_initial)
		is_valid = place_room(room)
		if not is_valid:
			self.room_placement_failures += 1
			if placeable_door_is_connectable():
				if not door_is_valid(self.placeable_door):
					continue
				place_door()
			continue
		if not is_initial:
			place_door(room)
		count_and_index_room(room)
		create_doors(room)

func count_and_index_room(room: ProceduralLevelRoom) -> void:
	self.room_ids.append(room.id)
	self.rooms[room.id] = room
	self.room_count += 1

func count_and_index_door(door: ProceduralLevelDoor, is_pending: bool = false) -> void:
	if is_pending:
		self.pending_doors.append(door)
	else:
		self.door_ids.append(door.id)
		self.doors[door.id] = door
		self.door_count += 1

func place_room(room: ProceduralLevelRoom) -> bool:
	if not room or not room_is_valid(room.centroid, room.segments):
		return false
	# TODO: When functions become first class,
	# we can rewrite this to use lambdas like JS
	# so the loop can be reused
	var coordinates: Vector2
	var y_base: int = room.segments.y
	var x_base: int = room.segments.x
	var y_max: int = y_base + 1
	var x_max: int = x_base + 1
	for y in range(-y_base, y_max):
		for x in range(-x_base, x_max):
			coordinates = Vector2(room.centroid.x + x, room.centroid.y + y)
			self.data[coordinates.y][coordinates.x] = room.id
	set_last_placed_room(room)
	return true

# TODO room argument is room or null
func place_door(room: ProceduralLevelRoom = null) -> void:
	var door = self.placeable_door
	if not door.to_room_id and room is ProceduralLevelRoom:
		door.to_room_id = room.id
	count_and_index_door(door)
	var coordinates: Vector2
	var y_base: int = door.segments.y
	var x_base: int = door.segments.x
	var y_max: int = y_base + 1
	var x_max: int = x_base + 1
	for y in range(-y_base, y_max):
		for x in range(-x_base, x_max):
			coordinates = Vector2(door.centroid.x + x, door.centroid.y + y)
			self.data[coordinates.y][coordinates.x] = door.id

func create_room(is_initial: bool) -> ProceduralLevelRoom:
	var room: ProceduralLevelRoom = ProceduralLevelRoom.new(
		self.config.rooms.size.minimum, 
		self.config.rooms.size.maximum
	)
	if is_initial:
		room.centroid = get_initial_centroid()
	else:
		room.centroid = get_centroid_from_last_door(room.segments)
		if self.placeable_door.id:
			room.door_ids.append(self.placeable_door.id)
	return room

func create_doors(room: ProceduralLevelRoom) -> void:
	randomize()
	# TODO: randomized direction name is supposed to be string array
	# also, randomize doesn't always need to be called due to performance
	# issues. Keep an eye on this.
	var randomized_direction_names: Array = Direction.CARDINAL_DIRECTION_NAMES.keys()
	randomized_direction_names.shuffle()
	var door: ProceduralLevelDoor
	for direction_name in randomized_direction_names:
		door = create_door(direction_name, room)
		if door_is_valid(door):
			count_and_index_door(door, true)

func create_door(direction_name: String, from_room: ProceduralLevelRoom) -> ProceduralLevelDoor:
	var width: int = self.config.doors.size.width
	var length: int = self.config.doors.size.length
	return ProceduralLevelDoor.new(width, length, direction_name, from_room)

func is_room_id(id: int) -> bool:
#	if not id: return false
	return typeof(id) == TYPE_INT and id != 0

func get_room_buffer() -> int:
	var maximum_room_size: int = self.config.rooms.size.maximum
	return int(floor((maximum_room_size + 1) / 2))

func get_random_level_index() -> int:
	# TODO: Might need to remove more instances of randomize()
	# As it's not needed and could be a performance hit
	randomize()
	var level_size: int = self.config.level.size
	var room_buffer: int = get_room_buffer()
	var middle_of_level = int(ceil(level_size / 2))
	var max_index: int = level_size - room_buffer
	var min_max_index: int = middle_of_level - room_buffer
	var max_min_index: int = middle_of_level + room_buffer
	var min_index: int = 0 + room_buffer
	var min_max_to_max_range: Array = range(min_max_index, max_index)
	var min_to_max_min_range: Array = range(min_index, max_min_index)
	var potential_values: Array = Util.unique_int_set(
		min_to_max_min_range,
		min_max_to_max_range
	)
	var potential_random_index: int = Util.get_random_int(potential_values.size() - 1, true)
	return potential_values[potential_random_index]

func coordinates_exceeds_level(coordinates: Vector2) -> bool:
	return coordinate_out_of_bounds(coordinates.x) or coordinate_out_of_bounds(coordinates.y)

func coordinate_out_of_bounds(coordinate: int) -> bool:
	var level_size: int = self.config.level.size
	return coordinate < 0 or coordinate > (level_size - 1)

func coordinate_is_taken(coordinates: Vector2) -> bool:
	return get_level_coordinate_value(coordinates) != 0

func coordinate_is_available(coordinates: Vector2) -> bool:
	return not coordinate_is_taken(coordinates)

func room_is_valid(centroid: Vector2, segments: Vector2) -> bool:
	var door_length: int = self.config.doors.size.length
	var separate_rooms: bool = true
	var coordinates: Vector2
	var seperate_rooms_value: int = door_length if separate_rooms else 0
	var y_base: int = segments.y + seperate_rooms_value
	var x_base: int = segments.x + seperate_rooms_value
	var y_max: int = y_base + 1
	var x_max: int = x_base + 1
	for y in range(-y_base, y_max):
		for x in range(-x_base, x_max):
			coordinates = Vector2(centroid.x + x, centroid.y + y)
			if coordinates_exceeds_level(coordinates) or coordinate_is_taken(coordinates):
				return false
	return true

func door_is_valid(door: ProceduralLevelDoor) -> bool:
	var coordinates: Vector2
	var y_base: int = door.segments.y
	var x_base: int = door.segments.x
	var y_max: int = y_base + 1
	var x_max: int = x_base + 1
	for y in range(-y_base, y_max):
		for x in range(-x_base, x_max):
			coordinates = Vector2(door.centroid.x + x, door.centroid.y + y)
			if coordinates_exceeds_level(coordinates) or coordinate_is_taken(coordinates):
				return false
	return true

func placeable_door_is_connectable() -> bool:
	var is_connectable: bool = true
	var door: ProceduralLevelDoor = self.placeable_door
	if not door:
		return false
	var coordinates_to_check_for_connectable_room: Vector2 = door.bounds[door.direction_name] + Direction[door.direction_name]
	if coordinates_exceeds_level(coordinates_to_check_for_connectable_room) or coordinate_is_available(coordinates_to_check_for_connectable_room):
		is_connectable = false
	else:
		var potential_room_id: int = get_level_coordinate_value(coordinates_to_check_for_connectable_room)
		if not is_room_id(potential_room_id) or door_is_too_close(door):
			is_connectable = false
		if is_connectable:
			is_connectable = Util.chance_to_fail(0.2)
		if is_connectable and potential_room_id != 0 and self.rooms[potential_room_id]:
			self.placeable_door.to_room_id = self.rooms[potential_room_id].id
	return is_connectable

func door_is_too_close(door: ProceduralLevelDoor) -> bool:
	# Opposite direction names should be string array
	var opposite_direction_names: Array = Direction.get_opposite_direction_names_from_direction(door.direction_name)
	var direction: Vector2
	var door_bound: Vector2
	for opposite_direction_name in opposite_direction_names:
		direction = Direction[opposite_direction_name]
		door_bound = door.bounds[opposite_direction_name]
		if coordinate_is_taken(door_bound + direction):
			return true
	return false

func get_centroid_from_last_door(room_segments: Vector2) -> Vector2:
	var door: ProceduralLevelDoor = get_next_pending_door()
	return get_room_centroid_from_door(door, room_segments)

func get_room_centroid_from_door(door: ProceduralLevelDoor, room_segments: Vector2) -> Vector2:
	var x: int = door.centroid.x
	var y: int = door.centroid.y
	match door.direction_name:
		Direction.NORTH_NAME:
			y = y - door.segments.y - room_segments.y
		Direction.SOUTH_NAME:
			y = y + door.segments.y + room_segments.y
		Direction.EAST_NAME:
			x = x + door.segments.x + room_segments.x
		Direction.WEST_NAME:
			x = x - door.segments.x - room_segments.x

	return Vector2(x, y) + Direction[door.direction_name]

func get_level_coordinate_value(coordinates: Vector2) -> int:
	return self.data[coordinates.y][coordinates.x]

func set_last_placed_room(room: ProceduralLevelRoom) -> void:
	self.last_placed_room = room

func log_debug(rooms_and_doors: bool = false) -> void:
		log_level()
		if rooms_and_doors:
			print('----------------')
			print('Rooms: ', self.room_count, self.rooms.keys().size())
			print(self.rooms)
			print('----------------')
			print('Doors: ', self.door_count, self.doors.keys().size())
			print(self.doors)

func log_level() -> void:
	for row_index in self.data.size():
		print(self.data[row_index])
