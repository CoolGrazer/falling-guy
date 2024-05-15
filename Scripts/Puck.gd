extends Sprite2D

var clicking : bool = false

var justClicked : bool = false

var justReleased : bool = false

var velocity : Vector2 = Vector2.ZERO

var canSlide : bool = true

var lastGlobalPos : Vector2 = Vector2.ZERO

var actionTypes = ["nothing","justPressed","justReleased","quickRelease","slide","flick","hold"]

var currentAction : String = ""

@export var quickTapLength : int = 2

var framesHeldButton : int = -1

@export var minSpeed : float = 0.0

@export var disabled : bool = false

var flicking : bool = false

var screenShake : float = 0.0

var bounce : int = 0

# add some sprite rotation and scaling! I love sprite rotation and scaling! WOO! Yeah! here we go!


signal input(input)

func _physics_process(delta):
	if disabled == true:
		return
	
	
	
	
	_touchScreen()
	_specialEffects()
	_determineInput()



func _touchScreen():
	
	clicking = Input.is_action_pressed("Click")
	
	
	
	
	
	if Input.is_action_just_pressed("Click"):
		velocity = Vector2.ZERO
		flicking = false
		justClicked = true
		framesHeldButton = 0
		screenShake = 0
		rotation_degrees = 0
		scale = Vector2(1,1)
		hide()
		#position = Vector2(694,-606)
		
	elif Input.is_action_just_released("Click"):
		justReleased = true
	
	if clicking == true:
		
		#position += Input.get_vector("JoyLeft","JoyRight","JoyUp","JoyDown") * 15
		
		global_position = get_global_mouse_position()
		
		#$Face.position = get_global_mouse_position() - get_parent().global_position
		
		$Face.position = velocity * 0.4
		framesHeldButton += 1
	elif clicking == false and !velocity == Vector2.ZERO:
		velocity = lerp(velocity,Vector2.ZERO,0.05)
		global_position += velocity
		
	
	
	if clicking == true:
		pass
		global_position.x = clamp(global_position.x,220,360)
		global_position.y = clamp(global_position.y,24,232)
	
	velocity = global_position - lastGlobalPos
	
	
	
	
	
	if clicking == true:
		pass
	else:
		if (abs(velocity.x) + abs(velocity.y)) / 2 > minSpeed:
			pass
		else:
			velocity = Vector2(0,0)
			pass
	
	lastGlobalPos = global_position
	
	if clicking == false and currentAction == "quickRelease":
		
		
		show()
		frame = 0
		#$Eyes.position = Vector2(0,-36)
		$Face.hide()
		$Eyes.show()
		$Eyes.position = Vector2(0,-36)
		#$Eyes.hide()
		framesHeldButton = 99
		velocity = Vector2(0,0)
	
	$Face.frame = round(sin(Engine.get_physics_frames() / 3.0) + 7)
	
	if framesHeldButton == 0 and clicking == true:
		hide()
		
		
		$Face.hide()
		#frame = 6
	
	
	
	if framesHeldButton == 3:
		show()
		
		frame = 5
	elif framesHeldButton == 4:
		$Eyes.show()
		$Eyes.position = Vector2(0,-9)
		frame -= 1
	elif framesHeldButton == 5:
		$Eyes.position = Vector2(0,-13)
		frame -= 1
	elif framesHeldButton == 6:
		$Face.show()
		$Eyes.position = Vector2(0,-17)
		frame -= 1
	elif framesHeldButton == 7:
		$Eyes.position = Vector2(0,-21)
		frame -= 1
	elif framesHeldButton == 8:
		$Eyes.position = Vector2(0,-30)
		
	elif framesHeldButton == 9:
		$Eyes.position = Vector2(0,-36)
		
	
	
	
	
	
	if clicking == false and frame < 5 and flicking == false:
		
		if fmod(Engine.get_frames_drawn(),2) == 0 and framesHeldButton == 0:
			$Face.hide()
			frame += 1
			$Eyes.position.y += 5
		elif fmod(Engine.get_frames_drawn(),3) == 0 and framesHeldButton == 99:
			$Face.hide()
			frame += 1
			$Eyes.position.y += 5
		
		
		
		if frame == 5:
			$Eyes.hide()
			hide()
		
	
	elif clicking == false and frame <= 5 and flicking == true:
		$Face.hide()
		if fmod(Engine.get_frames_drawn(),4) == 0:
			frame += 1
			$Eyes.position.y += 5
		
		if frame == 5:
			$Eyes.hide()
			hide()
	
	
	global_position.x += sin(Engine.get_frames_drawn()) * screenShake
	

func _determineInput():
	currentAction = "nothing"
	
	#if abs(velocity.y) < 1:
	#	canSlide = true
	
	
	if clicking == true and abs(velocity.y) > 0 and canSlide == true:
		currentAction = actionTypes[4]
		#canSlide = false
	elif clicking == true and justClicked == false:
		currentAction = actionTypes[6]

	
	
	if justClicked == true:
		currentAction = actionTypes[1]
		justClicked = false
	
	
	if justReleased == true and framesHeldButton < quickTapLength:
		currentAction = actionTypes[3]
		justReleased = false
	elif justReleased == true and (abs(velocity.x) + abs(velocity.y)) / 2 > minSpeed:
		flicking = true
		currentAction = actionTypes[5]
		justReleased = false
	elif justReleased == true:
		currentAction = actionTypes[2]
		justReleased = false
		framesHeldButton = 0
		
	
	
	emit_signal("input",currentAction)
	

func _specialEffects():
	
	# make our puck shirnk down and shake before you flick it by deteching how long the plaher has held the puck for.
	# right now we need to work on this to make our gmae more special! i should probably add some fx to the back ground too, like screen flashes and wahat not to make it more epix!!!!
	
	if framesHeldButton > 300:
		screenShake = 2
		rotation_degrees = sin(Engine.get_physics_frames() / 3.0) * 10
		scale.x = 1 + sin(Engine.get_physics_frames() / 3.0) / 20
		scale.y = 1 + sin(Engine.get_physics_frames() / 3.0) / 20
	
	if currentAction == "flick" and velocity.length() > minSpeed * 4:
		scale = abs(velocity.normalized() / 2) + Vector2(0.75,0.75)
		
		
	
	print(velocity.normalized())


func _on_textbox_enabled(enabled):
	disabled = not enabled
	
	if enabled == true:
		velocity = Vector2.ZERO
	
