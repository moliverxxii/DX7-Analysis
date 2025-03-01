function v_harmonics = analyse_period(v_signal)

v_harmonics = 2*abs(fft(v_signal)/size(v_signal)(1));
end
