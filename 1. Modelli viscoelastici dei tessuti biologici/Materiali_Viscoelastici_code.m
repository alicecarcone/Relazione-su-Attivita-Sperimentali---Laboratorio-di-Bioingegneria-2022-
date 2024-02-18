%% 1. MATERIALI VISCOELASTICI


load('data_turnoA');
minimum = min;
clear min;
%% Precondizionamento prova 1, 2, 3
spostamento_prec1=data_prec1(:,1);
tempo_prec1=data_prec1(:,4);
forza_prec1=data_prec1(:,2);

spostamento_prec2=data_prec2(:,1);
tempo_prec2=data_prec2(:,4);
forza_prec2=data_prec2(:,2);

spostamento_prec3=data_prec3(:,1);
tempo_prec3=data_prec3(:,4);
forza_prec3=data_prec3(:,2);

%plot(tempo_prec1,spostamento_prec1)
%plot(tempo_prec1,forza_prec1);
%plot(spostamento_prec1,forza_prec1);

plot(tempo_prec1,spostamento_prec1)
hold on
plot(tempo_prec2,spostamento_prec2)
plot(tempo_prec3,spostamento_prec3)


%% Rilassamento: ingresso->gradino di spostamento, uscita->forza 
tempo_ril=data_ril(:,4); 
spostamento_ril=data_ril(:,1); 
forza_ril=data_ril(:,2);
deformazione_ril=data_ril(:,11); 
sforzo_ril=data_ril(:,3);

plot(tempo_ril,spostamento_ril);


%% Rottura
tempo_rott=data_rott(:,4); 
spostamento_rott=data_rott(:,1); 
forza_rott=data_rott(:,2);
deformazione_rott=data_rott(:,11);
sforzo_rott=data_rott(:,3);

plot(tempo_rott,spostamento_rott)


%% Grafici isteresi precondizionamenti: plot(spostamento,forza)
plot(spostamento_prec1,forza_prec1,'linewidth',1);
hold on
plot(spostamento_prec2,forza_prec2,'linewidth',1);
plot(spostamento_prec3,forza_prec3,'linewidth',1);
legend('Precondizionamento 1','Precondizionamento 2','Precondizionamento 3','Location','best')
xlabel('Spostamento [mm]','fontsize',18)
ylabel('Forza [N]','FontSize',18)
grid on
set(gca,'fontsize',18)


%% Test di Isteresi
%precondizionamento 1
N=10;
indice_ciclo1=data_prec1(:,5);
plot(indice_ciclo1);

for j=1:N;
    k=1;
    for i=1:length(data_prec1);
        if j==indice_ciclo1(i)+1
            spostamento_prec1_cicli(k,j)=spostamento_prec1(i);
            forza_prec1_cicli(k,j)=forza_prec1(i);
            k=k+1;
        end
    end
end

% plot(spostamento_prec1_cicli);
% plot(forza_prec1_cicli);
% xlabel('spostamento [mm]',"FontSize",20);
% ylabel('forza [N]', "FontSize",20);
% 
% plot(spostamento_prec1_cicli(:,6:10));
% plot(forza_prec1_cicli(:,6:10));

spostamento_prec1_cicli_mean=mean(spostamento_prec1_cicli(:,6:10),2);
forza_prec1_cicli_mean=mean(forza_prec1_cicli(:,6:10),2);

plot(spostamento_prec1_cicli,forza_prec1_cicli)
hold on
plot(spostamento_prec1_cicli_mean,forza_prec1_cicli_mean, 'Color','k', LineWidth=3);


%precondizionamento 2
indice_ciclo2=data_prec2(:,5);
%plot(indice_ciclo2);
for j=1:N;
    k=1;
    for i=1:length(data_prec2);
        if j==indice_ciclo2(i)+1
            spostamento_prec2_cicli(k,j)=spostamento_prec2(i);
            forza_prec2_cicli(k,j)=forza_prec2(i);
            k=k+1;
        end
    end
end

% plot(spostamento_prec2_cicli);
% plot(forza_prec2_cicli);
% xlabel('spostamento [mm]',"FontSize",20);
% ylabel('forza [N]', "FontSize",20);
% 
% plot(spostamento_prec2_cicli(:,6:10),forza_prec2_cicli(:,6:10));

spostamento_prec2_cicli_mean=mean(spostamento_prec2_cicli(:,6:10),2);
forza_prec2_cicli_mean=mean(forza_prec2_cicli(:,6:10),2);

plot(spostamento_prec2_cicli,forza_prec2_cicli)
hold on
plot(spostamento_prec2_cicli_mean,forza_prec2_cicli_mean, 'Color','k', LineWidth=3);

%precondizionamento 3
indice_ciclo3=data_prec3(:,5);
%plot(indice_ciclo3);
for j=1:N;
    k=1;
    for i=1:length(data_prec3);
        if j==indice_ciclo3(i)+1
            spostamento_prec3_cicli(k,j)=spostamento_prec3(i);
            forza_prec3_cicli(k,j)=forza_prec3(i);
            k=k+1;
        end
    end
end
% plot(spostamento_prec3_cicli);
% plot(forza_prec3_cicli);
% xlabel('spostamento [mm]',"FontSize",20);
% ylabel('forza [N]', "FontSize",20);
% 
% plot(spostamento_prec3_cicli(:,6:10));
% plot(forza_prec3_cicli(:,6:10));

spostamento_prec3_cicli_mean=mean(spostamento_prec3_cicli(:,6:10),2);
forza_prec3_cicli_mean=mean(forza_prec3_cicli(:,6:10),2);

plot(spostamento_prec3_cicli,forza_prec3_cicli)
hold on
plot(spostamento_prec3_cicli_mean,forza_prec3_cicli_mean, 'Color','k', LineWidth=3);


plot(spostamento_prec1_cicli_mean,forza_prec1_cicli_mean);
hold on
plot(spostamento_prec2_cicli_mean,forza_prec2_cicli_mean);
plot(spostamento_prec3_cicli_mean,forza_prec3_cicli_mean);
legend('Prova1','Prova2','Prova3','Location','best')

% annullare offset iniziale della forza + calcolare energia dissipata
x_prec1=spostamento_prec1_cicli_mean-spostamento_prec1_cicli_mean(1);
y_prec1=forza_prec1_cicli_mean-forza_prec1_cicli_mean(1);
plot(x_prec1(1:end/2),y_prec1(1:end/2)); 
hold on
plot(x_prec1(end/2+1:end),y_prec1(end/2+1:end));
isteresi_prec1=trapz(x_prec1(1:end/2),y_prec1(1:end/2))-trapz(x_prec1(end/2+1:end),y_prec1(end/2+1:end)); %energia dissipata

x_prec2=spostamento_prec2_cicli_mean-spostamento_prec2_cicli_mean(1);
y_prec2=forza_prec2_cicli_mean-forza_prec2_cicli_mean(1);
plot(x_prec2(1:end/2),y_prec2(1:end/2));
hold on
plot(x_prec2(end/2+1:end),y_prec2(end/2+1:end));
isteresi_prec2=trapz(x_prec2(1:end/2),y_prec2(1:end/2))-trapz(x_prec2(end/2+1:end),y_prec2(end/2+1:end)); %energia dissipata

x_prec3=spostamento_prec3_cicli_mean-spostamento_prec3_cicli_mean(1);
y_prec3=forza_prec3_cicli_mean-forza_prec3_cicli_mean(1);
plot(x_prec3(1:end/2),y_prec3(1:end/2));
hold on
plot(x_prec3(end/2+1:end),y_prec3(end/2+1:end));
isteresi_prec3=trapz(x_prec3(1:end/2),y_prec3(1:end/2))-trapz(x_prec3(end/2+1:end),y_prec3(end/2+1:end)); %energia dissipata


figure
bar([isteresi_prec1,isteresi_prec2,isteresi_prec3]);
set(gca,'fontsize',18);
xlabel('numero prova','FontSize',18);
ylabel('isteresi [J]','fontsize',18);
grid on

% verifico che l'inversione presa a metà sia corretta
subplot(2,1,1)
plot(x_prec1)
subplot(2,1,2)
v_prec1=diff(x_prec1)/0.01;
plot(abs(v_prec1))
grid on

[min2,index]=min(abs(v_prec1(round(end/2-10):round(end/2+10))));

figure
plot(deformazione_rott,sforzo_rott,'linewidth',2)
set(gca,'Fontsize',18)
xlabel('Deformazione [%]')
ylabel('Sforzo [MPa]')
title('Curva Sforzo-Deformazione')
grid on


%% Test di Rottura
lin_in=cursor_info1.DataIndex;
lin_fin=cursor_info2.DataIndex;
sforzo_lin=sforzo_rott(lin_in:lin_fin);
deformazione_lin=deformazione_rott(lin_in:lin_fin);

plot(deformazione_lin,sforzo_lin,'LineWidth',2)
set(gca,'fontsize',18)
xlabel('deformazione [%]')
ylabel('sforzo [MPa]','fontsize',18)
title('Tratto lineare 3%-4%')
grid on
xlim([3 4])

p=polyfit(deformazione_lin,sforzo_lin,1); %regressione lineare pe identificare il modulo di Young
young=p(1);
offset=p(2);

plot(deformazione_lin,sforzo_lin,'b','LineWidth',1.5)
hold on
plot(deformazione_lin,offset+young*deformazione_lin,'r','LineWidth',1.5)
set(gca,'fontsize',22)
legend('Dati sperimentali','Regressione','location','best')
xlabel('Deformazione [%]')
ylabel('Sforzo [MPa]')
grid on


%% Test di Rilassamento
subplot(2,1,1)
plot(tempo_ril,spostamento_ril,'LineWidth',1.5)
xlabel('Tempo [s]','fontsize',22)
ylabel('Spostamento [mm]','fontsize',22)
grid on
subplot(2,1,2)
plot(tempo_ril,forza_ril,'LineWidth',1.5)
xlabel('Tempo [s]','fontsize',22)
ylabel('Forza [N]','fontsize',22)
grid on

Fs=100;
t_in=0.5;
s_in=Fs*t_in;
tempo_espo_ril=tempo_ril(s_in:end);
spostamento_espo_ril=spostamento_ril(s_in:end);
forza_espo_ril=forza_ril(s_in:end);

figure
subplot(2,1,1)
plot(tempo_espo_ril,spostamento_espo_ril,'LineWidth',1.5)
xlim([0 180])
ylim([0 4.5])
xlabel('Tempo [s]','fontsize',18)
ylabel('Spostamento [mm]','fontsize',18)
grid on
subplot(2,1,2)
plot(tempo_espo_ril,forza_espo_ril,'LineWidth',1.5)
xlabel('Tempo [s]','fontsize',18)
ylabel('Forza [N]','fontsize',18)
grid on

% nel grafico forza-tempo l'esponenziale sembra avvicinarsi al valore 44 anziche' a 0, per t->infinto, quindi posso: 
%   1)modellare il corpo come somma di due esponenziali (sovrapposizione di effetti tra due corpi di
%   Maxwell: parallelo tra le due risposte a rilassamento cioè si sommano le forze);
%   2)modellare il corpo come un corpo di Kelvin che si assesta ad un valore diverso da zero

% 1) Primo metodo di modellazione: Maxwell
a=6.476;
b=-0.06544;
c=49.13;
d=-0.0005717;
tau1=-1/b;
tau2=-1/d;
forza_fit_ril=a*exp(b*tempo_espo_ril)+c*exp(d*tempo_espo_ril);
F_min=40;
F_max=60;
figure
plot(tempo_espo_ril,[forza_espo_ril,forza_fit_ril],'LineWidth',2)
hold on
xline(tau1,'g','LineWidth',1.5)

% 2) Secondo Metodo di modellazione: Kelvin
a1=51.12;
b1=-0.0008911;
tau=-1/b1;
forza_fit_ril1=a1*exp(b1*tempo_espo_ril);
figure
plot(tempo_espo_ril,[forza_espo_ril,forza_fit_ril1])






