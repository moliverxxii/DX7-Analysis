function harmonics = analyse_period(a_signal)

harmonics = 2*abs(fft(a_signal)/size(a_signal)(1));
end
