extends CharacterBody2D

@export var level_atual = ""
@export var movement_data : PlayerMovementData
@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var coyoteJump = $CoyoteJumpTimer as Timer
@onready var start_position = global_position
@onready var heart_label = %Heartsize
@onready var death_count_label = %DeathCount
@onready var level_label = %LevelLabel

var air_jump = false
var heart_size = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	heart_size = get_tree().get_nodes_in_group("Hearts").size()
	heart_label.text = str(heart_size)
	death_count_label.text = str(Events.death_count)
	level_label.text = level_atual

func _physics_process(delta):
	var direction = Input.get_axis("a_key", "d_key")
	
	apply_gravity(delta)
	jump()
	wall_jump()
	apply_move(delta, direction)
	state_animation(direction)
	
	# Making a system to wait 0.2s until fall off
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_floor = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_floor:
		coyoteJump.start()
	
func apply_move(delta, direction):
	# Moving with acceleration
	handle_acceleration(delta, direction)
	handle_friction(delta, direction)
	handle_air_acceleration(delta, direction)
	

func handle_friction(delta, direction):
	if direction == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func handle_acceleration(delta, direction):
	if not is_on_floor(): return
	if direction != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.acceleration * delta)
		sprite.scale.x = direction

func handle_air_acceleration(delta, direction):
	if is_on_floor(): return
	if direction != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.air_acceleration * delta)
		sprite.scale.x = direction
		

func wall_jump():
	if not is_on_wall_only(): return
	var wall_normal = get_wall_normal()
	if Input.is_action_just_pressed("a_key") and wall_normal == Vector2.LEFT:
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
	if Input.is_action_just_pressed("d_key") and wall_normal == Vector2.RIGHT:
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity

func jump():
	if is_on_floor(): air_jump = true
	
	if is_on_floor() or coyoteJump.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity
	# Make short jumps and high jumps
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 4
			
		if Input.is_action_just_pressed("jump") and air_jump:
			velocity.y = movement_data.jump_velocity * 0.8	
			air_jump = false

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func state_animation(direction):
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if sprite.name != state:
		sprite.play(state)


func _on_hazard_detector_area_entered(area):
	Events.death_count = Events.death_count + 1
	death_count_label.text = str(Events.death_count)
	global_position = start_position
	
func showHearts():
	heart_size = heart_size - 1
	heart_label.text = str(heart_size)
