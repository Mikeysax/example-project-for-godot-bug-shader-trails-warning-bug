class_name Util

# Int Methods -------------------
static func get_random_int(max_number: int, zero_inclusive: bool = false) -> int:
	randomize()
	return randi() % max_number + (0 if zero_inclusive else 1)

static func even_to_odd_int(value: int, minimum: int) -> int:
	randomize()
	if value % 2 == 0:
		if randi() > 0.5:
			value += 1
		else:
			value -= 1
	if value < minimum: 
		value = minimum
	return int(abs(value))
	
static func bisect_odd_int(number: int) -> int:
	return int(max((number - 1) / 2, 1))
	
static func rounded_halved_int(number: int) -> int:
	return int(abs(ceil(number / 2)))
	
static func chance_to_fail(chance: float) -> bool:
	return (randf() * 100) > (chance * 100)

# Vector2 Methods -------------------
static func rounded_halved_vector2(vector2: Vector2) -> Vector2:
	return Vector2(
		rounded_halved_int(vector2.x),
		rounded_halved_int(vector2.y)
	)

static func cartesian_to_isometric(cartesian: Vector2) -> Vector2:
	return Vector2(
		cartesian.x - cartesian.y , 
		cartesian.x + cartesian.y
	) / 2

# Time Methods -------------------
static func get_time() -> float:
	return Time.get_unix_time_from_system()
	
# Array Methods -------------------
static func array_contains(arr, value) -> bool:
	for i in arr:
		if i == value:
			return true
	return false

# TODO: When typed arrays are added, add int for all arguments and return value
static func unique_int_set(arr1: Array, arr2: Array) -> Array:
	var unique_int_array: Array = []
	for i in arr1 + arr2:
		if not unique_int_array.has(i):
			unique_int_array.append(i)
	return unique_int_array

# EventBus Methods -----------------
static func safe_connect(source: Object, signal_name: String, dest: Object, func_name: String, binds := [], flags := 0):
	if not source or not dest:
		return
	if not source.is_connected(signal_name, dest, func_name):
		var err := source.connect(signal_name, dest, func_name, binds, flags)
		if err != OK:
			print("Could not connect ", signal_name, " from ", source, " on ", dest, ".", func_name, " - Code ", err)

# Just a shorthand to append a value to an array stored in a dictionary but you don't know in advance if
# said array already exists or if it needs to be created first.
static func append_to_dict(dict, key, row):
	if dict.has(key):
		dict[key].append(row)
	else:
		dict[key] = [row]
