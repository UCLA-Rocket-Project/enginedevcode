function Re = get_reynolds(viscosity, diameter, density, velocity)
            % viscosity, lb/ ft s
            Re = density*velocity*(diameter/12)/viscosity;
end 