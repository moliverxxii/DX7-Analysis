pkg load optim
clear
%algorithm definition
mod_none = 0;
mod_mod1 = 1;
mod_mod2 = 2;
mod_y    = 3;

out_y       = 0;
out_mod1    = 1;
out_mod1_p  = 2;
out_mod2    = 3;

c_modulations = ...
{
mod_mod1;
mod_mod1;
mod_none;
mod_mod1;
mod_none;
mod_none
};

c_outputs = ...
{
out_y;
out_mod1;
out_mod1;
out_y;
out_mod1_p;
out_mod1;
};

global algorithm = struct("modulation", c_modulations, ...
                          "output",     c_outputs)
%file opening 
s_path = 'vox';
l_files = dir(fullfile(s_path, '*.wav'));
files = {l_files.name};

n_rep                 = 20;
s_file_path           = fullfile(s_path, files{3})
[a_sample, f_sample]  = audioread(s_file_path);
n_sample = size(a_sample)(1);
f_signal = n_rep*f_sample/n_sample
a_sample = a_sample(1:round(n_sample/n_rep), 1);
n_sample = size(a_sample)(1);

%dx7_algorithm;
t_total             = 1/f_signal;
t_n                 = (0:n_sample-1)'/n_sample;
t_r                 = t_n/f_signal;
global x_simulation = 2 * pi * t_n;
global m_sample     = rotated_matrix(a_sample);

%parameters
n_ratio_max = 31;
n_ratio_min = 1;
n_level_max = 99;
n_level_min = 0;
n_trial     = 100000;
n_use       = 6;


best_result.r2 = 0;
global oscillators    = zeros(6,1);
global levels         = zeros(6,1);

%time estimation init
t_now      = time;
t_start    = t_now;
t_elapsed  = t_now - t_start;
r2_array   = [];
figure(1)

%statistics init
stat_step = 1/20;
stat_classes = 0:stat_step:1;
statistics = zeros(1,length(stat_classes));

%graphs init
pl1 = subplot(131);
gr1 = plot(pl1, 0, [0, 0]);
axis(pl1, [0,1/f_signal, -1, 1])
grid(pl1, 'on')
title(pl1, disp(best_result))
xlabel(pl1, "t (s)")
pl2 = subplot(132);
gr2 = plot(pl2, 0, 0,'-+');
xlabel(pl2, "t (s)")
grid(pl2, 'on')

pl3 = subplot(133);
gr3 = semilogy(pl3, stat_classes, statistics, '-');
axis(pl3, [-0.1, 1.1, 1.0e-7, 1])
grid(pl3, 'on')
set(pl3, 'xtick', 0:0.1:1)
global y_simulation;
global r2_max_index;
global r_max;
for n_ = (1:n_trial)
	t_now = time;
	t_elapsed = t_now - t_start;
	t_remaining = floor((n_trial - n_) * t_elapsed/n_);
	oscillators(7-n_use:6) = randi(n_ratio_max, n_use, 1);
	levels(7-n_use:6)      = [randi(n_level_max, n_use, 1)];
	nonlin_min_settings.ubound = [n_ratio_max*ones(6,1); n_level_max*ones(6,1)];
	nonlin_min_settings.lbound = [ones(6,1); zeros(6,1)];
	nonlin_min_settings.fract_prec = ones(12,1);
	nonlin_min_settings.max_fract_change = ones(12,1);
	nonlin_min_settings.MaxIter = 10;
	nonlin_min_settings.Algorithm = 'samin';

	[params, r2_max, cvg, ret] = nonlin_min(@dx7_corr, [oscillators; levels], nonlin_min_settings);
	cvg
	ret.niter
	r2_max = -r2_max;
        %[r2_max, corr_sample_simulation_best, r2_max_index, y_simulation] = dx7_corr([oscillators; levels]);
	corr_sample_simulation_best = r_max;
        stat_index = ceil(r2_max/stat_step);
        statistics(stat_index)++;
        
	if(r2_max > best_result.r2)
		%changing the result
		best_result.r2        = r2_max;
		best_result.operators = params(1:6)';
		best_result.levels    = params(7:12)';
		disp(best_result)

		%calculating the projection
		correction = std(m_sample(:,r2_max_index))/(std(y_simulation)*corr_sample_simulation_best);
		display_y =  correction*circshift(y_simulation, -r2_max_index);
		%updating the simulation/sample curve
		set(gr1(1), 'xdata', t_r', 'ydata', display_y)
		set(gr1(2), 'xdata', t_r', 'ydata', a_sample)
		title(pl1, disp(best_result))

		sound(dx7_level_to_gain(70)*[repmat(display_y/max(abs(display_y),[],1),100,1); repmat(a_sample,100,1)], f_sample);

		%updating the r^2 curve
		r2_array = [r2_array; t_elapsed, best_result.r2];
		set(gr2, 'xdata', r2_array(:,1), 'ydata', r2_array(:,2))
		title(pl2,["r^2 = ", num2str(r2_array(end,2))])



	end
	if(rem(n_,400) == 399)
		axis(pl2, [0, t_elapsed, 0, 1])
		display_hour(t_remaining);
		set(gr3, 'xdata', [stat_classes(1:end-1); stat_classes(2:end)](:), 'ydata', [statistics;statistics](:)/n_)
		drawnow;
	end

end

disp(best_result)
