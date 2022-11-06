function apply_friction(_obj, _amount)
{
	// First check to see if we're moving
	if (_obj.xspeed != 0)
	{
		if (abs(_obj.xspeed) - _amount > 0)
		{
			_obj.xspeed -= _amount * image_xscale;
		}
		else
		{
			_obj.xspeed = 0;
		}
	}
}


function move_actor(_obj, _collision_obj)
{
	// Horizontal Collisions
	if (place_meeting(_obj.x + _obj.xspeed, _obj.y, _collision_obj))
	{
		while (!place_meeting(_obj.x + sign(_obj.xspeed), _obj.y, _collision_obj))
		{
			x += sign(_obj.xspeed);
		}
		_obj.xspeed = 0;
	}
	_obj.x += _obj.xspeed;
	
	// Vertical Collisions
	if (place_meeting(_obj.x, _obj.y + _obj.yspeed, _collision_obj))
	{
		while (!place_meeting(_obj.x, _obj.y + sign(_obj.yspeed), _collision_obj))
		{
			y += sign(_obj.yspeed);
		}
		_obj.yspeed = 0;
	}
	_obj.y += _obj.yspeed;
}

function take_damage(_obj)
{
	if (_obj.state != player.hurt)
	{
		_obj.state = player.hurt;
		audio_play_sound(a_ouch, 8, false);
	
		_obj.image_blend = make_color_rgb(220, 150, 150);
	
		_obj.yspeed = -6;
		_obj.xspeed = (sign(_obj.x - other.x) * 8);
	
		move_actor(_obj, o_solid);
	
		if (instance_exists(o_player_stat))
		{
			o_player_stat.hp -= 1;
		}
	}
	else
	{
		exit;
	}	
}

function direction_move_bounce(_obj, _collision_obj)
{
	// Horizontal Collisions
	if (place_meeting(_obj.x + _obj.xspeed, _obj.y, _collision_obj))
	{
		while (!place_meeting(_obj.x + sign(_obj.xspeed), _obj.y, _collision_obj))
		{
			x += sign(_obj.xspeed);
		}
		_obj.xspeed = -(_obj.xspeed / 4);
	}
	_obj.x += _obj.xspeed;
	
	// Vertical Collisions
	if (place_meeting(_obj.x, _obj.y + _obj.yspeed, _collision_obj))
	{
		while (!place_meeting(_obj.x, _obj.y + sign(_obj.yspeed), _collision_obj))
		{
			y += sign(_obj.yspeed);
		}
		_obj.yspeed = -(_obj.yspeed / 4);
		if (abs(_obj.yspeed) < 2)
		{
			_obj.yspeed = 0;
		}
	}
	_obj.y += _obj.yspeed;
}













