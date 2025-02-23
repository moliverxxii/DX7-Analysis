function gain = dx_level_to_gain(n_level, b_modulator = false)
MODULATOR_OFFSET = 30;
gain = (n_level != 0) * 2.^((n_level - 99 + (b_modulator != false)*MODULATOR_OFFSET)/8);
end
