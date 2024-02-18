function animate_walking(markers,coms,com)

%INPUT: dati dei marker, dati delle posizioni dei singoli COM e dati del
%centro di massa totale

%OUTPUT: plot 3D del cammino (stick diagram)

%NB: una function che plotta un grafico non ha bisogno che gli venga 
%assegnata una variabile da restituire in output nel workspace.

%Estraggo i nomi dei marker tramite la funzione fieldnames che legge i nomi
%dei dati contenuti dentro il campo markers che hanno n righe e 3 colonne, 
%e mi restituisce una array di celle ({}) contenenti ciascuna una stringa 
%(''), e li salvo nella variabile names:
markers_names=fieldnames(markers);

%% Scelgo di analizzare la prima walking
%se voglio estrarre il contenuto di una cella devo usare {} perchè () mi fa
%accedere solamente alla cella, non al suo contenuto.
first_marker=markers_names{1};

%Voglio conteggiare la lunghezza di una prova: per farlo in maniera più 
%automatizzata rispetto a length, uso la funzione eval che riceve in 
%ingresso un'informazione, come stringa, che potrei analogamente eseguire 
%manualmente nella command window:   eval('length(markers.C7)').
%Per automatizzare acora di più il comando:
%-[] -> per racchiudere una stringa "spezzettata"
%-'' -> per racchiudere ciascun "pezzo" di stringa
%-spazio -> per separare le varie stringhe concatenate
%-first_marker -> per sostitutire la stringa specifica con una variabile
%che contiene tutte le stringhe di markers più utile nel caso di operazioni
%iterative (per fare questo, in reealtà, dovrei inserire markers{i}) 
%ends= -> variabile in cui salvare la lunghezza cercata
eval(['ends=length(markers.' first_marker ')']);

%Analogo a scrivere 
%-eval(['ends=length(markers.' 'C7' ')']);
%-length(markers.C7) nella command window

%Salvo questa lunghezza in una variabile:
marker_num=length(markers_names);

%% Ciclo for temporizzato per creare il video del cammino: 
%l'acquisizione è stata fatta a 60 Hz e poichè matlab non è così veloce da 
%aggiornare i plot ogni 1/60 secondi, scelgo di plottare il movimento ogni 
%10 secondi ottenendo così una grafica meno fluida (ricampionato) ma meno 
%pesante da eseguire. 

%Creo delle sottofunzioni specifiche per plottare:
%-marker -> plot_marker
%-segmenti -> plot_segment
%-COM -> plot_com
%-COM_TOT -> plot_com_tot

for i=1:10:ends
    
    %%PLOT MARKER:
    %RIGHT
    plot_marker(markers.RGT(i,:)) %GRAN TROCANTERE DX
    hold on
    plot_marker(markers.RLE(i,:)) %EPICONDILO LATERALE DX
    plot_marker(markers.RLM(i,:)) %MALLEOLO LATERALE DX
    plot_marker(markers.RVM(i,:)) %5° METATARSO DX
    
    %LEFT
    plot_marker(markers.LGT(i,:)) %GRAN TROCANTERE SX
    hold on
    plot_marker(markers.LLE(i,:)) %EPICONDILO LATERALE SX
    plot_marker(markers.LLM(i,:)) %MALLEOLO LATERALE SX
    plot_marker(markers.LVM(i,:)) %5° METATARSO SX

    %TRUNK
    plot_marker(markers.C7(i,:)) %VERTEBRA C7
    plot_marker(markers.PE(i,:)) %PUNTO MEDIO DEL BACINO
    plot_marker(markers.L4(i,:)) %SACRO

    %%PLOT SEGMENT:
    %RIGHT
    plot_segment(markers.RGT(i,:),markers.RLE(i,:)) %COSCIA DX
    plot_segment(markers.RLE(i,:),markers.RLM(i,:)) %GAMBA DX
    plot_segment(markers.RLM(i,:),markers.RVM(i,:)) %PIEDE DX

    %LEFT
    plot_segment(markers.LGT(i,:),markers.LLE(i,:)) %COSCIA SX
    plot_segment(markers.LLE(i,:),markers.LLM(i,:)) %GAMBA SX 
    plot_segment(markers.LLM(i,:),markers.LVM(i,:)) %PIEDE SX

    %TRUNK
    plot_segment(markers.RGT(i,:),markers.LGT(i,:)) %ANCA DX-ANCA SX (BACINO)
    plot_segment(markers.RGT(i,:),markers.L4(i,:)) %ANCA DX-SACRO
    plot_segment(markers.LGT(i,:),markers.L4(i,:)) %ANCA SX-SACRO
    plot_segment(markers.C7(i,:),markers.L4(i,:)) %C7-SACRO
    plot_segment(markers.C7(i,:),markers.PE(i,:)) %C7-PUNTO MEDIO BACINO

    %%PLOT COMS:
    %RIGHT
    plot_com(coms.COM_RT(i,:)) %COSCIA DX
    plot_com(coms.COM_RS(i,:)) %GAMBA DX
    plot_com(coms.COM_RF(i,:)) %PIEDE DX

    %LEFT
    plot_com(coms.COM_LT(i,:)) %COSCIA SX
    plot_com(coms.COM_LS(i,:)) %GAMBA SX
    plot_com(coms.COM_LF(i,:)) %PIEDE SX

    %TRUNK
    plot_com(coms.COM_TA(i,:)) %TORACE+ADDOME
    plot_com(coms.COM_P(i,:)) %BACINO

    %PLOT COM TOTALE
    plot_com_tot(com(i,:))
    
    hold off
    
    axis([-0.6 0.6 -2.5 2.5 0 1.5])

    xlabel('X')
    ylabel('Y')
    zlabel('Z')

    grid on

    %Temporizzazione:
    tmpAspect=daspect();
    daspect(tmpAspect([1 1 1]))
    pause(0.04)
   
end

    



