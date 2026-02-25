pkg load control

% Model procesa 
s = tf('s');
G = -4.5e-5/((s+0.023)*(s+0.01));

% --- PID regulator ---
Kp = -24.9;
Ki = -0.2;
Kd = -711;
tau = 1;  % filtracija derivacije

Greg = Kp + Ki/s + Kd*s/(tau*s + 1);


% Zatvorena sprega 
Tcl = feedback(G*Greg, 1);  

% --- Vreme / Referenca / Radne tačke (apsolutne veličine) ---
Ts   = 0.5;                      % [min] korak (0.5 min = 30 s)
Tsim = 600;                      % [min] ukupno vreme (10 h)
t    = (0:Ts:Tsim)';             % kolona!
r_ref = 1.0;                     % korak u devijaciji (+1 mmol/L)
r_sig = r_ref * ones(size(t));   % kolona
G0 = 5.5;                        % [mmol/L] radna tačka glukoze
I0 = 15;                         % [mU/min] radna tačka insulina

% --- Simulacija izlaza (dev) i apsolutne glukoze ---
[y_dev, t_out] = lsim(Tcl, r_sig, t);
G_abs = y_dev + G0;

% --- Greška i kontrolni signal preko PI-a ---
e_dev = r_sig - y_dev;
[u_dev, ~] = lsim(Greg, e_dev, t);
I_abs = I0 + u_dev;

% GRAFICI
t_min = t_out;   % već je u minutima

% 1) Glukoza (apsolutno) + referenca + radna tačka
figure(1); clf;
plot(t_min, G_abs, 'LineWidth', 1.6); hold on;
plot(t_min, (G0 + r_ref) * ones(size(t_min)), '--', 'LineWidth', 1.2); % referenca (apsolutno)
plot(t_min, G0 * ones(size(t_min)), ':', 'LineWidth', 1.0);            % radna tačka
grid on;
xlabel('Vreme [min]'); ylabel('Glukoza G [mmol/L]');
legend('G (apsolutno)', 'Referenca', 'Radna tačka', 'location', 'best');
title('Odziv glukoze (zatvorena sprega)');

% 2) Insulin (apsolutno)
figure(2); clf;
plot(t_min, I_abs, 'LineWidth', 1.6);
grid on;
xlabel('Vreme [min]'); ylabel('Insulin I [mU/min]');
legend('I (apsolutno)', 'location', 'best');
title('Kontrolni signal (insulin)');

% 3) Greška u devijacionim veličinama
figure(3); clf;
plot(t_min, e_dev, 'LineWidth', 1.6); hold on;
plot(t_min, zeros(size(t_min)), '--', 'LineWidth', 1.0); % nulta linija
grid on;
xlabel('Vreme [min]'); ylabel('Greška e = r - y  [dev]');
legend('e(t)', '0', 'location', 'best');
title('Greška');


