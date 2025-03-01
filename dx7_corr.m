function [r2_max] = dx7_corr(parameters)
global m_sample;
global x_simulation;
global algorithm;
global y_simulation;
global r2_max_index;
global r_max;
oscillators              = round(parameters(1:6));
levels                   = round(parameters(7:12));
y_simulation             = dx7_simulator(x_simulation, algorithm, oscillators, levels);
v_corr_sample_simulation = corr(m_sample, y_simulation);
[r2_max, r2_max_index]   = max(v_corr_sample_simulation.^2,[], 1);
r2_max                   = -r2_max;
r_max                    = v_corr_sample_simulation(r2_max_index);

end
