extends Reference
class_name MeshPlacer

var grass_mmi_scene: PackedScene = preload("res://src/gridmaps/grass/grass.tscn")

var floor_grid_map: GridMap
#var wall_tile_map: TileMap
var config: Dictionary
var level: ProceduralLevel

func _init(config: Dictionary, level: ProceduralLevel, floor_grid_map: GridMap) -> void:
	self.config = config
	self.level = level
	self.floor_grid_map = floor_grid_map
	set_meshes()

func set_floor_mesh(coordinates: Vector2) -> void:
	var mesh_item_number: int = pick_floor_mesh()
	self.floor_grid_map.set_cell_item(coordinates.x, 0, coordinates.y, mesh_item_number)

func pick_floor_mesh() -> int:
	var mesh_count: int = self.floor_grid_map.mesh_library.get_item_list().size()
	var random_mesh_number: int = Util.get_random_int(mesh_count)
	return self.floor_grid_map.mesh_library.find_item_by_name('floor' + String(random_mesh_number))

func set_foliage_sprite(coordinates: Vector2) -> void:
	var grass: MultiMeshInstance = grass_mmi_scene.instance()
	var grass_offset: Vector3 = Vector3(0, 0.5, 0)
	self.floor_grid_map.add_child(grass)
	grass.global_transform.origin = self.floor_grid_map.map_to_world(coordinates.x, 1, coordinates.y) - grass_offset

#func draw_wall_tile(coordinates: Vector2) -> void:
#	var tile_number: int = pick_wall_tile()
#	self.wall_tile_map.set_cell(coordinates.x, coordinates.y, tile_number)
#
#func pick_wall_tile() -> int:
#	var tile_count: int = self.wall_tile_map.tile_set.get_tiles_ids().size()
#	var random_tile_number: int = Util.get_random_int(tile_count)
#	return self.wall_tile_map.tile_set.find_tile_by_name('wall' + String(random_tile_number))

func set_meshes() -> void:
	var size: int = config.level.size
	var coordinates: Vector2
	for y in range(size):
		for x in range(size):
			coordinates = Vector2(x, y)
			if self.level.coordinate_is_taken(coordinates): # self.level.data[coordinates.y][coordinates.x] != 0:
				set_floor_mesh(coordinates)
				#set_foliage_sprite(coordinates) # TODO: passing for now so I can see the animation footwork better

#			elif ground_around_cell(coordinates):
#				draw_wall_tile(coordinates)
				
#			if LEVEL_DATA[x][y] == 0:
#				place_wall_tile(x, y)
#			elif LEVEL_DATA[x][y] > 0:
#				# Can add future logic here for adding doors and not just floors
#				# Would need to alter the elif statement and such because
#				# floors are only 1 and not 2 or more.
#				place_floor_tile(x, y)

#func ground_around_cell(cell_coordinates: Vector2) -> bool:
#	var place_wall: bool = false
#	var coordinates: Vector2
#	for y2 in range(-1, 2):
#		for x2 in range(-1, 2):
#			coordinates = Vector2(cell_coordinates.x + x2, cell_coordinates.y + y2)
#			if self.level.coordinates_exceeds_level(coordinates):
#				pass
#			elif self.level.coordinate_is_taken(coordinates):
#				return true
#	return false

#func find_wall_tile_name(x: int, y: int):
#	if ground_around_cell(x, y):
#		# Add logic for adding specific type of wall
#		var northwest: bool = is_ground(x, y, 'northwest')
#		var southwest: bool = is_ground(x, y, 'southwest')
#		var northeast: bool = is_ground(x, y, 'northeast')
#		var southeast: bool = is_ground(x, y, 'southeast')
#		var north: bool = is_ground(x, y, 'north')
#		var south: bool = is_ground(x, y, 'south')
#		var east: bool = is_ground(x, y, 'east')
#		var west: bool = is_ground(x, y, 'west')
#		if south:
#			if west:
#				#if east:
#				#	find_and_place_wall_tile_by_name(x, y, true, 'north_edge')
#				#elif north:
#				#	find_and_place_wall_tile_by_name(x, y, true, 'east_edge')
#				#else:
#					var rand_number: String = String(get_random_number(5))
#					return 'northeast_outer_corner' + rand_number
#			elif east:
#				#if north:
#				#	find_and_place_wall_tile_by_name(x, y, true, 'west_edge')
#				#else:
#					var rand_number: String = String(get_random_number(5))
#					return 'northwest_outer_corner' + rand_number
#			else:
#				var rand_number: String = String(get_random_number(5))
#				return 'north' + rand_number
#		elif north:
#			if west:
#				#if east:
#				#	find_and_place_wall_tile_by_name(x, y, true, 'south_edge')
#				#elif south:
#				#	find_and_place_wall_tile_by_name(x, y, true, 'west_edge')
#				#else:
#					return 'southeast_outer_corner1'
#			elif east:
#				return 'southwest_outer_corner1'
#			else:
#				return 'south1'
#		elif east:
#			return 'west1'
#		elif west:
#			return 'east1'
#		elif southwest:
#			return 'northeast_long_inner_corner1'
#		elif southeast:
#			return 'northwest_long_inner_corner1'
#		elif northwest:
#			return 'southeast_inner_corner1'
#		elif northeast:
#			return 'southwest_inner_corner1'
#	else:
#		return 'empty'
#
#func place_wall_tile(x: int, y: int) -> void:
#	var tile_name: String = find_wall_tile_name(x, y)
#	var sort: bool = false if tile_name == 'empty' else true
##	TODO: Turns off the empty placement of the fully black walls
##	if sort:
#	find_and_place_wall_tile_by_name(x, y, sort, tile_name)

#
#func pick_tileset(is_wall: bool = true, sort: bool = true):
#	if is_wall:
#		if sort:
#			return WALL_TILES_Y_SORT
#		else:
#			return WALL_TILES
#	else:
#		return FLOOR_TILES
#
#func find_and_place_wall_tile_by_name(x: int, y: int, sort: bool, name: String, flip_x: bool = false, flip_y = false) -> void:
#	var tile_set_node = pick_tileset(true, sort)
#	var found_tile = tile_set_node.tile_set.find_tile_by_name(name)
#	tile_set_node.set_cell(x, y, found_tile, flip_x, flip_y)
#
#func is_ground(x: int, y: int, direction: String) -> bool:
#	var coordinates = Vector2(x, y) + DIRECTIONS[direction]
#	if coordinates_exceed_world(coordinates.x, coordinates.y):
#		return false
#	else:
#		return LEVEL_DATA[coordinates.x][coordinates.y] >= 1
#

