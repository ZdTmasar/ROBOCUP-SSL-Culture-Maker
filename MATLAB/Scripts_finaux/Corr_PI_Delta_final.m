%% Synth�se d'un r�gulateur de type PI et approximation en Delta

% Ce script comprend les �tapes de la synth�se du r�gulateur proportionnel
% int�gral qui sera associ� au mod�le identifi� pr�c�demment et aux calculs
% de ses coefficients dans le domaine discret.

clear all
close all
clc

%% Domaine Continu

% D�finition de la variable continue et de la fonction de transfert du
% proc�d�

s = tf('s');

Ko = 25.8532;
tau1 = 0.011;
tau2 = 0.078;
Go = Ko/(1+tau2*s)/(1+tau1*s);

% Synth�se du r�gulateur � actions proportionnelle et int�grale

wu = 20;    % pulsation au gain unit�

[Gwu, Pwu] = bode(Go, wu);

wi = wu;
Co = (wu/wi) /(Gwu * sqrt(1+(wu/wi)*(wu/wi)));

C = Co  * (1+s/wi) / (s/wi);

[CGwu, CPwu] = bode(C*Go, 20); % permet la v�rification de la valeur du gain � la pulsation au gain unit�

%% Trac�s

figure(1);
subplot(2,1,1);
step(Go);
title('R�ponse indicielle du proc�d�');
subplot(2,1,2);
margin(Go); % Diagrammes de Bode du proc�d� avec affichage de la marge de phase et du gain unit�

figure(2);
subplot(2,1,1);
step(C);
title('R�ponse indicielle du correcteur');
subplot(2,1,2);
margin(C); % Diagrammes de Bode du correcteur avec affichage de la marge de phase et du gain unit�

figure(3);
% Boucle ouverte
margin(C*Go); % Diagrammes de Bode de la boucle ouverte de l'asservissement

figure(4);
step(C*Go/(1+C*Go));
title('R�ponse indicielle de la boucle ferm�e de l''asservissement');

%% Domaine Discret

% Synth�se du r�gulateur dans le domaine discret avec l'approximation en
% Delta

Ts = 0.001; % P�riode d'�chantillonnage

disp('----------------------------------------------------------------------------');
Czc = c2d(C, Ts, 'foh'); 
disp('Correcteur num�rique avec approximation en delta');
disp(Czc);

% Equation r�currente � impl�menter avec u[k] et e[k] respectivement la
% commande  et l'erreur � l'instant kTs

disp('----------------------------------------------------------------------------');
disp('Equation r�currente:');
disp('u[k] = u[k-1] + 0.0524*e[k] - 0.0514*e[k-1]');
