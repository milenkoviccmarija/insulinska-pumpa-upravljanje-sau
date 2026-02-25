pkg load control;
%Parametri sistema
SG=0.014;
C=0.1725;
ka=6e-6;
kb=0.01;
%Pocetna stanja
G0=7.5;
X0=0.009;
x0=[G0;X0];
%Vremenski interval
t=0:0.01:100;
%definiija insulina
I=@(t) 15+5*(t>=10);
%sistem sa promenljivim insulinom
d_stanja=@(t,x)[-(SG+x(2))*x(1)+C; ka*I(t)-kb*x(2)];
[t,x_nelinearno]=ode45(d_stanja,t,x0);
%prikaz nelinearnog sistema
figure;
plot(t,x_nelinearno(:,1),'b','LineWidth',2);
hold on;
xlabel('Vreme[min]');
ylabel('Glukoza G(t)[mmol/L]');
%vrednosti radne tacke
I0=15;
x10=7.5;
x20=0.009;
%matrice sistema
A=[-(0.014+x20),-x10;0,-0.01];
B=[0;6*10^(-6)];
C=[1,0];
D=[];
sistem=ss(A,B,C,D);
G=tf(sistem);
delta_I=5;
u=zeros(size(t));
u(t>=10)=delta_I;
g_linearno=lsim(G,u,t)+G0;
plot(t,g_linearno,'r','LineWidth',1.5);
