function [alpha, tau] = lagCompensatorWithFormulas(Mf_star, Ge, wc_star)
    % Rete ritardatrice:
    % Rr(s) = (1 + alpha*tau*s)/(1 + tau*s)
    % con 0 < alpha < 1

    Gjwc_star = evalfr(Ge, 1i*wc_star);

    starting_magnitude = abs(Gjwc_star);
    starting_phase = rad2deg(angle(Gjwc_star));

    if starting_phase > 0
        starting_phase = starting_phase - 360;
    end

    M = 1/starting_magnitude;

    phi_deg = -180 + Mf_star - starting_phase;
    phi = deg2rad(phi_deg);

    if M < cos(phi)
        error("Non si può")
    end
    tau_z = (M - cos(phi))/(wc_star*sin(phi));
    tau_p = (cos(phi) - 1/M)/(wc_star*sin(phi));

    if tau_z <= 0 || tau_p <= 0 || tau_z >= tau_p
        error("Progetto ritardatrice non realizzabile con questi valori.");
    end

    tau = tau_p;
    alpha = tau_z/tau_p;
end