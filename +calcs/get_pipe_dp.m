function dp = get_pipe_dp(friction_coef, pipe_length, ...
    diameter, density, velocity)
% friction loss coefficient, a function of the reynolds number and
% of cooling passage conditions such as surface smoothness,
% geometric shape
% pipe_length, in
% diameter, in.
% density, lb/ft3
% velocity, ft/s
dp = friction_coef*pipe_length/diameter*density*12^2*velocity^2/(2*32.174*12*12^3);
end