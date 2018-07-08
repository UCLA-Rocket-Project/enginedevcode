% returns pressure(lbm/ft2) given alt(ft)
function pressure = get_pressure(altitude)
    temp = get_temp(altitude);
    if(altitude < 36152)
        pressure = 2116 * (((temp + 459.7) / 518.6) ^ 5.256);
    elseif(altitude < 82345)
        pressure = 473.1 * (exp(1) ^ (1.73 - (0.000048 * altitude)));
    else
        pressure = (51.97 * (((temp + 459.7) / 389.98) ^ -11.388));
    end
end

function temp = get_temp(altitude)
    if(altitude < 36152)
        temp = 59 - (0.00356 * altitude);
    elseif(altitude < 82345)
        temp = -70;
    else
        temp = (0.00164 * altitude) - 205.05;
    end
end