extends WAT.Test

var config = preload("res://tests/mocks/config.gd").MOCK_CONFIG
var level: Level

func start() -> void:
	level = Level.new(config)

func end() -> void:
	pass

func pre() -> void:
	pass

func post() -> void:
	pass

func test_initialize_data_structure() -> void:
	var level_size: int = config.level.size
	level.initialize_data_structure()
	# Checks that the level size is the correct height and width
	asserts.is_equal(level.data.size(), level_size)
	for row_index in level.data.size():
		asserts.is_equal(level.data[row_index].size(), level_size)

func test_get_initial_centroid() -> void:
	var level_size: int = config.level.size
	var centroid: Vector2 = level.get_initial_centroid()
	# Is less than level size and larger than 0
	asserts.is_less_than(centroid.x, level_size)
	asserts.is_greater_than(centroid.x, 0)
	asserts.is_less_than(centroid.y, level_size)
	asserts.is_greater_than(centroid.y, 0)

#func test_get_random_level_index() -> void:
#	pass
