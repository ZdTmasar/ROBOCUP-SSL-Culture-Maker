%% Synthèse d'un régulateur de type PI et approximation en Delta

% Ce script comprend les étapes de la synthèse du régulateur proportionnel
% intégral qui sera associé au modèle identifié précédemment et aux calculs
% de ses coefficients dans le domaine discret.

clear all
close all
clc

%% Domaine Continu

% Définition de la variable continue et de la fonction de transfert du
% procédé

s = tf('s');

Ko = 25.8532;
tau1 = 0.011;
tau2 = 0.078;
Go = Ko/(1+tau2*s)/(1+tau1*s);

% Synthèse du régulateur à actions proportionnelle et intégrale

wu = 20;    % pulsation au gain unité

[Gwu, Pwu] = bode(Go, wu);

wi = wu;
Co = (wu/wi) /(Gwu * sqrt(1+(wu/wi)*(wu/wi)));

C = Co  * (1+s/wi) / (s/wi);

[CGwu, CPwu] = bode(C*Go, 20); % permet la vérification de la valeur du gain à la pulsation au gain unité

%% Tracés

figure(1);
subplot(2,1,1);
step(Go);
title('Réponse indicielle du procédé');
subplot(2,1,2);
margin(Go); % Diagrammes de Bode du procédé avec affichage de la marge de phase et du gain unité

figure(2);
subplot(2,1,1);
step(C);
title('Réponse indicielle du correcteur');
subplot(2,1,2);
margin(C); % Diagrammes de Bode du correcteur avec affichage de la marge de phase et du gain unité

figure(3);
% Boucle ouverte
margin(C*Go); % Diagrammes de Bode de la boucle ouverte de l'asservissement

figure(4);
step(C*Go/(1+C*Go));
title('Réponse indicielle de la boucle fermée de l''asservissement');

%% Domaine Discret

% Synthèse du régulateur dans le domaine discret avec l'approximation en
% Delta

Ts = 0.001; % Période d'échantillonnage

disp('----------------------------------------------------------------------------');
Czc = c2d(C, Ts, 'foh'); 
disp('Correcteur numérique avec approximation en delta');
disp(Czc);

% Equation récurrente à implémenter avec u[k] et e[k] respectivement la
% commande  et l'erreur à l'instant kTs

disp('----------------------------------------------------------------------------');
disp('Equation récurrente:');
disp('u[k] = u[k-1] + 0.0524*e[k] - 0.0514*e[k-1]');
