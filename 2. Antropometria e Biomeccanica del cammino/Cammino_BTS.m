%% Esercitazione 03/05/2022

close all;
clear all;
clc;

addpath('functions_BTS\');
dataBTS.data_path=uigetdir('Select the directory with the data');
dataBTS.files=dir([dataBTS.data_path filesep '*.txt']);
for iC=1:length(dataBTS.files)
    dataBTS.walking(iC).name = dataBTS.files(iC).name;
    dataBTS.walking(iC).markers = load_dataBTS([dataBTS.data_path filesep dataBTS.walking(iC).name]); 
end

%% Definisco b^n: distanza dal giunto prossimale normalizzata 
%Struttura b 
b.TA=0.63;   %Thorax+Abdomen-> torace+addome
b.P=0.105;   %Pelvis-> bacino
b.T=0.433;   %Thigh-> coscia
b.S=0.433;   %Shank-> gamba     
b.F=0.5;   %Foot-> piede

%% Calcolo della massa normalizzata
M=53; 
%Struttura m (massa)
m.TA=0.3550;     %Thorax+Abdomen-> torace+addome
m.P=0.1420;     %Pelvis-> bacino
m.T=0.1000;     %Thigh-> coscia
m.S=0.0465;     %Shank-> gamba
m.F=0.145;     %Foot-> piede
m.TOT=M;     %Totale


%% Calcolo la posizione dei centri di massa locali dei segmenti e totale
for iC=1:length(dataBTS.files)
    %%RIGHT 
    %Coscia (Right Thigh)
    dataBTS.walking(iC).coms.COM_RT=...
        calculate_com(dataBTS.walking(iC).markers.RGT,...
        dataBTS.walking(iC).markers.RLE,b.T); 
    %Gamba (Right Shank)
    dataBTS.walking(iC).coms.COM_RS=...
        calculate_com(dataBTS.walking(iC).markers.RLE,...
        dataBTS.walking(iC).markers.RLM,b.S); 
    %Piede (Right Foot)
    dataBTS.walking(iC).coms.COM_RF=...
        calculate_com(dataBTS.walking(iC).markers.RLM,...
        dataBTS.walking(iC).markers.RVM,b.F); 
    
    %%LEFT 
    %Coscia (Left Thigh)
    dataBTS.walking(iC).coms.COM_LT=...
        calculate_com(dataBTS.walking(iC).markers.LGT,...
        dataBTS.walking(iC).markers.LLE,b.T); 
    %Gamba (Left Shank)
    dataBTS.walking(iC).coms.COM_LS=...
        calculate_com(dataBTS.walking(iC).markers.LLE,...
        dataBTS.walking(iC).markers.LLM,b.S); 
    %Piede (Left Foot)
    dataBTS.walking(iC).coms.COM_LF=...
        calculate_com(dataBTS.walking(iC).markers.LLM,...
        dataBTS.walking(iC).markers.LVM,b.F); 
end

for iC=1:length(dataBTS.files)
    %marker virtuale PE (pelvis) 
    for i=1:length(dataBTS.walking(iC).markers.RGT) 
        dataBTS.walking(iC).markers.PE(i,:)=mean([dataBTS.walking(iC).markers.RGT(i,:);...
        dataBTS.walking(iC).markers.LGT(i,:)]);
    end

    %%TRONCO
    %Torace+addome
    dataBTS.walking(iC).coms.COM_TA=...
        calculate_com(dataBTS.walking(iC).markers.C7,...
        dataBTS.walking(iC).markers.L4,b.TA); 
    %Bacino
    dataBTS.walking(iC).coms.COM_P=...
        calculate_com(dataBTS.walking(iC).markers.L4,...
        dataBTS.walking(iC).markers.PE,b.P); 

    %%TOTAL
    dataBTS.walking(iC).COM_TOT=...
        calculate_total_com(dataBTS.walking(iC).coms,m);

end

%% PLOT 3D animate walking (funzione dedicata)
iC=2;
animate_walking(dataBTS.walking(iC).markers,dataBTS.walking(iC).coms,...
    dataBTS.walking(iC).COM_TOT)

% segmentare i dati tramite i Foot-Strike per estrarre due passi del cammino aS caricando nel codice BTS i dati APDM:
load('dataAPDM_TurnoC2.mat')

%% Ricampionamento e sincronizzazione dei segnali APDM e BTS
fs_APDM=128;
fs_BTS=60;

for iC=1:length(dataBTS.files)
    shank=dataBTS.walking(iC).markers.RLM-dataBTS.walking(iC).markers.RLE;
    foot=dataBTS.walking(iC).markers.RVM-dataBTS.walking(iC).markers.RLM;

    for i=1:length(shank)
        scalar_shank_foot(i)=((shank(i,:)*foot(i,:)'));
        shank_len(i)=(norm(shank(i,:)));
        foot_len(i)=(norm(foot(i,:)));
    end
    
    %CALCOLO L'ANGOLO COMPRESO
    dataBTS.walking(iC).r_ankle_angle=acos(...
        scalar_shank_foot./(shank_len.*foot_len));
    % ricampionare i dati BTS alla frequenza dei dati APDM:
    ankle_angle_BTS=resample(rad2deg(dataBTS.walking(iC).r_ankle_angle)...
        -90,fs_APDM,fs_BTS);
    ankle_angle_APDM=rad2deg(...
        dataAPDM.walking(iC).data.cin.theta_caviglia_dx);

    time_BTS=(0:(length(ankle_angle_BTS)-1))/fs_APDM;
    time_APDM=(0:(length(ankle_angle_APDM)-1))/fs_APDM;

    figure()
    plot(time_BTS,ankle_angle_BTS,'linewidth',2)
    hold on
    plot(time_APDM,ankle_angle_APDM,'linewidth',2)
    legend('BTS','APDM')
    xlabel('Time [s]','FontSize',20)
    ylabel('Angolo Caviglia [deg]','FontSize',18)
    set(gca,'fontsize',18)

    %BTS ha cominciato a registrare prima di APDM,
    input('Select cross correletion range and press RETURN when ready','s')
    
    %pause(40)

    %selezionare due data-tip (di inizio e fine) che individuano la finestra utile su cui operare cross-correlazione.
    %close all
    start_cross=(cursor_crosscorr(2).DataIndex);
    end_cross=(cursor_crosscorr(1).DataIndex);
    range_cross=start_cross:end_cross;
    
    %CALCOLO DEL RITARDO TRA I DUE SEGNALI RICAMPIONATI
    [xa,ya,delay]=alignsignals(ankle_angle_BTS(range_cross),...
        ankle_angle_APDM(range_cross));

    plot(ankle_angle_BTS(abs(delay)+1:end)-ankle_angle_BTS(abs(delay)))
    hold on
    plot(ankle_angle_APDM-nanmean(ankle_angle_APDM(1:100)))
    legend('BTS','APDM')

    dataBTS.walking(iC).delay=abs(delay)/fs_APDM;
    clear cursor_crosscorr
end


