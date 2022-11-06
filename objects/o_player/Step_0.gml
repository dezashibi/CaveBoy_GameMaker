/// @description controlling the player's state

#region SETUP CONTROLS FOR THE PLAYER

var _right = keyboard_check(vk_right);
var _left = keyboard_check(vk_left);
var _up = keyboard_check(vk_up);
var _down = keyboard_check(vk_down);

// how long does it jump
var _up_release = keyboard_check_released(vk_up);

#endregion

#region STATE MACHINE
switch (state)
{
	#region MOVE STATE
	case player.moving:
	
		if (xspeed == 0)
		{
			sprite_index = s_player_idle;	
		}
		else
		{
			sprite_index = s_player_walk;
		}
	
		// check if player is on the ground
		if (!place_meeting(x, y + 1, o_solid))
		{
			yspeed += gravity_acceleration;
		
			// player is in the air
			sprite_index = s_player_jump;
			image_index = (yspeed > 0);
		
			// control the jump height
			if (_up_release and yspeed < -6)
			{
				yspeed = -3;
			}
		}
		else
		{
			yspeed = 0;
		
			// jumping code
			if (_up)
			{
				yspeed = jump_height;
				audio_play_sound(a_jump, 5, false);
			}
		}
	
		// change direction of scprite
		if (xspeed != 0)
		{
			image_xscale = sign(xspeed);
		}
	
		// check for moving left or right
		if (_right or _left)
		{
			xspeed += (_right - _left) * acceleration;
			xspeed = clamp(xspeed, -max_speed, max_speed); // limit the changes of the xspeed value
		}
		else
		{
			apply_friction(self, acceleration);
		}
	
		if (place_meeting(x, y + yspeed + 1, o_solid) and yspeed > 0)
		{
			audio_play_sound(a_step, 6, false);
		}
	
		move_actor(self, o_solid);
	
		// check for ledge grab
		var _falling = (y - yprevious) > 0;
		var _wasnt_wall = !position_meeting(x + grab_width * image_xscale, yprevious, o_solid);
		var _is_wall = position_meeting(x + grab_width * image_xscale, y, o_solid);
	
		if (_falling and _wasnt_wall and _is_wall)
		{
			xspeed = 0;
			yspeed = 0;
		
			// Move against the ledge
			while (!place_meeting(x + image_xscale, y, o_solid))
			{
				x += image_xscale;
			}
		
			// check vertical position
			while (position_meeting(x + grab_width * image_xscale, y - 1, o_solid))
			{
				y -= 1;
			}
		
			// change sprite and state
			sprite_index = s_player_ledge_grab;
			state = player.ledge_grab;
		
			audio_play_sound(a_step, 6, false);
		}
	
		break;
	#endregion
	
	#region LEDGE GRAB STATE
	case player.ledge_grab:
	
		if (_down)
		{
			state = player.moving;
		}
	
		if (_up)
		{
			state = player.moving;
			yspeed = jump_height;
		}
	
		break;
	#endregion
	
	#region DOOR STATE
	case player.door:
	
		sprite_index = s_player_exit;
	
		// fade out
		if (image_alpha > 0)
		{
			image_alpha -= 0.05;
		}
		else
		{
			room_goto_next();
		}
	
		break;
	#endregion
	
	#region HURT STATE
	case player.hurt:
	
		sprite_index = s_player_hurt;
		
		// change direction as we bounce back when we are hurt
		if (xspeed != 0)
		{
			image_xscale = sign(xspeed);
		}
		
		if (!place_meeting(x, y + 1, o_solid))
		{
			yspeed += gravity_acceleration;
		}
		else
		{
			yspeed = 0;
			apply_friction(self, acceleration);
		}
		
		direction_move_bounce(self, o_solid);
		
		// check the health
		if (o_player_stat.hp <= 0)
		{
			state = player.death;
		}
		
		// Change back to the other states
		if (xspeed = 0 and yspeed = 0)
		{
			// check the health
			if (o_player_stat.hp > 0)
			{
				image_blend = c_white;
				state = player.moving;
			}
		}
	
		break;
	#endregion
	
	#region DEATH STATE
	case player.death:
	
		with (o_player_stat)
		{
			hp = max_hp;
			sapphires = 0;
		}
		
		room_restart();
	
		break;
	#endregion
}
#endregion