%input alt (ft) output [density(slugs/ft3), pressure(lb/ft2), temp(F), dynamic viscocity(slugs/fts)]
function [temp, pressure, density, viscocity] = atmosphere(h)
    density = get_density(h);
    temp = get_temp(h);
    pressure = get_pressure(h);
    viscocity = get_viscocity(h);
end