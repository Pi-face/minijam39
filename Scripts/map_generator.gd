extends Node2D

@export var terrain_patch_scene : PackedScene

@onready var player := $"../Player"

var noise : FastNoiseLite = FastNoiseLite.new()
var noise_patches : Dictionary = {}

var patch_render_dist : int = 3

func _physics_process(_delta: float) -> void:
	var current_patch : Vector2i = _get_player_patch_position(player.global_position)
	for x in range(current_patch.x-patch_render_dist, current_patch.x+patch_render_dist):
		for y in range(current_patch.y-patch_render_dist, current_patch.y+patch_render_dist):
			if !noise_patches.has(Vector2i(x, y)):
				_generate_patch(Vector2i(x, y))
			
	_clear_unused_patches(current_patch)



func _generate_patch(loc : Vector2i) -> void:
	var patch := terrain_patch_scene.instantiate()
	patch.global_position = Vector2( 
		(loc.x * TerrainPatch.PATCH_SIZE * TerrainPatch.TILE_SIZE), 
		(loc.y * TerrainPatch.PATCH_SIZE * TerrainPatch.TILE_SIZE)
	)
	patch.generate(noise, loc)
	noise_patches.get_or_add(loc, patch)
	add_child.call_deferred(patch)

func _get_player_patch_position(pos : Vector2) -> Vector2i:
	var patch_pos : Vector2i = Vector2i(
		int(pos.x / (TerrainPatch.PATCH_SIZE * TerrainPatch.TILE_SIZE)),
		int(pos.y / (TerrainPatch.PATCH_SIZE * TerrainPatch.TILE_SIZE))
	)
	if pos.x < 0:
		patch_pos.x -= 1
	if pos.y < 0:
		patch_pos.y -= 1
	return patch_pos
	
func _clear_unused_patches(current_patch : Vector2i) -> void:
	var keys := noise_patches.keys()
	for v in keys:
		if (
			v.x < current_patch.x - patch_render_dist or 
			v.x > current_patch.x + patch_render_dist or 
			v.y < current_patch.y - patch_render_dist or 
			v.y > current_patch.y + patch_render_dist
		):
			var p : TerrainPatch = noise_patches.get(v)
			p.queue_free()
			noise_patches.erase(v)