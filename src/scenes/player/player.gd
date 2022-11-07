extends CharacterBody3D

@export var camera_path: NodePath

# Scene Nodes
var camera_root: Node3D
var camera: Camera3D
var camera_basis: Basis
var mesh: Node3D
var animation_tree: AnimationTree
var animation_player: AnimationPlayer
var skeleton: Skeleton3D
var body_collision: CollisionObject3D

# Character Parameters
var run_speed: float = 4.5
var walk_speed: float = 2.1

var acceleration_walk_rate: float = 7.0
var acceleration_run_rate: float = 20.0

var deceleration_walk_rate: float = 16.0
var deceleration_run_rate: float = 20.0

var is_sprinting: bool = false
var is_jumping: bool = false

var rotation_speed: float = 5.0

var jump_walk_height: float = 0.5
var jump_run_height: float = 1

var jump_walk_time_to_peak: float = 0.5
var jump_run_time_to_peak: float = 0.5

var jump_walk_time_to_descent: float = 0.3
var jump_run_time_to_descent: float = 0.5

# Character Vars In Use
# NOTE: Velocity is built into the CharacterBody3D
var move_direction: Vector3 = Vector3.ZERO
var input_direction: Vector2 = Vector2.ZERO
var current_gravity: float = 0.0
var current_acceleration: float = 0.0
var current_speed: float = 0.0
var current_jump_height: float = 0.0
var current_jump_time_to_peak: float = 0.0
var current_jump_time_to_descent: float = 0.0

func _init() -> void:
	return

func _ready() -> void:
	self.get_nodes()

func _input(_event: InputEvent) -> void:
	input_system()

func _physics_process(delta: float) -> void:
	movement_system(delta)

# NOTE: Systems
func input_system() -> void:
	self.set_input_direction()
	self.set_is_sprinting()
	self.set_is_jumping()

func movement_system(delta: float) -> void:
	# NOTE: Prevents movement in air and changes in velocity and rotation
	# of character. This might not be wanted for gameplay purposes
	if self.is_grounded():
		self.reset_move_direction()
		if self.is_input_direction_set():
			self.get_camera_basis()
			self.set_move_direction()
			self.set_mesh_rotation(delta)
		
	self.set_current_values()
	
	self.set_horizontal_velocity(delta)
	self.set_vertical_velocity()
	
	self.animation_system(delta)
	self.gravity_system(delta)
	
	move_and_slide()

func gravity_system(delta: float) -> void:
	self.current_gravity = self.get_gravity()
	velocity.y += self.current_gravity * delta

func animation_system(delta: float) -> void:
	var sprint_blend: float = 1.0
	var walk_blend: float = 0.0
	var idle_blend: float = -1.0
	
	# NOTE: If there is movement or not, change the acceleration
	# and animation target (idle, walk, run) for the bl end tree
	var iwr_blend_path: String = "parameters/iwr_blend/blend_amount"
	var iwr_blend_target: float = idle_blend
	if self.is_jumping_or_falling():
#		print('animation_system is jumping or falling')
		iwr_blend_target = idle_blend
	elif self.move_direction.dot(self.velocity) > 0:
		if self.is_sprinting:
			iwr_blend_target = sprint_blend
		else:
			iwr_blend_target = walk_blend
	else:
		iwr_blend_target = idle_blend
	
	var current_iwr_blend = self.animation_tree[iwr_blend_path]
	var animation_tree_iwr_blend_value: float = lerp(
		current_iwr_blend, 
		iwr_blend_target, 
		self.current_acceleration * delta
	)
	self.animation_tree[iwr_blend_path] = animation_tree_iwr_blend_value

# NOTE: Methods
func get_nodes() -> void:
	self.camera_root = get_node(self.camera_path)
	self.camera = self.camera_root.get_node('SpringArm/Camera')
	self.mesh = get_node("Root")
	self.animation_tree = get_node("AnimationTree")
	self.animation_player = get_node("AnimationPlayer")
	self.skeleton = get_node("Root/Skeleton3D")
	self.body_collision = get_node("BodyCollision")

# NOTE: Gravity System Methods
func get_gravity() -> float:
	if self.is_currently_jumping():
		return self.calculate_jump_gravity()
	else:
		return self.calculate_fall_gravity()

func is_currently_jumping() -> bool:
	return self.velocity.y > 0.0

func is_currently_falling() -> bool:
	return self.velocity.y < 0.0

func is_jumping_or_falling() -> bool:
	return self.is_jumping || self.is_currently_jumping() || self.is_currently_falling()

func is_grounded() -> bool:
	return !self.is_jumping_or_falling()

func calculate_jump_gravity() -> float:
	return (-2.0 * self.current_jump_height) / (self.current_jump_time_to_peak * self.current_jump_time_to_peak)

func calculate_fall_gravity() -> float:
	return (-2.0 * self.current_jump_height) / (self.current_jump_time_to_descent * self.current_jump_time_to_descent)

# NOTE: Input System Methods
func set_input_direction() -> void:
	self.input_direction = Input.get_vector("left", "right", "up", "down")

func set_is_sprinting() -> void:
	if Input.is_action_pressed("sprint"):
		self.is_sprinting = true
	elif Input.is_action_just_released("sprint"):
		self.is_sprinting = false
	
func set_is_jumping() -> void:
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		self.is_jumping = true
	elif Input.is_action_just_released("jump"):
		self.is_jumping = false
	
# NOTE: Movement System Methods
func is_input_direction_set() -> bool:
	return self.input_direction != Vector2.ZERO

func get_camera_basis() -> void:
	self.camera_basis = self.camera.get_global_transform().basis

func reset_move_direction() -> void:
	self.move_direction = Vector3.ZERO

func set_move_direction() -> void:
	# NOTE: Handle player movement based on camera rotation
	self.move_direction += self.camera_basis.z * self.input_direction.y
	self.move_direction += self.camera_basis.x * self.input_direction.x
	self.move_direction.y = 0
	self.move_direction = self.move_direction.normalized()

func set_mesh_rotation(delta: float) -> void:
	self.mesh.rotation.y = lerp_angle(
		self.mesh.rotation.y, 
		atan2(self.move_direction.x, self.move_direction.z),
		delta * self.rotation_speed
	)
	
func set_current_values() -> void:
	if self.move_direction.dot(self.velocity) > 0:
		if self.is_sprinting:
			self.current_acceleration = self.acceleration_run_rate
			self.current_speed = self.run_speed
			
			self.current_jump_height = self.jump_run_height
			self.current_jump_time_to_peak = self.jump_run_time_to_peak
			self.current_jump_time_to_descent = self.jump_run_time_to_descent
		else:
			self.current_acceleration = self.acceleration_walk_rate
			self.current_speed = self.walk_speed
			
			self.current_jump_height = self.jump_walk_height
			self.current_jump_time_to_peak = self.jump_walk_time_to_peak
			self.current_jump_time_to_descent = self.jump_walk_time_to_descent
	else:
		self.current_acceleration = self.deceleration_walk_rate
		self.current_speed = self.walk_speed
		
		self.current_jump_height = self.jump_walk_height
		self.current_jump_time_to_peak = self.jump_walk_time_to_peak
		self.current_jump_time_to_descent = self.jump_walk_time_to_descent
	
func set_horizontal_velocity(delta: float) -> void:
	var horizontal_velocity: Vector3 = Vector3(self.velocity.x, 0, self.velocity.z)
	var target_horizontal_distance: Vector3 = self.move_direction * self.current_speed
	horizontal_velocity = horizontal_velocity.lerp(
		target_horizontal_distance, 
		self.current_acceleration * delta
	)
	self.velocity.x = horizontal_velocity.x
	self.velocity.z = horizontal_velocity.z

func set_vertical_velocity() -> void:
	if self.is_jumping:
		self.velocity.y = self.calculate_jump_velocity()
		self.reset_is_jumping()
	
func calculate_jump_velocity() -> float:
	return (2.0 * self.current_jump_height) / self.current_jump_time_to_peak
	
func reset_is_jumping() -> void:
	self.is_jumping = false
