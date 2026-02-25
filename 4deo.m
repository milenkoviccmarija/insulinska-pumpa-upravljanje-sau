pkg load control

s=tf('s');
W=(0.031995*s^2+0.0011205*s+9*10^(-6))/(s*(s+0.023)*(s+0.01));

nyquist(W);

[d,Phi,Wpi,Wpf]=margin(W);
disp(["Pretek pojacanja = ",num2str(d)]);
disp(["Pretek kasnjenja = ",num2str(Phi)]);
