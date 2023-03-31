extends Control

@onready var heart_ui_empty = $HeartUIEmpty
@onready var heart_ui_full = $HeartUIFull

var player_stats = PlayerStats

var hearts:
	set(value):
		assert(max_hearts != null, "Max Hearts should be set before Hearts")
		hearts = clamp(value, 0, max_hearts)
		if heart_ui_full != null:
			heart_ui_full.set_size(Vector2(hearts * 15, 11))
		
var max_hearts:
	set(value):
		max_hearts = max(value, 1)
		
		if (hearts == null):
			hearts = max_hearts
		else:
			hearts = min(hearts, max_hearts)
			
		if heart_ui_empty != null:
			heart_ui_empty.set_size(Vector2(max_hearts * 15, 11))

# Called when the node enters the scene tree for the first time.
func _ready():
	max_hearts = player_stats.max_health
	hearts = player_stats.health
	player_stats.connect("max_health_changed", self._on_max_health_changed)
	player_stats.connect("health_changed", self._on_health_changed)

func _on_max_health_changed(value):
	print(str("MAX HEARTS SIGNAL RECEIVED", value))
	max_hearts = value

func _on_health_changed(value):
	hearts = value
