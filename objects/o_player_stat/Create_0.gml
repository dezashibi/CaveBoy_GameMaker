display_set_gui_size(camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]));

// play title music
audio_play_sound(a_title, 20, false);

// Mouse Cursor
window_set_cursor(cr_none);

// Randomize it up
randomize();