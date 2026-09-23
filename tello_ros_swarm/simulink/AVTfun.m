%%AVT function

function AVT = AVTfun(d_avt, d, adjustment, s_adjust, min, max, inc2, dec2)

    e_adjust = d_avt - d;
    %s_adjust = 0;

       %%TODO test pour D negatif add ou erreur 
    
   if e_adjust < 0 
        if s_adjust < 0
            adjustment = inc2*adjustment; 
            if adjustment >= max
                adjustment = max;
            elseif adjustment <= min
                adjustment = min;
            end        
        else   
            adjustment = 2*inc2*adjustment; %%1.05
            if adjustment >= max
                adjustment = max;
            elseif adjustment <= min
                adjustment = min;
            end     
        end
    elseif e_adjust > 0
        if s_adjust >0
            adjustment = adjustment/(2*dec2);
            if adjustment >= max
                adjustment = max;
            elseif adjustment <= min
                adjustment = min;
            end   
        else
            adjustment = adjustment/dec2;
            if adjustment >= max
                adjustment = max;
            elseif adjustment <= min
                adjustment = min;
            end   
        end
    else
        adjustment = adjustment;
    end

    d_avt = adjustment*d_avt;
    s_adjust = e_adjust;   %%TODO check for s_adjust

    AVT = [d_avt;adjustment;s_adjust];

end