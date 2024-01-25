extends CharacterBody2D

var startPosition
var endPosition
var player = null
var player_chase = false
@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D
@onready var animations = $AnimatedSprite2D

func _ready():
	startPosition = position
	# If you want to g
	#endPosition = startPosition + Vector2(0, 3*16)
	endPosition = endPoint.global_position
	
func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	
func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed
	
func updateAnimation():
	var animationString = "walkUp"
	if velocity.y > 0:
		animationString = "walkDown"
	animations.play(animationString)

func playerChase():
	var moveDirection = player.position - position
	
func _physics_process(delta):
	if (player == null):
		updateVelocity()
	else:
		playerChase()
		move_and_slide()
		updateAnimation()
	

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	player.currentHealth -= 1
	player.healthChanged.emit(player.currentHealth)
	print_debug("Health: ", player.currentHealth)
	if (player.currentHealth <= 0):
		player.currentHealth = player.maxHealth
	
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass
