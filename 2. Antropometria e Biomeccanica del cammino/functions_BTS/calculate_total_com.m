function COM_TOT=calculate_total_com(coms,m)

%INPUT: posizioni di tutti i centri di massa e vettore con le masse degli 8
%segmenti.

%OUTPUT: posizione del COM totale

COM_TOT=(coms.COM_RT*m.T+coms.COM_RS*m.S+coms.COM_RF*m.F+coms.COM_LT*m.T+...
    coms.COM_LS*m.S+coms.COM_LF*m.F+coms.COM_TA*m.TA+coms.COM_P*m.P)...
    /(2*m.T+2*m.S+2*m.F+m.TA+m.P)
