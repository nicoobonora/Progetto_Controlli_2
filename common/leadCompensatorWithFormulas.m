function [alpha, tau] = leadCompensatorWithFormulas(Mf_star,Ge,wc_star)
    
    % Step 1
    Gjwc_star = evalfr(Ge, j*wc_star)
    starting_magnitude = abs(Gjwc_star)
    starting_magnitude_db = mag2db(starting_magnitude)
    starting_phase = angle(Gjwc_star)*180/pi

    % Step 2
    M = 10^(-starting_magnitude_db/20)
    fi = deg2rad(-180 + Mf_star - starting_phase)

    % Step 3 e Step 4
    if cos(fi) <= 1/M
        fprintf("Impossible: cos(fi): %d, 1/M: %d \n", cos(fi), 1/M)
    else
        tau = (M - cos(fi))/(wc_star*sin(fi))
        alpha = (cos(fi) - 1/M)/(wc_star*sin(fi))
    end

end
