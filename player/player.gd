extends CharacterBody2D
 
signal  healthChanged

@export var speed: int = 35
@onready var animations = $AnimationPlayer

@export var maxHealth = 3
@onready var currentHealth: int = maxHealth
var enemy_in_range = false

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed
	
func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		animations.play("walk" + direction)
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	if enemy_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "this_is_a_node_title")
			return
			
func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect()


func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range = true
		
		
func _on_area_2d_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_range = false
