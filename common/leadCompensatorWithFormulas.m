function [alpha, tau, Ra, info] = leadCompensatorWithFormulas(Mf_star, Ge, wc_star)
    % Rete anticipatrice:
    % Ra(s) = (1 + tau*s)/(1 + alpha*tau*s)
    % con 0 < alpha < 1

    s = tf('s');

    % Valutazione del sistema esteso alla pulsazione desiderata
    Gjwc_star = evalfr(Ge, 1i*wc_star);

    starting_magnitude = abs(Gjwc_star);
    starting_magnitude_db = mag2db(starting_magnitude);

    starting_phase = rad2deg(angle(Gjwc_star));

    % Correzione semplice del wrapping della fase
    % Se MATLAB dà +160°, spesso nel Bode corrisponde a -200°
    if starting_phase > 0
        starting_phase = starting_phase - 360;
    end

    % Modulo che deve avere la rete alla wc desiderata
    M = 1/starting_magnitude;

    % Fase che deve aggiungere la rete
    phi_deg = -180 + Mf_star - starting_phase;
    phi = deg2rad(phi_deg);

    % Salvo info utili
    info.starting_magnitude = starting_magnitude;
    info.starting_magnitude_db = starting_magnitude_db;
    info.starting_phase_deg = starting_phase;
    info.M = M;
    info.phi_deg = phi_deg;

    % Controlli di fattibilità
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

    % Rete anticipatrice
    Ra = (1 + tau*s)/(1 + alpha*tau*s);

    % Info aggiuntive
    info.tau_z = tau_z;
    info.tau_p = tau_p;
    info.alpha = alpha;
    info.tau = tau;
    info.zero = -1/tau;
    info.pole = -1/(alpha*tau);

    fprintf("\n--- Rete anticipatrice ---\n");
    fprintf("Modulo iniziale a wc*: %.2f dB\n", starting_magnitude_db);
    fprintf("Fase iniziale a wc*: %.2f deg\n", starting_phase);
    fprintf("M richiesto: %.4f (%.2f dB)\n", M, mag2db(M));
    fprintf("Fase richiesta: %.2f deg\n", phi_deg);
    fprintf("alpha = %.4f\n", alpha);
    fprintf("tau = %.4f\n", tau);
    fprintf("zero = %.4f rad/s\n", -info.zero);
    fprintf("polo = %.4f rad/s\n", -info.pole);
end