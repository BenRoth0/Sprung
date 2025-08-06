class_name AimArc
extends Line2D

# Number of simulation steps for the arc
@export var steps := 30
# Time between each simulated step (smaller = smoother arc)
@export var step_time := 0.1
# Gravity strength (defaults to project gravity setting)
var gravity_strength = ProjectSettings.get_setting("physics/2d/default_gravity")

# Call this to update the arc based on launch velocity
func update_arc(start_pos: Vector2, launch_velocity: Vector2):
	var points = []
	var pos = start_pos
	var vel = launch_velocity
	var gravity = Vector2.DOWN * gravity_strength

	# Simulate the arc step-by-step
	for i in range(steps):
		# Store position relative to the Line2D node
		points.append(pos - global_position)
		# Apply gravity
		vel += gravity * step_time
		# Move forward in time
		pos += vel * step_time

	# Update the visual line
	self.points = points
	self.visible = true

# Call this to hide the arc
func clear_arc():
	self.visible = false
	self.points = []
