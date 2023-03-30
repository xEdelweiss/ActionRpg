extends Area2D

class_name PlayerDetectionZone

var player: CharacterBody2D = null

func can_see_player():
	return player != null

func _on_body_entered(body):
	player = body

func _on_body_exited(body):
	player = null
