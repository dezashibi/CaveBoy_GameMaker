/// @description Execute the state

switch (state)
{
	#region Idle State
	case boss.idle:
		var _dis = point_distance(x, y, o_player.x, o_player.y);
		if (_dis <= sight)
		{
			state = boss.lift;
		}
		break;
	#endregion
	
	#region Lift State
	case boss.lift:
		image_index = 1;
		yspeed = -3.5;
		move_actor(self, o_solid);
		if (place_meeting(x, y - 64, o_solid))
		{
			yspeed = 0;
			state = boss.chase;
		}
		break;
	#endregion
		
	#region Chase State
	case boss.chase:
		// only checking if we're above the player (just x distance)
		var _dis = point_distance(x, y, o_player.x, y);
		if (_dis < (sprite_width / 2 - 16) or place_meeting(x - 1, y, o_solid) or place_meeting(x + 1, y, o_solid))
		{
			state = boss.smash;
			audio_play_sound(a_jump, 6, false);
			xspeed = 0;
		}
		else
		{
			xspeed = (o_player.x - x) * 0.015;
		}
		move_actor(self, o_solid);
		break;
	#endregion
	
	#region Smash State
	case boss.smash:
		if (!place_meeting(x, y + 1, o_solid))
		{
			if (yspeed < 16)
			{
				yspeed += 0.5;
			}
			move_actor(self, o_solid);
		}
		else
		{
			state = boss.stall;
			alarm[0] = room_speed;
			audio_play_sound(a_step, 8, false);
			if (place_meeting(x, y, o_lava))
			{
				hp -= 1;
				audio_play_sound(a_snake, 9, false);
			}
		}
		break;
	#endregion
	
	#region Stall State
	case boss.stall:
		image_index = 0;
		if (alarm[0] == -1)
		{
			state = boss.lift;
		}
		break;
	#endregion
}

// Draw the boss as red
if (place_meeting(x, y, o_lava))
{
	image_blend = c_red;
}
else
{
	image_blend = c_white;
}

// Kill the boss
if (hp <= 0)
{
	repeat (50)
	{
		var _particle = instance_create_layer(bbox_left + random(sprite_width - 24), bbox_top + random(sprite_height), "Lava", o_particle);
		_particle.image_blend = c_red;
	}
	instance_destroy();
}