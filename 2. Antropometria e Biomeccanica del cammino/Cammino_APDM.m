%% Esercitazione 12/04/2022

close all;
clear all;
clc;

addpath('functions_APDM\');
dataAPDM.data_path=uigetdir('select the directory with the data APDM');
dataAPDM.files=dir([dataAPDM.data_path filesep '*.csv']);
for iC=1:length(dataAPDM.files)
    dataAPDM.walking(iC).name = dataAPDM.files(iC).name;
    dataAPDM.walking(iC).data = loadDataGeneric_v2([dataAPDM.data_path filesep dataAPDM.walking(iC).name],',','DEVICE_ID');
end

%Coscia dx: sensore 583 
%Gamba dx: sensore 584
%Piede dx: sensore 693
%Coscia sx: sensore 510
%Gamba sx: sensore 512
%Piede sx: sensore 513

for i=1:length(dataAPDM.files)
    dataAPDM.walking(i).data.sensor_510.quat= ...
        [dataAPDM.walking(i).data.sensor_510.quat_0 ...
        dataAPDM.walking(i).data.sensor_510.quat_1 ...
        dataAPDM.walking(i).data.sensor_510.quat_2 ...
        dataAPDM.walking(i).data.sensor_510.quat_3];
    dataAPDM.walking(i).data.sensor_510.DCM= ...
    quat2dcm(dataAPDM.walking(i).data.sensor_510.quat);
end    

for i=1:length(dataAPDM.files)
    dataAPDM.walking(i).data.sensor_512.quat= ...
        [dataAPDM.walking(i).data.sensor_512.quat_0 ...
        dataAPDM.walking(i).data.sensor_512.quat_1 ...
        dataAPDM.walking(i).data.sensor_512.quat_2 ...
        dataAPDM.walking(i).data.sensor_512.quat_3];
    dataAPDM.walking(i).data.sensor_512.DCM= ...
    quat2dcm(dataAPDM.walking(i).data.sensor_512.quat);
end    

for i=1:length(dataAPDM.files)
    dataAPDM.walking(i).data.sensor_513.quat= ...
        [dataAPDM.walking(i).data.sensor_513.quat_0 ...
        dataAPDM.walking(i).data.sensor_513.quat_1 ...
        dataAPDM.walking(i).data.sensor_513.quat_2 ...
        dataAPDM.walking(i).data.sensor_513.quat_3];
    dataAPDM.walking(i).data.sensor_513.DCM= ...
    quat2dcm(dataAPDM.walking(i).data.sensor_513.quat);
end    

for i=1:length(dataAPDM.files)
    dataAPDM.walking(i).data.sensor_583.quat= ...
        [dataAPDM.walking(i).data.sensor_583.quat_0 ...
        dataAPDM.walking(i).data.sensor_583.quat_1 ...
        dataAPDM.walking(i).data.sensor_583.quat_2 ...
        dataAPDM.walking(i).data.sensor_583.quat_3];
    dataAPDM.walking(i).data.sensor_583.DCM= ...
    quat2dcm(dataAPDM.walking(i).data.sensor_583.quat);
end    

for i=1:length(dataAPDM.files)
    dataAPDM.walking(i).data.sensor_584.quat= ...
        [dataAPDM.walking(i).data.sensor_584.quat_0 ...
        dataAPDM.walking(i).data.sensor_584.quat_1 ...
        dataAPDM.walking(i).data.sensor_584.quat_2 ...
        dataAPDM.walking(i).data.sensor_584.quat_3];
    dataAPDM.walking(i).data.sensor_584.DCM= ...
    quat2dcm(dataAPDM.walking(i).data.sensor_584.quat);
end    

for i=1:length(dataAPDM.files)
    dataAPDM.walking(i).data.sensor_693.quat= ...
        [dataAPDM.walking(i).data.sensor_693.quat_0 ...
        dataAPDM.walking(i).data.sensor_693.quat_1 ...
        dataAPDM.walking(i).data.sensor_693.quat_2 ...
        dataAPDM.walking(i).data.sensor_693.quat_3];
    dataAPDM.walking(i).data.sensor_693.DCM= ...
    quat2dcm(dataAPDM.walking(i).data.sensor_693.quat);
end    

figure()
subplot(2,1,1)
plot(dataAPDM.walking(1).data.sensor_583.quat_0,'linewidth',2)
hold on
plot(dataAPDM.walking(1).data.sensor_583.quat_1,'linewidth',2)
plot(dataAPDM.walking(1).data.sensor_583.quat_2,'linewidth',2)
plot(dataAPDM.walking(1).data.sensor_583.quat_3,'linewidth',2)
legend('Quat0','Quat1','Quat2','Quat3')
title('Right Thigh Quaternions_w_1')
subplot(2,1,2)
plot(dataAPDM.walking(1).data.sensor_693.quat_0,'linewidth',2)
hold on
plot(dataAPDM.walking(1).data.sensor_693.quat_1,'linewidth',2)
plot(dataAPDM.walking(1).data.sensor_693.quat_2,'linewidth',2)
plot(dataAPDM.walking(1).data.sensor_693.quat_3,'linewidth',2)
title('Right Foot Quaternions_w_1')
legend('Quat0','Quat1','Quat2','Quat3')


%% ARTO DESTRO
for i=1:length(dataAPDM.files)
    % angolo della coscia destra: sensor 583
    for k=1:length(dataAPDM.walking(i).data.sensor_583.DCM)
        y_s_z=dataAPDM.walking(i).data.sensor_583.DCM(2,3,k); 
        x_s_z=dataAPDM.walking(i).data.sensor_583.DCM(1,3,k);
        dataAPDM.walking(i).data.sensor_583.theta(k)=atan2(-y_s_z,x_s_z);
    end

    % angolo della gamba destra: sensor 584
    for k=1:length(dataAPDM.walking(i).data.sensor_584.DCM)
        y_s_z=dataAPDM.walking(i).data.sensor_584.DCM(2,3,k);
        x_s_z=dataAPDM.walking(i).data.sensor_584.DCM(1,3,k);
        dataAPDM.walking(i).data.sensor_584.theta(k)=atan2(-y_s_z,x_s_z);
    end

    % angolo del piede destro: sensor 693
    for k=1:length(dataAPDM.walking(i).data.sensor_693.DCM)
        y_s_z=dataAPDM.walking(i).data.sensor_693.DCM(2,3,k);
        x_s_z=dataAPDM.walking(i).data.sensor_693.DCM(1,3,k);
        dataAPDM.walking(i).data.sensor_693.theta(k)=atan2(-y_s_z,x_s_z);

        % Heel Strike e Toe Off tramite picco di accelerazione del sensore del piede 
        acc_x=dataAPDM.walking(i).data.sensor_693.acc_x_si(k);
        acc_y=dataAPDM.walking(i).data.sensor_693.acc_y_si(k);
        dataAPDM.walking(i).data.sensor_693.acc_xy(k)=norm([acc_x acc_y]);
    end
end

figure()
plot(rad2deg(dataAPDM.walking(1).data.sensor_583.theta))
hold on
plot(rad2deg(dataAPDM.walking(1).data.sensor_584.theta))
plot(rad2deg(dataAPDM.walking(1).data.sensor_693.theta))
title('Right Lower Limb Angles_w_1','linewidth',1.5,'FontSize',18)
legend('Right Thigh','Right Leg','Right Foot','location','best')

%% ARTO SINISTRO
for i=1:length(dataAPDM.files)
    % angolo della coscia sinistra: sensor 510
    for k=1:length(dataAPDM.walking(i).data.sensor_510.DCM)
        y_s_z=dataAPDM.walking(i).data.sensor_510.DCM(2,3,k);
        x_s_z=dataAPDM.walking(i).data.sensor_510.DCM(1,3,k);
        dataAPDM.walking(i).data.sensor_510.theta(k)=atan2(y_s_z,x_s_z);
    end

    % angolo della gamba sinistra: sensor 512
    for k=1:length(dataAPDM.walking(i).data.sensor_512.DCM)
        y_s_z=dataAPDM.walking(i).data.sensor_512.DCM(2,3,k);
        x_s_z=dataAPDM.walking(i).data.sensor_512.DCM(1,3,k);
        dataAPDM.walking(i).data.sensor_512.theta(k)=atan2(y_s_z,x_s_z);
    end

    % angolo del piede sinistro: sensor 513
    for k=1:length(dataAPDM.walking(i).data.sensor_513.DCM)
        y_s_z=dataAPDM.walking(i).data.sensor_513.DCM(2,3,k);
        x_s_z=dataAPDM.walking(i).data.sensor_513.DCM(1,3,k);
        dataAPDM.walking(i).data.sensor_513.theta(k)=atan2(y_s_z,x_s_z);

        % Heel Strike e Toe Off tramite picco di accelerazione del sensore del piede 
        acc_x=dataAPDM.walking(i).data.sensor_513.acc_x_si(k);
        acc_y=dataAPDM.walking(i).data.sensor_513.acc_y_si(k);
        dataAPDM.walking(i).data.sensor_513.acc_xy(k)=norm([acc_x acc_y]);
    end
end

figure()
plot(rad2deg(dataAPDM.walking(1).data.sensor_583.theta))
hold on
plot(rad2deg(dataAPDM.walking(1).data.sensor_584.theta))
plot(rad2deg(dataAPDM.walking(1).data.sensor_693.theta))
title('Left Lower Limb Angles_w_1','linewidth',1.5,'FontSize',18)
legend('Left Thigh','Left Leg','Left Foot','location','best')


%% Plot degli angoli theta dei link sovrapponendo per ciascuno dx e sx:
%coscia destra e sinistra 
figure()
plot(rad2deg(dataAPDM.walking(1).data.sensor_510.theta),'linewidth',2)
hold on
plot(rad2deg(dataAPDM.walking(1).data.sensor_583.theta),'linewidth',2)
title('Right and Left Thigh Theta_w_1','FontSize',20)
legend('Left Thigh','Right Thigh','location','northeast')
set(gca,'fontsize',18)

%gamba destra e sinistra
figure()
plot(rad2deg(dataAPDM.walking(1).data.sensor_512.theta),'linewidth',2)
hold on
plot(rad2deg(dataAPDM.walking(1).data.sensor_584.theta),'linewidth',2)
title('Right and Left Leg Theta_w_1','FontSize',20)
legend('Left Leg','Right Leg','location','northwest')
set(gca,'fontsize',18)

%piede destro e sinistro
figure()
plot(rad2deg(dataAPDM.walking(1).data.sensor_513.theta),'linewidth',2)
hold on
plot(rad2deg(dataAPDM.walking(1).data.sensor_693.theta),'linewidth',2)
title('Right and Left Foot Theta_w_1','FontSize',20)
legend('Left Foot','Right Foot','location','northwest')
set(gca,'fontsize',18)

%% Tolgliere offset iniziale: 
for i=1:length(dataAPDM.files)

    %MODO 1
    %plot(dataAPDM.walking(i).data.sensor_513.acc_x_si)
    %hold on
    %plot(dataAPDM.walking(i).data.sensor_513.acc_y_si)
    %plot(dataAPDM.walking(i).data.sensor_513.acc_z_si)

    %MODO 2
    figure()
    subplot(6,1,1)
    plot([dataAPDM.walking(i).data.sensor_510.acc_x_si ...
        dataAPDM.walking(i).data.sensor_510.acc_y_si...
        dataAPDM.walking(i).data.sensor_510.acc_z_si])
    subplot(6,1,2)
    plot([dataAPDM.walking(i).data.sensor_512.acc_x_si ...
        dataAPDM.walking(i).data.sensor_512.acc_y_si...
        dataAPDM.walking(i).data.sensor_512.acc_z_si])
    subplot(6,1,3)
    plot([dataAPDM.walking(i).data.sensor_513.acc_x_si ...
        dataAPDM.walking(i).data.sensor_513.acc_y_si...
        dataAPDM.walking(i).data.sensor_513.acc_z_si])
    subplot(6,1,4)
    plot([dataAPDM.walking(i).data.sensor_583.acc_x_si ...
        dataAPDM.walking(i).data.sensor_583.acc_y_si...
        dataAPDM.walking(i).data.sensor_583.acc_z_si])
    subplot(6,1,5)
    plot([dataAPDM.walking(i).data.sensor_584.acc_x_si ...
        dataAPDM.walking(i).data.sensor_584.acc_y_si...
        dataAPDM.walking(i).data.sensor_584.acc_z_si])
    subplot(6,1,6)
    plot([dataAPDM.walking(i).data.sensor_693.acc_x_si ...
        dataAPDM.walking(i).data.sensor_693.acc_y_si...
        dataAPDM.walking(i).data.sensor_693.acc_z_si])

    [x,y]=ginput(1);
    dataAPDM.walking(i).data.it0=round(x);
end

%% Calcolare angoli di giunto

for i=1:length(dataAPDM.files)
    sample_in=dataAPDM.walking(i).data.it0;

    %ANCA
    dataAPDM.walking(i).data.cin.theta_anca_dx=...
        dataAPDM.walking(i).data.sensor_583.theta-...
        dataAPDM.walking(i).data.sensor_583.theta(sample_in);
    dataAPDM.walking(i).data.cin.theta_anca_sx=...
        dataAPDM.walking(i).data.sensor_510.theta-...
        dataAPDM.walking(i).data.sensor_510.theta(sample_in);

    %GINOCCHIO
    dataAPDM.walking(i).data.cin.theta_ginocchio_dx=...
        (dataAPDM.walking(i).data.sensor_583.theta-...
        dataAPDM.walking(i).data.sensor_583.theta(sample_in))-...
        (dataAPDM.walking(i).data.sensor_584.theta-...
        dataAPDM.walking(i).data.sensor_584.theta(sample_in));
    dataAPDM.walking(i).data.cin.theta_ginocchio_sx=...
        (dataAPDM.walking(i).data.sensor_510.theta-...
        dataAPDM.walking(i).data.sensor_510.theta(sample_in))-...
        (dataAPDM.walking(i).data.sensor_512.theta-...
        dataAPDM.walking(i).data.sensor_512.theta(sample_in));

    %CAVIGLIA
    dataAPDM.walking(i).data.cin.theta_caviglia_dx=...
        (dataAPDM.walking(i).data.sensor_693.theta-...
        dataAPDM.walking(i).data.sensor_693.theta(sample_in))-...
        (dataAPDM.walking(i).data.sensor_584.theta-...
        dataAPDM.walking(i).data.sensor_584.theta(sample_in));
    dataAPDM.walking(i).data.cin.theta_caviglia_sx=...
        (dataAPDM.walking(i).data.sensor_513.theta-...
        dataAPDM.walking(i).data.sensor_513.theta(sample_in))-...
        (dataAPDM.walking(i).data.sensor_512.theta-...
        dataAPDM.walking(i).data.sensor_512.theta(sample_in));
end   

%Plot theta anca dx e sx allineati
figure()
plot(dataAPDM.walking(1).data.cin.theta_anca_dx,'linewidth',2)
hold on
plot(dataAPDM.walking(1).data.cin.theta_anca_sx,'linewidth',2)
title('Right and Left Hip Theta_w_1','fontsize',18)
ylabel('Angles [deg]')
xlabel('Sample')
xline(sample_in,'k','linewidth',3)
set(gca,'fontsize',18)

%Plot theta ginocchio dx e sx allineati
figure()
plot(dataAPDM.walking(1).data.cin.theta_ginocchio_dx,'linewidth',2)
hold on
plot(dataAPDM.walking(1).data.cin.theta_ginocchio_sx,'linewidth',2)
title('Right and Left Knee Theta_w_1','fontsize',18)
ylabel('Angles [deg]')
xlabel('Sample')
xline(sample_in,'k','linewidth',3)
set(gca,'fontsize',18)

%Plot theta caviglia dx e sx allineati
figure()
plot(dataAPDM.walking(1).data.cin.theta_caviglia_dx,'linewidth',2)
hold on
plot(dataAPDM.walking(1).data.cin.theta_caviglia_sx,'linewidth',2)
title('Right and Left Ankle Theta_w_1','fontsize',18)
ylabel('Angles [deg]')
xlabel('Sample')
xline(sample_in,'k','linewidth',3)
set(gca,'fontsize',18)


%% Estrazione picchi di accelerazione: istanti di Foot Strike
for i=1:length(dataAPDM.files)
    
    %Foot Strike dx
    plot(dataAPDM.walking(i).data.sensor_693.acc_xy,'LineWidth',2)
    hold on
    plot(rad2deg(dataAPDM.walking(i).data.cin.theta_ginocchio_dx),'LineWidth',1.5)
    title(['Accelerazione del piede destro della prova' num2str(i)],'fontsize', 18)
    set(gcf,'windowstate','maximize');
    
    pause(40)
    
    dataAPDM.walking(i).data.cin.footstrike_dx=...
        sort([footstrike_dx.DataIndex]);
       
    input('...press RETURN when ready...','s');    
    clear footstrike_dx

    %Foot Strike sx
    plot(dataAPDM.walking(i).data.sensor_513.acc_xy, 'linewidth', 2)
    hold on
    plot(rad2deg(dataAPDM.walking(i).data.cin.theta_ginocchio_sx),...
        'linewidth', 1.5)
    title(['Accelerazione del piede sinistro della prova' num2str(i)],...
        'fontsize', 18)
    set(gcf,'windowstate','maximize');
   
    pause(40)
    
    input('...press RETURN when ready...','s');
    dataAPDM.walking(i).data.cin.footstrike_sx=...
        sort([footstrike_sx.DataIndex]);
    clear footstrike_sx
end

%% Selezionare cicli del passo (estrazione dei 2 passi di nostro interesse): 

for i=1:length(dataAPDM.files)

    %%%ARTO DESTRO
    %%Passo 1: distanza tra il primo e il secondo appoggio destro
    %ANCA
    dataAPDM.walking(i).data.cin.passo1.theta_anca_dx=...
        dataAPDM.walking(i).data.cin.theta_anca_dx(...
        dataAPDM.walking(i).data.cin.footstrike_dx(1):...
        dataAPDM.walking(i).data.cin.footstrike_dx(2));
    
    %GINOCCHIO
    dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_dx=...
        dataAPDM.walking(i).data.cin.theta_ginocchio_dx(...
        dataAPDM.walking(i).data.cin.footstrike_dx(1):...
        dataAPDM.walking(i).data.cin.footstrike_dx(2));

    %CAVIGLIA
    dataAPDM.walking(i).data.cin.passo1.theta_caviglia_dx=...
    dataAPDM.walking(i).data.cin.theta_caviglia_dx(...
    dataAPDM.walking(i).data.cin.footstrike_dx(1):...
    dataAPDM.walking(i).data.cin.footstrike_dx(2));

    %%Passo 2: distanza tra il secondo e il terzo appoggio destro
    %ANCA
    dataAPDM.walking(i).data.cin.passo2.theta_anca_dx=...
        dataAPDM.walking(i).data.cin.theta_anca_dx(...
        dataAPDM.walking(i).data.cin.footstrike_dx(2):...
        dataAPDM.walking(i).data.cin.footstrike_dx(3));
    
    %GINOCCHIO
    dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_dx=...
        dataAPDM.walking(i).data.cin.theta_ginocchio_dx(...
        dataAPDM.walking(i).data.cin.footstrike_dx(2):...
        dataAPDM.walking(i).data.cin.footstrike_dx(3));

    %CAVIGLIA
    dataAPDM.walking(i).data.cin.passo2.theta_caviglia_dx=...
    dataAPDM.walking(i).data.cin.theta_caviglia_dx(...
    dataAPDM.walking(i).data.cin.footstrike_dx(2):...
    dataAPDM.walking(i).data.cin.footstrike_dx(3));

    %%%ARTO SINISTRO
    %%Passo 1: distanza tra il primo e il secondo appoggio sinistro
    %ANCA
    dataAPDM.walking(i).data.cin.passo1.theta_anca_sx=...
        dataAPDM.walking(i).data.cin.theta_anca_sx(...
        dataAPDM.walking(i).data.cin.footstrike_sx(1):...
        dataAPDM.walking(i).data.cin.footstrike_sx(2));
    
    %GINOCCHIO
    dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_sx=...
        dataAPDM.walking(i).data.cin.theta_ginocchio_sx(...
        dataAPDM.walking(i).data.cin.footstrike_sx(1):...
        dataAPDM.walking(i).data.cin.footstrike_sx(2));

    %CAVIGLIA
    dataAPDM.walking(i).data.cin.passo1.theta_caviglia_sx=...
    dataAPDM.walking(i).data.cin.theta_caviglia_sx(...
    dataAPDM.walking(i).data.cin.footstrike_sx(1):...
    dataAPDM.walking(i).data.cin.footstrike_sx(2));

    %%Passo 2: distanza tra il primo appoggio sinistro
    %ANCA
    dataAPDM.walking(i).data.cin.passo2.theta_anca_sx=...
        dataAPDM.walking(i).data.cin.theta_anca_sx(...
        dataAPDM.walking(i).data.cin.footstrike_sx(2):...
        dataAPDM.walking(i).data.cin.footstrike_sx(3));
    
    %GINOCCHIO
    dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_sx=...
        dataAPDM.walking(i).data.cin.theta_ginocchio_sx(...
        dataAPDM.walking(i).data.cin.footstrike_sx(2):...
        dataAPDM.walking(i).data.cin.footstrike_sx(3));

    %CAVIGLIA
    dataAPDM.walking(i).data.cin.passo2.theta_caviglia_sx=...
    dataAPDM.walking(i).data.cin.theta_caviglia_sx(...
    dataAPDM.walking(i).data.cin.footstrike_sx(2):...
    dataAPDM.walking(i).data.cin.footstrike_sx(3));

end


for i=1:length(dataAPDM.files)
    %Minimo tra la lunghezza del passo 1 e 2 dell'arto destro
    L_passi_dx(i)=min([...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_dx)...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_dx)]);
    
    %Minimo tra la lunghezza passo 1 e 2 dell'arto sinistro
    L_passi_sx(i)=min([...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_sx)...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_sx)]);  
end    

passo_dx_min=min(L_passi_dx);
passo_sx_min=min(L_passi_sx);
passo_min=min([passo_dx_min passo_sx_min]);
    
%% Comfortable
for i=1:length(dataAPDM.files)/3
    %%%ARTO DESTRO
    %%PASSO 1 
    %Anca 
    dataAPDM.comf.theta_anca(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_anca_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_dx),0)
    %Ginocchio 
    dataAPDM.comf.theta_ginocchio(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_dx),0)
    %Caviglia
    dataAPDM.comf.theta_caviglia(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_caviglia_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_caviglia_dx),0)
    %%PASSO 2 
    %Anca 
    dataAPDM.comf.theta_anca(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_anca_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_dx),0)
    %Ginocchio 
    dataAPDM.comf.theta_ginocchio(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_dx),0)
    %Caviglia 
    dataAPDM.comf.theta_caviglia(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_caviglia_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_caviglia_dx),0)
    
    %%%ARTO SINISTRO
    %%PASSO 1 
    %Anca 
    dataAPDM.comf.theta_anca(i+6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_anca_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_sx),0)
    %Ginocchio 
    dataAPDM.comf.theta_ginocchio(i+6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_sx),0)
    %Caviglia
    dataAPDM.comf.theta_caviglia(i+6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_caviglia_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_caviglia_sx),0)
    %%PASSO 2 
    %Anca 
    dataAPDM.comf.theta_anca(i+9,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_anca_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_sx),0)
    %Ginocchio 
    dataAPDM.comf.theta_ginocchio(i+9,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_sx),0)
    %Caviglia 
    dataAPDM.comf.theta_caviglia(i+9,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_caviglia_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_caviglia_sx),0)
    
end
    
%% Slow
for i=(1+length(dataAPDM.files)/3):2*length(dataAPDM.files)/3
    %%%ARTO DESTRO
    %%PASSO 1 
    %Anca 
    dataAPDM.slow.theta_anca(i-3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_anca_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_dx),0)
    %Ginocchio 
    dataAPDM.slow.theta_ginocchio(i-3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_dx),0)
    %Caviglia
    dataAPDM.slow.theta_caviglia(i-3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_caviglia_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_caviglia_dx),0)
    %%PASSO 2 
    %Anca 
    dataAPDM.slow.theta_anca(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_anca_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_dx),0)
    %Ginocchio 
    dataAPDM.slow.theta_ginocchio(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_dx),0)
    %Caviglia 
    dataAPDM.slow.theta_caviglia(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_caviglia_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_caviglia_dx),0)
    
    %%%ARTO SINISTRO
    %%PASSO 1 
    %Anca 
    dataAPDM.slow.theta_anca(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_anca_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_sx),0);
    %Ginocchio 
    dataAPDM.slow.theta_ginocchio(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_sx),0)
    %Caviglia
    dataAPDM.slow.theta_caviglia(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_caviglia_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_caviglia_sx),0)
    %%PASSO 2 
    %Anca 
    dataAPDM.slow.theta_anca(i+6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_anca_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_sx),0)
    %Ginocchio 
    dataAPDM.slow.theta_ginocchio(i+6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_sx),0)
    %Caviglia 
    dataAPDM.slow.theta_caviglia(i+6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_caviglia_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_caviglia_sx),0)
    
end

%% Fast
for i=(1+2*(length(dataAPDM.files)/3)):length(dataAPDM.files)
    %%%ARTO DESTRO
    %%PASSO 1 
    %Anca 
    dataAPDM.fast.theta_anca(i-6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_anca_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_dx),0)
    %Ginocchio 
    dataAPDM.fast.theta_ginocchio(i-6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_dx),0)
    %Caviglia
    dataAPDM.fast.theta_caviglia(i-6,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_caviglia_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_caviglia_dx),0)
    %%PASSO 2 
    %Anca 
    dataAPDM.fast.theta_anca(i-3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_anca_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_dx),0)
    %Ginocchio 
    dataAPDM.fast.theta_ginocchio(i-3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_dx),0)
    %Caviglia 
    dataAPDM.fast.theta_caviglia(i-3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_caviglia_dx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_caviglia_dx),0)
    
    %%%ARTO SINISTRO
    %%PASSO 1 
    %Anca 
    dataAPDM.fast.theta_anca(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_anca_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_anca_sx),0)
    %Ginocchio 
    dataAPDM.fast.theta_ginocchio(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_ginocchio_sx),0)
    %Caviglia
    dataAPDM.fast.theta_caviglia(i,:)=resample(...
        dataAPDM.walking(i).data.cin.passo1.theta_caviglia_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo1.theta_caviglia_sx),0)
    %%PASSO 2 
    %Anca 
    dataAPDM.fast.theta_anca(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_anca_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_anca_sx),0)
    %Ginocchio 
    dataAPDM.fast.theta_ginocchio(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_ginocchio_sx),0)
    %Caviglia 
    dataAPDM.fast.theta_caviglia(i+3,:)=resample(...
        dataAPDM.walking(i).data.cin.passo2.theta_caviglia_sx,passo_min,...
        length(dataAPDM.walking(i).data.cin.passo2.theta_caviglia_sx),0)
    
end

%% MEDIA
%Confortable
dataAPDM.comf.theta_anca_media=mean(dataAPDM.comf.theta_anca);
dataAPDM.comf.theta_ginocchio_media=mean(dataAPDM.comf.theta_ginocchio);
dataAPDM.comf.theta_caviglia_media=mean(dataAPDM.comf.theta_caviglia);

%Slow
dataAPDM.slow.theta_anca_media=mean(dataAPDM.slow.theta_anca);
dataAPDM.slow.theta_ginocchio_media=mean(dataAPDM.slow.theta_ginocchio);
dataAPDM.slow.theta_caviglia_media=mean(dataAPDM.slow.theta_caviglia);

%Fast
dataAPDM.fast.theta_anca_media=mean(dataAPDM.fast.theta_anca);
dataAPDM.fast.theta_ginocchio_media=mean(dataAPDM.fast.theta_ginocchio);
dataAPDM.fast.theta_caviglia_media=mean(dataAPDM.fast.theta_caviglia);


%% Subplot dei theta con la rispettiva media
figure()
subplot(3,3,1)
plot(rad2deg(dataAPDM.comf.theta_anca'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.comf.theta_anca_media'),'k','linewidth',3)
ylabel('Theta Ankle','fontsize',14)
title('Confortable','FontSize',20)
set(gca,'fontsize',14)

subplot(3,3,4)
plot(rad2deg(dataAPDM.comf.theta_ginocchio'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.comf.theta_ginocchio_media'),'k','linewidth',3)
ylabel('Theta Knee [deg]','fontsize',14)
set(gca,'fontsize',14)

subplot(3,3,7)
plot(rad2deg(dataAPDM.comf.theta_caviglia'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.comf.theta_caviglia_media'),'k','linewidth',3)
ylabel('Theta Hip','fontsize',14)
set(gca,'fontsize',14)

subplot(3,3,2)
plot(rad2deg(dataAPDM.slow.theta_anca'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.slow.theta_anca_media'),'k','linewidth',3)
title('Slow','FontSize',20)
set(gca,'fontsize',14)

subplot(3,3,5)
plot(rad2deg(dataAPDM.slow.theta_ginocchio'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.slow.theta_ginocchio_media'),'k','linewidth',3)
set(gca,'fontsize',14)

subplot(3,3,8)
plot(rad2deg(dataAPDM.slow.theta_caviglia'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.slow.theta_caviglia_media'),'k','linewidth',3)
xlabel('Sample')
set(gca,'fontsize',14)

subplot(3,3,3)
plot(rad2deg(dataAPDM.fast.theta_anca'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.fast.theta_anca_media'),'k','linewidth',3)
title('Fast','FontSize',20)
set(gca,'fontsize',14)

subplot(3,3,6)
plot(rad2deg(dataAPDM.fast.theta_ginocchio'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.fast.theta_ginocchio_media'),'k','linewidth',3)
set(gca,'fontsize',14)

subplot(3,3,9)
plot(rad2deg(dataAPDM.fast.theta_caviglia'),'LineWidth',0.5)
hold on
plot(rad2deg(dataAPDM.fast.theta_caviglia_media'),'k','linewidth',3)
set(gca,'fontsize',14)

%% DEVIAZIONE STANDARD
%Confortable
dataAPDM.comf.theta_anca_std=std(dataAPDM.comf.theta_anca);
dataAPDM.comf.theta_ginocchio_std=std(dataAPDM.comf.theta_ginocchio);
dataAPDM.comf.theta_caviglia_std=std(dataAPDM.comf.theta_caviglia);

%Slow
dataAPDM.slow.theta_anca_std=std(dataAPDM.slow.theta_anca);
dataAPDM.slow.theta_ginocchio_std=std(dataAPDM.slow.theta_ginocchio);
dataAPDM.slow.theta_caviglia_std=std(dataAPDM.slow.theta_caviglia);

%Fast
dataAPDM.fast.theta_anca_std=std(dataAPDM.fast.theta_anca);
dataAPDM.fast.theta_ginocchio_std=std(dataAPDM.fast.theta_ginocchio);
dataAPDM.fast.theta_caviglia_std=std(dataAPDM.fast.theta_caviglia);


%% Plot theta medio con la sua deviazione standard (positiva e negativa):
%%Confortable
%THETA ANCA
figure()
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.comf.theta_anca_media'),'linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.comf.theta_anca_media+...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.comf.theta_anca_media-...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
xlabel('Gait Cycle [%]')
ylabel('Theta Ankle [deg]') 
title('Flesso-Estensione dell Anca (mean±std)')

%THETA GINOCCHIO
figure()
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.comf.theta_ginocchio_media'),'linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.comf.theta_ginocchio_media+...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.comf.theta_ginocchio_media-...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
xlabel('Gait Cycle [%]')
ylabel('Theta ginocchio [deg]')  
title('Flesso-Estensione del Ginocchio (mean±std)')

%THETA CAVIGLIA
figure()
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.comf.theta_caviglia_media'),'linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.comf.theta_caviglia_media+...
    dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.comf.theta_caviglia_media...
    -dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
xlabel('Gait Cycle [%]')
ylabel('Theta caviglia [deg]') 
title('Dorsi-Plantar Flessione della Caviglia (mean±std)')

%% Subplot 3x3
%Per confrontare i grafici ottenuti per ogni giunto ad ogni velocità
figure()
subplot(3,3,1)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.comf.theta_anca_media'),'k','linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.comf.theta_anca_media+...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.comf.theta_anca_media-...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
ylabel('Theta Ankle')
title('Confortable','FontSize',20)
set(gca,'fontsize',14)

subplot(3,3,4)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.comf.theta_ginocchio_media'),...
    'k','linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.comf.theta_ginocchio_media+...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.comf.theta_ginocchio_media-...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
ylabel('Theta Knee [deg]')
set(gca,'fontsize',14)

subplot(3,3,7)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.comf.theta_caviglia_media'),...
    'k','linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.comf.theta_caviglia_media+...
    dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.comf.theta_caviglia_media...
    -dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
ylabel('Theta Hip')
set(gca,'fontsize',14)

subplot(3,3,2)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.slow.theta_anca_media'),'k','linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.slow.theta_anca_media+...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.slow.theta_anca_media-...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
title('Slow','FontSize',20)
set(gca,'fontsize',14)

subplot(3,3,5)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.slow.theta_ginocchio_media'),...
    'k','linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.slow.theta_ginocchio_media+...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.slow.theta_ginocchio_media-...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
set(gca,'fontsize',14)

subplot(3,3,8)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.slow.theta_caviglia_media'),...
    'k','linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.slow.theta_caviglia_media+...
    dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.slow.theta_caviglia_media...
    -dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
xlabel('Gait Cycle [%]')
set(gca,'fontsize',14)

subplot(3,3,3)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.fast.theta_anca_media'),'k','linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.fast.theta_anca_media+...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.fast.theta_anca_media-...
    dataAPDM.comf.theta_anca_std),'linewidth',1.5)
title('Fast','FontSize',20)
legend('Media','Std(+)','Std(-)','location','north')
set(gca,'fontsize',14)

subplot(3,3,6)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.fast.theta_ginocchio_media'),'k',...
    'linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.fast.theta_ginocchio_media+...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.fast.theta_ginocchio_media-...
    dataAPDM.comf.theta_ginocchio_std),'linewidth',1.5)
set(gca,'fontsize',14)

subplot(3,3,9)
axis_perc=linspace(0,100,passo_min);
plot(axis_perc,rad2deg(dataAPDM.fast.theta_caviglia_media'),'k',...
    'linewidth',3)
hold on
plot(axis_perc,rad2deg(dataAPDM.fast.theta_caviglia_media+...
    dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
plot(axis_perc,rad2deg(dataAPDM.fast.theta_caviglia_media...
    -dataAPDM.comf.theta_caviglia_std),'linewidth',1.5)
set(gca,'fontsize',14)