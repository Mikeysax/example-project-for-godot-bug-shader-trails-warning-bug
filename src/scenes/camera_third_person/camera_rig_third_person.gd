extends Node3D

var camera_rig: Node3D
var spring_arm: SpringArm3D
var camera: Camera3D
var camera_rig_target: Node3D
var camera_rig_target_position: Vector3

@export var camera_rig_target_path: NodePath
@export var max_x_rotation: float = 75
@export var min_x_rotation: float = -55
@export var max_zoom: float = 4
@export var min_zoom: float = 0.1
@export var zoom_step: float = 2
@export var zoom_y_step: float = 0.15
@export var vertical_sensitivity: float = 0.002
@export var horizontal_sensitivity: float = 0.002
@export var spring_arm_length: int = 1
@export var spring_arm_margin: float = 0.01
@export var camera_rig_y_offset: float = 1.5
@export var camera_rig_lerp_speed: float = 5.0
@export var camera_size: int = 5
@export var camera_fov: int = 62
@export var camera_near: float = 0.05
@export var camera_far: int = 4000
@export var camera_rig_rotation_x: float = -30 / 100
@export var camera_rig_rotation_y: float = 360 / 100
@export var camera_z_distance: float = 2

@onready var current_zoom: float = self.max_zoom

func _ready() -> void:
	set_physics_process(true)
	set_as_top_level(true)
	# Note: This should be moved if menus are added, etc.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.get_nodes() 
	self.setup_spring_arm()
	self.setup_camera()

func get_nodes() -> void:
	self.camera_rig_target = get_node(self.camera_rig_target_path)
	self.camera_rig = get_node(".")
	self.spring_arm = get_node("SpringArm")
	self.camera = get_node("SpringArm/Camera")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotate_camera_rig_around_target(event)

func _physics_process(delta: float) -> void:
	self.update_spring_arm_zoom(delta)
	self.follow_camera_rig_target(delta)

func setup_spring_arm() -> void:
	self.spring_arm.spring_length = self.spring_arm_length
	self.spring_arm.margin = self.spring_arm_margin

func setup_camera() -> void:
	self.setup_camera_distance()
	self.setup_camera_zoom()
	self.setup_camera_rotation()

func setup_camera_distance() -> void:
	self.camera.translate(Vector3(0, 0, self.camera_z_distance))

func setup_camera_zoom() -> void:
	self.camera.fov = self.camera_fov
	self.camera.size = self.camera_size
	self.camera.near = self.camera_near
	self.camera.far = self.camera_far

func setup_camera_rotation() -> void:
	self.camera_rig.rotation = Vector3(
		self.camera_rig_rotation_x,
		self.camera_rig_rotation_y,
		0
	)

func rotate_camera_rig_around_target(event: InputEventMouseMotion) -> void:
	self.camera_rig.rotation.y -= event.relative.x * self.horizontal_sensitivity
	self.camera_rig.rotation.y = wrapf(self.camera_rig.rotation.y, 0.0, TAU)
	self.camera_rig.rotation.x -= event.relative.y * self.vertical_sensitivity
	self.camera_rig.rotation.x = clamp(self.camera_rig.rotation.x, deg_to_rad(self.min_x_rotation), deg_to_rad(self.max_x_rotation))

func update_spring_arm_zoom(delta: float) -> void:
	self.spring_arm.spring_length = lerp(
		self.spring_arm.spring_length, 
		self.current_zoom, 
		delta * self.camera_rig_lerp_speed
	)

func follow_camera_rig_target(delta: float) -> void:
	var height_offset: Vector3 = Vector3(0, self.camera_rig_y_offset, 0)
	var new_target_position: Vector3 = lerp(
		self.camera_rig.global_position,
		self.camera_rig_target.global_position + height_offset,
		delta * self.camera_rig_lerp_speed
	)
	self.set_position(new_target_position)
