/// @description create some blood
repeat (irandom_range(4, 7))
{
	var _random_x = irandom_range(-4, 4);
	var _random_y = irandom_range(-4, 4);
	var _particle = instance_create_layer(x + _random_x, y + _random_y, "Enemies", o_particle);
	_particle.image_blend = c_red;
	_particle.image_speed = 5;
}