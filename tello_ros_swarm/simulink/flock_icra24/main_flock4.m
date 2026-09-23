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
%    Initial conditions rotorcrafts 
%-----------------------------------
Att1 = [2 -2 -15]; % Angular position
P01 = [1 -0.5 0]; % 3D Position
dP01 = [0 0 0]; %3D velocity
om01 = [0 0 0]; % Angular velocity
X0_1 = [P01 dP01 om01];

Att2 = [2 -2 -15]; % Angular position
P02 = [1 1 0]; % 3D Position
dP02 = [0 0 0]; %3D velocity
om02 = [0 0 0]; % Angular velocity
X0_2 = [P02 dP02 om02];

Att3 = [2 -2 -15]; % Angular position
P03 = [-1 0 0]; % 3D Position
dP03 = [0 0 0]; %3D velocity
om03 = [0 0 0]; % Angular velocity
X0_3 = [P03 dP03 om03];

Att4 = [2 -2 -15]; % Angular position
P04 = [0 -0.5 0]; % 3D Position
dP04 = [0 0 0]; %3D velocity
om04 = [0 0 0]; % Angular velocity
X0_4 = [P04 dP04 om04];

%%
%Object position and radius (obstacle)
xobs = 0.75;
yobs = -0.25;
zobs = 1.7;
vxobs = 0;
vyobs = 0;
vzobs = 0;
R = 0.15 ;

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
%Control gains interdistances
Kx = 8.5; Ky = 8.5; Kz = 8.5;                %1.8
Kpx = 0; Kpy = 0; Kpz = 0;
Kdx = 2; Kdy = 2; Kdz = 2;
Kix = 3.5; Kiy = 3.5; Kiz = 3.5;

%Obstacle avoidance
cBetax = 1.7; cBetay = 1.7; cBetaz = 1.7;
cdBetax = 0.1; cdBetay = 0.1; cdBetaz = 0.1;

%Control vector
KP = [Kx Ky Kz Kpx Kpy Kpz Kdx Kdy Kdz Kix Kiy Kiz cBetax cBetay cBetaz cdBetax cdBetay cdBetaz];

%%
%------------------------------------
% Flocking parameters
%------------------------------------
%Interdistance params
epsilon = 0.1 ;
a = 1 ;        % 0 < a <= b
b = 1 ;
c = 1 ;     % 0.6 
d = 0.6 ;     % 0.3
e = abs(a - b) / sqrt(4*a*b) ;
h = 0.2 ;

%Navigation feedback params
c_gammap = 1.2 ;
c_gammav = 3.5 ;
xmin = -2 ;
xmax = 2 ; 

%Obstacle params
d_prime = 1 ;

%%
%------------------------------------
%      SIM CONNFIG
%------------------------------------

    tsim=200;       
    
    open_system('nav_flocking4')    %32 works fine
    sim('nav_flocking4.slx',tsim);
    
% %%    
% %------------------------------------
% %       PLOTS 
% %------------------------------------
lw=2.2; lw2 = 2; t=tout;    
%horizontal motion
xi=X(:,1:5);  yi=X(:,6:10); zi=X(:,11:15); vxi=X(:,16:20); vyi=X(:,21:25); vzi=X(:,26:30);
N = size(X1) ;

figure(1)
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(gcf,'position',[x0,y0,width,height])
    pos3 = plot3(xi(2:5:end,2:5), yi(2:5:end,2:5), zi(2:5:end,2:5),'LineWidth',lw); 
    set(pos3,{'LineStyle'},{'-';'-';'-';'-'})
    grid on;    
    legend((pos3),'$x_1$','$x_2$','$x_3$','$x_4$', 'AutoUpdate','off','interpreter','latex','Fontsize',15);
    xlabel('$p_x$ [m]','interpreter','latex')
    ylabel('$p_y$ [m]','interpreter','latex')
    zlabel('$p_z$ [m]','interpreter','latex')
    hold on;
    line([xi(3000,2:5), xi(3000,2)], [yi(3000,2:5), yi(3000,2)], [zi(3000,2:5), zi(3000,2)], 'LineStyle', '--', 'Color', 'b', 'LineWidth',lw2);
    hold on;
    line([xi(10000,2:5), xi(10000,2)], [yi(10000,2:5), yi(10000,2)], [zi(10000,2:5), zi(10000,2)], 'LineStyle', '--', 'Color', 'b', 'LineWidth',lw2);
    hold on;
    line([xi(20000,2:5), xi(20000,2)], [yi(20000,2:5), yi(20000,2)], [zi(20000,2:5), zi(20000,2)], 'LineStyle', '--', 'Color', 'b', 'LineWidth',lw2);
    hold on
    [A,B,C] = sphere;
    r = 0.15;
    A1 = A * r;
    B1 = B * r;
    C1 = C * r;
    surf(A1+xobs,B1+yobs,C1+zobs)

    % Plotting interdistances

d12 = zeros(N(1),1) ;
d13 = zeros(N(1),1) ;
d14 = zeros(N(1),1) ;
d23 = zeros(N(1),1) ;
d24 = zeros(N(1),1) ;
d34 = zeros(N(1),1) ;

for i=1:N(1)
    d12(i,1) = norm(X1(i,:) - X2(i,:)) ;
    d13(i,1) = norm(X1(i,:) - X3(i,:)) ;
    d14(i,1) = norm(X1(i,:) - X4(i,:)) ;
    d23(i,1) = norm(X2(i,:) - X3(i,:)) ;
    d24(i,1) = norm(X2(i,:) - X4(i,:)) ;
    d34(i,1) = norm(X3(i,:) - X4(i,:)) ;
end

figure(2) ;
plot(t, d12,'LineWidth',lw) ;
hold on;
plot(t, d13,'LineWidth',lw) ;
hold on ;
plot(t, d14,'LineWidth',lw) ;
hold on ;
plot(t, d23,'LineWidth',lw) ;
grid on ;
plot(t, d24,'LineWidth',lw) ;
grid on ;
plot(t, d34,'LineWidth',lw) ;
grid on ;
legend('{$d_{12}$}','{$d_{13}$}','{$d_{14}$}','{$d_{23}$}','{$d_{24}$}','{$d_{34}$}','interpreter', 'latex', 'FontSize', 12);
%legend('d12', 'd13', 'd23') ;
xlabel('time [s]', 'interpreter', 'latex', 'FontSize', 15) ;
ylabel('interdistance [m]', 'interpreter', 'latex', 'FontSize', 15) ;

figure(3)
subplot(3,1,1)
    x0=10;
    y0=10;
    width=720;
    height=400;
    set(gcf,'position',[x0,y0,width,height])
    posx = plot(t(1:5:end),xi(1:5:end,1:5),'LineWidth',lw);
    set(posx,{'LineStyle'},{'-';'-';'-';'-';'-'})
    grid on
    %xlabel('Time [sec]','interpreter','latex')
    ylabel('$p_x$ [m]','interpreter','latex')
    legend('$x_d$','$x_1$','$x_2$','$x_3$','$x_4$','interpreter','latex','Fontsize',17);  

subplot(3,1,2)
    x0=10;
    y0=10;
    width=720;
    height=400;
    set(gcf,'position',[x0,y0,width,height])
    posx = plot(t(1:5:end),yi(1:5:end,1:5),'LineWidth',lw);
    set(posx,{'LineStyle'},{'-';'-';'-';'-';'-'})
    grid on
    %xlabel('Time [sec]','interpreter','latex')
    ylabel('$p_y$ [m]','interpreter','latex')
    legend('$y_d$','$y_1$','$y_2$','$y_3$','$y_4$','interpreter','latex','Fontsize',17);  

subplot(3,1,3)
    x0=10;
    y0=10;
    width=720;
    height=400;
    set(gcf,'position',[x0,y0,width,height])
    posx = plot(t(1:5:end),zi(1:5:end,1:5),'LineWidth',lw);
    set(posx,{'LineStyle'},{'-';'-';'-';'-';'-'})
    grid on
    %xlabel('Time [sec]','interpreter','latex')
    ylabel('$p_z$ [m]','interpreter','latex')
    legend('$z_d$','$z_1$','$z_2$','$z_3$','$z_4$','interpreter','latex','Fontsize',17);  
    
    
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