
// =======================================================
// MOD ENTRY POINT
// =======================================================

script eval_startup
	//LoadPak \{'MODS/eval.pak'}
	decompress_eval
	decompress_help
	decompress_chars
	FGH3Config sect='Mods' 'EvalVerbose' #"0x1ca1ff20"=($evalverbose)
	change evalverbose = <value>
	printf \{'Running autoexec line'}
	FGH3Config \{sect='Mods' 'AutoExec' #"0x1ca1ff20"="printf 'no autoexec specified!!!!!'"}
	eval <value> // evalu8 for fun
	wait \{2 gameframes}
	spawnscriptlater key_events
endscript

eval_mod_info = {
	name = 'eval'
	desc = 'QbScript Console and Interpreter, within QbScript, bundled with ConVars'
	author = 'donnaken15'
	version = '24.01'
	params = [ // for user config, values stored in config.qb
		// non unique named mods have the filename prefixed on vars
		{ name = 'console_pause' default = 1 type = bool
			ini = [ 'Mods' 'ConsolePause' ]
			desc = 'Pause game when the console is active.' }
		{ name = 'evalverbose' default = 0 type = bool
			ini = [ 'Mods' 'EvalVerbose' ]
			desc = 'Print the ongoing process of parsing and executing script text.' }
	]
}


// =======================================================
// convars
// =======================================================

// todo?: autocomplete lol // i need help
manual = {}
script decompress_help // desperate
	change manual = {
		exit = {
			'Exit the engine.' name = 'exit'
		}
		quit = {
			'Exit the engine.' name = 'quit'
		}
		help = {
			'Find help about a convar/concommand.'
			params = [ { 'script' } ]
			name = 'help'
		}
		give = {
			'Give item to player.'
			params = [
				{ item name = #"0x00000000" }
				{ player name = player }
			]
			name = 'give'
		}
		fps = {
			'Frame rate limiter.'
			//params = [ { fps } ]
			name = 'fps'
			cvar = fps_max
		}
		sv_speed = {
			'Change speed of the song.'
			params = [ { speed } ]
			name = 'sv_speed'
			cvar = current_speedfactor
		}
		alias = {
			'Alias a command, or script string.'
			params = [
				{ 'name' }
				{ 'script' }
			]
			name = 'give'
		}
	}
endscript
quit=$ExitGameConfirmed
exit=$ExitGameConfirmed
script help
	if NOT GotParam \{#"0x00000000"}
		help \{help}
		return
	endif
	if NOT ScriptExists <#"0x00000000">
		printf \{'Script does not exist.'}
		return
	endif
	if NOT StructureContains structure=$manual <#"0x00000000">
		printf \{'Script does not have information.'}
		return
	endif
	info = ($manual.<#"0x00000000">)
	if StructureContains \{structure=info name}
		name = (<info>.name)
	else
		name = <#"0x00000000">
	endif
	if StructureContains \{structure=info cvar}
		formattext textname = helptext "%s = (%v)" s = (<info>.name) v = (<info>.cvar) // wtf, old syntax moment
	else
		formattext textname = helptext "%n" n = <name>
		params = (<info>.params)
		GetArraySize <params>
		if (<array_size> > 0)
			i = 0
			begin
				param = (<params>[<i>])
				if StructureContains \{structure=param name}
					if NOT (<param>.name = #"0x00000000")
						formattext textname = helptext "%s %p =" s = <helptext> p = (<param>.name)
					endif
				endif
				formattext textname = helptext "%s <%p>" s = <helptext> p = (<param>.#"0x00000000")
				Increment \{i}
			repeat <array_size>
		endif
	endif
	printf "%h" h = <helptext>
	printf " - %s" s = (<info>.#"0x00000000")
endscript
script echo
	if GotParam \{#"0x00000000"}
		printf "%a" a = <#"0x00000000">
	endif
endscript
// doskey freaking
aliases = []
script alias
	if not GotParam \{name}
		goto #" alias list"
	endif
	if not GotParam \{#"0xe37e78c5"}
		goto #" alias list"
	endif
	// no functions can suffice to remove or overwrite an existing item,
	// have fun leaking memory by creating an alias under the same name over and over, or something
	AddArrayElement array = ($aliases) element = { name = <name> command = <#"0xe37e78c5"> }
	change aliases = <array>
endscript
script #" alias list"
	printf 'Current alias commands:'
	array = ($aliases)
	GetArraySize \{array}
	if (<array_size> = 0)
		return
	endif
	i = 0
	begin
		printf '%s : %c' s = (<array>[<i>].name) c = (<array>[<i>].command)
		Increment \{i}
	repeat <array_size>
endscript

// console command like
script give \{player = 1}
	if NOT GotParam \{#"0x00000000"}
		help \{give}
		return
	endif
	if (<player> = 2)
		player_status = player2_status
	else
		player_status = player1_status
	endif
	switch <#"0x00000000">
		case health
			//begin
			//	IncreaseCrowd player_status=<player_status>
			//repeat 10
			Change StructureName = <player_status> current_health = ($<player_status>.current_health + 0.5)
			if ($<player_status>.current_health > 2.0)
				Change StructureName = <player_status> current_health = 2.0
			endif
			return
	endswitch
	if NOT ($game_mode = p2_battle)
		switch <#"0x00000000">
			case starpower
				increase_star_power amount = 50.0 player_status = <player_status>
				return
		endswitch
	else
		params = { player_status = <player_status> battle_text = 1 }
		switch <#"0x00000000">
			case starpower
				battlemode_ready { battle_gem = 8 <params> }
				return
			case lightning
				battlemode_ready { battle_gem = 0 <params> }
				return
			case difficulty
				battlemode_ready { battle_gem = 1 <params> }
				return
			case double
				battlemode_ready { battle_gem = 2 <params> }
				return
			case steal
				battlemode_ready { battle_gem = 3 <params> }
				return
			case lefty
				battlemode_ready { battle_gem = 4 <params> }
				return
			case string
				battlemode_ready { battle_gem = 5 <params> }
				return
			case whammy
				battlemode_ready { battle_gem = 6 <params> }
				return
			case deth
				battlemode_ready { battle_gem = 7 <params> }
				return
		endswitch
	endif
	printf 'unknown item: %i' i = <#"0x00000000">
endscript

script fps
	if NOT GotParam \{#"0x00000000"}
		help \{fps}
		return
	endif
	change fps_max = <#"0x00000000">
endscript

script sv_speed
	if NOT GotParam \{#"0x00000000"}
		help \{sv_speed}
		return
	endif
	if NOT ($toggle_console)
		change current_speedfactor = <#"0x00000000">
		update_slomo
	else
		change old_speed = <#"0x00000000">
	endif
endscript

/* NOT WORKING WITH 2 PLAYER

script sv_mode \{players = 0}
	if NOT GotParam \{#"0x00000000"}
		help \{sv_mode}
		return
	endif
	restore_start_key_binding
	switch <#"0x00000000">
		case 1
			#"0x00000000" = training
		//case 2 // CRASHING AGAIN
		//	#"0x00000000" = p2_coop
		case 3
			#"0x00000000" = p2_faceoff
		case 4
			#"0x00000000" = p2_pro_faceoff
		case p1_career
		case training
		//case p2_coop
		//case p2_career
		case p2_faceoff
		case p2_pro_faceoff
		case p1_quickplay
		case p2_battle
			EmptyScript
		case 0
		default
			#"0x00000000" = p1_quickplay
	endswitch
	printstruct <...>
	change game_mode = <#"0x00000000">
	got_players = 0
	if NOT (<players> < 1 & <players> > 2)
		got_players = 1
	endif
	if (<got_players> = 0)
		switch $game_mode
			//case p2_coop
			//case p2_career
			case p2_pro_faceoff
			case p2_faceoff
			case p2_battle
				players = 2
			case training
			case p1_quickplay
			case p1_career
			default
				players = 1
		endswitch
	endif
	change current_num_players = (<players> + 1)
	old_speed = ($old_speed)
	destroy_keyboard_input
	change old_speed = <old_speed>
	change \{toggle_console = 0}
	restart_song
endscript
*///

script xy \{x=0 y=0}
	return pair = (((1.0, 0.0) * <x>) + ((0.0, 1.0) * <y>))
endscript

script #"draw base" \{x=640 y=360 just=[center center] parent=root_window alpha=1 scale=1.0}
	if GotParam \{w}
		if GotParam \{h}
			xy x = <w> y = <h>
		endif
	endif
	if GotParam \{pair}
		dims = <pair>
		RemoveComponent \{pair}
	endif
	if GotParam \{x}
		if GotParam \{y}
			xy x = <x> y = <y>
		endif
	endif
	RemoveComponent \{x}
	RemoveComponent \{y}
	if NOT IsArray \{just}
		justt = <just>
		RemoveComponent \{just}
		just = [center center] // if just is only a qbkey, use it as the horizontal param
		SetArrayElement arrayname=just index=0 newvalue=<justt>
		RemoveComponent \{justt}
	endif
	CreateScreenElement {
		type = <type>
		font = <font>
		pos = <pair>
		just = <just>
		text = <text>
		id = <id>
		parent = <parent>
		dims = <dims>
		scale = <scale>
		alpha = <alpha>
		texture = <texture>
		material = <material>
		z_priority = <z>
		rot_angle = <angle>
	}
	printf 'The id for this text element is %s' s = <id>
endscript

script drawtext \{font=fontgrid_title_gh3 text='Hello, world!' id=mytext}
	#"draw base" type = textelement <...>
endscript

script drawsprite \{id=mysprite}
	if NOT GotParam \{texture}
		if NOT GotParam \{material}
			texture = sprite_missing
		endif
	endif
	#"draw base" type = spriteelement <...>
endscript

script killelement
	if ScreenElementExists id = <id>
		DestroyScreenElement <...>
	endif
	if ScreenElementExists id = <#"0x00000000">
		DestroyScreenElement id = <#"0x00000000"> <...>
	endif
endscript




// =======================================================
// console
// =======================================================


// fun todo: arrow keys to navigate in the current line, and command history

toggle_console = 0
might_hold_shift = 0
console_pause = 1
script create_keyboard_input
	//EnableInput OFF ($player1_status.controller)
	CreateScreenElement {
		parent = root_window
		id = console_text
		text = ""
		type = textblockelement // GAME CRASHES IF TEXT IS TOO LONG
		font = text_a1
		scale = 0.7
		rgba = [ 255 255 255 255 ]
		just = [ left bottom ]
		internal_just = [ left bottom ]
		pos = (72.0, 718.0)
		dims = (1200.0, 620.0)
		z_priority = 200
	}
	update_console_input
	if ($console_pause = 1)
		change old_speed = ($current_speedfactor)
		change current_speedfactor = 0.0
		update_slomo
	endif
	spawnscriptnow \{check_user_input}
	spawnscriptnow \{blink_cursor_loop}
endscript
script destroy_keyboard_input
	//EnableInput ($player1_status.controller)
	if ScreenElementExists \{id = console_text}
		DestroyScreenElement \{id = console_text}
	endif
	KillSpawnedScript \{name = check_user_input}
	KillSpawnedScript \{name = blink_cursor_loop}
	change \{console_input = ""}
	if ($console_pause = 1)
		change current_speedfactor = ($old_speed)
		update_slomo
		change old_speed = -1.0
	endif
endscript
//console_history = ""
script update_console_input
	if NOT ScreenElementExists id = console_text
		return
	endif
	if ($blink_cursor = 1)
		cursor = "_"
	else
		cursor = " "
	endif
	formattext textname = con ">%t%c" t = ($console_input) c = <cursor>
	SetScreenElementProps id = console_text text = <con>
endscript
script clear
	//change \{console_history = ""}
	//update_console_input
endscript
console_cursor = 0
blink_cursor = 0
script blink_cursor_loop
	begin
		update_console_input
		change blink_cursor = (1 - $blink_cursor)
		Wait \{0.1 seconds ignoreslomo}
	repeat
endscript
script check_user_input
	capslock = 0
	shift = 0
	begin
		WinPortSioGetControlPress \{deviceNum = 3}
		if NOT (<controlNum> = -1)
			if NOT ($last_key = <controlNum>)
				if ord <controlNum>
					if IsCapsLockOn
						capslock = 1
					else
						capslock = 0
					endif
					if ($might_hold_shift = 1)
						shift = 1
					else
						shift = 0
					endif
					shift = (<shift> - <capslock>)
					if (<shift> = 0)
						GetLowerCaseString <char>
						char = <lowercasestring>
						FormatText checksumname = id "%a" a = <char>
						if StructureContains structure=$key_chars_lower <id>
							char = ($key_chars_lower.<id>)
						endif
					endif
					change console_cursor = ($console_cursor + 1)
					change console_input = ($console_input + <char>)
					update_console_input
				else
					//if (<controlNum> = 219) // Back
					//	
					//endif
					if (<controlNum> = 229) // Delete
						trim ($console_input)
						change console_input = <trim>
					endif
					if (<controlNum> = 293) // Enter
						output_log_text "%h" h = ($console_input)
						//change console_history = ($console_history + "\n" + $console_input)
						spawnscriptnow eval params = { ($console_input) ignore_slomo = 1 accept_aliases = 1 warn_nonexistent = 1 }
						change \{console_input = ""}
					endif
					update_console_input
				endif
			endif
		endif
		wait \{1 gameframe}
	repeat
endscript
script ord // lol
	if (<#"0x00000000"> = -1)
		return \{false}
	endif
	formattext checksumname = id "%a" a = <#"0x00000000">
	if StructureContains structure=$key_chars <id>
		return true char = ($key_chars.<id>)
	endif
	return \{false}
endscript
script trim \{c = 1}
	StringToCharArray string = <#"0x00000000">
	getarraysize \{char_array}
	if (<array_size> > 1)
		AddParams \{ trim = "" i = 0 } // stupid
		begin
			trim = (<trim> + <char_array>[<i>])
			Increment \{i}
		repeat (<array_size> - <c>)
		return trim = <trim>
	elseif (<array_size> = 1)
		return \{trim = ""}
	endif
endscript
console_input = ""
key_chars_lower = {}
key_chars = {}
script decompress_chars // desperate
	change key_chars = {
		#"304" = "Q"
		#"331" = "W"
		#"232" = "E"
		#"305" = "R"
		#"322" = "T"
		#"341" = "Y"
		#"324" = "U"
		#"256" = "I"
		#"295" = "O"
		#"297" = "P"
		
		#"210" = "A"
		#"313" = "S"
		#"227" = "D"
		#"236" = "F"
		#"252" = "G"
		#"254" = "H"
		#"258" = "J"
		#"259" = "K"
		#"262" = "L"
		
		#"343" = "Z"
		#"340" = "X"
		#"221" = "C"
		#"328" = "V"
		#"218" = "B"
		#"277" = "N"
		#"269" = "M"
		
		#"201" = "!"
		#"202" = "@"
		#"203" = "#"
		#"204" = "$"
		#"205" = "%"
		#"206" = "^"
		#"207" = "&"
		#"208" = "*"
		#"209" = "("
		#"200" = ")"
		
		#"273" = "_"
		#"234" = "+"
		#"263" = "{"
		#"306" = "}"
		#"213" = "+"
		#"225" = ","
		#"299" = "."
		#"316" = "?"
		#"318" = " "
		#"345" = ";"
		#"214" = "\""
		#"220" = "\\"
	}
	change key_chars_lower = {
		#"0xF89D5196" = "'" // "
		#"0xD6295C17" = "-" // _
		#"0x8141E932" = "=" // +
		#"0xEA2AB8C6" = "[" // {
		#"0x03491DF3" = "]" // }
		#"0x6194002C" = "1" // !
		#"0x5B2151E2" = "2" // @
		#"0x8F9A6100" = "3" // #
		#"0x11FEF4A3" = "4" // $
		#"0x66F9C435" = "5" // %
		#"0xA12E6C81" = "6" // ^
		#"0xFFF0958F" = "7" // &
		#"0xF646D9A4" = "8" // *
		#"0x1848B888" = "9" // (
		#"0x6F4F881E" = "0" // )
	}
endscript




















script key_events
	begin
		//ProfilingStart
		//if ($toggle_console = 0)
		WinPortSioGetControlPress \{deviceNum = 3 actionNum = 0} //$player1_device // keyboard is always 3
		if NOT (<controlNum> = -1)
			if (<controlNum> = 323) // Tab
				// emulator moment
				if (($console_pause = 1 & $toggle_console = 0) | $console_pause = 0)
					if ($hold_tab = 0)
						change old_speed = ($current_speedfactor)
						change current_speedfactor = ($old_speed * $fastforward)
						update_slomo
						change \{hold_tab = 1}
					endif
				endif
			endif
			if (<controlNum> = 253) // ~
				if NOT ($last_key = <controlNum>)
					toggle = toggle_console
					change globalname = <toggle> newvalue = (1 - $<toggle>)
					if ($toggle_console)
						//printf 'opened console'
						create_keyboard_input
					else
						destroy_keyboard_input
					endif
				endif
			endif
			if (<controlNum> = 267 | <controlNum> = 311) // l/rshift
				if ($might_hold_shift = 0)
					change might_hold_shift = 1
				endif
			endif
		else
			if ($might_hold_shift = 1)
				change might_hold_shift = 0
			endif
		endif
		if NOT (<controlNum> = 323)
			if ($hold_tab = 1)
				change current_speedfactor = ($old_speed)
				update_slomo
				change \{hold_tab = 0}
			endif
		endif
		change last_key = <controlNum>
		//ProfilingEnd <...> 'test' loop ____profiling_interval = 800
		Wait \{1 gameframe}
	repeat
endscript
last_key = 0
old_speed = -1.0
hold_tab = 0
fastforward = 2.0




// =======================================================
// main
// =======================================================


/**///

evalverbose = 0

script eval \{'printf \'no command specified\''}
	printf "] %l" l = <#"0x00000000">
	if NOT evaltokenizer <#"0x00000000">
		printf \{'tokenizer did not return successfully'}
		return \{false}
	endif
	//printstruct <tokens>
	//Block
	//return
	array = [] // nodes
	getarraysize \{tokens}
	i = 0
	begin
		token = (<tokens>[<i>])
		switch (<token>.type)
			case bytecode
				switch (<token>.value)
					case 1 //newline
						if NOT evalparseline <tokens> token_count = <token_count> i = (<i> + 1)
							printf \{'line parser did not return successfully'}
							return \{false}
						endif
						//printstruct <node>
				endswitch
		endswitch
		AddArrayElement array = <array> element = <node>
		Increment \{i}
		if (<i> >= <token_count>)
			break
		endif
	repeat
	RemoveComponent \{tokens}
	
	script_locals = {}
	script_lastresult = #"  invalid  "
	// node values:
	// start_type, line_type, left_op, right_op
	getarraysize \{array}
	i = 0
	begin
		node = (<array>[<i>])
		//printstruct <node>
		switch (<node>.start_type)
			case name
				switch (<node>.line_type)
					case assign
						AddParam {
							structure_name = script_locals
							name = (<node>.left_op) value = (<node>.right_op)
						}
					case call
						evalrun {
							(<node>.left_op) params = (<node>.right_op)
							ignore_slomo = <ignore_slomo>
							accept_aliases = <accept_aliases>
							warn_nonexistent = <warn_nonexistent>
						}
						script_locals = { <script_locals> <returned> }
						script_lastresult = <returned>
				endswitch
			case result
				EmptyScript
		endswitch
		Increment \{i}
	repeat <array_size>
	//printstruct <script_locals>
	
	//if NOT (<script_lastresult> = #"  invalid  ")
	//	printstruct <script_locals>
	//endif
	//Block
	
	return {
		true
		locals = <script_locals>
		result = <script_lastresult>
	}
endscript

script evalrun
	// isolate parameters returned from scripts being called
	if (<warn_nonexistent> = 1)
		if SymbolIsCFunc <#"0x00000000">
		elseif ScriptExists <#"0x00000000">
		else
			printf "%w%s" w = 'Warning, cannot find the function to be called: ' s = <#"0x00000000">
		endif
	endif
	RemoveComponent \{warn_nonexistent}
	if NOT GotParam \{elevated}
		is_alias = 0
		if (<accept_aliases> = 1)
			array = ($aliases)
			GetArraySize \{array}
			if (<array_size> > 0)
				i = (<array_size> -1)
				begin
					alias = (<array>[<i>])
					FormatText checksumname = name "%a" a = (<alias>.name)
					if (<name> = <#"0x00000000">)
						alias = (<alias>.command)
						is_alias = 1
						break
					endif
					i = (<i> -1)
				repeat <array_size>
			endif
			if (<is_alias> = 1)
				eval <alias> ignore_slomo = <ignore_slomo> accept_aliases = <accept_aliases>
				return returned = <result>
			endif
		endif
		
		if NOT GotParam \{params}
			params = {}
		endif
		ExtendCrc <#"0x00000000"> '__' out = ffs
		if (<ignore_slomo> = 1 & <ffs> = Wait__)
			// wait by default factors in slomo multiplier, so ignore it for console
			params = { <params> ignoreslomo }
		endif
		RemoveComponent \{ffs}
		evalrun elevated #" args " = <params> #"  script to run  " = <#"0x00000000">
		return returned = <returned>
	else
		RemoveFlag \{elevated}
		if NOT ChecksumEquals a = <#"  script to run  "> b = #"printstruct" // WTFFFFFFFFF
			<#"  script to run  "> <#" args ">
		else
			printstruct <#" args ">
		endif
		RemoveComponent \{#"  script to run  "}
		RemoveComponent \{#" args "}
		return returned = <...>
	endif
endscript

script evalparseglobal
	//printstruct <...>
	if (<i> + 1 >= <token_count>)
		printf \{'parser prematurely ended when global pointer wasn\'t followed by a name!!!!!!'}
		return \{false}
	endif
	next_token = (<#"0x00000000">[(<i> + 1)])
	printtoken t = <next_token> i = <i>
	//printstruct <next_token>
	if NOT (<next_token>.type = name)
		printf \{'parser prematurely ended when global pointer wasn\'t followed by a name!!!!!!'}
		return \{false}
	endif
	//printstruct true value = (<next_token>.value) i = (<i> + 1)
	return true value = (<next_token>.value) i = (<i> + 1)
endscript

script evalparseexpr \{depth = 0 debug = $evalverbose}
	expression_value = 0
	operator = 0
	operation = 0
	mode = 0
	printf 'expression evaluating ('
	begin
		// don't know what the order of operations in qscript is
		// but i can somehow imagine if comparison isolates
		// the two values around it, somehow this random scenario came to mind
		// if without parentheses, this (4+5=5) could be executed as (4+(5=5))
		skip = 0
		token = (<#"0x00000000">[<i>])
		if (<token>.type = bytecode)
			operator = (<token>.value)
			if NOT (<operator> >= 7 & <operator> <= 15)
				if NOT (<operator> = 75)
					printf 'invalid or unimplemented bytecode in expression: %a <%b>, skipping' a = (<token>.literal) b = (<token>.value)
					skip = 1
				endif
			endif
		else
			operator = 0
		endif
		if (<skip> = 0)
			printtoken t = <token> i = <i> indent = (<depth> + 1) depth = <depth>
			switch (<mode>)
				// 0 - get lvalue (first)
				// 1 - get operator
				// 2 - get rvalue, apply operator (subsequent values)
				case 0
				case 2
					if (<token>.type = bytecode)
						switch (<token>.value)
							case 15
								if (<mode> = 0)
									printf \{'warning: empty expression'}
								endif
								break
							case 14 // (
								evalparseexpr <#"0x00000000"> token_count = <token_count> i = (<i> + 1) depth = (<depth> + 1)
								i = <t>
							case 75 // $
								evalparseglobal <#"0x00000000"> token_count = <token_count> i = <i>
								value = ($<value>)
								//printstruct <...>
							default
								printf 'invalid operator (mode 0): %a' a = (<token>.literal)
								return false
						endswitch
					else
						value = (<token>.value)
					endif
					if (<mode> = 0)
						expression_value = <value>
					else
						switch <operation>
							case 7
								expression_value = (<expression_value> = <value>)
							case 11
								expression_value = (<expression_value> + <value>)
							case 10
								expression_value = (<expression_value> - <value>)
							case 13
								expression_value = (<expression_value> * <value>)
							case 12
								expression_value = (<expression_value> / <value>)
							case 8
								// uhhhh, will need to put in another expression
								expression_value = (<expression_value>.<value>)
							default
							//case 9
								// uhhhhh
								printf 'oh no (%e)' e = <operation>
								return false
						endswitch
					endif
					printf 'current value = %a' a = <expression_value>
					mode = 1
				case 1
					switch <operator>
						case 7 // =(=)
						case 8 // .
						case 9 // ,
						case 11 // +
						case 10 // -
						case 13 // *
						case 12 // /
							operation = <operator>
						case 15
							break
						default
							printf 'invalid operator (mode 1): %a' a = (<operator>)
							return false
					endswitch
					mode = 2
			endswitch
		endif
		Increment \{i}
	repeat
	printf ')'
	//printstruct <...>
	return true value = <expression_value> t = (<i>)
endscript

script evalparsestruct \{depth = 0 debug = $evalverbose}
	AddParams \{struct = {} brackets = 0}
	token = (<#"0x00000000">[<i>])
	if (<debug>)
		printf 'struct assembling {'
	endif
	if (<token>.type = bytecode & <token>.value = 3)
		brackets = 1
		if (<debug>)
			printf 'got brackets'
		endif
		Increment \{i}
	endif
	;passthru = 0
	type = none
	begin
		skip = 0
		target = #"0x00000000"
		token = (<#"0x00000000">[<i>])
		printtoken t = <token> i = <i> indent = (<depth> + 1) depth = <depth>
		switch (<token>.type)
			case name
				//printf '%t' t = (<token>.value)
				next_token = (<#"0x00000000">[(<i> + 1)])
				// this feels like a tumor i'm writing
				if (<i> + 1 < <token_count> & <next_token>.type = bytecode & <next_token>.value = 7)
					if NOT (<i> + 2 < <token_count>)
						printf 'parser prematurely ended when variable assignment wasn\'t followed by a value!!!!!!'
						break
					endif
					next_token = (<#"0x00000000">[(<i> + 2)])
					//j = (<i> + 3)
					//pad <j> count = 3 pad = ' '
					//printf '%i: token: [%v] <%t>' i = <pad> t = (<next_token>.type) v = (<next_token>.value)
					switch (<next_token>.type)
						case bytecode
							switch (<next_token>.value)
								//case 14
								case 3
								//	type = struct
								//	target = (<token>.value)
								//	value = (<next_token>.value)
								//	i = (<i> + 3)
									evalparsestruct <#"0x00000000"> token_count = <token_count> i = (<i> + 2) depth = (<depth> + 1)
									i = <t>
									target = (<token>.value)
								case 75
									evalparseglobal <#"0x00000000"> token_count = <token_count> i = (<i> + 2)
									target = (<token>.value)
									value = ($<value>)
									i = (<i> + 4)
								case 14
									evalparseexpr <#"0x00000000"> token_count = <token_count> i = (<i> + 3)
									target = (<token>.value)
									i = <t>
									//printstruct <...>
								//case 5
								//	type = array
									//target = (<token>.value)
									//value = (<next_token>.value)
									//i = (<i> + 2)
								default
									printf 'invalid syntax for assignment!!!!!!!!!!!!!'
									break
							endswitch
						case string
						case int
						case float
						case name
						//	type = (<next_token>.type)
							//printstruct <token>
							target = (<token>.value)
							value = (<next_token>.value)
							if (<next_token>.type = string & <next_token>.wide = true)
								RemoveComponent \{value}
								AddParam_WStr name = <target> (<next_token>.value)
								struct = { <struct> <value> }
								skip = 1
							endif
							i = (<i> + 2)
					endswitch
				else
					value = (<token>.value)
				endif
			case string
			case int
			case float
				value = (<token>.value)
				//type = (<token>.type)
				if (<token>.type = string)
					if (<token>.wide = true)
						//printf '/!\ widestring gets ignored by AddParam!!!!! >:('
						AddParam_WStr name = #"0x00000000" (<token>.value)
						struct = { <struct> <value> }
						skip = 1
					endif
				endif
			case bytecode
				switch (<token>.value)
					case 3
						evalparsestruct <#"0x00000000"> token_count = <token_count> i = <i> depth = (<depth> + 1)
						i = <t>
					case 75
						evalparseglobal <#"0x00000000"> token_count = <token_count> i = <i>
						i = (<t> + 2)
						target = #"0x00000000"
						tmp = ($<value>)
						RemoveComponent \{value}
						value = <tmp>
					case 14
						evalparseexpr <#"0x00000000"> token_count = <token_count> i = <i>
						printstruct <...>
						target = #"0x00000000"
						i = <t>
				endswitch
				;if (<token>.value = 44)
				;	passthru = 1
				;endif
				if (<brackets> = 1)
					if (<token>.value = 4)
						break
					endif
					if (<token>.value = 1)
						skip = 1
					endif
				else
					if (<token>.value = 1)
						i = (<i> - 1)
						break
					endif
				endif
		endswitch
		//printf '%t = %v' t = (<token>.value) v = <value>
		if (<skip> = 0)
			AddParam structure_name = struct name = <target> value = <value>
		endif
		Increment \{i}
		if (<i> >= <token_count>)
			if (<brackets> = 1)
				printf 'warning: unclosed brackets'
			endif
			break
		endif
	repeat
	if (<debug>)
		printf '}'
	endif
	//if (<depth> = 0)
		//printstruct <struct>
	//endif
	return value = <struct> t = <i>
endscript

script evalparseline \{debug = $evalverbose}
	//line_type = call
	//line_type = assign
	start_type = none
	t = <i> // current token (continued from other functions)
	i = 0 // current bytecode/item of tokenized line
	// only needed to check first two ops
	// for assignment or function call for now
	begin
		token = (<#"0x00000000">[<t>])
		//pad <t> count = 3 pad = ' '
		//printf '>%i: token: [%v] <%t>' i = <pad> t = (<token>.type) v = (<token>.value)
		printtoken t = <token> i = <i> debug = <debug>
		//printf 'token: %v <%t>' t = (<token>.type) v = (<token>.value)
		//printstruct (<token>.value)
		//printf '%a' a = (<token>.type)
		switch (<token>.type)
			case name
				if (<i> < 3)
					switch <i>
						case 0
							start_type = name
						case 1
							// there needs to be a better way to handle this and be less redundant
							line_type = call
						case 2
							right_op = (<token>.value)
					endswitch
				endif
			case int
			case float
			case string
				switch <i>
					case 0
						start_type = result
					case 1
						line_type = call
					case 2
						right_op = (<token>.value)
				endswitch
			case bytecode
				op = (<token>.value)
				switch <op>
					case 7
						//if (<i> < 2)
							/*if (<i> = 0)
							endif*///
							if (<i> = 1)
								line_type = assign
							else
								printf 'invalid syntax!!!!!!!! (%i)' i = <i>
								return false
							endif
						//endif
					case 14
					case 3
					case 5
					case 75
						switch <op>
							case 14
								evalparseexpr <#"0x00000000"> token_count = <token_count> i = (<i> + 2)
								i = <t>
								right_op = <value>
							case 3
								//evalparsestruct
							case 5
								//evalparsearray
						endswitch
						if (<i> < 3)
							switch <i>
								case 0
									start_type = result
									left_op = <value>
								case 1
									line_type = call
								case 2
									line_type = assign
							endswitch
						endif
					case 1
						if (<i> = 1)
							line_type = call
						endif
						break
					default
						//if IndexOf (<token>.value) array = ($eval_syntax2bytecodes)
						//	literal = ($evaltokens_syntax[<indexof>])
						//else
						//	literal = 'unknown'
						//endif
						printf {
							'unknown bytecode %a!!!!!!!! literal: \'%b\''
							a = <op> b = (<token>.literal)
						}
						return false
				endswitch
			default
				printf {
					'unknown token type %a!!!!!!!! value: \'%b\''
					a = (<token>.type) b = (<token>.value)
				}
		endswitch
		if (<i> = 0)
			left_op = (<token>.value)
		endif
		if ((<line_type> = call | <line_type> = assign) & <i> < 3)
			evalparsestruct <#"0x00000000"> token_count = <token_count> i = (<t>) debug = <debug>
			right_op = <value>
			//printstruct <value>
		endif
		//printstruct (<#"0x00000000">[<t>])
		Increment \{t}
		Increment \{i}
		if (<t> >= <token_count>)
			if (<i> = 1)
				line_type = call
			endif
			break
		endif
	repeat
	if (<debug>)
		printf 'eol'
	endif
	return {
		true
		node = {
			start_type = <start_type>
			line_type = <line_type>
			left_op = <left_op>
			right_op = <right_op>
		}
		i = (<t> - 1) // :/
	}
endscript

script evaltokenizer \{debug = $evalverbose}
	array = [ // tokens
		{
			type = bytecode
			value = 1
		}
	]
	parser_pos = 0
	current_token = ""
	FormatText textname = #"0x00000000" "%a" a = <#"0x00000000">
	StringRemoveTrailingWhitespace \{param = #"0x00000000"}
	// ensure wstring because i imagine expressions won't work when comparing cstring and wstring, or even concat
	StringToCharArray string = <#"0x00000000">
	getarraysize \{char_array}
	parser_text = <char_array>
	parser_size = <array_size>
	RemoveComponent \{char_array}
	RemoveComponent \{array_size}
	RemoveComponent \{#"0x00000000"}
	
	token_count = 1
	matched = none
	new_token = 0
	eof = 0
	literal = ""
	
	WStr = { delegate = LocalizedStringEquals }
	
	ProfilingStart
	// region tokenizer
	// parser_pos = 0
	begin
		begin
			if (<parser_pos> >= <parser_size>)
				eof = 1
				break
			endif
			
			current_char = (<parser_text>[<parser_pos>])
			
			if ArrayContains contains = <current_char> array = ($evaltokens_whitespace)
				if (<new_token> = 1)
					new_token = 0
					break
				endif
				Increment \{parser_pos}
			else
				if (<new_token> = 0)
					new_token = 1
				endif
				break
			endif
		repeat
		
		if (<new_token> = 1)
			if NOT LocalizedStringEquals a = <current_token> b = ""
				printf <current_token>
				current_token = ""
			endif
		endif
		
		if (<eof> = 1)
			break
		endif
		
		matched = none
		// region check what kind of item the current character is
		begin // *
			//if (<matched> = none)
				if LocalizedStringEquals a = <current_char> b = "'"
					matched = string
					string_type = c
					break
				endif
				if LocalizedStringEquals a = <current_char> b = "\""
					matched = string
					string_type = w
					break
				endif
			//endif
			//if (<matched> = none)
				StringToCharArray \{string = $evaltokens_alphabet}
				if ArrayContains contains = <current_char> array = <char_array>
					matched = name
					break
				endif
			//endif
			// comment
			//if (<matched> = none)
				if LocalizedStringEquals a = <current_char> b = "/"
					if (<parser_pos> < <parser_size>)
						Increment \{parser_pos}
						if LocalizedStringEquals a = (<parser_text>[<parser_pos>]) b = "/"
							Increment \{parser_pos}
							begin
								current_char = (<parser_text>[<parser_pos>])
								if (<current_char> = "\\")
									if (<parser_pos> < <parser_size>)
										if (<parser_text>[(<parser_pos>+1)] = "n")
											matched = none
											break
										endif
									endif
								endif
								if (<parser_pos> >= <parser_size>)
									matched = none
									break
								endif
								Increment \{parser_pos}
							repeat
							break
						endif
					endif
				endif
			//endif
			//if (<matched> = none)
				if (<current_char> = "\\")
					Increment \{parser_pos}
					current_char = (<parser_text>[<parser_pos>])
					if (<current_char> = "n")
						matched = bytecode
						value = 1
						//Increment \{parser_pos}
						break
					endif
				endif
//				test2 = 'b
//a'
//				printstruct <...>
//				if LocalizedStringEquals a = <current_char> b = "
//"
//					printf 'a'
//					matched = bytecode
//					value = 1
//					break
//				endif
			//endif
			//if (<matched> = none)
				StringToCharArray string = ($evaltokens_digits + "-")
				// feels repetitive to have this condition over and over
				// array of token arrays? (trollface)
				if ArrayContains contains = <current_char> array = <char_array>
					//printf <current_char>
					matched = digits
					break
				endif
			//endif
			//if (<matched> = none)
				StringToCharArray string = ($evaltokens_syntax_nosep)
				if IndexOf <WStr> <current_char> array = <char_array>
					matched = bytecode
					value = ($eval_syntax2bytecodes[<indexof>])
					literal = <current_char>
				else
					if ArrayContains contains = <current_char> array = ($evaltokens_syntax)
						matched = bytecode
						//value = ($eval_syntax2bytecodes[<indexof>])
						break
					endif
				endif
			//endif
			;if (<matched> = none)
			;	StringToCharArray \{string = $evaltokens_syntax}
			;	if WStringIsInArray <current_char> array = <char_array>
			;		matched = syntax
			;		break
			;	endif
			;endif
		repeat 1 // *HACK!!1/!/1///!/!/!/1!!!///!
		RemoveComponent \{char_array}
		// endregion
		// region parse the rest of the text until no more characters match the type of text to parse
		switch <matched>
			case name
				name = <current_char>
				Increment \{parser_pos}
				StringToCharArray string = ($evaltokens_alphabet + $evaltokens_digits)
				finish = 0
				begin
					current_char = (<parser_text>[<parser_pos>])
					if (<parser_pos> >= <parser_size>)
						finish = 1
					endif
					if NOT ArrayContains contains = <current_char> array = <char_array>
						finish = 1
					endif
					if (<finish> = 0)
						name = (<name> + <current_char>)
						Increment \{parser_pos}
					endif
					if (<finish> = 1)
						literal = <name>
						ExtendCrc #"0xFFFFFFFF" <name> out = value
						RemoveComponent \{name}
						break
					endif
				repeat // |:|
				RemoveComponent \{char_array}
			case string
				last_char = (<parser_text>[<parser_pos>])
				Increment \{parser_pos}
				if (<string_type> = c)
					delim = "'"
					wide = false
				elseif (<string_type> = w)
					delim = "\""
					wide = true
				endif
				string = ""
				finish = 0
				begin
					current_char = (<parser_text>[<parser_pos>])
					if (<current_char> = <delim>)
						if NOT (<last_char> = "\\")
							finish = 1
						else
							trim <string>
							string = <trim>
							RemoveComponent \{trim}
						endif
					endif
					if (<finish> = 0)
						string = (<string> + <current_char>)
						last_char = (<parser_text>[<parser_pos>])
						Increment \{parser_pos}
					endif
					if (<parser_pos> >= <parser_size>)
						finish = 1
					endif
					if (<finish> = 1)
						literal = (<delim> + <string> + <delim>)
						if (<string_type> = c)
							formattext textname = value '%a' a = <string>
						else
							value = <string>
						endif
						RemoveComponent \{delim}
						RemoveComponent \{last_char}
						RemoveComponent \{string_type}
						RemoveComponent \{string}
						break
					endif
				repeat
				Increment \{parser_pos}
			case bytecode
				if NOT GotParam \{value}
					syntax = ""
					begin
						syntax = (<syntax> + <current_char>)
						Increment \{parser_pos}
						if (<parser_pos> >= <parser_size>)
							break
						endif
						current_char = (<parser_text>[<parser_pos>])
						if NOT ArrayContains contains = <current_char> array = ($evaltokens_syntax)
							break
						endif
					repeat
					literal = <syntax>
					if IndexOf <WStr> <syntax> array = ($evaltokens_syntax)
						value = ($eval_syntax2bytecodes[<indexof>])
					else
						//value = 0
						printf {
							'tokenizer error!!!! @ %a / %b | invalid syntax: "%c"'
							a = <parser_pos> b = <parser_size> c = <syntax>
						}
						return false
					endif
					RemoveComponent \{syntax}
				else
					Increment \{parser_pos}
				endif
			case digits
				// don't exceed 1 for either
				dashes = 0
				dots = 0
				digits = 0
				number = 0
				decimals = 0
				matched = int
				StringToCharArray string = ("-." + $evaltokens_digits)
				literal = ""
				begin
					current_char = (<parser_text>[<parser_pos>])
					if ArrayContains contains = <current_char> array = <char_array>
						literal = (<literal> + <current_char>)
						switch <current_char>
							case "-"
								Increment \{dashes}
							case "."
								Increment \{dots}
								number = (<number> * 1.0)
								matched = float
							default
								StringToInteger \{current_char}
								if (<dots> = 0)
									number = ((<number> * 10) + <current_char>)
									Increment \{digits}
								else
									Increment \{decimals}
									MathPow 10 exp = <decimals>
									number = (<number> + (<current_char> / <pow>))
								endif
						endswitch
						if (<dots> > 1 || <dashes> > 1)
							printf {
								'tokenizer error!!!! @ %a / %b | too many dots or dashes in parsed number: "%e" dashes: %c, dots: %d'
								a = <parser_pos> b = <parser_size> c = <dashes> d = <dots> e = <number>
							}
							return false
						endif
					else
						break
					endif
					Increment \{parser_pos}
					if (<parser_pos> >= <parser_size>)
						break
					endif
				repeat
				value = <number>
				if (<dashes> = 1)
					value = (<value> * -1)
				endif
				RemoveComponent \{dashes}
				RemoveComponent \{dots}
				RemoveComponent \{digits}
				RemoveComponent \{decimals}
				//RemoveComponent \{char_array}
				RemoveComponent \{current_char}
				RemoveComponent \{current_char}
			case none
				EmptyScript
			default
				printf 'unknown token!!!!!!! symbol: %a' a = <current_char>
		endswitch
		// endregion
		// save token
		if NOT ChecksumEquals a = <matched> b = none
			AddArrayElement {
				array = <array>
				element = {
					type = <matched>
					value = <value>
					wide = <wide>
					literal = <literal>
				}
			}
			RemoveComponent \{wide}
			RemoveComponent \{literal}
			//printf '%d %e' d = <parser_pos> e = <token_count>
			Increment \{token_count}
		endif
		RemoveComponent \{value}
	repeat <parser_size>
	// endregion
	ProfilingEnd <...> 'evaltokenizer'
	RemoveComponent \{parser_pos} // useless but whatever
	RemoveComponent \{parser_size}
	RemoveComponent \{matched}
	RemoveComponent \{new_token}
	RemoveComponent \{eof}
	//if (<debug>)
	//	printstruct <...>
	//endif
	return true tokens = <array> token_count = <token_count>
endscript

evaltokens_whitespace = [ ]
evaltokens_alphabet = ""
evaltokens_digits = ""
evaltokens_syntax = [ ]
evaltokens_syntax_nosep = ""
eval_syntax2bytecodes = [ ]
evaltokens_keywords = [ ]
eval_kw2bytecodes = [ ]

script decompress_eval
	change evaltokens_whitespace = [ " " "	" "\n" ]
	formattext textname = text "%s" s = 'ABCDEFGHIJKLMNOPRQSTUWXYZabcdefghijklmnopqrstuvwxyz_'
	change evaltokens_alphabet = <text>
	formattext textname = text "%s" s = '0123456789'
	change evaltokens_digits = <text>
	change evaltokens_syntax = [ "=" ":" "." "," "(" ")" "{" "}" "[" "]" "+" "-" "*" "/" "$" "!=" "!" "&" "|" "<" "<=" ">" ">=" "<...>" ]
	change evaltokens_syntax_nosep = "=:.,(){}[]+-*/$"
	// should be named in a way that indicates these are each one character
	// because later part of tokenizer continuously adds up characters
	// until the next char doesn't match the type like whitespace, and
	// that doesn't need to happen for above chars
	change eval_syntax2bytecodes = [ 7 66 8 9 14 15 3 4 5 6 11 10 13 12 75 77 57 58 59 18 19 20 21 44 ]
	change evaltokens_keywords = [ "if" "else" "elseif" "endif" "return" "switch" "endswitch" "case" "default" "begin" "repeat" "not" "break" /*"script" "endscript"*/ ]
	change eval_kw2bytecodes = [ 37 38 39 40 41 60 61 62 63 32 33 57 34 /*35 36*/ ]
endscript

script indent \{1}
	if (<#"0x00000000"> = 0)
		return indent = ''
	endif
	indent = ''
	begin
		indent = (<indent> + '    ')
	repeat <#"0x00000000">
	//RemoveComponent \{#"0x00000000"}
	return indent = <indent>
endscript

script printtoken \{indent = 0 debug = $evalverbose}
	if NOT (<debug>)
		return
	endif
	//if (<t>.type = bytecode)
		//if (<t>.value > 1)
		//	if IndexOf (<t>.value) array = ($eval_syntax2bytecodes)
		//		literal = ($evaltokens_syntax[<indexof>])
		//	else
		//		literal = 'unknown'
		//	endif
		//else
		//	literal = 'newline'
		//endif
		//type = 'bytecode' // display properly because it's not a debug name // now it is ;)
	//else
		//literal = (<t>.value)
		//type = (<t>.type)
	//endif
	pad <i> count = (3) pad = ' '
	indent <indent>
	printf '%n>%i: %v <%t>' n = <indent> i = <pad> t = (<t>.type) v = (<t>.literal)
endscript

// :(
script AddParam_WStr
	#"  name  " = <name>
	#"  value  " = <#"0x00000000">
	RemoveComponent \{name}
	RemoveComponent \{#"0x00000000"}
	if NOT (<#"  name  "> = #"0x00000000")
		FormatText textname = <#"  name  "> "%a" a = <#"  value  ">
	else
		FormatText textname = name "%a" a = <#"  value  ">
		#"0x00000000" = <name>
		RemoveComponent \{name}
	endif
	RemoveComponent \{#"  name  "}
	RemoveComponent \{#"  value  "}
	return value = { <...> }
endscript

script stupid
	// guessing game
	// you'll be stupid too
	switch <name>
		case #"0x00000000"
			EmptyScript
		case test2
			test2 = <#"0x00000000">
		case value
			value = <#"0x00000000">
		case pos
			pos = <#"0x00000000">
		case dims
			dims = <#"0x00000000">
		case scale
			scale = <#"0x00000000">
		case pair
			pair = <#"0x00000000">
		case vector
			vector = <#"0x00000000">
		case name
			name = <#"0x00000000">
			overwrite_name = 1
		default
			printf \{'unknown name for my stupid hack in struct string parsing'}
			printf <name>
	endswitch
	if NOT (<overwrite_name> = 1)
		RemoveComponent \{name}
	else
		RemoveComponent \{overwrite_name}
	endif
	return value = {<...>}
endscript













