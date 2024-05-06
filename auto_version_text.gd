extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var text_intro = "Version " + Autoload.version + "\n" + "Build " + Autoload.builddate + "\n" + "Running on "
	if OS.get_name() == "Linux" or OS.get_name() == "Android":
		text_intro += OS.get_distribution_name() # Use the distro name or "LineageOS" instead
	elif OS.get_name() == "Web":
		if OS.has_feature("web_android"):
			text_intro += "Android (Web Browser)"
		elif OS.has_feature("web_ios"):
			text_intro += "iOS (Web Browser)"
		elif OS.has_feature("web_linuxbsd"):
			text_intro += "Linux/BSD (Web Browser)"
		elif OS.has_feature("web_macos"):
			text_intro += "macOS (Web Browser)"
		elif OS.has_feature("web_windows"):
			text_intro += "Windows (Web Browser)"
		else:
			text_intro += "Unknown (Web Browser)"
	else:
		text_intro += OS.get_name()
		
	text_intro += " " + OS.get_version()
	
	text = text_intro


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
