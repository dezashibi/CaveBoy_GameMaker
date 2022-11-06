// check if we're above them
var _above_enemy = y < other.y + yspeed;
var _falling = yspeed > 0;

if (_above_enemy and (_falling or state == player.ledge_grab) and state == player.moving)
{	
	// keep player above the enemy
	if (!place_meeting(x, yprevious, o_solid)) y = yprevious;
	
	// get as close to the enemy as possible
	while (!place_meeting(x, y + 1, other))
	{
		y++;
	}
	
	with (other)
	{
		instance_destroy();
	}
	
	// bounce off the enemy
	yspeed = -(16 / 3);
	audio_play_sound(a_step, 6, false);
}
else
{
	take_damage(self);
}