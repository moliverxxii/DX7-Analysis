function display_hour(time_s)
time_u  = time_s;
seconds = floor(rem(time_u, 60));
time_u  = floor(time_u/60);
minutes = floor(rem(time_u, 60));
time_u  = floor(time_u/60);
hours   = time_u;
printf("time remaining: %4d:%02d:%02d\n", hours, minutes, seconds)
end
