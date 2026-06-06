addpath('common');
clc;
clear;
close all;

% Variabili
l = 0.15; % l lunghezza SMA
d = 0.0002; % d diametro dello SMA
Cth = 25.1 * 10^(-3); % capacità termica SMA
beta = 0.08; % parametro di attrito volvente
Re = 4.8; % resistenza da scaldare
Rth = 16.7; % resistenza termica della cella
Tp = celsiusToKelvin(15); % temperatura cella
Tamb = celsiusToKelvin(24); % temperatura ambiente
Tdiff = 20; % Temperatura di differenza (???) (Essendo una differenza va lasciata in K)
S = pi*d*l; % superficie di interesse (cilindrica)
h = 6.55; % coefficiente di convenzione
Le = 0; % induttanza
Tavg = celsiusToKelvin(70); % temperatura media
dlmax = l/100 * 4; % dlmax
r1 = 0.0045; % raggio interno della puleggia
r2 = 0.045; % raggio interno della puleggia
J = 2 * 10^(-4); % momento di inerzia della puleggia
z_star = 0.04; % altezza desiderata (punto di linearizzazione)
m = 0.04; % massa del peso
g = 9.80665; % forza di gravità
K_star = (m*g*r2)/(r1*(dlmax-(r1/r2)*z_star)); % costante
c = 6.2; % altra costante dello SMA
K_max = 3.92 * 10^3; % costante massima
x2_eq = Tavg + (Tdiff/c)*(log(K_star/(K_max - K_star))); % temperatura per tenere il peso a 4cm
dK_dx2 = (c*K_max/Tdiff)*exp(c*(x2_eq - Tavg)/Tdiff)/(1 + exp(c*(x2_eq - Tavg)/Tdiff))^2; % altro parametro per la matrice
x1_eq = sqrt((1/Re)*(h*S*(x2_eq - Tamb)+(x2_eq-Tp)/Rth)); % Corrente equivalente 
K = K_max*(1-(1/(1+exp(c*((x2_eq-Tavg)/Tdiff)))));

% Matrici
a11 = -((h*S+(1/Rth))/Cth)
a31 = (r1/r2)*((dlmax-(r1/r2)*z_star)/(m+(J/r2^2))) * dK_dx2;
a32 = -((((r1)^2)*K)/(((r2)^2)*(m+(J/((r2)^2)))))
a33 = -(beta/(m+(J/((r2)^2))))


b11 = 2*x1_eq/Cth;
b12 = (h*S)/Cth;
b13 = 1/(Cth*Rth);

A = [a11, 0, 0; 0, 0, 1; a31, a32, a33]
B = [b11, b12, b13; 0, 0, 0; 0, 0, 0];
C = [0, 1, 0];
D = [0, 0, 0];

% Spazio degli stati
model = ss(A, B, C, D);

% FdT complessiva e "sotto-G"
figure(1);
Gc = tf(model);
Gv = Gc(1,1); % V -> z
Gtamb = Gc(1,2); % Tamb -> z
Gdtp = Gc(1,3) % Tdp -> z

% Plot dei vincoli
drawBode(Gv);

% Regolatore statico
% === Regolatore proposto ===
s = tf('s');
figure


% --- PRIMA SOLUZIONE ---

wn = 11.89;
zeta_n = 0.03;
zeta_d = 0.30;

% Notch
N = (s^2 + 2*zeta_n*wn*s + wn^2) * 1/(s+1000)

% Lead
z = 2.2;
p = 14.0;
Lead = (s + z) / (s + p);

% PI
Ki = 2500;
Rs = Ki / s;

rlocus(Gv*1/s*N)

beta = 9;
p_lag = 0.0025;
z_lag = beta * p_lag;

Lag = (s + z_lag) / (s + p_lag);

% Controllore totale
R = Rs * Lead * N * Lag ;

% Loop gain
Ge = Gv * R ;

drawBode(Ge);      % controlla: 1 crossing, PM >65°, |L_res| << 0 dB

% % --- PRIMA SOLUZIONE ---
% 
% 
% % Notch
% N = (s^2 + 2*zeta_n*wn*s + wn^2) / (s^2 + 2*zeta_d*wn*s + wn^2);
% 
% % Lead (esempio per ~45-50° boost)
% z = 2.2;
% p = 14.0;
% Lead = (s + z) / (s + p);
% 
% % Integrale + guadagno
% Ki = 190000000000;
% Rs = Ki / s;
% 
% 
% beta = 9;
% p_lag = 0.0025;
% z_lag = beta * p_lag;
% 
% Lag = (s + z_lag) / (s + p_lag);
% 
% % Controllore totale
% R = Rs * Lead * N * Lag * (s+13)^3 * 1/((s+10000)^3);
% 
% % Loop gain
% Ge = Gv * R ;
% 
% drawBode(Ge);      % controlla: 1 crossing, PM >65°, |L_res| << 0 dB