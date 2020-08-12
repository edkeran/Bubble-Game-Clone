extends KinematicBody2D
#Declaring an array with the different colors available in the game
var arrayColors = [[0,1,0],[1,0,0],[0,0,1],[8,8,8],[0.5,1,0]]
var isPlayer = false
var movesBall = false
var globalVelocity = Vector2(3,3)
var isChanableVectorMovement = true
var vectorMovement
var yPositionOffset = 15
var xPositionShift = 15
var withBall = 30
var xPositionArray
var yPositionArray
var currentColor

func _ready():
	randomize()
	var pos = randi()%4;
	get_node(".").modulate = Color(arrayColors[pos][0],arrayColors[pos][1],arrayColors[pos][2])
	currentColor = pos

func _process(delta):
	if(isPlayer):
		readInputMouse()
		if(movesBall && vectorMovement != null && vectorMovement.y <= 0):
			var vector = vectorMovement * globalVelocity;
			var collided = move_and_collide(vector * delta)
			if(collided):
				#I Check If The Colition Is A Wall
				if(collided.collider.name != "Paredes"):
					movesBall = false
					var posFinal = get_node(".").position
					#With The Final Position, I just get The Array Index And Fixed Its Position
					getGridPosition(posFinal)
					isPlayer = false
				else:
					#In The Else statement i Proceed With The Reflection Vector
					vectorMovement = vectorMovement.rotated(deg2rad(180) - deg2rad(vectorMovement.angle()));
					vectorMovement.y = vectorMovement.y * -1
		else: 
			isChanableVectorMovement = true

func readInputMouse():
	if(Input.is_action_pressed("ui_shoot")):
		#it shall move the ball in the same way as the arrow vector
		movesBall = true
		isChanableVectorMovement = false
		pass
	pass

func getGridPosition(posFinal):
	var y = posFinal.y + 15;
	y = int(round(y / withBall))
	var x = posFinal.x
	if(y % 2 == 1):
		x -= 15
	x = int(round(x / withBall))
	#Knowing x and y, i'll fix the node position in the grid
	xPositionArray = x
	yPositionArray = y
	get_node(".").position.y = (y * withBall) - yPositionOffset
	if(y % 2 == 1):
		get_node(".").position.x = (x * withBall) + xPositionShift
	else:
		get_node(".").position.x = (x * withBall)
		pass
