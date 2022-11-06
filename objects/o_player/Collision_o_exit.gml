/// @description Move to next level
var _up = keyboard_check(vk_up);
if (_up and other.visible == true)
{
	y = yprevious;
	state = player.door;
	if (!audio_is_playing(a_exit)) {	
		audio_play_sound(a_exit, 4, false);
		audio_stop_sound(a_jump);
	}
	if (room == r_boss)
	{
		game_restart();
	}
}