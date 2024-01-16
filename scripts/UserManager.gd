class_name UserManager extends Resource

@export var introAudio : bool = true
@export var kills : int = 0 
static var userPath: String = "res://user_data.tres" 

func save() -> void:
	ResourceSaver.save(self, userPath)

static func load_or_create() -> UserManager:
	var res: UserManager = load(userPath) as UserManager
	if !res:
		res = UserManager.new()
	return res
