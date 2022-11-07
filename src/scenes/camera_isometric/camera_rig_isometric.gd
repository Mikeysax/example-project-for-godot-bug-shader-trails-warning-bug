extends Node3D

var camera_rig: Node3D
var camera: Camera3D
var camera_rig_target: Node3D
var camera_rig_target_position: Vector3

@export var camera_rig_target_path: NodePath

# NOTE: Zoom Params
@export var max_zoom: float = 4
@export var min_zoom: float = 2
@export var zoom_step: float = 2
@export var zoom_y_step: float = 0.15
@export var zoom_input: int = 0
@export var zoom_speed: float = 5.0
@export var zoom_sensitivity: float = 1.0
@export var zoom_smoothness: float = 0.02

# NOTE: Rotation Params
@export var y_rotation_input: int = 0
@export var rotation_speed: float = PI / 2
@export var rotation_sensitivity: float = 1.0
@export var rotation_smoothness: float = 0.02

# NOTE: Camera Rig
@export var camera_rig_height_offset: float = 1
@export var camera_rig_lerp_speed: float = 5.0
@export var camera_rig_rotation_vertical: float = 0.0
@export var camera_rig_rotation_horizontal: float = 0.45 #45.0 Degrees

# NOTE: Camera
@export var camera_size: int = 12
@export var camera_fov: int = 15
@export var camera_near: float = 0.001
@export var camera_far: int = 400
@export var camera_distance: float = 30.0
@export var camera_height: float = 15.0
@export var camera_rotation_vertical: float = -0.45 #-45 Degrees
@export var camera_rotation_horizontal: float = 0.0

@onready var current_zoom: float = self.max_zoom

func _ready() -> void:
	set_physics_process(true)
	set_as_top_level(true)
	self.get_nodes()
	self.setup_camera()

func _input(event: InputEvent) -> void:
	self.set_y_rotation_input()
	self.set_zoom_input()

func _physics_process(delta: float) -> void:
	self.follow_camera_rig_target(delta)
	if self.y_rotation_input:
		self.rotate_camera_rig(delta)
	if self.zoom_input:
		self.update_camera_zoom()

func get_nodes() -> void:
	self.camera_rig_target = get_node(self.camera_rig_target_path)
	self.camera_rig = get_node(".")
	self.camera = get_node("Camera")

# NOTE: Setup Methods
func setup_camera() -> void:
	self.setup_camera_zoom()
	self.setup_camera_position()
	self.setup_camera_rotation()
	self.setup_camera_rig_rotation()

func setup_camera_zoom() -> void:
	self.camera.fov = self.camera_fov
	self.camera.size = self.camera_size
	self.camera.near = self.camera_near
	self.camera.far = self.camera_far

func setup_camera_position() -> void:
	self.camera.position = Vector3(
		0, 
		self.camera_height, 
		self.camera_distance
	)

func setup_camera_rotation() -> void:
	self.camera.rotation = Vector3(
		self.camera_rotation_vertical,
		self.camera_rotation_horizontal,
		0
	)

func setup_camera_rig_rotation() -> void:
	self.camera_rig.rotation = Vector3(
		self.camera_rig_rotation_vertical,
		self.camera_rig_rotation_horizontal,
		0
	)

func setup_camera_rig_height_offset() -> void:
	self.camera_rig_height_offset = abs(self.camera.transform.origin.z / 10) + 1

# NOTE: Update Methods
func rotate_camera_rig(delta: float) -> void:
	self.camera_rig.rotate_object_local(
		Vector3.UP, 
		self.y_rotation_input * self.rotation_speed * 
		self.rotation_sensitivity * delta
	)

func get_zoom_camera_param() -> String:
	if self.camera.projection == self.camera.PROJECTION_ORTHOGONAL:
		return "size"
	elif self.camera.projection == self.camera.PROJECTION_PERSPECTIVE:
		return "fov"
	else:
		return "size"

func update_camera_zoom() -> void:
	var zoom_param: String = self.get_zoom_camera_param()
	var current_zoom: float = self.camera[zoom_param]
	self.camera[zoom_param] = lerp(
		current_zoom, 
		current_zoom + self.zoom_input * self.zoom_speed * self.zoom_sensitivity, 
		self.zoom_smoothness
	)

func follow_camera_rig_target(delta: float) -> void:
	var height_offset: Vector3 = Vector3(0, self.camera_rig_height_offset, 0)
	var new_target_position: Vector3 = lerp(
		self.global_position,
		self.camera_rig_target.global_position + height_offset,
		delta * self.camera_rig_lerp_speed
	)
	self.set_position(new_target_position)

# NOTE: Input Methods
func set_y_rotation_input() -> void:
	self.y_rotation_input = 0
	if Input.is_action_pressed("ui_left"):
		self.y_rotation_input += 1
	if Input.is_action_pressed("ui_right"):
		self.y_rotation_input -= 1
		
func set_zoom_input() -> void:
	self.zoom_input = 0
	if Input.is_action_pressed("ui_up"):
		self.zoom_input -= 1
	if Input.is_action_pressed("ui_down"):
		self.zoom_input += 1
