function display_hour(time_s)
time_u    = time_s;
n_seconds = floor(rem(time_u, 60));
time_u    = floor(time_u/60);
n_minutes = floor(rem(time_u, 60));
time_u    = floor(time_u/60);
n_hours   = time_u;
printf("time remaining: %4d:%02d:%02d\n", n_hours, n_minutes, n_seconds)
end
