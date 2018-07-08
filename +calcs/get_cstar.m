function cstar = get_cstar(gamma, molecular_weight, Tc)
%GET_CSTAR Get ideal characteristic exhaust velocity, ft/s
%   gamma, specific heat ratio, dimmensionless
%   molecular weight of combustion products
%   Tc, chamber total temperature, Kelvin

g = 32.2;
Tc = Tc*1.8; % convert to Rankine
R = 1544*molecular_weight; % gas constant ft/Rankine
c1 = 2/(gamma+1);
c2 = (gamma+1)/(gamma-1);
cstar = sqrt(g*gamma*Tc)/(gamma*sqrt(c1^c2));

end

