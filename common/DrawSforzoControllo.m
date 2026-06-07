function drawSforzoControllo(G, R)
    Q = feedback(R, G);
    figure;
    bode(Q);
end