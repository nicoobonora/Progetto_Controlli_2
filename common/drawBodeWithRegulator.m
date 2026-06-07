function drawBode(varargin)

    % Frequenze di plot
    w_min = 1e-3;      % non si può usare 0 in scala log
    w_max = 1e4;
    w = logspace(log10(w_min), log10(w_max), 3000);

    % Specifica su R
    w_spec = 0.5;
    R_spec_dB = 40.7;

    figure;

    % =====================
    % MODULO
    % =====================
    ax_mod = subplot(2,1,1);
    hold on;
    grid on;

    % Rettangolo arancione: zona vietata per R
    % cioè |R(jw)| < 40.7 dB per w <= 0.5 rad/s
    y_bottom = -150;
    y_top = R_spec_dB;

    patch( ...
        [w_min, w_spec, w_spec, w_min], ...
        [y_bottom, y_bottom, y_top, y_top], ...
        [1, 0.5, 0], ...
        'FaceAlpha', 0.3, ...
        'EdgeColor', [1, 0.5, 0], ...
        'PickableParts', 'none', ...
        'HandleVisibility', 'off');

    % Linea della specifica
    yline(R_spec_dB, '--', '40.7 dB', ...
        'HandleVisibility', 'off');

    xline(w_spec, '--', '\omega = 0.5 rad/s', ...
        'HandleVisibility', 'off');

    % Plot dei moduli dei sistemi passati alla funzione
    for k = 1:nargin
        [mag, ~] = bode(varargin{k}, w);
        mag = squeeze(mag);
        mag_dB = 20*log10(mag);
        semilogx(w, mag_dB, 'LineWidth', 1.4);
    end

    xlim([w_min, w_max]);
    ylim([y_bottom, 120]);
    ylabel('Magnitude [dB]');
    title('Bode Diagram');
    set(gca, 'XScale', 'log');

    % =====================
    % FASE
    % =====================
    ax_fase = subplot(2,1,2);
    hold on;
    grid on;

    for k = 1:nargin
        [~, phase] = bode(varargin{k}, w);
        phase = squeeze(phase);
        semilogx(w, phase, 'LineWidth', 1.4);
    end

    xlim([w_min, w_max]);
    ylim([-270, 90]);
    xlabel('Frequency [rad/s]');
    ylabel('Phase [deg]');
    set(gca, 'XScale', 'log');

    % Link assi x
    linkaxes([ax_mod, ax_fase], 'x');

    % Legenda
    legend(ax_mod, 'G_v', 'R', 'Location', 'best');
    legend(ax_fase, 'G_v', 'R', 'Location', 'best');

end