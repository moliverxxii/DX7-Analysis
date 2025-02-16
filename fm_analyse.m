n_harmonics = 10

figure(1)

r_level = 3:4:99
result = zeros(length(r_level),n_harmonics);
n = 1
for n_level = r_level
	a_signal = audioread(["samples/", num2str(n_level), ".wav"])(:,1);
	result(n,:) = analyse_period(a_signal)(2:n_harmonics+1)';
	n++;
end
result1 = 20*log10(result);
[r_level', round(result1)]
plot(r_level,result1,'+');
grid
axis([0,100, -60, 10])
hold

n_signal = 2^10;

arr_t = (0:n_signal-1)'/n_signal;

OFFSET = 30

r_level = 3:4:99
r_a_fm = 10.^(dx_level_to_db(r_level+OFFSET)/20);
n = 1
result2 = zeros(length(r_a_fm),n_harmonics);
for a_level = r_a_fm
	result2(n,:) = analyse_period(fm_sin(2*pi*arr_t, 1, a_level))(2:n_harmonics+1)';
	n++;
end
result3 = 20*log10(result2);
[r_level', round(result3)]
plot(r_level,result3);
hold off
round(1000*corr(result,result2))


path = 'vox';
l_files = dir(fullfile(path, '*.wav'));
files = {l_files.name};

n = 1;
figure(2)
n_harmo = 30;
for a = files
	subplot(3,3,n)
	n++;
	file_path = fullfile(path, a{1})
	a_sample= audioread(file_path)(:,1);
	20 * log10(std(a_sample))
	plot(round(20*log10(analyse_period(a_sample)))(1:20*n_harmo),'+')
	axis([1,20*n_harmo, -40, 10])
	grid
	title(a{1})
end
