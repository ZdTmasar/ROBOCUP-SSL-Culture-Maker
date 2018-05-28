clear all
close all
clc

%% Domaine Continu

s = tf('s');

Ko = 25.8532;
tau1 = 0.011;
tau2 = 0.078;
Go2 = Ko/(1+tau2*s)/(1+tau1*s);
Go1 = Ko/(1+tau1*s);

wu = 20;

[Gwu1, Pwu1] = bode(Go1, wu)
[Gwu2, Pwu2] = bode(Go2, wu)

wi = wu;
Co1 = (wu/wi) /(Gwu1 * sqrt(1+(wu/wi)*(wu/wi)));
Co2 = (wu/wi) /(Gwu2 * sqrt(1+(wu/wi)*(wu/wi)));

C1 = Co1  * (1+s/wi) / (s/wi);
C2 = Co2  * (1+s/wi) / (s/wi);

[CGwu1, CPwu1] = bode(C1*Go1, 20)
[CGwu2, CPwu2] = bode(C2*Go2, 20)

%% Tracés

figure(1);
subplot(2,1,1);
step(Go1);
title('Go1 & Go2');
hold on;
step(Go2);
subplot(2,1,2);
margin(Go1);
hold on;
margin(Go2);

figure(2);
subplot(2,1,1);
step(C1);
hold on;
step(C2);
title('C1 & C2');
subplot(2,1,2);
margin(C1);
hold on;
margin(C2);

figure(3);
% Boucle ouverte
margin(C1*Go1);
hold on;
margin(C2*Go2);

figure(4);
% Boucle fermée
step(C1*Go1/(1+C1*Go1));
hold on;
step(C2*Go2/(1+C2*Go2));
title('FTBF');

%% Domaine Discret

Ts = 0.001;

%Approximation Delta
disp('----------------------------------------------------------------------------');
Czc1 = c2d(C1, Ts, 'foh'); 
disp('Correcteur avec approximation en delta ordre1');
disp(Czc1);

disp('----------------------------------------------------------------------------');
Czc2 = c2d(C2, Ts, 'foh'); 
disp('Correcteur avec approximation en delta ordre2');
disp(Czc2);

%% 
% close all;