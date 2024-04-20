extends Node2D
var player

var curr_coal : int
var curr_iron : int
var curr_copper : int
var curr_gold : int

# Cost of the upgrades
var levels_gold = [0,3,4]
var levels_iron = [0,1, 3, 5]
var levels_copper = [0,1,3,5]

# The upgrade level the player starts at.
var gold_level = 0
var iron_level = 0
var copper_level = 0

var level_tot_gold = levels_gold.size()
var level_tot_iron = levels_iron.size()
var level_tot_copper = levels_iron.size()

# Is the menu active?
var is_open : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../../Iron_Shell"
	curr_coal = player.coal_count
	curr_iron = player.iron_count
	curr_copper = player.copper_count
	curr_gold  = player.gold_count
	
	$"Numbers/Speed Total".frame = level_tot_copper
	$"Numbers/Weapon Total".frame = level_tot_gold
	$"Numbers/Health Total".frame = level_tot_iron
	
	# Start cost at first level
	$"Numbers/Copper Cost".frame = levels_copper[1]
	$"Numbers/Gold Cost".frame = levels_gold[1]
	$"Numbers/Iron Cost".frame = levels_iron[1]
	
	$"Numbers/Speed Current".frame = copper_level
	$"Numbers/Weapon Current".frame = gold_level
	$"Numbers/Health Current".frame = iron_level
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	is_open = $".".visible
	if is_open:
		buy()
		
	pass

func buy():
	# Buy Copper Upgrade
	if Input.is_action_just_pressed("Craft Op 1"):
		#print("ATTEMPTING TO BUY 1")
		curr_copper = player.copper_count
		# If we arent at the max upgrade
		if copper_level < level_tot_copper:
			#print("ATTEMPTING TO BUY 2")
			# If we have enough copper to buy the upgrade
			#print("CURR_COPPER:", curr_copper)
			#print("levels_copper[copper_level -1]: ", levels_copper[copper_level -1])
			if curr_copper >= levels_copper[copper_level + 1]:
				# Buy it
				# Remove funds from this script
				#print("ATTEMPTING TO BUY 3")
				curr_copper -= levels_copper[copper_level+1]
				# Remove funds from player
				player.copper_count = curr_copper
				# Increase player level
				copper_level += 1
				# Make the numbers align
				$"Numbers/Speed Current".frame = copper_level
				# Do not attempt to show a number past the max level
				if copper_level != level_tot_copper:
					$"Numbers/Copper Cost".frame = levels_copper[copper_level +1]
				else:
					# Show "SOLD OUT"
					pass
				# Upgrade speed
				player.walk_speed += 1500.0
	# Buy Gold Upgrade
	if Input.is_action_just_pressed("Craft Op 2"):
		curr_gold = player.gold_count
		# If we arent at the max upgrade
		if gold_level < level_tot_gold:
			#print("ATTEMPTING TO BUY 2")
			# If we have enough gold to buy the upgrade
			if curr_gold >= levels_gold[gold_level + 1]:
				# Buy it
				# Remove funds from this script
				curr_gold -= levels_gold[gold_level+1]
				# Remove funds from player
				player.gold = curr_gold
				# Increase player level
				gold_level += 1
				# Make the numbers align
				$"Numbers/Weapon Current".frame = gold_level
				# Do not attempt to show a number past the max level
				if gold_level != level_tot_gold:
					$"Numbers/Gold Cost".frame = levels_gold[gold_level +1]
				else:
					# TODO: Show "SOLD OUT"
					pass
				# Upgrade Weapon
				# TODO: SET PLAYER BOOL HERE TO USE NEW WEAPON
		pass
	# Buy Iron Upgrade
	if Input.is_action_just_pressed("Craft Op 3"):
		curr_iron = player.iron_count
		# If we arent at the max upgrade
		if iron_level < level_tot_iron:
			# If we have enough iron to buy the upgrade
			if curr_iron >= levels_iron[iron_level + 1]:
				# Buy it
				# Remove funds from this script
				curr_iron -= levels_iron[iron_level+1]
				# Remove funds from player
				player.iron_count = curr_iron
				# Increase player level
				iron_level += 1
				# Make the numbers align
				$"Numbers/Health Current".frame = iron_level
				# Do not attempt to show a number past the max level
				if iron_level != level_tot_iron:
					$"Numbers/Iron Cost".frame = levels_iron[iron_level +1]
				else:
					# Show "SOLD OUT"
					pass
				# Upgrade max health
				player.max_hp += 1
				# Give the player full health
				player.coal_count = player.max_hp
