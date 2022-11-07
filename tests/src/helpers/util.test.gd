extends WAT.Test

var Util = preload("res://src/helpers/util.gd")

# Int Methods -------------------
func test_get_random_int() -> void:
	var random_int: int
	for i in 100:
		random_int = Util.get_random_int(i + 1)
		asserts.is_true(random_int <= i + 1)
		asserts.is_true(random_int >= 0)

func test_even_to_odd_int() -> void:
	var value: int
	for i in 100:
		value = Util.even_to_odd_int(i + 10, i + 1)
		asserts.is_true(value % 2 != 0)

func test_bisect_odd_int() -> void:
	var odd_int: int
	var value: int
	var expected_value: int
	for i in 100:
		odd_int = Util.even_to_odd_int(i, 1)
		value = Util.bisect_odd_int(odd_int)
		expected_value = int(max((odd_int - 1) / 2, 1))
		asserts.is_true(value >= 1)
		asserts.is_true(value == expected_value)

func test_rounded_halved_int() -> void:
	var value: int
	var expected_value: int
	for i in range(2, 100):
		value = Util.rounded_halved_int(i)
		expected_value = int(abs(ceil(i / 2)))
		asserts.is_true(value >= 1)
		asserts.is_true(value == expected_value)

func test_chance_to_fail() -> void:
	var value: bool = Util.chance_to_fail(0.5)
	asserts.is_true(value == true or value == false)

# Vector2 Methods -------------------
func test_rounded_halved_vector2() -> void:
	var input: Vector2 = Vector2(3, 3)
	var value: Vector2 = Util.rounded_halved_vector2(input)
	asserts.is_true(value == Vector2(1, 1))

# Time Methods -------------------
func test_get_time() -> void:
	var time: int = Util.get_time()
	asserts.is_true(time <= OS.get_unix_time())

# Array Methods -------------------
func test_array_contains() -> void:
	var arr: Array = range(1, 100)
	var value: int
	for i in arr:
		value = Util.array_contains(arr, i)
		asserts.is_true(value)

func test_unique_int_set() -> void:
	var arr1: Array = range(1, 25)
	var arr2: Array = range(1, 50)
	var value: Array = Util.unique_int_set(arr1, arr2)
	for i in range(1, 50):
		asserts.is_true(Util.array_contains(value, i))
		value.pop_front()
	asserts.is_true(value.size() == 0)
