%% Identification du moteur

% Ce script comprend les étapes qui ont amené à l'identification du
% modèle du moteur sur le premier banc de test

clear all
close all
clc

%% Extraction donnee

file = fopen('data.txt','r');
data = fscanf(file,'%f %f',[2 Inf]);
fclose(file);

%% Tracé commande U (V) et vitesse de rotation w (rad/s) du moteur

w = data(1,1:6000).*(2*pi/100);
u = data(2,1:6000).*(24/3000);
X = 0:1e-3:5.999;

figure(1);
title('Réponse indicielle du procédé');

yyaxis left;
ylim([0,7]);
plot(X,u);
ylabel('Commande moteur U (V)');
hold on; 

yyaxis right;
ylim([0,160]);
ylabel('Vitesse de rotation w (rad/s)')
plot(X,w);

xlabel('Temps (s)');

%% Determination du gain statique (moyenne sur 1600pts)

wend = w(1,4000);
uend = u(1,4000);
for i=4001:5600
    wend = wend + w(1,i);
end
wend = wend/1600;

wsta = w(1,1000);
usta = u(1,1000);
for i=1001:2600
    wsta = wsta + w(1,i);
end
wsta = wsta/1600;

disp('Gain statique /V/s');
Ko = (wend-wsta)/(uend-usta);
disp(Ko);

%% Tracé commande U (V) et tension image de la vitesse de rotation w (rad/s) du moteur

uw = data(1,1:6000).*(2*pi/100/Ko);
yt = 61.333.*X-183.195;

figure(2);

plot(X,u);
hold on; 
plot(X,uw);
hold on;
plot(X,yt);
xlim([2.75,3.6]);
ylim([1,7]);

title('Réponse indicielle du procédé');
xlabel('Temps (s)');
ylabel('Commande moteur U (V)');

tau1 = 0.011;
tau2 = 0.078;
disp('Constantes de temps');
disp('tau1');
disp(tau1);
disp('tau2');
disp(tau2);
