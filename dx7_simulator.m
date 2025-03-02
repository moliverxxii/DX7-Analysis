function y = dx7_simulator(x, algorithm, oscillators, levels)
mod_none = 0;
mod_mod1 = 1;
mod_mod2 = 2;
mod_y    = 3;

out_y       = 0;
out_mod1    = 1;
out_mod1_p  = 2;
out_mod2    = 3;

n_x = length(x);
y          = zeros(n_x, 1);
mod1       = zeros(n_x, 1);
mod2       = zeros(n_x, 1);
x_operator = zeros(n_x, 1);
y_operator = zeros(n_x, 1);
m_operator = zeros(n_x, 1);
n_operator = length(oscillators);
n_output = 0;
for operator = algorithm(end:-1:1)'
	operator;
	x_operator = x;
	switch(operator.modulation)
	case mod_none
	case mod_mod1
		m_operator = mod1;
	case mod_mod2
		m_operator = mod2;
	case mod_y
end
	y_operator = fm_sin(x_operator, m_operator, oscillators(n_operator));

	switch(operator.output)
	case out_y
		n_output++;
		y += dx7_level_to_gain(levels(n_operator)) * y_operator;
	case out_mod1
		mod1 = dx7_level_to_gain(levels(n_operator), true) * y_operator;
	case out_mod1_p
		mod1 += dx7_level_to_gain(levels(n_operator), true) * y_operator;
	case out_mod2
		mod2 = dx7_level_to_gain(levels(n_operator), true) * y_operator;
	end
	n_operator--;
end
n_output;
y /= n_output;
end
