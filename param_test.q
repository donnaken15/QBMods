mod_info = {
	name = 'param test'
	desc = 'y'
	author = 'donnaken15'
	params = [
		{ name = 'my_value' default = 1 type = bool }
		{ name = 'my_value_3s' default = 2 type = bool3 }
		{ name = 'string' default = 'test text' }
		{ name = 'widestring' default = "test wide text" }
		{ name = 'my_number' default = 3 min = -15 max = 10 }
		{ name = 'my_number2' default = 8 min = -15 max = 10 type = slider }
		{ name = 'my_color' default = [255 0 0 255] type = color }
	]
}