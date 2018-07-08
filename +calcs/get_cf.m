function Cf = get_cf(gamma, expansion_ratio, Pe_Pc, Pc, Pa)
% Ideal thrust coefficient
% Pe_Pc, pressure ratio, exit over chamber
% Pc, combustion chamber pressure
% Pa, ambient pressure
Cf = sqrt(2*gamma^2/(gamma-1)*(2/(gamma+1))^((gamma+1)/(gamma-1))*...
    (1-Pe_Pc^((gamma-1)/gamma)))+ expansion_ratio*(Pe_Pc-Pa/Pc);
end