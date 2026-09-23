clear all;
clc
set(0,'defaulttextinterpreter','latex');

%%
%Object position and radius (obstacle)
R = 0.15 ;


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

%Obstacle params
d_prime = 1 ;

% %%
% %------------------------------------
% %      SIM CONNFIG
% %------------------------------------
% 
%     tsim=200;       
% 
%     open_system('nav_flocking4')    %32 works fine
%     sim('nav_flocking4.slx',tsim);
% 
% % %%    
% % %------------------------------------
% % %       PLOTS 
% % %------------------------------------
% lw=2.2; lw2 = 2; t=tout;    
% %horizontal motion
% xi=X(:,1:5);  yi=X(:,6:10); zi=X(:,11:15); vxi=X(:,16:20); vyi=X(:,21:25); vzi=X(:,26:30);
% N = size(X1) ;
% 
% figure(1)
%     x0=10;
%     y0=10;
%     width=650;
%     height=500;
%     set(gcf,'position',[x0,y0,width,height])
%     pos3 = plot3(xi(2:5:end,2:5), yi(2:5:end,2:5), zi(2:5:end,2:5),'LineWidth',lw); 
%     set(pos3,{'LineStyle'},{'-';'-';'-';'-'})
%     grid on;    
%     legend((pos3),'$x_1$','$x_2$','$x_3$','$x_4$', 'AutoUpdate','off','interpreter','latex','Fontsize',15);
%     xlabel('$p_x$ [m]','interpreter','latex')
%     ylabel('$p_y$ [m]','interpreter','latex')
%     zlabel('$p_z$ [m]','interpreter','latex')
%     hold on;
%     line([xi(3000,2:5), xi(3000,2)], [yi(3000,2:5), yi(3000,2)], [zi(3000,2:5), zi(3000,2)], 'LineStyle', '--', 'Color', 'b', 'LineWidth',lw2);
%     hold on;
%     line([xi(10000,2:5), xi(10000,2)], [yi(10000,2:5), yi(10000,2)], [zi(10000,2:5), zi(10000,2)], 'LineStyle', '--', 'Color', 'b', 'LineWidth',lw2);
%     hold on;
%     line([xi(20000,2:5), xi(20000,2)], [yi(20000,2:5), yi(20000,2)], [zi(20000,2:5), zi(20000,2)], 'LineStyle', '--', 'Color', 'b', 'LineWidth',lw2);
%     hold on
%     [A,B,C] = sphere;
%     r = 0.15;
%     A1 = A * r;
%     B1 = B * r;
%     C1 = C * r;
%     surf(A1+xobs,B1+yobs,C1+zobs)
% 
%     % Plotting interdistances
% 
% d12 = zeros(N(1),1) ;
% d13 = zeros(N(1),1) ;
% d14 = zeros(N(1),1) ;
% d23 = zeros(N(1),1) ;
% d24 = zeros(N(1),1) ;
% d34 = zeros(N(1),1) ;
% 
% for i=1:N(1)
%     d12(i,1) = norm(X1(i,:) - X2(i,:)) ;
%     d13(i,1) = norm(X1(i,:) - X3(i,:)) ;
%     d14(i,1) = norm(X1(i,:) - X4(i,:)) ;
%     d23(i,1) = norm(X2(i,:) - X3(i,:)) ;
%     d24(i,1) = norm(X2(i,:) - X4(i,:)) ;
%     d34(i,1) = norm(X3(i,:) - X4(i,:)) ;
% end
% 
% figure(2) ;
% plot(t, d12,'LineWidth',lw) ;
% hold on;
% plot(t, d13,'LineWidth',lw) ;
% hold on ;
% plot(t, d14,'LineWidth',lw) ;
% hold on ;
% plot(t, d23,'LineWidth',lw) ;
% grid on ;
% plot(t, d24,'LineWidth',lw) ;
% grid on ;
% plot(t, d34,'LineWidth',lw) ;
% grid on ;
% legend('{$d_{12}$}','{$d_{13}$}','{$d_{14}$}','{$d_{23}$}','{$d_{24}$}','{$d_{34}$}','interpreter', 'latex', 'FontSize', 12);
% %legend('d12', 'd13', 'd23') ;
% xlabel('time [s]', 'interpreter', 'latex', 'FontSize', 15) ;
% ylabel('interdistance [m]', 'interpreter', 'latex', 'FontSize', 15) ;
% 
% figure(3)
% subplot(3,1,1)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     posx = plot(t(1:5:end),xi(1:5:end,1:5),'LineWidth',lw);
%     set(posx,{'LineStyle'},{'-';'-';'-';'-';'-'})
%     grid on
%     %xlabel('Time [sec]','interpreter','latex')
%     ylabel('$p_x$ [m]','interpreter','latex')
%     legend('$x_d$','$x_1$','$x_2$','$x_3$','$x_4$','interpreter','latex','Fontsize',17);  
% 
% subplot(3,1,2)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     posx = plot(t(1:5:end),yi(1:5:end,1:5),'LineWidth',lw);
%     set(posx,{'LineStyle'},{'-';'-';'-';'-';'-'})
%     grid on
%     %xlabel('Time [sec]','interpreter','latex')
%     ylabel('$p_y$ [m]','interpreter','latex')
%     legend('$y_d$','$y_1$','$y_2$','$y_3$','$y_4$','interpreter','latex','Fontsize',17);  
% 
% subplot(3,1,3)
%     x0=10;
%     y0=10;
%     width=720;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])
%     posx = plot(t(1:5:end),zi(1:5:end,1:5),'LineWidth',lw);
%     set(posx,{'LineStyle'},{'-';'-';'-';'-';'-'})
%     grid on
%     %xlabel('Time [sec]','interpreter','latex')
%     ylabel('$p_z$ [m]','interpreter','latex')
%     legend('$z_d$','$z_1$','$z_2$','$z_3$','$z_4$','interpreter','latex','Fontsize',17);  
    
    
