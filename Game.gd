extends Node2D
var points = 0
var rows = 0
const cols = 21
var ballPlayer
const position_start_player = Vector2(320,385)
var matrixPositionBall = []
var shift = 15
var contCluster = 1

func _ready():
	rows = 11
	fillInitialMatrixBalls()
	rows = 5
	get_node("Panel/HUBPlayer/Label").text = "puntaje : " + str(points);
	generaterRow(rows)
	generate_player_ball()
	pass # Replace with function body.

func _process(delta):
	calculateArrowPosition()
	if(!ballPlayer.isPlayer):
		addBallToArray()
		var cluster = getClusterSameColor([],ballPlayer)
		removeClustersNeightbores(cluster)
		generate_player_ball()

func calculateArrowPosition():
	var arrowPos = get_node("Panel/Arrow").position;
	var posMouse = get_viewport().get_mouse_position()
	var vect2 = posMouse - arrowPos;
	if(ballPlayer.isChanableVectorMovement):
		ballPlayer.vectorMovement = vect2
	var value = atan2(vect2.y,vect2.x);
	var angle = value * (180 / PI)
	get_node("Panel/Arrow").rotation_degrees=angle - 270

func generaterRow(var cantRows):
	var pixelSeparationBall = 15
	var rowPosition = 15
	for i in range(cantRows):
		for j in range(cols):
			#Se Procede con la creacion de las Balls Rows
			var ball = load("res://bubble.tscn").instance()
			get_node("Panel/Bubbles").add_child(ball)
			ball.position.x+=pixelSeparationBall;
			if(i%2 == 1):
				ball.position.x+=shift
			ball.position.y+=rowPosition
			pixelSeparationBall+=30;
			ball.yPositionArray = i
			ball.xPositionArray = j
			matrixPositionBall[i][j] = ball
		pass
		pixelSeparationBall = 15
		rowPosition+=30
	pass

func generate_player_ball():
	ballPlayer = load("res://bubble.tscn").instance()
	get_node("Panel/Bubbles").add_child(ballPlayer)
	ballPlayer.position.x = position_start_player.x
	ballPlayer.position.y = position_start_player.y
	ballPlayer.isPlayer = true

func fillInitialMatrixBalls():
	for i in range(rows):
		matrixPositionBall.append([])
		for j in range(cols):
			matrixPositionBall[i].append(null)

func addBallToArray():
	var jPlayer = ballPlayer.xPositionArray
	var iPlayer = ballPlayer.yPositionArray - 1
	if(iPlayer % 2 == 1):
		jPlayer-=1
	if(matrixPositionBall.size() <= iPlayer or matrixPositionBall[iPlayer].size() <= jPlayer):
		return get_tree().change_scene("res://Main.tscn")
	else:
		if(matrixPositionBall[iPlayer][jPlayer] == null):
			ballPlayer.xPositionArray = jPlayer
			ballPlayer.yPositionArray = iPlayer
			matrixPositionBall[iPlayer][jPlayer] = ballPlayer
		else:
			return get_tree().change_scene("res://Main.tscn")

func getClusterSameColor(matrixCluster, ball):
	var evenBallVert = [[0,1],[0,-1],[1,0],[-1,0],[1,1],[-1,1]]
	var oddBallVert =  [[0,1],[0,-1],[1,0],[-1,0],[-1,-1],[1,-1]]
	var selectedPosition
	if(ball.yPositionArray % 2 == 1):
		selectedPosition = evenBallVert
	else:
		selectedPosition = oddBallVert
	for positionNeighbor in selectedPosition:
			if(positionNeighbor[0] + ball.yPositionArray < matrixPositionBall.size()
			&& positionNeighbor[1] + ball.xPositionArray < matrixPositionBall[0].size()
			&& positionNeighbor[0] + ball.yPositionArray >= 0 
			&& positionNeighbor[1] + ball.xPositionArray >= 0):
				var ballClust = matrixPositionBall[positionNeighbor[0] + ball.yPositionArray][positionNeighbor[1] + ball.xPositionArray]
				if( ballClust != null && ballClust.currentColor == ball.currentColor):
					if(!matrixCluster.has(ballClust)):
						matrixCluster.append(ballClust)
						matrixCluster = getClusterSameColor(matrixCluster,ballClust)
	return matrixCluster
	
func removeClustersNeightbores(cluster):
	for object in cluster:
		if(object != null && cluster.size() >= 3):
			get_node("Panel/Bubbles").remove_child(object)
			matrixPositionBall[object.yPositionArray][object.xPositionArray] = null

func removeBallNoNeightbore():
	#We pass to each element of the grid and check their neightbores
	for i in matrixPositionBall:
		for j in i:
			pass
	pass
