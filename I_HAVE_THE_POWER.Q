; cue he-man theme and electricuting sounds

mod_info = {
	name = 'I HAVE THE POWER'
	desc = 'You know, from GH3+...'
	version = '0'
	author = 'ExileLord (donnaken15)'
}
I_HAVE_THE_POWER = {
	gem_material = sys_Big_Bolt01_sys_Big_Bolt01
	gem_hammer_material = sys_Big_Bolt01_sys_Big_Bolt01
	gem_tap_material = sys_Big_Bolt01_sys_Big_Bolt01
	star_material = sys_Big_Bolt01_sys_Big_Bolt01
	star_hammer_material = sys_Big_Bolt01_sys_Big_Bolt01
	star_tap_material = sys_Big_Bolt01_sys_Big_Bolt01
	battle_star_material = sys_Big_Bolt01_sys_Big_Bolt01
	battle_star_hammer_material = sys_Big_Bolt01_sys_Big_Bolt01
	star_power_material = sys_Big_Bolt01_sys_Big_Bolt01
	star_power_hammer_material = sys_Big_Bolt01_sys_Big_Bolt01
	star_power_whammy_material = sys_Whammy2D_StarPower_sys_Whammy2D_StarPower
	star_power_tap_material = sys_Big_Bolt01_sys_Big_Bolt01
	dead_whammy = sys_Whammy2D_Dead_sys_Whammy2D_Dead
}

button_models = {
	green = {
		$I_HAVE_THE_POWER
		whammy_material = sys_Whammy2D_Green_sys_Whammy2D_Green
		name = button_g
	}
	red = {
		$I_HAVE_THE_POWER
		whammy_material = sys_Whammy2D_Red_sys_Whammy2D_Red
		name = button_r
	}
	yellow = {
		$I_HAVE_THE_POWER
		whammy_material = sys_Whammy2D_Yellow_sys_Whammy2D_Yellow
		name = button_y
	}
	blue = {
		$I_HAVE_THE_POWER
		whammy_material = sys_Whammy2D_Blue_sys_Whammy2D_Blue
		name = button_b
	}
	orange = {
		$I_HAVE_THE_POWER
		whammy_material = sys_Whammy2D_Orange_sys_Whammy2D_Orange
		name = button_o
	}
	// already injected by GH3+ but whatever
	open = {
		gem_material = sys_gem2d_open_sys_gem2d_open
		gem_hammer_material = sys_gem2d_open_hammer_sys_gem2d_open_hammer
		star_material = sys_star2d_open_sys_star2d_open
		star_hammer_material = sys_star2d_open_hammer_sys_star2d_open_hammer
		battle_star_material = sys_star2d_open_sys_star2d_open
		battle_star_hammer_material = sys_star2d_open_hammer_sys_star2d_open_hammer
		whammy_material = sys_whammy2d_open_sys_whammy2d_open
		star_power_material = sys_gem2d_open_starpower_sys_gem2d_open_starpower
		star_power_hammer_material = sys_gem2d_open_starpower_hammer_sys_gem2d_open_starpower_hammer
		star_power_whammy_material = sys_whammy2d_open_star_sys_whammy2d_open_star
		dead_whammy = sys_whammy2d_open_dead_sys_whammy2d_open_dead // not working
		name = button_z
	}
}



