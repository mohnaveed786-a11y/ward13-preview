extends Node3D

const ROOM = preload("res://assets/ward13_room101_v2.glb")
var player: CharacterBody3D
var camera: Camera3D
var pitch := 0.0
var yaw := 0.0
var speed := 3.0
var mouse_sensitivity := 0.0028
var is_mouse_captured := true

func _ready() -> void:
    add_child(ROOM.instantiate())
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.025, 0.045, 0.055)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.35, 0.49, 0.55)
    env.ambient_light_energy = 0.21
    env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    world.environment = env
    add_child(world)
    _light(Vector3(0, 2.91, -2.2), Color(0.72, 0.82, 0.92), 1.45, 5.5)
    _light(Vector3(0, 2.91, 1.8), Color(0.70, 0.80, 0.92), 1.05, 5.4)
    _light(Vector3(-2.7, 2.1, -1.8), Color(1, 0.73, 0.49), 0.95, 3.5)
    _light(Vector3(0.1, 2.15, 3.6), Color(0.57, 0.73, 0.92), 0.85, 4.6)
    player = CharacterBody3D.new()
    player.name = "InspectionPlayer"
    player.position = Vector3(-2.35, 0.11, -3.1)
    add_child(player)
    var capsule := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.28
    shape.height = 1.65
    capsule.shape = shape
    capsule.position.y = 0.86
    player.add_child(capsule)
    camera = Camera3D.new()
    camera.position.y = 1.57
    camera.current = true
    player.add_child(camera)
    # Facing into room from doorway: in Godot, -Z is forward, so turn around.
    yaw = PI
    player.rotation.y = yaw
    _static_box(Vector3(0, -0.21, 0), Vector3(7.6, 0.35, 8.4))
    _static_box(Vector3(-3.8, 1.55, 0), Vector3(.2, 3.1, 8.4))
    _static_box(Vector3(3.8, 1.55, 0), Vector3(.2, 3.1, 8.4))
    _static_box(Vector3(0, 1.55, 4.2), Vector3(7.6, 3.1, .2))
    # Simple collision for important furniture; this is an inspection sandbox.
    _static_box(Vector3(.55, .5, .5), Vector3(1.55, 1.0, 2.5))
    _static_box(Vector3(-3.12, .6, -1.95), Vector3(.9, 1.2, 2.0))
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    var label := Label.new()
    label.text = "WARD 13 • ROOM 101 / ENVIRONMENT V2\nWASD move  •  Mouse look  •  Shift sprint  •  Esc release mouse"
    label.position = Vector2(20, 18)
    label.add_theme_color_override("font_color", Color(0.9, 0.96, 0.94))
    var hud := CanvasLayer.new()
    add_child(hud)
    hud.add_child(label)

func _light(pos: Vector3, tint: Color, energy: float, distance: float) -> void:
    var light := OmniLight3D.new()
    light.position = pos
    light.light_color = tint
    light.light_energy = energy
    light.omni_range = distance
    light.shadow_enabled = true
    add_child(light)

func _static_box(pos: Vector3, size: Vector3) -> void:
    var body := StaticBody3D.new()
    body.position = pos
    var shape := CollisionShape3D.new()
    var box_shape := BoxShape3D.new()
    box_shape.size = size
    shape.shape = box_shape
    body.add_child(shape)
    add_child(body)

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        is_mouse_captured = not is_mouse_captured
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_mouse_captured else Input.MOUSE_MODE_VISIBLE
    if event is InputEventMouseButton and event.pressed and not is_mouse_captured:
        is_mouse_captured = true
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    if event is InputEventMouseMotion and is_mouse_captured:
        yaw -= event.relative.x * mouse_sensitivity
        pitch = clamp(pitch - event.relative.y * mouse_sensitivity, -1.3, 1.3)
        player.rotation.y = yaw
        camera.rotation.x = pitch

func _physics_process(delta: float) -> void:
    var move := Vector2.ZERO
    if Input.is_key_pressed(KEY_W): move.y -= 1
    if Input.is_key_pressed(KEY_S): move.y += 1
    if Input.is_key_pressed(KEY_A): move.x -= 1
    if Input.is_key_pressed(KEY_D): move.x += 1
    move = move.normalized()
    var dir := player.global_transform.basis * Vector3(move.x, 0, move.y)
    var actual_speed := speed * (1.7 if Input.is_key_pressed(KEY_SHIFT) else 1.0)
    player.velocity.x = dir.x * actual_speed
    player.velocity.z = dir.z * actual_speed
    player.velocity.y -= 12.0 * delta
    player.move_and_slide()
