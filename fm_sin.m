function a_signal = fm_sin(n, r_c, r_m, a)
a_signal = sin(r_c*n - a*sin(r_m*n));
end
