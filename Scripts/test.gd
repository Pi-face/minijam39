@tool
extends Node2D

var noise : FastNoiseLite = FastNoiseLite.new()
@export var generate : bool:
	set(value):
		generate = value
		generate_patch()

@export var rand_seed : int:
	set(value):
		rand_seed = value
		generate_patch()


func generate_patch():
	noise.seed = rand_seed
	$Tiles.clear()
	$Tiles.generate(noise, Vector2i(0, 0))