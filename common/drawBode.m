function drawBode(G)
    figure;
    margin(G);
    
    ax = findall(gcf, 'Type', 'axes');
    
    pos1 = get(ax(1), 'Position');
    pos2 = get(ax(2), 'Position');
    if pos1(2) > pos2(2)
        ax_mod = ax(1);
        ax_fase = ax(2);
    else
        ax_mod = ax(2);
        ax_fase = ax(1);
    end
    
    set(ax, 'XLim', [0.001, 10000]);
    set(ax_fase, 'YLim', [-270, 0]);
    
    axes(ax_mod);
    hold on;
    patch([0.001, 0.5, 0.5, 0.001], [-150, -150, 19, 19], 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'red', 'PickableParts', 'none');
    patch([1000, 100000, 100000, 1000], [-40, -40, 100, 100], 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'red', 'PickableParts', 'none');
    
    axes(ax_fase);
    hold on;
    patch([0.5, 1000, 1000, 0.5], [-270, -270, -110, -110], 'red', 'FaceAlpha', 0.3, 'EdgeColor', 'red', 'PickableParts', 'none');
end