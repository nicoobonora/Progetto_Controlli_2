function [alpha, tau, Ra] = leadCompensatorWithFormulas(Mf_star, Ge, wc_star)

    s = tf('s');

    Gjwc_star = evalfr(Ge, 1i*wc_star);

    starting_magnitude = abs(Gjwc_star);
    starting_magnitude_db = mag2db(starting_magnitude);

    starting_phase = rad2deg(angle(Gjwc_star));

    if starting_phase > 0
        starting_phase = starting_phase - 360;
    end

    M = 1/starting_magnitude;

    phi_deg = -180 + Mf_star - starting_phase;
    phi = deg2rad(phi_deg);

    info.starting_magnitude = starting_magnitude;
    info.starting_magnitude_db = starting_magnitude_db;
    info.starting_phase_deg = starting_phase;
    info.M = M;
    info.phi_deg = phi_deg;

    if phi_deg <= 0
        error("La fase richiesta è <= 0°. Non serve una rete anticipatrice.");
    end

    if phi_deg >= 90
        error("La fase richiesta è >= 90°. Una singola anticipatrice non è adatta.");
    end

    if M <= 1
        error("M <= 1. Alla wc scelta servirebbe attenuare, non amplificare: non è scenario da anticipatrice pura.");
    end

    if cos(phi) <= 1/M
        error("Progetto impossibile: cos(phi) <= 1/M. Cambia wc_star o Mf_star.");
    end

    % Formule di inversione
    tau_z = (M - cos(phi))/(wc_star*sin(phi));
    tau_p = (cos(phi) - 1/M)/(wc_star*sin(phi));

    % Conversione nella forma Ra = (1+tau*s)/(1+alpha*tau*s)
    tau = tau_z;
    alpha = tau_p/tau_z;

    if alpha <= 0 || alpha >= 1
        error("Alpha fuori intervallo: alpha = %.4f. Serve 0 < alpha < 1.", alpha);
    end

    Ra = (1 + tau*s)/(1 + alpha*tau*s);
end