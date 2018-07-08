function minor_dp = get_minor_dp(loss_coef, density, velocity)
            minor_dp = 0.00694*loss_coef*0.5*density/32.174*velocity^2;
end