clear all;
clc
set(0,'defaulttextinterpreter','latex');

%%
%-----------------------------------
%       Rotorcraft Parameters
%-----------------------------------
m=0.65;   P.m = 0.65;   % mass [kg]
l=(0.2)*(sin(pi/4));
rad2deg = 180/pi;
Ts=0.01;            %sampling time
g=9.81;   P.g = 9.81;

%%
%-----------------------------------
%    Initial conditions rotorcraft 
%-----------------------------------
Att_1 = [2 -2 -15]; % Angular position
P0 = [1 -2 0]; % 3D Position
dP0 = [0 0 0]; %3D velocity
om0 = [0 0 0]; % Angular velocity
X0_1 = [P0 dP0 om0];

%%
%-----------------------------------
%Attitude Control 
%-----------------------------------
%Control gains body
lam1 = 3; lam2 = 3; lam3 = 3;         %3 3 3
Ki1 = 0; Ki2 = 0; Ki3 = 0;                  
k111 = 3.5; k122 = 3.5; k133 = 3.5;   %3.3 3.3 3.3 
k211 = 4; k222 = 4; k233 = 4;         %7 7 7
ar = 1; ap = 1; ay = 1;         %0.2 0.2 0.2

%Control gains matrices
lam = diag([lam1; lam2; lam3]);
Ki = diag([Ki1; Ki2; Ki3]);
K1 = diag([k111; k122; k133]);
K2 = diag([k211; k222; k233]);
aR = diag([ar; ap; ay]);

%%
%-----------------------------------
%Position Control 
%-----------------------------------
%Control gains 
Kx = 1.8; Ky = 1.8; Kz = 1.8;                %2.8 2.8 2.5
Kix = 0; Kiy = 0; Kiz = 0;
Kdx = 2.2; Kdy = 2.2; Kdz = 2.1;

%Control vector
%KP = [Kx Ky Kz Kix Kiy Kiz l1 l2 l3 a1 a2 a3 Lamx Lamy Lamz]'; 
KP = [Kx Ky Kz Kdx Kdy Kdz Kix Kiy Kiz];

%%
%------------------------------------
%      SIM CONNFIG
%------------------------------------

    tsim=100;       
    
    open_system('nav_sliding')    %comparison
    sim('nav_sliding',tsim);
    
% %%    
% %------------------------------------
% %       PLOTS 
% %------------------------------------
% lw=2.8; lw2=1.8; t=tout;    
% %horizontal motion
% xi=X(:,1:3);  yi=X(:,4:6); zi=X(:,7:9);
% vxi=X(:,10:12);  vyi=X(:,13:15); vzi=X(:,16:18);
% 
% figure(1)
% %subplot(3,1,1)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     posx = plot(t(1:3:end),xi(1:3:end,1:3),'LineWidth',lw);
%     set(posx,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     %xlabel('Time [sec]','interpreter','latex')
%     ylabel('$p_x$ [m]','interpreter','latex')
%     legend('$x_d$','$x_{slid}$','$x_{sat}$','interpreter','latex','Fontsize',17);  
%     axes('position',[.185 .65 .20 .20])
%     box on % put box around new pair of axes
%     indexOfInterest = (t(1:end) < 132) & (t(1:end) > 130); % range of t 
%     posxz = plot(t(indexOfInterest),xi(indexOfInterest,1:3),'LineWidth',lw); % plot on new axes
%     set(posxz,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     axis tight
%     x1 = [0.83 0.79];    % adjust length and location of arrow 
%     y1 = [0.22 0.27];      % adjust hieght and width of arrow
%     annotation('textarrow',x1,y1,'String','$d_x @t = 130s$','FontSize',10,'Linewidth',1)
%     
% figure(2)
% %subplot(3,1,2)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     posy = plot(t(1:3:end),yi(1:3:end,1:3),'LineWidth',lw);
%     set(posy,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     %xlabel('Time [sec]','interpreter','latex')
%     ylabel('$p_y$ [m]','interpreter','latex')
%     legend('$y_d$','$y_{slid}$','$y_{sat}$','interpreter','latex','Fontsize',17);   
%     axes('position',[.185 .65 .20 .20])
%     box on % put box around new pair of axes
%     indexOfInterest = (t(1:end) < 52) & (t(1:end) > 50); % range of t 
%     posxz = plot(t(indexOfInterest),yi(indexOfInterest,1:3),'LineWidth',lw); % plot on new axes
%     set(posxz,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     axis tight
%     x1 = [0.83 0.79];    % adjust length and location of arrow 
%     y1 = [0.22 0.27];      % adjust hieght and width of arrow
%     annotation('textarrow',x1,y1,'String','$d_x @t = 130s$','FontSize',10,'Linewidth',1)
%     
%     
% figure(3)
% %subplot(3,1,3)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     posz = plot(t(1:3:end),zi(1:3:end,1:3),'LineWidth',lw);
%     set(posz,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     xlabel('Time [sec]','interpreter','latex')
%     ylabel('$p_z$ [m]','interpreter','latex')
%     legend('$z_d$','$z_{slid}$','$z_{sat}$','interpreter','latex','Fontsize',17); 
%     axes('position',[.185 .65 .20 .20])
%     box on % put box around new pair of axes
%     indexOfInterest = (t(1:3:end) < 64) & (t(1:3:end) > 44); % range of t 
%     poszz = plot(t(indexOfInterest),zi(indexOfInterest,1:3),'LineWidth',lw); % plot on new axes
%     set(poszz,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     axis tight
%     x1 = [0.83 0.79];    % adjust length and location of arrow 
%     y1 = [0.22 0.27];      % adjust hieght and width of arrow
%     annotation('textarrow',x1,y1,'String','$d_x @t = 130s$','FontSize',10,'Linewidth',1)
%     
% figure(4)
% %subplot(3,1,1)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     velx = plot(t(1:3:end),vxi(1:3:end,1:3),'LineWidth',lw);
%     set(velx,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     %xlabel('Time [sec]','interpreter','latex')
%     ylabel('$\dot{p}_x$ [m]','interpreter','latex')
%     legend('$\dot{x}_d$','$\dot{x}_{slid}$','$\dot{x}_{sat}$','interpreter','latex','Fontsize',17);   
%     
% figure(5)
% %subplot(3,1,2)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     vely = plot(t(1:3:end),vyi(1:3:end,1:3),'LineWidth',lw);
%     set(vely,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     %xlabel('Time [sec]','interpreter','latex')
%     ylabel('$\dot{p}_y$ [m]','interpreter','latex')
%     legend('$\dot{y}_d$','$\dot{y}_{slid}$','$\dot{y}_{sat}$','interpreter','latex','Fontsize',17);   
%     
% figure(6)
% %subplot(3,1,3)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     velz = plot(t(1:3:end),vzi(1:3:end,1:3),'LineWidth',lw);
%     set(velz,{'LineStyle'},{'-';'--';'-.'})
%     grid on
%     xlabel('Time [sec]','interpreter','latex')
%     ylabel('$\dot{p}_z$ [m]','interpreter','latex')
%     legend('$\dot{z}_d$','$\dot{z}_{slid}$','$\dot{z}_{sat}$','interpreter','latex','Fontsize',17);  
%     
% figure(7)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     pos2 = plot(xi(1:3:end,1:3), yi(1:3:end,1:3),'LineWidth',lw); 
%     set(pos2,{'LineStyle'},{'-';'--';'-.'})
%     grid on;    
%     legend((pos2),'$X_d$','$X_{slid}$','$X_{sat}$', 'AutoUpdate','off','interpreter','latex','Fontsize',15);
%     xlabel('$p_x$ [m]','interpreter','latex')
%     ylabel('$p_y$ [m]','interpreter','latex')
%     axis([-3.5 3.5 -1.5 1.5])
%     x2 = [0.83 0.79];    % adjust length and location of arrow 
%     y2 = [0.22 0.27];      % adjust hieght and width of arrow
%     annotation('textarrow',x2,y2,'String','$d_x @t = 130s$','FontSize',10,'Linewidth',1)
%     x3 = [0.2 0.28];    % adjust length and location of arrow 
%     y3 = [0.9 0.85];      % adjust hieght and width of arrow
%     annotation('textarrow',x3,y3,'String','$d_y @t = 50s$','FontSize',10,'Linewidth',1)
%     axes('position',[.185 .65 .20 .20])
%     box on % put box around new pair of axes
%     %indexOfInterest = (xi(2:3:end) < 3.2) & (xi(2:3:end) > 2.8); % range of t 
%     %poszz = plot(xi(indexOfInterest,1:3),yi(indexOfInterest,1:3),'LineWidth',lw); % plot on new axes
%     %xlim([-2.5 -1.5])
%     %ylim([-1.5 -1.5])
%     poszz = plot(xi(1:3:end,1:3), yi(1:3:end,1:3),'LineWidth',lw);
%     set(poszz,{'LineStyle'},{'-';'--';'-.'})
%     axis([2.8 3.4 1 1.2])
%     grid on
%     axis tight
%     axes('position',[.185 .65 .20 .20])
%     box on
%     poszz2 = plot(xi(1:3:end,1:3), yi(1:3:end,1:3),'LineWidth',lw);
%     set(poszz2,{'LineStyle'},{'-';'--';'-.'})
%     axis([-2.4 -2 1 1.2])
%     grid on
%     axis tight