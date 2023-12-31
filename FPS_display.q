
script mod_startup
	AddParams \{element = 0.0 time_since_refresh = 0.0 size = 1000 array = [] i = 0}
	FGH3Config \{sect='GFX' 'VSync' #"0x1ca1ff20"=0}
	if NOT ($fps_max = 0 || <value> = 1)
		array_size = ($fps_max * 2)
	else
		array_size = 500
	endif
	begin
		AddArrayElement <...>
	repeat <array_size>
	
	Wait \{1 gameframe}
	// doesnt work with RB theme, oops :|
	// and i dont know/forgot if there is another monospace digit font
	CreateScreenElement \{ Type = TextElement parent = root_window font = #"0xc0becb74" id = fps_text text = 'FPS:' Pos = (90.0,25.0) font_spacing = 5 just = [left top] rgba = [255 255 255 255] Scale = 0.75 alpha = 1 z_priority = 1000 }
	Wait \{1 gameframe}
	// wtf
	// phantom text element
	SetScreenElementProps \{id = fps_text pos = (170.0,25.0) text = ''}
	rate = (1.0/90.0)
	begin
		GetDeltaTime \{ignore_slomo}
		time_since_refresh = (<time_since_refresh> + <delta_time>)
		SetArrayElement arrayname=array index=<i> newvalue=<delta_time>
		Increment \{i}
		mod a=<i> b=<array_size>
		i = <mod>
		if (<time_since_refresh> >= <rate>)
			// avg <array> {
				sum = 0.0
				j = 0
				begin
					sum = (<sum> + (<array>[<j>] * 1.0))
					Increment \{j}
				repeat <array_size>
				avg = (<sum> / <array_size>)
			// }
			test2 = (1/<avg>)
			CastToInteger \{test2}
			if NOT (<last_fps> = <test2>)
				last_fps = (1/<avg>)
				rgba = [ 255 255 255 255 ]
				CastToInteger \{last_fps}
				FormatText textname = text '%d' d = <last_fps>
				if NOT ($fps_max = 0 || <value> = 1)
					fractional = (<last_fps> / ($fps_max * 1.0))
					if (<fractional> >= 0.5 && <fractional> < 0.9)
						g = (64 + (<fractional> * 191))
						b = ((<fractional> - 0.5) * 510)
						CastToInteger \{g}
						CastToInteger \{b}
						SetArrayElement arrayname=rgba index=1 newvalue=<g>
						SetArrayElement arrayname=rgba index=2 newvalue=<b>
					elseif (<fractional> < 0.5)
						rgba = [ 255 127 0 255 ]
						g = (<fractional> * 255)
						CastToInteger \{g}
						SetArrayElement arrayname=rgba index=1 newvalue=<g>
					endif
					FormatText textname = text '%d / %f' d = <last_fps> f = $fps_max
				endif
				SetScreenElementProps id = fps_text text = <text> rgba = <rgba>
			endif
			time_since_refresh = 0.0
		endif
		Wait \{1 gameframe}
	repeat
endscript
mod_info = {
	name = 'FPS Display'
	author = 'donnaken15'
}
