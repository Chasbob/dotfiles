conky.config = {
    -- Run settings
    total_run_times = 0,
    update_interval = 1,

    -- Positioning
    alignment = 'bottom_left',
    gap_x = 50,
    gap_y = 125,
    minimum_width = 125,
    maximum_width = 125,
    minimum_height = 125,

    -- Draw settings
    double_buffer = true,
    draw_shades = false,
    draw_blended = false,

    -- Compositor settings
    own_window = true,
    own_window_argb_visual = true,
    own_window_argb_value = 0,
    own_window_transparent = true,
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    own_window_type = 'dock',
    own_window_class = 'conky-spot',					-- manually set the WM_CLASS name for use with xprop
    own_window_title = 'conky-spot',			-- set the name manually; default conky "hostname"
};

conky.text = [[
${if_running spotify}${exec ~/.config/conky/now-clocking/scripts/fetch-art spotify}
	${image ~/.config/conky/now-clocking/data/spotify.png -p 0,0 -s 125x125 -n}
${else}${if_match "" != "${exec playerctl -p vlc status}"}${exec ./scripts/fetch-art vlc}
	${image ~/.config/conky/now-clocking/data/vlc.png -p 0,0 -s 125x125 -n}
${else}${if_running cmus}${exec ./scripts/fetch-art cmus}
	${image ~/.config/conky/now-clocking/data/cmus.png -p 0,0 -s 125x125 -n}
${endif}
${endif}
${endif}
]];
