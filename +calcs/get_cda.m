function cda = get_cda(pipe_dp, density, mdot)
% mdot = CdA/12*sqrt(2*32.2*density*pipe_dp)
cda = 12*mdot/sqrt(2*32.174*density*pipe_dp);
end