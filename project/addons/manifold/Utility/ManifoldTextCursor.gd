class_name ManifoldTextCursor
extends Node

var position : Vector2i
var length : int

func _init(position: Vector2i, length: int) -> void:
	self.position = position
	self.length = length
