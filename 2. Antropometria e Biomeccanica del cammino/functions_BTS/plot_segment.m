function plot_segment(marker_p,marker_d)

segm=5;

%Devo separare le coordinate che sono salvate come colonne di una matrice, 
%perchè un plot 3D le legge singolarmente:
x_marker_p=marker_p(:,1);
y_marker_p=marker_p(:,2);
z_marker_p=marker_p(:,3);

x_marker_d=marker_d(:,1);
y_marker_d=marker_d(:,2);
z_marker_d=marker_d(:,3);

plot3([x_marker_p x_marker_d],[z_marker_p z_marker_d],...
    [y_marker_p y_marker_d],'b','linewidth',segm)








