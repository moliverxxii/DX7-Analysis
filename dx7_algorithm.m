mod_none = 0;
mod_mod1 = 1;
mod_mod2 = 2;
mod_y    = 3;

out_y       = 0;
out_mod1    = 1;
out_mod1_p  = 2;
out_mod2    = 3;

modulations = ...
{
mod_mod1;
mod_none;
mod_mod1;
mod_mod1;
mod_none;
mod_none
};

outputs = ...
{
out_y;
out_mod1;
out_y;
out_mod1;
out_mod1_p;
out_mod1;
};

algorithm = struct("modulation", modulations, ...
                   "output",     outputs)

