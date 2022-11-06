/// @description Move to next level
var _up = keyboard_check(vk_up);
if (_up and other.visible == true)
{
	y = yprevious;
	state = player.door;
	if (!audio_is_playing(a_exit)) {	
		audio_play_sound(a_exit, 3, false, 2.4);
		audio_stop_sound(a_jump);
	}
	if (room == r_boss)
	{
		game_restart();
	}
}