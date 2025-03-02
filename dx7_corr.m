function [r2_max] = dx7_corr(parameters)
%parameters
global m_sample;
global x_simulation;
global algorithm;
global y_simulation;
global r2_max_index;
global r_max;
oscillators              = round(parameters(1:6));
levels                   = round(parameters(7:12));
min_osc = min(oscillators(:),[],1);
max_osc = max(oscillators(:),[],1);
min_lev = min(levels(:),     [],1);
max_lev = max(levels(:),     [],1);

if((min_osc <  0) ||...
   (max_osc > 31) ||...
   (min_lev <  0) ||...
   (max_lev > 99))
	y_simulation = zeros(length(x_simulation));
	r2_max = 0;
	r_max = 0;
else
	y_simulation             = dx7_simulator(x_simulation, algorithm, oscillators, levels);
	v_corr_sample_simulation = corr(m_sample, y_simulation);
	[r2_max, r2_max_index]   = max(v_corr_sample_simulation.^2,[], 1);
	r2_max                   = -r2_max;
	r_max                    = v_corr_sample_simulation(r2_max_index);
end

end
