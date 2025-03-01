function level_db = dx7_level_to_db(n_level, b_modulator = false)
level_db = 20*log10(dx7_level_to_gain(n_level, b_modulator));
end

