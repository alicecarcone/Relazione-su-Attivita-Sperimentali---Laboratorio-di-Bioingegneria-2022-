%% ESERCITAZIONE STATICA (20/05/2022)

clear all
close all
clc

addpath('functions\')
dataBTS.data_path=uigetdir("Selezionare la cartella che contiene i dati");

% Caricamento dati STANDING
dataBTS_standing.files=dir([dataBTS.data_path filesep 'standing' filesep '*.txt']);

for iC=1:length(dataBTS_standing.files)
    dataBTS_standing_name=dataBTS_standing.files(iC).name;
    if contains(dataBTS_standing_name, 'forze')
       dataBTS.standing.grf=load_dataBTS_forces( ...
       [dataBTS.data_path filesep 'standing' filesep dataBTS_standing_name]);
    elseif contains(dataBTS_standing_name, 'punti')
           dataBTS.standing.markers=load_dataBTS_markers( ...
           [dataBTS.data_path filesep 'standing' filesep dataBTS_standing_name]);
    end
end

% Caricamento dati WALKING
dataBTS_walking.files=dir([dataBTS.data_path filesep 'walking' filesep '*.txt']);
num_walking=length(dataBTS_walking.files)/4;

k=1;
for iC=1:length(dataBTS_walking.files)
    dataBTS_walking_name=dataBTS_walking.files(iC).name;
    if contains(dataBTS_walking_name, 'forze')
       dataBTS.walking(k).grf=load_dataBTS_forces( ...
       [dataBTS.data_path filesep 'walking' filesep dataBTS_walking_name]);
    elseif contains(dataBTS_walking_name, 'punti')
           dataBTS.walking(k).markers=load_dataBTS_markers( ...
           [dataBTS.data_path filesep 'walking' filesep dataBTS_walking_name]);
        k=k+1;
    end
end

% Caricamento dati COP
k=1;
for iC=1:length(dataBTS_walking.files)
    dataBTS_walking_name=dataBTS_walking.files(iC).name;
    if contains(dataBTS_walking_name, 'COPl')
       dataBTS.walking(k).COP.l=load_dataBTS_COP( ...
       [dataBTS.data_path filesep 'walking' filesep dataBTS_walking_name]);
    elseif contains(dataBTS_walking_name, 'COPr')
           dataBTS.walking(k).COP.r=load_dataBTS_COP( ...
           [dataBTS.data_path filesep 'walking' filesep dataBTS_walking_name]);
        k=k+1;
    end
end

save('all_data_BTS.mat','dataBTS');

%%                      PRE-PROCESSING

%% 1) MISURE ANTROPOMETRICHE

% Massa
left_weight=nanmean(dataBTS.standing.grf.v_force_l);
right_weight=nanmean(dataBTS.standing.grf.v_force_r);

% Plot
figure()
plot(dataBTS.standing.grf.v_force_l)
hold on
plot(dataBTS.standing.grf.v_force_r)
plot([0 length(dataBTS.standing.grf.v_force_l)], ...
    [left_weight left_weight], 'b--', 'linewidth', 2)
plot([0 length(dataBTS.standing.grf.v_force_l)], ...
    [right_weight right_weight], 'r--', 'linewidth', 2)
legend('Left vGRF', 'Right vGRF', 'Left Weight', 'Right Weight')

g=9.81;
M=(left_weight+right_weight)/g;                                             % massa totale

static_asim=abs(right_weight-left_weight)/(right_weight+left_weight)*100;

% Definisco misure antropometriche
M_thigh=0.1*M;                                                              % massa del segmento coscia
M_leg=0.061*M;                                                              % massa del segmento gamba

b_thigh=0.433;                                                              % centro di massa del segmento coscia rispetto al giunto prossimale (anca)
b_leg=0.606;                                                                % centro di massa del segmento gamba rispetto al giunto prossimale (ginocchio)

%% 2) RICAMPIONAMENTO DEI SEGNALI
% Fs_markers= 60;
% Fs_forces= 240;

iW_sel=1;
for iW=iW_sel %:num_walking
    
    markers_list=dataBTS.walking(iW).markers;

    % Definisco le lunghezze di ciascun vettore di dati
    len_markers=length(markers_list.RGT);                                   % RGT preso per convenzione (valgono tutti perchè hanno la stessa lunghezza)
    len_forces=length(dataBTS.walking(iW).grf.ap_force_l);                  % preso per convenzione come RGT
    len_COP=length(dataBTS.walking(iW).COP.r.COPx);                         % preso per convenzione come RGT

    % Ricampionamento il vettore delle forze

    % DESTRA
    grf_vector.v_force_r=resample( ...
        dataBTS.walking(iW).grf.v_force_r,len_markers,len_forces);          % vettore_ricampionato=resample(vettore da ricampionare, lunghezza nuova, lunghezza vecchia)
    grf_vector.ap_force_r=resample( ...
        dataBTS.walking(iW).grf.ap_force_r,len_markers,len_forces);
    grf_vector.ml_force_r=resample( ...
        dataBTS.walking(iW).grf.ml_force_r,len_markers,len_forces);
    
    % SINISTRA
    grf_vector.v_force_l=resample( ...
        dataBTS.walking(iW).grf.v_force_l,len_markers,len_forces);          
    grf_vector.ap_force_l=resample( ...
        dataBTS.walking(iW).grf.ap_force_l,len_markers,len_forces);
    grf_vector.ml_force_l=resample( ...
        dataBTS.walking(iW).grf.ml_force_l,len_markers,len_forces);

    % COP DESTRO
    cop_vector.x_cop_r=resample( ...
        dataBTS.walking(iW).COP.r.COPx, len_markers, len_COP);
    cop_vector.y_cop_r=resample( ...
        dataBTS.walking(iW).COP.r.COPy, len_markers, len_COP);
    cop_vector.z_cop_r=resample( ...
        dataBTS.walking(iW).COP.r.COPz, len_markers, len_COP);

    % COP SINISTRO
    cop_vector.x_cop_l=resample( ...
        dataBTS.walking(iW).COP.l.COPx, len_markers, len_COP);
    cop_vector.y_cop_l=resample( ...
        dataBTS.walking(iW).COP.l.COPy, len_markers, len_COP);
    cop_vector.z_cop_l=resample( ...
        dataBTS.walking(iW).COP.l.COPz, len_markers, len_COP);
    
end

%% DATA PROCESSING - RIGHT LIMB

for iW=iW_sel

    clearvars A_r B_r C_r E_r O_r G1_r G2_r A1_r B1_r A2_r B2_r A3_r B3_r ...
        W1 W2 grf_r OC_skew_r OG1_skew_r OG2_skew_r OA1_skew_r OA2_skew_r ...
        OA3_skew_r v_A1B1_r v_A2B2_r FM1_r FM2_r FM3_r FMs_r M_e_r
    
    % Posizione dei marker
    A_r=markers_list.RGT;                                                   % Gran trocantere
    A_r=fillmissing(A_r, 'nearest');
    B_r=markers_list.RASIS;                                                 % Spina Iliaca
    B_r=fillmissing(B_r, 'nearest');
    D_r=markers_list.RLM;                                                   % Malleolo laterale
    D_r=fillmissing(D_r,'nearest');
    E_r=markers_list.RLE;                                                   % Epicondilo laterale
    E_r=fillmissing(E_r, 'nearest');            

    % Posizione dei centri di massa dei segmenti
    % formula marker_prossimale*(1-posizione del COM rispetto al giunto
    % prossimale)+marker_distale*posizione delCOM rispetto al giunto
    % prossimale

    G1_r=A_r*(1-b_thigh)+E_r*b_thigh;
    G2_r=E_r*(1-b_leg)+D_r*b_leg;

    % Posizione del centro di rotazione dell'anca O
    O_r(:,1)=B_r(:,1)+0.02;
    O_r(:,2)=A_r(:,2)+(B_r(:,2)-A_r(:,2))/3;                                % Posizione del marker A + 1/3 della distanza tra A e B
    O_r(:,3)=A_r(:,3)-0.01;

    % Posizione del centro di pressione C (COP)
    C_r(:,1)=cop_vector.x_cop_r;
    C_r(:,2)=cop_vector.y_cop_r;
    C_r(:,3)=cop_vector.z_cop_r;

    % Posizione dei punti di inserzione dei muscoli tramite ipotesi sul
    % modello muscolare
    alpha=1.2;

    % Muscolo 1) GRANDE GLUTEO
    
    % Punti di inserzione: gran trocantere (posteriore) -> ala iliaca posteriore
    % Direzione della forza muscolare: Fm1= A1_r -> B1_r
    % Ricostruzione di alcuni punti di cui non conosciamo coordinate
    A1_r(:,1)=A_r(:,1)+0.02*alpha;
    A1_r(:,2)=A_r(:,2)-0.04*alpha;
    A1_r(:,3)=A_r(:,3)-0.06*alpha;

    % B1_r
    B1_r(:,1)=B_r(:,1)+0.05*alpha;
    B1_r(:,2)=B_r(:,2)+0.045*alpha;
    B1_r(:,3)=B_r(:,3)-0.08*alpha;
    
    % M2  Medio Gluteo
    % Punti di inserzione: Gran trocantere(laterale) -> ala iliaca esterna
    % Direzione della forza muscolare Fm2: A2_r-B2_r
    A2_r(:,1)=A_r(:,1);
    A2_r(:,2)=A_r(:,2)+0.01*alpha;
    A2_r(:,3)=A_r(:,3)-0.03*alpha;

    
    B2_r(:,1)=B_r(:,1)-0.005*alpha;
    B2_r(:,2)=B_r(:,2)+0.05*alpha;
    B2_r(:,3)=B_r(:,3)-0.06*alpha;

    % M3-Psoas
    % Punti di inserzione: piccolo trocantere -> Vertebra D12
    % Direzione della forza muscolare Fm3: A3_r-B3_r

    A3_r(:,1)=A_r(:,1)+0.015*alpha;
    A3_r(:,2)=A_r(:,2)-0.015*alpha;
    A3_r(:,3)=A_r(:,3)+0.06*alpha;
    
    B3_r(:,1)=B_r(:,1)+0.07*alpha;
    B3_r(:,2)=B_r(:,2)+0.17*alpha;
    B3_r(:,3)=B_r(:,3)-0.06*alpha;

    % Forza peso dei segmenti corporei
    W1(:,1)=zeros(len_markers,1);
    W1(:,2)=-ones(len_markers,1)*M_thigh*g;
    W1(:,3)=zeros(len_markers,1);
    
    % Forza peso dei segmenti corporei
    W2(:,1)=zeros(len_markers,1);
    W2(:,2)=-ones(len_markers,1)*M_leg*g;
    W2(:,3)=zeros(len_markers,1);

    % GRF ha:
    % - Componente verticale (lungo l'asse y): GRF_vec.v_force_r
    % - Componente antero-posteriore (lungo l'asse z): GRF_vec.ap_force_r
    % - Componente medio-laterale (lungo l'asse x): GRF_vec.ml_force_r
    GRF_r(:,1)=grf_vector.ml_force_r;
    GRF_r(:,2)=grf_vector.v_force_r;
    GRF_r(:,3)=grf_vector.ap_force_r;

    % Forze muscolari: equazione di bilancio dei momenti  Me+Mm=0
    % - Me: contributo delle forze esterne. Me=OG1*W1+OG2*W2+OG3*GRF
    % - Mm: contributo delle forze muscolari. Mm=OA1*FM1+OA2*FM2*OA3*FM3

    % Vettori dal polo O al punto di inserzione della forza 
    OC_r=C_r-O_r;
    OG1_r=G1_r-O_r;
    OG2_r=G2_r-O_r;
    OA1_r=A1_r-O_r;
    OA2_r=A2_r-O_r;
    OA3_r=A3_r-O_r;

    for i=1:len_markers
        OC_skew_r(:,:,i)=SKEW(OC_r(i,:)');
        OG1_skew_r(:,:,i)=SKEW(OG1_r(i,:)');
        OG2_skew_r(:,:,i)=SKEW(OG2_r(i,:)');
        OA1_skew_r(:,:,i)=SKEW(OA1_r(i,:)');
        OA2_skew_r(:,:,i)=SKEW(OA2_r(i,:)');
        OA3_skew_r(:,:,i)=SKEW(OA3_r(i,:)');
    end

    % DIREZIONE DELLE FORZE
    % Mm1=OA1_skew_r*v_A1B1*FM1
    % dove V_A1B1 è il versore della forza muscolare FM1
    A1B1_r=B1_r-A1_r;
    A2B2_r=B2_r-A2_r;
    A3B3_r=B3_r-A3_r;

    for i=1:len_markers
        v_A1B1_r(i,:)=A1B1_r(i,:)/norm(A1B1_r(i,:));
        v_A2B2_r(i,:)=A2B2_r(i,:)/norm(A2B2_r(i,:));
        v_A3B3_r(i,:)=A3B3_r(i,:)/norm(A3B3_r(i,:));

        % Matrice delle distanze dei punti di inserzione dal polo O
        v_matrix_r(:,:,1)=[OA1_skew_r(:,:,i)*v_A1B1_r(i,:)' ...
            OA2_skew_r(:,:,i)*v_A2B2_r(i,:)' ...
            OA3_skew_r(:,:,i)*v_A3B3_r(i,:)'];

        % Scriviamo il momento delle forze esterne (noto)
        M_e_r(:,i)= ... 
            OG1_skew_r(:,:,i)*W1(i,:)'+OG2_skew_r(:,:,i)*W2(i,:)' ... 
            + OC_skew_r(:,:,i)*GRF_r(i,:)';

        % Me+Mm=0 -> Mm=-Me
        % lisolve(A,B) A*x = B
        %  v_matrix _r*FM=-Me
        FMs_r(:,i)=linsolve(v_matrix_r(:,:,1), -M_e_r(:,i));

        % FINE LEZIONE 24.05.22
        FM1_r(i,:)=FMs_r(1,i)*v_A1B1_r(i,:); % Grande Gluteo   
        FM2_r(i,:)=FMs_r(2,i)*v_A2B2_r(i,:); % Medio Gluteo
        FM3_r(i,:)=FMs_r(3,i)*v_A3B3_r(i,:); % psoas
    end

    % Salviamo i dati nella struttura data_bts
    dataBTS.walking(iW).FMs.r=FMs_r';
end

%% DATA PLOT - LATO DESTRO
figure('Name', 'Forze Muscolari lato destro')
subplot(3,1,1)
plot(FM1_r)
hold on
plot(FMs_r(1,:), 'r', 'LineWidth', 4)
legend({'FM_x', 'FM_y', 'FM_z', 'FM'})
ylabel('Forza [N]', 'FontSize',24)
set(gca, 'FontSize', 22)
title ('Grande Gluteo (estensore)')

subplot(3,1,2)
plot(FM2_r)
hold on
plot(FMs_r(2,:), 'k', 'LineWidth', 4)
legend({'FM_x', 'FM_y', 'FM_z', 'FM'})
ylabel('Forza [N]', 'FontSize',24)
set(gca, 'FontSize', 22)
title ('Medio Gluteo (abduttore)')

subplot(3,1,3)
plot(FM3_r)
hold on
plot(FMs_r(3,:), 'g', 'LineWidth', 4)
legend({'FM_x', 'FM_y', 'FM_z', 'FM'})
ylabel('Forza [N]', 'FontSize',24)
set(gca, 'FontSize', 22)
title ('psoas (flessore)')


%% LEFT LIMB

for iW=iW_sel
    
    clearvars A_l B_l C_l E_l O_l G1_l G2_l A1_l B1_l A2_l B2_l A3_l B3_l ...
        W1 W2 GRF_l OC_skew_l OG1_skew_l OG2_skew_l OA1_skew_l OA2_skew_l ...
        OA3_skew_l v_A1B1_l v_A2B2_l FM1_l FM2_l FM3_l FMs_l M_e_l

    % Posizione dei marker
    A_l=markers_list.LGT;                                                   % Gran trocantere
    A_l=fillmissing(A_l, 'nearest');
    B_l=markers_list.LASIS;                                                 % Spina Iliaca
    B_l=fillmissing(B_l, 'nearest');
    D_l=markers_list.LLM;                                                   % Malleolo laterale
    D_l=fillmissing(D_l,'nearest');
    E_l=markers_list.LLE;                                                   % Epicondilo laterale
    E_l=fillmissing(E_l, 'nearest');            

    % Posizione dei centri di massa dei segmenti
    % formula marker_prossimale*(1-posizione del COM rispetto al giunto
    % prossimale)+marker_distale*posizione delCOM rispetto al giunto
    % prossimale

    G1_l=A_l*(1-b_thigh)+E_l*b_thigh;
    G2_l=E_l*(1-b_leg)+D_l*b_leg;

    % Posizione del centro di rotazione dell'anca O
    O_l(:,1)=B_l(:,1)-0.02;
    O_l(:,2)=A_l(:,2)+(B_l(:,2)-A_l(:,2))/3;                                % Posizione del marker A + 1/3 della distanza tra A e B
    O_l(:,3)=A_l(:,3)-0.01;

    % Posizione del centro di pressione C (COP)
    C_l(:,1)=cop_vector.x_cop_l;
    C_l(:,2)=cop_vector.y_cop_l;
    C_l(:,3)=cop_vector.z_cop_l;

    % Posizione dei punti di inserzione dei muscoli tramite ipotesi sul
    % modello muscolare
    alpha=1.2;

    % Muscolo 1) GRANDE GLUTEO
    
    % Punti di inserzione: gran trocantere (posteriore) -> ala iliaca
    % posteriore

    % Direzione della forza muscolare: Fm1= A1_l -> B1_l

    % Ricostruzione di alcuni punti di cui non conosciamo coordinate
    A1_l(:,1)=A_l(:,1)-0.02*alpha;
    A1_l(:,2)=A_l(:,2)-0.04*alpha;
    A1_l(:,3)=A_l(:,3)-0.06*alpha;

    % B1_r
    B1_l(:,1)=B_l(:,1)-0.05*alpha;
    B1_l(:,2)=B_l(:,2)+0.045*alpha;
    B1_l(:,3)=B_l(:,3)-0.08*alpha;
    
    % M2  Medio Gluteo
    % Punti di inserzione: Gran trocantere(laterale) -> ala iliaca esterna
    % Direzione della forza muscolare Fm2: A2_l-B2_l
    A2_l(:,1)=A_l(:,1);
    A2_l(:,2)=A_l(:,2)+0.01*alpha;
    A2_l(:,3)=A_l(:,3)-0.03*alpha;

    
    B2_l(:,1)=B_l(:,1)+0.005*alpha;
    B2_l(:,2)=B_l(:,2)+0.05*alpha;
    B2_l(:,3)=B_l(:,3)-0.06*alpha;

    % M3-Psoas
    % Punti di inserzione: piccolo trocantere -> Vertebra D12
    % Direzione della forza muscolare Fm3: A3_r-B3_r

    A3_l(:,1)=A_l(:,1)-0.015*alpha;
    A3_l(:,2)=A_l(:,2)-0.015*alpha;
    A3_l(:,3)=A_l(:,3)+0.06*alpha;

    
    B3_l(:,1)=B_l(:,1)-0.07*alpha;
    B3_l(:,2)=B_l(:,2)+0.17*alpha;
    B3_l(:,3)=B_l(:,3)-0.06*alpha;

    % Forza peso dei segmenti corporei
    % W1 è la forza peso del semgneto 1 (coscia). L'unica componente
    % diversa da 0 è la componente lungo y, è negativa ed è pari a massa
    % del segmento*accelerazione di gravità M_thigh*g
    W1(:,1)=zeros(len_markers,1);
    W1(:,2)=-ones(len_markers,1)*M_thigh*g;
    W1(:,3)=zeros(len_markers,1);
    
    % Forza peso dei segmenti corporei
    % W1 è la forza peso del semgneto 2 (gamba). L'unica componente
    % diversa da 0 è la componente lungo y, è negativa ed è pari a massa
    % del segmento*accelerazione di gravità M_leg*g
    W2(:,1)=zeros(len_markers,1);
    W2(:,2)=-ones(len_markers,1)*M_leg*g;
    W2(:,3)=zeros(len_markers,1);

    % GRF ha:
    % - Componente verticale (lungo l'asse y): GRF_vec.v_force_r
    % - Componente antero-posteriore (lungo l'asse z): GRF_vec.ap_force_r
    % - Componente medio-laterale (lungo l'asse x): GRF_vec.ml_force_r
    GRF_l(:,1)=grf_vector.ml_force_l;
    GRF_l(:,2)=grf_vector.v_force_l;
    GRF_l(:,3)=grf_vector.ap_force_l;

    % Forze muscolari: per ricavare le forze muscolari dobbiamo scrivere
    % un'equazione di bilancio dei momenti
    % Me+Mm=0
    % - Me: contributo delle forze esterne. Me=OG1*W1+OG2*W2+OG3*GRF
    % - Mm: contributo delle forze muscolari. Mm=OA1*FM1+OA2*FM2*OA3*FM3

    % Vettori dal polo O al punto di inserzione della forza 
    OC_l=C_l-O_l;
    OG1_l=G1_l-O_l;
    OG2_l=G2_l-O_l;
    OA1_l=A1_l-O_l;
    OA2_l=A2_l-O_l;
    OA3_l=A3_l-O_l;

    % Trasformiamo in matrici i vettori tramite l'operatore SKEW
    for i=1:len_markers
        OC_skew_l(:,:,i)=SKEW(OC_l(i,:)');
        OG1_skew_l(:,:,i)=SKEW(OG1_l(i,:)');
        OG2_skew_l(:,:,i)=SKEW(OG2_l(i,:)');
        OA1_skew_l(:,:,i)=SKEW(OA1_l(i,:)');
        OA2_skew_l(:,:,i)=SKEW(OA2_l(i,:)');
        OA3_skew_l(:,:,i)=SKEW(OA3_l(i,:)');
    
    
    end

    % DIREZIONE DELLE FORZE
    % Mm1=OA1_skew_r*v_A1B1*FM1
    % dove V_A1B1 è il versore della forza muscolare FM1
    A1B1_l=B1_l-A1_l;
    A2B2_l=B2_l-A2_l;
    A3B3_l=B3_l-A3_l;


    for i=1:len_markers
        v_A1B1_l(i,:)=A1B1_l(i,:)/norm(A1B1_l(i,:));
        v_A2B2_l(i,:)=A2B2_l(i,:)/norm(A2B2_l(i,:));
        v_A3B3_l(i,:)=A3B3_l(i,:)/norm(A3B3_l(i,:));

        % Matrice delle distanze dei punti di inserzione dal polo 
        v_matrix_l(:,:,1)=[OA1_skew_l(:,:,i)*v_A1B1_l(i,:)' ...
            OA2_skew_l(:,:,i)*v_A2B2_l(i,:)' ...
            OA3_skew_l(:,:,i)*v_A3B3_l(i,:)'];

        % Scriviamo il momento delle forze esterne (noto)
        M_e_l(:,i)= ... 
            OG1_skew_l(:,:,i)*W1(i,:)'+OG2_skew_l(:,:,i)*W2(i,:)' ... 
            + OC_skew_l(:,:,i)*GRF_l(i,:)';

        % Me+Mm=0 -> Mm=-Me
        % lisolve(A,B) A*x = B
        %  v_matrix _r*FM=-Me
        FMs_l(:,i)=linsolve(v_matrix_l(:,:,1), -M_e_l(:,i));

        % FINE LEZIONE 24.05.22
        FM1_l(i,:)=FMs_l(1,i)*v_A1B1_l(i,:); % Grande Gluteo   
        FM2_l(i,:)=FMs_l(2,i)*v_A2B2_l(i,:); % Medio Gluteo
        FM3_l(i,:)=FMs_l(3,i)*v_A3B3_l(i,:); % psoas
    end

    % Salviamo i dati nella struttura data_bts
    dataBTS.walking(iW).FMs.l=FMs_l';
end

%% DATA PLOT - LATO DESTRO
figure('Name', 'Forze Muscolari lato sinistro')
subplot(3,1,1)
plot(FM1_l)
hold on
plot(FMs_l(1,:), 'r', 'LineWidth', 4)
legend({'FM_x', 'FM_y', 'FM_z', 'FM'})
ylabel('Forza [N]', 'FontSize',24)
set(gca, 'FontSize', 22)
title ('Grande Gluteo (estensore)')

subplot(3,1,2)
plot(FM2_l)
hold on
plot(FMs_l(2,:), 'k', 'LineWidth', 4)
legend({'FM_x', 'FM_y', 'FM_z', 'FM'})
ylabel('Forza [N]', 'FontSize',24)
set(gca, 'FontSize', 22)
title ('Medio Gluteo (abduttore)')

subplot(3,1,3)
plot(FM3_l)
hold on
plot(FMs_l(3,:), 'g', 'LineWidth', 4)
legend({'FM_x', 'FM_y', 'FM_z', 'FM'})
ylabel('Forza [N]', 'FontSize',24)
set(gca, 'FontSize', 22)
title ('psoas (flessore)')

    
    
%% FASE DI STANCE LATO DESTRO
figure()
subplot(3,1,1)
plot(GRF_r(:,2),'b', 'linewidth', 4)
hold on
plot(GRF_l(:,2), 'r', 'linewidth', 4)
ylabel('GRF [N]', 'fontsize', 24)
legend('Right Side', 'Left Side')
set(gca, 'fontsize', 22)
title('GRF verticale')
grid on

subplot(3,1,2)
plot(GRF_r(:,3),'b', 'linewidth', 4)
hold on
plot(GRF_l(:,3), 'r', 'linewidth', 4)
ylabel('GRF [N]', 'fontsize', 24)
legend('Right Side', 'Left Side')
set(gca, 'fontsize', 22)
title('GRF antero-posteriore')
grid on

subplot(3,1,3)
plot(GRF_r(:,1),'b', 'linewidth', 4)
hold on
plot(GRF_l(:,1), 'r', 'linewidth', 4)
ylabel('GRF [N]', 'fontsize', 24)
legend('Right Side', 'Left Side')
set(gca, 'fontsize', 22)
title('GRF medio-laterale')
grid on


% Seleziono intervallo di stance
input('Seleziona i due punti di inizio e fine stance per il lato destro./n Successivamente premere invio.');
data_grf_sorted=sort([cursor_info_grf_r.DataIndex]);                        % Ordina in ordine crescente
FM_stance_r=FMs_r(:,data_grf_sorted(1):data_grf_sorted(2));

FM1_stance_mean_r=mean(FM_stance_r(1,:));

FM2_stance_mean_r=mean(FM_stance_r(2,:));

FM3_stance_mean_r=mean(FM_stance_r(3,:));

FM_stance_mean_r=[FM1_stance_mean_r FM2_stance_mean_r FM3_stance_mean_r];

% Salvataggio nella struttura dataBTS
dataBTS.walking(iW).FM_stance.r=FM_stance_r;
dataBTS.walking(iW).FM_stance_mean.r=FM_stance_mean_r;

indices_r=find(isnan((FMs_r(1,:))&(FMs_r(1,:)==0)));
dataBTS.walking(iW).start_step_r=indices_r(1);

figure()
plot(FMs_r(1,:), 'r')
hold on
plot(FMs_r(2,:), 'k')
plot(FMs_r(3,:), 'g')
line([dataBTS.walking(iW).start_step_r indices_r(end)], ...
    [FM1_stance_mean_r FM1_stance_mean_r], 'Color', 'red', 'LineStyle', '--')
line([dataBTS.walking(iW).start_step_r indices_r(end)], ...
    [FM2_stance_mean_r FM2_stance_mean_r], 'Color', 'black', 'LineStyle', '--')
line([dataBTS.walking(iW).start_step_r indices_r(end)], ...
    [FM3_stance_mean_r FM3_stance_mean_r], 'Color', 'green', 'LineStyle', '--')
legend({'Grande Gluteo', 'Medio Gluteo', 'Psoas'})


%% FASE DI STANCE LATO SINISTRO
figure()
subplot(3,1,1)
plot(GRF_r(:,2),'b', 'linewidth', 4)
hold on
plot(GRF_l(:,2), 'r', 'linewidth', 4)
ylabel('GRF [N]', 'fontsize', 24)
legend('Right Side', 'Left Side')
set(gca, 'fontsize', 22)
title('GRF verticale')
grid on

subplot(3,1,2)
plot(GRF_r(:,3),'b', 'linewidth', 4)
hold on
plot(GRF_l(:,3), 'r', 'linewidth', 4)
ylabel('GRF [N]', 'fontsize', 24)
legend('Right Side', 'Left Side')
set(gca, 'fontsize', 22)
title('GRF antero-posteriore')
grid on

subplot(3,1,3)
plot(GRF_r(:,1),'b', 'linewidth', 4)
hold on
plot(GRF_l(:,1), 'r', 'linewidth', 4)
ylabel('GRF [N]', 'fontsize', 24)
legend('Right Side', 'Left Side')
set(gca, 'fontsize', 22)
title('GRF medio-laterale')
grid on


% Seleziono intervallo di stance
input('Seleziona i due punti di inizio e fine stance per il lato destro.\n Successivamente premere invio.');
data_grf_sorted=sort([cursor_info_grf_l.DataIndex]);
FM_stance_l=FMs_l(:,data_grf_sorted(1):data_grf_sorted(2));

FM1_stance_mean_l=mean(FM_stance_l(1,:));

FM2_stance_mean_l=mean(FM_stance_l(2,:));

FM3_stance_mean_l=mean(FM_stance_l(3,:));

FM_stance_mean_l=[FM1_stance_mean_l FM2_stance_mean_l FM3_stance_mean_l];
 

% Salvataggio nella struttura dataBTS
dataBTS.walking(iW).FM_stance.l=FM_stance_l;
dataBTS.walking(iW).FM_stance_mean.l=FM_stance_mean_l;

indices_l=find(isnan(FMs_l(1,:))&(FMs_l(1,:)==0));
dataBTS.walking(iW).start_step_l=indices_l(1);

figure()
plot(FMs_l(1,:), 'r')
hold on
plot(FMs_l(2,:), 'k')
plot(FMs_l(3,:), 'g')
line([dataBTS.walking(iW).start_step_l indices_l(end)], ...
    [FM1_stance_mean_l FM1_stance_mean_l], 'Color', 'red', 'LineStyle', '--')
line([dataBTS.walking(iW).start_step_l indices_l(end)], ...
    [FM2_stance_mean_l FM2_stance_mean_l], 'Color', 'black', 'LineStyle', '--')
line([dataBTS.walking(iW).start_step_l indices_l(end)], ...
    [FM3_stance_mean_l FM3_stance_mean_l], 'Color', 'green', 'LineStyle', '--')
legend({'Grande Gluteo', 'Medio Gluteo', 'Psoas'})


%% DATA PLOT - LEFT STANCE

%% DATA ANALYSIS

for iW=iW_sel

    dataBTS.walking(iW).symmetry=abs( ...
        dataBTS.walking(iW).FM_stance_mean.l - ...
        dataBTS.walking(iW).FM_stance_mean.r);

    time_r=[1:length(dataBTS.walking(iW).FMs.r( ...
        dataBTS.walking(iW).start_step_r:end,1))];
    time_l=[1:length(dataBTS.walking(iW).FMs.l( ...
        dataBTS.walking(iW).start_step_l:end,1))];

    figure()
    plot( ...
        time_r,dataBTS.walking(iW).FMs.r( ...
        1, dataBTS.walking(iW).start_step_r:end), 'r')
    hold on
    figure()
    plot( ...
        time_r,dataBTS.walking(iW).FMs.r( ...
        2, dataBTS.walking(iW).start_step_r:end), 'k')
    
    figure()
    plot( ...
        time_r,dataBTS.walking(iW).FMs.r( ...
        3, dataBTS.walking(iW).start_step_r:end), 'g')

    
    figure()
    plot( ...
        time_l,dataBTS.walking(iW).FMs.l( ...
        1, dataBTS.walking(iW).start_step_l:end), 'r')

    figure()
    plot( ...
        time_l, dataBTS.walking(iW).FMs.l( ...
        2, dataBTS.walking(iW).start_step_l:end), 'k')
    
    figure()
    plot( ...
        time_l,dataBTS.walking(iW).FMs.l( ...
        3, dataBTS.walking(iW).start_step_l:end), 'g')

legend({'Grande Gluteo R', 'Medio Gluteo R', 'Psoas R', ...
        'Grande Gluteo L', 'Medio Gluteo L', 'Psoas L'})


end


%% Data Analysis: media tra condizioni diverse (peso normale, +10kg, +10kg)

%%%% Condizione 1: peso del soggetto
FM_stance_cond1_r=mean([dataBTS.walking(1).FM_stance_mean_r; ...
    dataBTS.walking(2).FM_stance_mean_r; ...
    dataBTS.walking(3).FM_stance_mean_r],1);

FM_stance_cond1_l=mean([dataBTS.walking(1).FM_stance_mean_l; ...
    dataBTS.walking(2).FM_stance_mean_l; ...
    dataBTS.walking(3).FM_stance_mean_l],1);

symmetry_cond1=mean([dataBTS.walking(1).symmetry; ...
    dataBTS.walking(2).symmetry; ...
    dataBTS.walking(3).symmetry],1);

%%%% Condizione 2: peso del soggetto + 2 manubri da 5 kg
FM_stance_cond2_r=mean([dataBTS.walking(5).FM_stance_mean_r; ...
    dataBTS.walking(6).FM_stance_mean_r; ...
    dataBTS.walking(7).FM_stance_mean_r],1);

FM_stance_cond2_l=mean([dataBTS.walking(5).FM_stance_mean_l; ...
    dataBTS.walking(6).FM_stance_mean_l; ...
    dataBTS.walking(7).FM_stance_mean_l],1);

symmetry_cond2=mean([dataBTS.walking(5).symmetry; ...
    dataBTS.walking(6).symmetry; ...
    dataBTS.walking(7).symmetry],1);

%%%% Condizione 3: peso del soggetto + 2 manubri da 10 kg
FM_stance_cond3_r=mean([dataBTS.walking(8).FM_stance_mean_r; ...
    dataBTS.walking(9).FM_stance_mean_r; ...
    dataBTS.walking(10).FM_stance_mean_r],1);

FM_stance_cond3_l=mean([dataBTS.walking(8).FM_stance_mean_l; ...
    dataBTS.walking(9).FM_stance_mean_l; ...
    dataBTS.walking(10).FM_stance_mean_l],1);

symmetry_cond3=mean([dataBTS.walking(8).symmetry; ...
    dataBTS.walking(9).symmetry; ...
    dataBTS.walking(10).symmetry],1);

% Istogramma
X=catogorical({'Condizione 1','Condizione 2','Condizione 3'});
X=reordercats({'Condizione 1', 'Condizione 2', 'Condizione 3'});

Figure('Name', 'Forze muscolari nelle tre condizioni sperimentali')
subplot(1,2,1)
barplot_l=bar(X,[FM_stance_cond1_l;FM_stance_cond2_l,FM_stance_cond3_l]);
barplot_l(1).FaceColor=[255 0 0]/255;
barplot_l(2).FaceColor=[0 0 0]/255;
barplot_l(3).FaceColor=[0 255 0]/255;
legend('Grande Gluteo','Medio Gluteo','Psoas','FontSize',14)
ylabel('Valore medio delle forze muscolari [N]')
title('Lato Sinistro')
set(gca,'FontSize',22)
subplot(1,2,2)
barplot_r=bar(X,[FM_stance_cond1_r;FM_stance_cond2_r,FM_stance_cond3_r]);
barplot_l(1).FaceColor=[255 0 0]/255;
barplot_l(2).FaceColor=[0 0 0]/255;
barplot_l(3).FaceColor=[0 255 0]/255;
legend('Grande Gluteo','Medio Gluteo','Psoas','FontSize',14)
ylabel('Valore medio delle forze muscolari [N]')
title('Lato Destro')
set(gca,'FontSize',22)

%quello che si nota è che all'aumentare del peso del soggetto è evidente
%che vi è un aumento della forza muscolare media per ciascun muscolo.
%Quello che aumenta di piò è il grande gluteo (estensore dell'anca) perchè
%nella fase di appoggio è quello che è più coinvolto, il medio gluteo è
%quello meno coinvolto mentre lo psoas 

% Plot Simmetria
figure('Name','Simmetria nelle 3 condizioni sperimentali')
barplot=bar(X,[symmetry_con1; symmetry_cond2; symmetry_cond3]);
barplot_l(1).FaceColor=[255 0 0]/255;
barplot_l(2).FaceColor=[0 0 0]/255;
barplot_l(3).FaceColor=[0 255 0]/255;l
legend('Grande Gluteo','Medio Gluteo','Psoas','FontSize',14 ...
    , 'Location', 'best')
ylabel('Simmetria [N]')
ylim([0 2000])
tilte('Simmetria')
set(gca,'FontSize',22)

%% Data Analysis - COP
for iW=iW_sel
    mean_cop_x_r=nanmean(cop_vector.x_cop_r);
    mean_cop_x_l=nanmean(cop_vector.x_cop_l);
    mean_cop_x=mean([mean_cop_x_r, mean_cop_x_l]);
    
    step_width=abs(mean_cop_x_r-mean_cop_x_l);

    figure('Name','COP')
    plot(cop_vector.x_cop_r, cop_vector.z_cop_l, 'LineWidth',2);
    hold on
    plot(cop_vector.x_cop_l, cop_vector.z_cop_l, 'LineWidth',2);
    xline(mean_cop_x,'-k','LineWidth',2)
    xline(mean_cop_x_l,'LineStyle','--')
    xline(mean_cop_x_r,'LineStyle','--')
    

    xlabel('x (Asse mediolaterale) [m]')
    ylabel('z (Asse anteroposteriale)[m]')
    set(gca, 'xdir','reverse','FontSize',14)
    axis equal
end
