import calcs.*
% propellant properties
g = 32.174;
ox_rho = 72.2;
fuel_rho = 50.8;
mixture_ratio = 2.58;
gamma = 1.21; % unsure about accuracy

% engine properties
Pc = 300; % chamber pressure, psia
expansion_ratio = 4.2;
% see 'flowisentropic' documentation on matlab page
[~, ~, Pe_Pc, ~, ~] = flowisentropic2(gamma, expansion_ratio, 'sup');

perfectly_expanded_altitude = 5000; % ft
% Pa = get_pressure(perfectly_expanded_altitude);
Pa = 14.7;
Cf = 0.85*get_cf(gamma, expansion_ratio, Pe_Pc, Pc, Pa);
Cstar = 0.90*get_cstar(

Wox = mixture_ratio/(mixture_ratio+1)*W;
Wfu = Wox/mixture_ratio;


pipe_roughness = 6.56E-6; % ft, aluminum
velocity = 10;

viscosity = 0.0001;

%Ox side CdAs
ox_line_diameter = 1/2;
ox_line_area = pi/4*ox_line_diameter^2;
ox_vel = Wox / (ox_rho*ox_line_area);
ox_Re = get_reynolds(ox_visc, ox_line_diameter, ox_rho, ox_vel);
ox_f = colebrook(ox_Re, pipe_roughness, ox_line_diameter);
CdA_MPVO = get_minor_dp(K_MPVO,ox_rho,ox_vel);
dp_POTO_MPV = get_pipe_dp(ox_f, POTO_MPV_length, ox_line_diameter, ox_rho, ox_vel);
CdA_POTO_MPV = get_cda(dp_POTO_MPV, ox_rho, Wox);

%fuel side CdAs
fuel_line_diameter = 1/2;

CdA_MPVF = 0.230;
% CdA_MPVF = getCdA(MPVF_Pos)
