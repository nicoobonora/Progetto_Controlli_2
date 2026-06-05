function drawBode(G)
    figure;
    h_bode1 = bodeplot(G);
    ax1 = getaxes(h_bode1);
    axes(ax1);
    hold on;
    patch([0.001, 0.5, 0.5, 0.001], [-150, -150, 32.2, 32.2], 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'red');
    patch([1000, 100000, 100000, 1000], [-40, -40, 100, 100], 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'red');
    ax2 = getaxes(h_bode1);
    axes(ax2);
    hold on;
    patch([0.5, 1000, 1000, 0.5], [-270, -270, -110, -110], 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'red');
end