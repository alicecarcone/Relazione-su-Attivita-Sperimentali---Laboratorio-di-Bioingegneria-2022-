function plot_marker(marker)

mark=8;

%Devo separare le coordinate che sono salvate come colonne di una matrice, 
%perchè un plot 3D le legge singolarmente:
x_marker=marker(:,1);
y_marker=marker(:,2);
z_marker=marker(:,3);

plot3(x_marker,z_marker,y_marker,'ob','MarkerSize',mark,...
    'MarkerFaceColor','b')
%NB:
%-y e z in Matlab sono invertiti rispetto a quelli usati in laboratorio 
%-'ob'= cerchio blu (vuoto)
%-mark = spessore del marker

