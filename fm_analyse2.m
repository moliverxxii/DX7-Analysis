n_harmonics = 10
n_ratio = 31;

n_signal = 2^10;

arr_t = (0:n_signal-1)'/n_signal;

OFFSET = 30

r_level = 3:1:99
r_a_fm = 10.^(dx_level_to_db(r_level+OFFSET)/20);
result2 = zeros(1+n_harmonics, length(r_a_fm), n_ratio, n_ratio);
for ratio_c = (1:n_ratio)
	for ratio_m = (1:n_ratio)
		n = 1;
		for a_level = r_a_fm
			result2(:,n, ratio_c, ratio_m)... 
				= analyse_period(fm_sin(2*pi*arr_t,...
				                        ratio_c, ...
							ratio_m, ...
							a_level)...
					        )(1:n_harmonics+1);
			n++;
		end
	result3 = 20*log10(result2(:,:,ratio_c, ratio_m));
	%disp("");
	disp([ratio_c, ratio_m])
	%disp([(0:n_harmonics)' ,[r_level; round(result3)]])
	end
end


path = 'vox';
l_files = dir(fullfile(path, '*.wav'));
files = {l_files.name};

n = 1
figure(1)
for a = files()
	subplot(3,3,n)
	n++;
	file_path = fullfile(path, a{1})
	a_sample= audioread(file_path)(:,1);
	20 * log10(std(a_sample))
	harmonica = analyse_period(a_sample)(1:20:end)(1:n_harmonics+1);
	file_results = zeros(4,n_ratio^2);
	
	for n_c = (1:n_ratio)
		for n_m = (1:n_ratio)
			correlatore = corr(harmonica,result2(:,:,n_c, n_m));
			[m, m_position] = max(correlatore,[], 2);
			file_results(: , n_ratio*(n_c-1) + n_m) = [n_c;n_m; [r_level; correlatore](:,m_position)];
		end
	end
	%disp(file_results)
	[m, m_position] = max(file_results(4,:), [], 2);
	disp(file_results(:,m_position));
	plot(round(20*log10(harmonica)),'+')
	axis([1,n_harmonics, -40, 10])
	grid
	title(a{1})
end
