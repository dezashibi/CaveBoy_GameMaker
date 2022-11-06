switch (state)
{
	case bat.idle:
		image_index = s_bat_idle;
		if (instance_exists(o_player))
		{
			var _dis = point_distance(x, y, o_player.x, o_player.y);
			if (_dis < sight)
			{
				state = bat.chase;
			}
		}
		break;
		
	case bat.chase:
		if (instance_exists(o_player))
		{
			var _dir = point_direction(x, y, o_player.x, o_player.y);
			xspeed = lengthdir_x(max_speed, _dir);
			yspeed = lengthdir_y(max_speed, _dir);
			sprite_index = s_bat_fly;
			if (xspeed != 0)
			{
				image_xscale = sign(xspeed);
			}
			
			move_actor(self, o_solid);
		}
		break;
}