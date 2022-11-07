extends Node

var config: Dictionary = {
	"level": { 
		"size": 80 
	},
	"rooms": { 
		"total": 5, 
		"size": { 
			"minimum": 3,
			"maximum": 21
		},
		"max_placement_failures": 30
	},
	"doors": {
		"size": {
			"width": 1,
			"length": 3
		}
	}
}
var floor_grid_map_scene: PackedScene = preload("res://src/gridmaps/test_floor/test.tscn")
#var wall_tile_map_scene: PackedScene = preload("res://src/tilemaps/test_wall/test.tscn")

var player_scene: PackedScene = preload("res://src/scenes/player.player.tscn")
#var camera_scene: PackedScene = preload("res://src/scenes/camera/camera.tscn")

var floor_grid_map: GridMap
#var wall_tile_map: TileMap
var player: Player
var level: ProceduralLevel
var mesh_placer: MeshPlacer

func _init() -> void:
	self.floor_grid_map = floor_grid_map_scene.instance()
#	self.wall_tile_map = wall_tile_map_scene.instance()
	self.player = player_scene.instance()
#	self.camera = camera_scene.instance()
	
	add_child(self.player)
	add_child(self.floor_grid_map)
#	add_child(self.wall_tile_map)
#	self.wall_tile_map.add_child(self.player)
#
	self.level = ProceduralLevel.new(config)
	self.mesh_placer = MeshPlacer.new(
		config, 
		self.level,
		self.floor_grid_map
	)
	print('TEST3d INIT: ')
	print('LEVEL: ', self.level)
	print('MESH PLACER: ', self.mesh_placer)
	print('PLAYER: ', self.player)
	self.player.place_at_start(self.level, self.floor_grid_map)

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
