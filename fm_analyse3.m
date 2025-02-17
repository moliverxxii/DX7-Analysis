n_harmonics = 10;
n_ratio     = 31;
n_rep       = 20;
OFFSET      = 30;

r_level = 3:4:99;
r_a_fm  = 10.^(dx_level_to_db(r_level+OFFSET)/20);
n_level = length(r_level);


path = 'vox';
l_files = dir(fullfile(path, '*.wav'));
files = {l_files.name};

for a = files()
	n = 1
	file_path             = fullfile(path, a{1})
	[a_sample, f_sample]  = audioread(file_path);
	n_sample = size(a_sample)(1);
	a_sample = a_sample(1:round(2*n_sample/n_rep), 1);
	n_sample = size(a_sample)(1);

	20 * log10(std(a_sample));

	m_sample = rotated_matrix(a_sample);
	arr_t    = 2*(0:n_sample-1)'/n_sample;
	file_results = zeros(4, n_level * n_ratio^2);
	%analyse par fréquences	
	for n_c = (1:n_ratio)
		for n_m = (1:n_ratio)
			%analyse par niveau de modulation
			n_current = 1;
			for a_level = r_a_fm
				operator = fm_sin(2*pi*arr_t, n_c, n_m, a_level);
				correlatore = corr(m_sample, operator);
				[m, m_position] = max(correlatore.^2,[], 1);
				file_results(:,n) = [n_c; n_m; r_level(n_current); correlatore(m_position)^2];
				n++;
				n_current++;
			end
		end
	end
	[max_r2, n_max] = max(file_results(4,:), [], 2)
	disp(file_results(:,n_max))
end
