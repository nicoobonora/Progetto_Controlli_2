function [R,Kp,Ti] = progettaPI(G,wc_star,Mf_star)
    s = tf('s');
    Ge = G/s;
    [mag,ph] = bode(Ge,wc_star);
    mag = squeeze(mag);
    ph = squeeze(ph);
    phi_star = -180 + Mf_star - ph;
    rho = tan(phi_star*pi/180);
    tau_z = rho / wc_star;
    A_dB = 20*log10(sqrt(1+rho^2));
    mu = 10^((-20*log10(mag) - A_dB)/20);
    Kp = mu * tau_z;
    Ti = tau_z;
    R = mu * (1 + tau_z*s) / s;
end