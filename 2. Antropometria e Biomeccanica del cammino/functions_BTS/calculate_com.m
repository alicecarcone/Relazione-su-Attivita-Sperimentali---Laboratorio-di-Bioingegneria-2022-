function COM=calculate_com(marker_p,marker_d,b)

%INPUT: posizione del marker prossimale, posizione del marker distale, 
%distanza del COM dal marker del giunto prossimale 

%OUTPUT: posizione del centro di massa del segmento

%NB: senza la necessità di ripetere il calcolo per x, y e z perchè matlab
%sta già gestendo i dati dei marker in vettori da tre colonne e opera
%quindi contemporaneamente sulle tre coordinate tramite calcoli matriciali

COM=marker_p*(1-b)+marker_d*b

