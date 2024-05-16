
script jorspy_startup
	printf \{'Initializing JORSpy...'}
	printf \{'created by donnaken15'}
	FGH3Config sect='JORSpy' 'Debug' #"0x1ca1ff20"=($js_debug)
	change js_debug = <value>
	FGH3Config sect='JORSpy' 'InvertWhammy' #"0x1ca1ff20"=($js_invert_whammy)
	change js_invert_whammy = <value>
	// load my assets
	ProfilingStart
	LoadPak \{'MODS/jorspy.pak' Heap = heap_global_pak}
	ProfilingEnd <...> 'LoadPak jorspy.pak'

	id = note_hit_delay_samples_i
	begin
		AllocArray <id> set = 0.0 size = 25
		ExtendCrc <id> 'i' out = id
	repeat 6
	AllocArray \{nps_avg_samples set = 0 size = 25}
	// keep user preference for whatever reason
	// to display original input logging
	change display_guitar_input = ($output_log_file)
	change \{output_log_file = 1}
	
	Wait \{1 gameframe}
	printf \{'JORSpy | creating screen'}
	AddParams \{text_opacity = 0.9 js_z = 10000000.0 js_colors = [[	0 255 144 159 ] [ 255	0	0 159 ] [ 255 255	0 159 ] [	0	0 255 159 ] [ 255 127	0 159 ] [ 255	0 255 159 ]]}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = spy_container Pos = (0.0, 0.0)}
	if ($display_guitar_input = 1)
		CreateScreenElement \{ Type = TextElement parent = spy_container font = text_jorspy1 id = js_debuginp text = '---- INPUT TEXT ----' Pos = (70.0,230.0) just = [left center] rgba = [255 255 255 255] Scale = 0.25 alpha = $display_guitar_input z_priority = 10000000 }
	endif
	CreateScreenElement \{ Type = TextElement parent = spy_container font = text_jorspy2 id = js_watermark text = '' Pos = (76.0,20.0) just = [left center] rgba = [255 255 255 255] Scale = 0.25 alpha = 0.5 z_priority = 10000000 }
	FormatText textname = text 'JORSpy %v | donnaken15.com/FastGH3' v = ($jorspy_mod_info.version)
	SetScreenElementProps id = js_watermark text = <text>
	AddParams \{i = 0 button_base = (640.0, 70.0) text_offset = (-0.5, -12.0) btn_text2_scale = 0.24}
	begin
		ExtendCrc js2D ($gem_colors_text[<i>]) out=name_base
		ExtendCrc <name_base> 'b' out=button_id // button sprite
		//ExtendCrc <button_id> 'p' out=button_p_id // button press sprite
		ExtendCrc <name_base> 'bt' out=text_base // button text
		ExtendCrc <text_base> 'pc' out=btn_pc_id // press count
		ExtendCrc <text_base> 'ht' out=btn_ht_id // hold time
		ExtendCrc <text_base> 'ot' out=btn_ot_id // off time
		ExtendCrc <text_base> 'a'  out=btn_a_id // anchor count
		//ExtendCrc <text_base> 'g'  out=btn_g_id // ghost count
		pos = (<button_base> + ((90.0, 0.0) * (<i> - 2)))
		CreateScreenElement { Type = ContainerElement parent = spy_container
			id = <name_base> Pos = <pos> just = [center center] }
		CreateScreenElement { Type = SpriteElement parent = <name_base>
			id = <button_id> rgba = (<js_colors>[<i>]) Scale = 0.9
			Pos = (0.0, 4.0) z_priority = (<js_z> + 10) texture = js_button }
		CreateScreenElement { Type = TextElement parent = <name_base>
			font = text_jorspy1 id = <btn_pc_id> text = '0' Scale = 0.5
			Pos = <text_offset> z_priority = (<js_z> + 12) alpha = <text_opacity> }
		CreateScreenElement { Type = TextElement parent = <name_base>
			font = text_jorspy1 id = <btn_ht_id> text = 'H:0.000'
			Pos = (<text_offset> + (0.0, 14.0)) Scale = <btn_text2_scale>
			z_priority = (<js_z> + 12) alpha = <text_opacity> }
		CreateScreenElement { Type = TextElement parent = <name_base>
			font = text_jorspy1 id = <btn_ot_id> text = 'T:0.000'
			Pos = (<text_offset> + (0.0, 28.0)) Scale = <btn_text2_scale>
			z_priority = (<js_z> + 12) alpha = <text_opacity> }
		/*CreateScreenElement { Type = TextElement parent = <name_base>
			font = text_jorspy1 id = <btn_g_id> text = 'G:0'
			Pos = (<text_offset> + (0.0, 42.0)) scale = <btn_text2_scale>
			z_priority = (<js_z> + 12) alpha = <text_opacity> }*///
		CreateScreenElement { Type = TextElement parent = <name_base>
			font = text_jorspy1 id = <btn_a_id> text = 'A:0'
			Pos = (<text_offset> + (0.0, 42.0)) Scale = <btn_text2_scale> // 56.0
			z_priority = (<js_z> + 12) alpha = <text_opacity> }
		if (<i> = 4)
			SetScreenElementProps id = <btn_a_id> text = ''
		endif
		Increment \{i}
	repeat 5

	ExtendCrc js2D 'open' out=name_base
	ExtendCrc <name_base> 'b' out=button_id
	ExtendCrc <button_id> 'p' out=button_p_id
	ExtendCrc <name_base> 'bt' out=text_base
	ExtendCrc <text_base> 'pc' out=btn_pc_id
	ExtendCrc <text_base> 'ht' out=btn_ht_id
	CreateScreenElement Type = ContainerElement parent = spy_container id = js2Dopen Pos = <button_base> just = [center center]
	// open sprite
	CreateScreenElement \{ Type = SpriteElement parent = js2Dopen texture = js_strum id = js2Dopenb rgba = [255 255 255 159] Scale = 1 z_priority = 10000009 }
	// left side text
	CreateScreenElement { Type = TextElement parent = js2Dopen
		font = text_jorspy1 id = js2Dopenbtpc text = 'U/D: 0/0'
		just = [left center] Pos = (<text_offset> + (-560.0, 16.0))
		Scale = 0.4 z_priority = (<js_z> + 12) alpha = <text_opacity> }
	CreateScreenElement { Type = TextElement parent = js2Dopen
		font = text_jorspy1 id = js2Dos text = 'OS: 0' just = [left center]
		Pos = (<text_offset>+(-360.0, 20.0)-(-10.0, 10.0)) Scale = 0.3
		z_priority = (<js_z> + 12) alpha = <text_opacity> }
	CreateScreenElement { Type = TextElement parent = js2Dopen
		font = text_jorspy1 id = js2Dmiss text = 'MI: 0' just = [left center]
		Pos = (<text_offset>+(-360.0, 20.0)+(10.0, 10.0)) Scale = 0.3
		z_priority = (<js_z> + 12) alpha = <text_opacity> }
	CreateScreenElement { Type = TextElement parent = js2Dopen
		font = text_jorspy1 id = js2Dstrho text = 'SH: 0' just = [left center]
		Pos = (<text_offset>+(-360.0, 20.0)+(10.0, 30.0)) Scale = 0.3
		z_priority = (<js_z> + 12) alpha = <text_opacity> }
	CreateScreenElement { Type = TextElement parent = js2Dopen
		font = text_jorspy1 id = js2Doot text = '' just = [center center]
		Pos = (<text_offset>+(-470.0, 20.0)+(10.0, 32.0)) Scale = 0.4
		z_priority = (<js_z> + 12) alpha = <text_opacity> }
	CreateScreenElement \{ Type = SpriteElement parent = spy_container texture = js_whammybar_base pos = (960.0, 96.0) just = [center center] id = js2Dwhammybase Scale = 0.6 z_priority = 10000010 alpha = 1 }
	CreateScreenElement \{ Type = SpriteElement parent = js2Dwhammybase texture = js_whammybar pos = (64.0, 24.0) just = [-0.4688 0.914] id = js2Dwhammy Scale = 1.4 z_priority = 10000009 alpha = 1 }
	CreateScreenElement \{ Type = TextElement parent = spy_container font = text_jorspy1 just = [left top] Scale = 0.5 z_priority = 10000020 id = js2D_time Pos = (80.0, 140.0) alpha = 0.8 }
	CreateScreenElement \{ Type = TextElement parent = spy_container font = text_jorspy1 just = [left top] Scale = 0.5 z_priority = 10000020 id = js2Dnps Pos = (80.0, 170.0) alpha = 0.8 }
	
	// >thinking this will be faster because the struct data is prebuilt
	AddParams \{ timer_update_rate = 16.666666666 last_time = -1.0 last_pattern = 0 last_starttime = 0 dirs = [ up down ] presses = [ 0 0 0 0 0 ] hold = [ 0 0 0 0 0 ] holdtime = [ 0.0 0.0 0.0 0.0 0.0 ] anchors = [ 0 0 0 0 0 ] updowns = [ 0 0 ] overstrums = 0 misses = 0 strums = 0 hammer = 0 strum_hopos = 0 strum_anim = 9999999.9999999 TUPF_i = 0.0 last_flip = 0}
	invert_whammy_bar = ($js_invert_whammy)
	if (<invert_whammy_bar> = 1)
		invert_whammy_bar = -11
	else
		invert_whammy_bar = 11
	endif
	
	Wait \{1 gameframe}
	
	printf \{'JORSpy | running loop'}
	begin
		//ProfilingStart
		SetScreenElementProps \{id = spy_container alpha = $playing_song}
		if ($current_num_players = 1 && $playing_song = 1)
			GetSongTimeMs
			GetDeltaTime \{ignore_slomo}
			// trying hard to refrain from injecting code into original scripts
			why = 0
			if (<time> - $current_starttime < 1 && <last_time> > <time>)
				why = 1
			endif
			if NOT (<last_starttime> = $current_starttime)
				last_starttime = ($current_starttime)
				why = 1
			endif
			if (<why> = 1)
				AddParams \{ i = 0 presses = [ 0 0 0 0 0 ] hold = [ 0 0 0 0 0 ] holdtime = [ 0.0 0.0 0.0 0.0 0.0 ] anchors = [ 0 0 0 0 0 ] updowns = [ 0 0 ] overstrums = 0 misses = 0 strums = 0 hammer = 0 strum_hopos = 0 strum_anim = 9999999.9999999 TUPF_i = 0.0 invert_whammy_bar = $js_invert_whammy last_flip = 0 }
				if (<invert_whammy_bar> = 1)
					invert_whammy_bar = -11
				else
					invert_whammy_bar = 11
				endif
				change \{js_possibly_strumming_hopo = 0}
				begin
					ExtendCrc js2D ($gem_colors_text[<i>]) out=name_base
					ExtendCrc <name_base> 'b' out=button_id
					//ExtendCrc <button_id> 'p' out=button_p_id
					ExtendCrc <name_base> 'bt' out=text_base
					ExtendCrc <text_base> 'pc' out=btn_pc_id
					ExtendCrc <text_base> 'ht' out=btn_ht_id
					ExtendCrc <text_base> 'ot' out=btn_ot_id
					ExtendCrc <text_base> 'a' out=btn_a_id
					//ExtendCrc <text_base> 'g' out=btn_g_id
					SetScreenElementProps id = <btn_pc_id> text = '0'
					SetScreenElementProps id = <btn_ht_id> text = 'H:0.000'
					SetScreenElementProps id = <btn_ot_id> text = 'T:0.000'
					//SetScreenElementProps id = <btn_g_id> text = 'G:0'
					if NOT (<i> = 4)
						SetScreenElementProps id = <btn_a_id> text = 'A:0'
					else
						SetScreenElementProps id = <btn_a_id> text = ''
					endif
					SetScreenElementProps \{id = js2Dopenb texture = js_strum}
					Increment \{i}
				repeat 5
				SetScreenElementProps \{id = js2Dos text = 'OS: 0'}
				SetScreenElementProps \{id = js2Dmiss text = 'MI: 0'}
				SetScreenElementProps \{id = js2Dopenbtpc text = 'U/D: 0/0'}
				SetScreenElementProps \{id = js2Dstrho text = 'SH: 0'}
				SetScreenElementProps \{id = js2Doot text = ''}
				SetScreenElementProps \{id = js2Dnps text = ''}
				i = 0
				begin
					SetArrayElement arrayname = note_hit_delay_indexes globalarray index = <i> newvalue = 0
					SetArrayElement arrayname = note_hit_delay_average globalarray index = <i> newvalue = 0.0
					id = note_hit_delay_samples_i
					begin
						AllocArray <id> set = 0.0 size = 25
						ExtendCrc <id> 'i' out = id
					repeat 5
					Increment \{i}
				repeat 6
				AllocArray \{nps_avg_samples set = 0 size = 25}
				array = ($player1_status.current_song_gem_array)
				GetArraySize ($<array>)
				startTime = ($current_starttime)
				i = 0
				begin
					if ($<array>[<i>] >= <startTime>)
						break
					endif
					i = (<i> + 3)
				repeat (<array_size> / 3)
				change nps_avg_offset = (<i> / 3)
				change \{nps_avg_last_capture = 0.0}
			endif
			last_time = <time>
			
			if NOT (<last_flip> = $player1_status.lefthanded_button_ups)
				last_flip = ($player1_status.lefthanded_button_ups)
				j = 0
				if (<last_flip> = 1)
					i = 4
				else
					i = 0
				endif
				begin
					ExtendCrc js2D ($gem_colors_text[<i>]) out=name_base
					// button sprite
					ExtendCrc <name_base> 'b' out=button_id
					pos = (<button_base> + ((90.0, 0.0) * (<j> - 2)))
					SetScreenElementProps id = <name_base> Pos = <pos>
					if (<last_flip> = 1)
						i = (<i> - 1)
					else
						Increment \{i}
					endif
					Increment \{j}
				repeat 5
			endif

			if (<time> > (<TUPF_i>))
				TUPF_i = (<time> + (<timer_update_rate> * $current_speedfactor))
				if (<time> > 0)
					format_time milliseconds (<time> / 1000)
					FormatText textname = text 'TIME: %t, INPUT: %s' t = <timetext> s = $inputtime
					SetScreenElementProps id = js2D_time text = <text>
				else
					SetScreenElementProps id = js2D_time text = 'TIME: 00:00.000'
				endif
				FormatText textname = text 'NPS: %n' n = ($nps_avg)
				SetScreenElementProps id = js2Dnps text = <text>
			endif
			
			// how do i run a script that executes when paused?
			
			// main
			GetHeldPattern controller = ($player1_status.controller) nobrokenstring
			AddParams \{ check_button = 65536 i = 0 }
			begin
				ExtendCrc js2D ($gem_colors_text[<i>]) out=name_base
				// TODO: calculate these once only
				ExtendCrc <name_base> 'b' out=button_id
				//ExtendCrc <button_id> 'p' out=button_p_id
				ExtendCrc <name_base> 'bt' out=text_base
				ExtendCrc <text_base> 'pc' out=btn_pc_id
				ExtendCrc <text_base> 'ht' out=btn_ht_id
				ExtendCrc <text_base> 'ot' out=btn_ot_id
				ExtendCrc <text_base> 'a' out=btn_a_id
				if (<hold_pattern> & <check_button>)
					on = 1
					if (<hold>[<i>] = 0)
						SetArrayElement arrayname=presses index=<i> newvalue=(<presses>[<i>] + 1)
					endif
					FormatText textname = text '%d' d = (<presses>[<i>])
					SetScreenElementProps id = <btn_pc_id> text = <text>
				else
					on = 0
				endif
				SetArrayElement arrayname=hold index=<i> newvalue=<on>
				if (<on> = 1)
					SetArrayElement arrayname=holdtime index=<i> newvalue=(<holdtime>[<i>] + <delta_time>)
					FormatText textname = text 'H:%d' d = (<holdtime>[<i>])
					SetScreenElementProps id = <btn_ht_id> text = <text>
				endif
				if ($js_a[<i>] > 0)
					SetArrayElement arrayname = anchors index = <i> newvalue = (<anchors>[<i>] + $js_a[<i>])
					FormatText textname = text 'A:%d' d = (<anchors>[<i>])
					SetScreenElementProps id = <btn_a_id> text = <text>
					SetArrayElement arrayname = js_a globalarray index = <i> newvalue = 0
				endif
				if NOT (<hold_pattern> = <last_pattern>)
					if (<on> = 1)
						texture = js_button_pressed
					else
						texture = js_button
					endif
					SetScreenElementProps id = <button_id> texture = <texture>
				endif
				FormatText textname = text 'T:%d' d = ($note_hit_delay_average[<i>])
				SetScreenElementProps id = <btn_ot_id> text = <text>
				<check_button> = (<check_button> / 16)
				Increment \{i}
			repeat 5
			if GuitarGetAnalogueInfo controller = ($player1_status.controller)
				SetScreenElementProps id = js2Dwhammy rot_angle = ((8 + (<invert_whammy_bar> * -1) + (<rightx> * (<invert_whammy_bar>))))
			endif
			FormatText textname = text 'OT: %d' d = ($note_hit_delay_average[5])
			SetScreenElementProps id = js2Doot text = <text>
			if ($js_os > 0)
				overstrums = (<overstrums> + $js_os)
				FormatText textname = text 'OS: %d' d = <overstrums>
				SetScreenElementProps id = js2Dos text = <text>
				change \{js_os = 0}
			endif
			if ($js_miss > 0)
				misses = (<misses> + $js_miss)
				FormatText textname = text 'MI: %d' d = <misses>
				SetScreenElementProps id = js2Dmiss text = <text>
				change \{js_miss = 0}
			endif
			//test_buttons = [ X square right start r2 triangle l1 circle up back black left z select down white l2]
			//i = 0
			//begin
			//	if ControllerMake (<test_buttons>[<i>]) $player1_device
			//		printf 'got %d' d = (<test_buttons>[<i>])
			//	endif
			//	Increment \{i}
			//repeat 16
			if ($player1_status.bot_play = 0)
				i = 0
				j = 0
				begin
					formattext checksumname = element 'js2Dopenbp%d' d = <i>
					if ControllerMake (<dirs>[<i>]) $player1_device
						if NOT (<strum_anim> = 9999999.9999999)
							SetScreenElementProps \{id = js2Dopenb scale = 1 texture = js_strum}
						endif
						if (<i> = 0)
							SetScreenElementProps \{id = js2Dopenb scale = 1 texture = js_strum_pressed_oneside}
						endif
						if (<i> = 1)
							SetScreenElementProps \{id = js2Dopenb scale = (1,-1) texture = js_strum_pressed_oneside}
						endif
						SetArrayElement arrayname = updowns index = <i> newvalue = (<updowns>[<i>] + 1)
						Increment \{j}
					endif
					Increment \{i}
				repeat 2
				if (<j> > 0)
					FormatText textname = text 'U/D: %a/%b' a = (<updowns>[0]) b = (<updowns>[1])
					SetScreenElementProps id = js2Dopenbtpc text = <text>
				endif
				if (<j> = 2)
					SetScreenElementProps \{id = js2Dopenb scale = 1 texture = js_strum}
				endif
			else
				if ($js_strums > 0)
					FormatText textname = text 'U/D: %d' d = <strums>
					SetScreenElementProps \{id = js2Dopenb scale = 1 texture = js_strum_pressed}
					SetScreenElementProps id = js2Dopenbtpc text = <text>
				endif
			endif
			if ($js_strums > 0)
				strums = (<strums> + $js_strums)
				change \{js_strums = 0}
				strum_anim = (<time> + 33.33333333)
			endif
			if ($js_sh > 0)
				strum_hopos = (<strum_hopos> + $js_sh)
				FormatText textname = text 'SH: %d' d = <strum_hopos>
				SetScreenElementProps id = js2Dstrho text = <text>
				change \{js_sh = 0}
			endif
			if (<time> > <strum_anim>)
				strum_anim = 9999999.9999999
				SetScreenElementProps \{id = js2Dopenb scale = 1 texture = js_strum}
			endif
			last_pattern = <hold_pattern>
		endif
		//ProfilingEnd <...> loop 'jorspy update' ____profiling_interval = 120
		Wait \{1 gameframe}
	repeat
endscript
script nps_avg_calc
	GetSongTimeMs
	GetArraySize \{$nps_avg_samples}
	interval = $nps_avg_sample_interval
	if (<time> - $nps_avg_last_capture < (<interval>/<array_size>))
		return
	endif
	//ProfilingStart
	array = ($<player_status>.current_song_gem_array)
	GetArraySize $<array>
	change nps_avg_last_capture = <time>
	k = ((<array_entry> + $nps_avg_offset) * 3)
	j = 0
	start = ($<array>[<k>])
	range = $nps_avg_capture_range
	time_end = (1000.0 * <range>)
	if NOT (<time> < (<start> - <time_end>))
		begin
			if (<k> > <array_size>)
				break
			endif
			if ($<array>[<k>] - <start> >= <time_end>)
				break
			endif
			k = (<k> + 3)
			Increment \{j}
		repeat
	endif
	GetArraySize \{$nps_avg_samples}
	index = $nps_avg_sample_index
	j = (<j> / <range>)
	setarrayelement arrayname=nps_avg_samples globalarray index=<index> newvalue=<j>
	Increment \{index}
	if (<index> >= <array_size>)
		avg \{$nps_avg_samples}
		change nps_avg = <avg>
	endif
	Mod a=<index> b=<array_size>
	change nps_avg_sample_index = <mod>
	//ProfilingEnd <...> 'nps_avg_calc'
endscript
script log_hit_time
	id = note_hit_delay_samples_i
	if (<#"0x00000000"> > 0)
		begin
			ExtendCrc <id> 'i' out = id
		repeat <#"0x00000000">
	endif
	index = ($note_hit_delay_indexes[<#"0x00000000">])
	SetArrayElement arrayname = <id> globalarray index = <index> newvalue = <value>
	Avg ($<id>)
	Increment \{index}
	Mod a=<index> b=25
	SetArrayElement arrayname = note_hit_delay_average globalarray index = <#"0x00000000"> newvalue = <avg>
	SetArrayElement arrayname = note_hit_delay_indexes globalarray index = <#"0x00000000"> newvalue = <mod>
endscript
// welp
debug_profile_i = 0
debug_profile_interval = 120
script debug_output
	if NOT (<player> = 1)
		return
	endif
	//ProfilingStart
	change inputtime = <time>
	input_time = <time>
	GetSongTimeMs
	spawnscriptnow nps_avg_calc params = {player_status = <player_status> array_entry = <array_entry>}
	change js_noteindex = <array_entry>
	log_guitar_input <...>
	// ^ super (need to implement actually)
	AddParams \{hit = 0 miss = 0 unnecessary = 0 strum = 0}
	change js_strums = ($js_strums + <hit_strum>)
	change ___why = ($___why + <hit_strum>)
	hammer = ($<song>[<array_entry>][6])
	// has tap flag @ 2nd bit lol
	if (<strummed_before_forming> >= 0.0)
		// kill me
		// half working
		if (<hammer> = 1)
			//printf \{'- might be strumming before hitting hopo'}
			change \{js_possibly_strumming_hopo = 2}
		endif
	endif
	GetStrumPattern song = <song> entry = <array_entry>
	GetHeldPattern controller = ($<player_status>.controller) nobrokenstring
	if (<action_hit> = 'HIT1')
		// log how off the player hit the note
		off_note = (<time> - $<song>[<array_entry>][0])
		AddParams \{hit = 1 check_button = 65536 i = 0}
		begin
			if (<strum> & <check_button>)
				log_hit_time <i> value = <off_note>
			endif
			<check_button> = (<check_button> / 16)
			Increment \{i}
		repeat 5
		// include opens...
		if (<strum> = 0)
			log_hit_time 5 value = <off_note>
		endif
		if (<hammer> = 1 || <hammer> = 2)
			if ($js_possibly_strumming_hopo = 2)
				spyprint \{' strummed before forming hopo pattern'}
				change js_sh = ($js_sh + 1)
				change \{js_possibly_strumming_hopo = 0}
			endif
			if ($js_possibly_strumming_hopo = 0)
				//printf \{'- check if hopo is strummed'}
				change \{js_possibly_strumming_hopo = 1}
				change js_possibly_strummed_hopo = <strum>
			endif
			// hitting hammer and strumming on same frame is rare probably
			if (<hit_strum> = 1)
				change js_sh = ($js_sh + 1)
			endif
			if ($js_check_anchoring = 1)
				GetStrumPattern song = <song> entry = <array_entry>
				if (<hold_pattern> & <strum>)
					check_button = 65536
					i = 0
					begin
						if (<strum> & <check_button>)
							spyprint \{'- got anchor'}
							SetArrayElement arrayname = js_a globalarray index = <i> newvalue = ($js_a[<i>] + 1)
							break
						endif
						<check_button> = (<check_button> / 16)
						Increment \{i}
					repeat 5
				endif
				//change \{debug_profile_i = 999999999}
				change \{js_check_anchoring = 0}
			endif
		else
			change \{js_check_anchoring = 0}
		endif
		if ($js_check_anchoring = 0)
			AddParams \{frets = 0 check_button = 65536 i = 0}
			begin
				if (<hold_pattern> & <check_button>)
					Increment \{frets}
					if (<frets> > 1)
						gemarrayid = ($<player_status>.current_song_gem_array)
						song_array = $<gemarrayid>
						GetArraySize \{song_array}
						if ((<array_entry> + 2) < (<array_size> / 3))
							strum2 = <strum>
							GetStrumPattern song = <song> entry = (<array_entry> + 1)
							if (<strum2> < <strum>) // if next note is lower
								AddParams \{hopo_chord = 0 check_button = 65536 i = 0}
								begin
									if (<strum> & <check_button>)
										Increment \{hopo_chord}
										if (<hopo_chord> > 1)
											break
										endif
									endif
									<check_button> = (<check_button> / 16)
									Increment \{i}
								repeat 5
								// check for singular note
								if (<hopo_chord> = 1) // wtf did i mean by this
									spyprint \{' possibly anchoring?'}
									// save pattern if it has lower frets
									change \{js_check_anchoring = 1}
									//change js_anchor_heldpattern = <hold_pattern>
									change js_anchor_nextnote = <strum>
								endif
								//change \{debug_profile_i = 999999999}
								break
							endif
						endif
					endif
				endif
				<check_button> = (<check_button> / 16)
				Increment \{i}
			repeat 5
		endif
	endif
	if ($js_check_anchoring = 1)
		// check if anchor fret was released
		if NOT (<hold_pattern> & $js_anchor_nextnote)
			spyprint \{'- anchor cancelled'}
			change \{js_check_anchoring = 0}
		endif
	endif
	if (<action_mis> = 'MIS1')
		miss = 1
		change js_miss = ($js_miss + 1)
		if (<hammer> = 1)
			change \{js_check_anchoring = 0}
		endif
	endif
	if (<action_mis> = 'MIS2')
		miss = 2
		change js_miss = ($js_miss + 1)
		if (<hammer> = 1)
			change \{js_check_anchoring = 0}
		endif
	endif
	if (<action_unn> = 'UNN1')
		unnecessary = 1
		change js_os = ($js_os + 1)
	endif
	if (<action_unn> = 'UNN2')
		unnecessary = 2
		change js_os = ($js_os + 1)
	endif
	if (<action_tol> = 'MIS3')
		// i dont remember what this is
		miss = 3
	endif
	if (<hit_strum> = 1)
		if ($js_possibly_strumming_hopo = 1)
			if (<unnecessary> = 0)
				if (<ignore_time> >= 0.0)
					//text = ''
					//debug_gem_text text = <text> pattern = <original_strum> prefix = "He:"
					//debug_gem_text text = <text> pattern = $js_possibly_strummed_hopo prefix = "PSH:"
					//printf <text>
					spyprint \{'- strum after tapping hopo'}
					if (<original_strum> = $js_possibly_strummed_hopo || (<hammer> = 1 || <hammer> = 2))
						change js_sh = ($js_sh + 1)
					endif
					change \{js_possibly_strummed_hopo = 0}
					change \{js_possibly_strumming_hopo = 0}
				endif
			endif
		endif
	endif
	/*if NOT ($js_ghost_lastinput = <hold_pattern>)// || NOT ($js_ghost_lastindex = <array_entry>)
		printf \{'ghost check'}
		MathFloor <time>
		floor2 = <floor>
		MathFloor <input_time>
		FormatText textname = text '%t,%s: ' t=<floor2> s=<floor>
		check_button = 65536
		begin
			if (<check_button> & <hold_pattern>)
				a = 1
			else
				a = 0
			endif
			FormatText textname = text "%t%a," t = <text> a = <a>
			<check_button> = (<check_button> / 16)
		repeat 5
		FormatText textname = text "%tS(%s)" t = <text> s = <hit_strum>
		printf <text>
		printf \{'-------------------------'}
		i = 0
		GetArraySize $<song>
		begin
			j = (<array_entry> + <i>)
			note = ($<song>[<j>])
			// useful maybe (probably input_arrayp1):
			// 0: time
			// 1-5: G/R/Y/B/O lengths
			// 6: hammer
			// 7: (input) time end??
			//printf '%d >= %e' d = (<time>) e = (<note>[0])
			if (<note>[0] = 2140283648) // wtf
				break
			endif
			if (<inputtime> + 250 > <note>[0])
				break
			endif
			if (<j> >= <array_size>)
				break
			endif
			//printstruct <note>
			printf {
				'%a-%h: %b,%c,%d,%e,%f,H(%g)'
				a = (<note>[0]) b = (<note>[1])
				c = (<note>[2]) d = (<note>[3])
				e = (<note>[4]) f = (<note>[5])
				g = (<note>[6]) h = (<note>[7])
			}
			Increment \{i}
		repeat
		change js_ghost_lastinput = <hold_pattern>
		change js_ghost_lastindex = <array_entry>
	endif*///
	//change debug_profile_i = ($debug_profile_i + 1)
	//if ($debug_profile_i > $debug_profile_interval)
	//	change \{debug_profile_i = 0}
	//	ProfilingEnd <...> 'debug_output override'
	//endif
endscript
script log_guitar_input
	if ($display_guitar_input = 0)
		return
	endif
	<showtime> = (<time> - ($check_time_early * 1000.0))
	FormatText textname = text "%t: %d:(%c)" t = <showtime> d = ($<song>[<array_entry>][6])c = ($<player_status>.controller)
	FormatText textname = text "%tAE:%d," t = <text> d = <array_entry>
	FormatText textname = text "%tTE:%d," t = <text> d = <time_end>
	if (<ignore_time> >= 0)
		debug_gem_text text = <text> pattern = <ignore_strum> prefix = "Ig: "
	else
		FormatText textname = text "%tIg: ..... " t = <text>
	endif
	GetHeldPattern controller = ($<player_status>.controller)nobrokenstring
	debug_gem_text text = <text> pattern = <strummed_pattern> prefix = "LS: "
	debug_gem_text text = <text> pattern = <original_strum> prefix = "Or: "
	debug_gem_text text = <text> pattern = <hold_pattern> prefix = "He: "
	if (<hit_strum> = 1)
		Ternary (<fake_strum> = 1) a = 'H' b = 'S'
	else
		Ternary (<fake_strum> = 1) a = 'F' b = '.'
	endif
	FormatText textname = text "%t %c " t = <text> c = <ternary>
	Ternary (<strummed_before_forming> >= 0.0) a = 'T' b = ' '
	FormatText textname = text "%t %c " t = <text> c = <ternary>
	get_input_debug_text <...>
	FormatText textname = text "%t%h%m%u%l%i" t = <text> h = <action_hit> m = <action_mis> u = <action_unn> l = <action_tol> i = <input_text>
	FormatText textname = text "%t :%o:" t = <text> o = ($<player_status>.hammer_on_tolerance)
	<check_entry> = <array_entry>
	if (<time> >= $<song>[<check_entry>][0])
		begin
			GetStrumPattern song = <song> entry = <check_entry>
			<hammer> = ($<song>[<check_entry>][6])
			if (<hammer> = 1)
				debug_gem_text text = <text> pattern = <strum> prefix = "h"
			else
				debug_gem_text text = <text> pattern = <strum> prefix = ">"
			endif
			if ((<check_entry> + 1)< <song_array_size>)
				<check_entry> = (<check_entry> + 1)
			else
				break
			endif
			if (<time> < ($<song>[<check_entry>][0]))
				break
			endif
		repeat
	endif
	GetArraySize <strum_hits>
	if (<array_Size> > 0)
		FormatText textname = text "%t S(" t = <text>
		<index> = 0
		begin
			<strum> = (<strum_hits> [<index>])
			debug_gem_text text = <text> pattern = <strum> prefix = ""
			Increment \{index}
		repeat <array_Size>
		FormatText textname = text "%t)" t = <text>
	endif
	GetArraySize <hammer_hits>
	if (<array_Size> > 0)
		FormatText textname = text "%t H(" t = <text>
		<index> = 0
		begin
			<strum> = (<hammer_hits> [<index>])
			debug_gem_text text = <text> pattern = <strum> prefix = ""
			Increment \{index}
		repeat <array_Size>
		FormatText textname = text "%t)" t = <text>
	endif
	if (<player> = 1)
		SetScreenElementProps id = js_debuginp text = <text>
	endif
endscript
// for floats
script Modulo \{mod = 10}
	begin
		if (<#"0x00000000"> >= <mod>)
			#"0x00000000" = (<#"0x00000000"> - <mod>)
		else
			return mod = <#"0x00000000">
		endif
	repeat
endscript
script Sum
	getarraysize \{#"0x00000000"}
	sum = 0.0
	i = 0
	begin
		sum = (<sum> + (<#"0x00000000">[<i>] * 1.0))
		Increment \{i}
	repeat <array_size>
	return sum = <sum>
endscript
script Avg
	Sum <#"0x00000000">
	getarraysize \{#"0x00000000"}
	return avg = (<sum> / <array_size>)
endscript
//script Toggle
//	change globalname = <#"0x00000000"> newvalue = (1 - $<#"0x00000000">)
//endscript
script Min \{a = 0 b = 0}
	if (<a> > <b>)
		return min = <b>
	else
		return min = <a>
	endif
endscript
script Max \{a = 0 b = 0}
	if (<a> < <b>)
		return max = <b>
	else
		return max = <a>
	endif
endscript
script spyprint
	if not IsTrue \{$js_debug}
		return
	endif
	formattext <...> textname = text
	GetSongTime
	printf "-- %t -%a" t = <songtime> a = <text>
endscript

js_invert_whammy = 0
js_debug = 1
js_os = 0 // overstrums
js_miss = 0 // misses
js_strums = 0 // strum check
js_sh = 0 // strummed hopos
js_a = [ 0 0 0 0 0 ] // anchor count for each fret
// per frame checking variables
js_possibly_strummed_hopo = 0
js_possibly_strumming_hopo = 0
js_check_anchoring = 0
//js_anchor_heldpattern = 0
js_anchor_nextnote = 0
js_check_ghosting = 0
js_noteindex = 0
//js_ghost_lastinput = 0
//js_ghost_lastindex = 0
//output_log_file = 1 // built in game variable, set to 1 to enable input text
display_guitar_input = 0
nps_avg_samples = []
nps_avg_sample_interval = 250.0
nps_avg_sample_index = 0
nps_avg_last_capture = 0.0
// number of seconds to scan notes, and divide count by
nps_avg_capture_range = 2
// final result
nps_avg = 0.0
nps_avg_offset = 0
// hit delay averaging, for each fret because im autistic
note_hit_delay_full = [ 0 0 0 0 0 0 ]
note_hit_delay_indexes = [ 0 0 0 0 0 0 ]
// hate me
note_hit_delay_samples_i = []
note_hit_delay_samples_ii = []
note_hit_delay_samples_iii = []
note_hit_delay_samples_iiii = []
note_hit_delay_samples_iiiii = []
note_hit_delay_samples_iiiiii = []
note_hit_delay_average = [ 0.0 0.0 0.0 0.0 0.0 0.0 ]
inputtime = 0

script format_time \{0.0}
	Modulo <#"0x00000000"> mod = 60
	seconds = <mod>
	MathFloor (<#"0x00000000"> / 60)
	if NOT GotParam \{milliseconds}
		CastToInteger \{seconds}
	endif
	pad <seconds> count = 6
	seconds = <pad>
	pad <floor>
	FormatText textname = timetext '%m:%s' m = <pad> s = <seconds>
	return timetext = <timetext>
endscript

jorspy_mod_info = {
	name = 'JORSpy'
	desc = 'just osu! right? / Player statistics'
	author = 'donnaken15'
	version = '0.62--24.04.24'
	requires = [
		'jorspy.pak.xen'
	]
	params = [ // for user config, values stored in config.qb
		// non unique named mods have the filename prefixed on vars
		{ name = 'js_invert_whammy' default = 0 type = bool
			ini = [ // implement saving to
				'JORSpy' 'InvertWhammy' // sect, key
			]
			desc = 'Enable if you prefer to have the whammy bar facing outwards.' }
		{ name = 'js_debug' default = 0 type = bool
			ini = [ 'JORSpy' 'Debug' ]
			desc = 'Print important information happening between timed events, requires Logger.' }
	]
}

