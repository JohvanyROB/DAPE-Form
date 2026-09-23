function [Ang]=A_Euler(u)

Q=u;
q0=Q(1);
q1=Q(2);
q2=Q(3);
q3=Q(4);

Mps=[2*(q0^2+q1^2)-1       2*(q1*q2+q0*q3)      2*(q1*q3-q0*q2);
     2*(q1*q2-q0*q3)       2*(q0^2+q2^2)-1      2*(q3*q2+q0*q1);
     2*(q1*q3+q0*q2)       2*(q2*q3-q0*q1)      2*(q0^2+q3^2)-1];
      
      
      pitch=asin(-Mps(1,3));
      aux=cos(pitch);
      
      yaw=asin(Mps(1,2)/aux);
      roll=asin(Mps(2,3)/aux);
      
    % place resultats in correct quadrante;
           
    if Mps(1,1) < 0
        if yaw < 0
            yaw=-(yaw+pi);
        else
            yaw=-(yaw-pi);
        end
    else
        yaw=yaw;        
    end
    
    
    if Mps(3,3) < 0
        if roll < 0
            roll=-(roll+pi);
        else
            roll=-(roll-pi);
        end
    else
        roll=roll;
    end
    
    conv=1;%80/pi;
        
    
      Ang=[roll*conv;pitch*conv;yaw*conv;];%[yaw*conv;roll*conv;pitch*conv]; En grados
      