function [V,Va,swingbus] = Pit(V,Ybus,Sbus,pv,pq,bus,Bp,Vm,Va)
%Pit Performs 1P
%   Input: complex voltage V vector, Ybus, Sbus, pv, pq, bus, Bpp,Vm,Va
%   Outputs:complex voltage V vector, the voltage angle Va, the swing bus

%--------------------------------------------------------------------------
% Compute the Real Power MisMatch
%--------------------------------------------------------------------------

mis = V .* conj(Ybus * V) - Sbus;
delP=-real(mis([pv; pq]));

%--------------------------------------------------------------------------
% Set-Up B-Prime Matrix Minus Swing Bus
%--------------------------------------------------------------------------

% Determines the Swing Bus
D = size(bus);
swingbus = -1;
for i=1:D(1)
    if bus(i,2) == 3;
        swingbus = bus(i,1);
    else
    end;
end;


bprimematrixnoswing = zeros(8,8);

for i=1:9
    for j = 1:9
     if (i ~= swingbus & j ~= swingbus)    
        if (i < swingbus & j < swingbus)
          bprimematrixnoswing(i,j) = Bp(i,j);  
        else
            if (i > swingbus & j < swingbus)  
                bprimematrixnoswing(i-1,j) = Bp(i,j); 
              else
                  if (i < swingbus & j > swingbus)   
                   bprimematrixnoswing(i,j-1) = Bp(i,j); 
                  else
                       if (i > swingbus & j > swingbus)  
                          bprimematrixnoswing(i-1,j-1) = Bp(i,j);
                       else
                       end;
                   end;                  
                end;
            end;
        end;
     end;

end;
% bprimematrixnoswing holds the matrix with the swing bus removed

% Reduce the Vm matrix for the swing bus

Vmtemp = zeros(8,1);

for i=1:9
    if i < swingbus
        Vmtemp(i,1) = Vm(i,1) ;
    else
        if i > swingbus
          Vmtemp(i-1,1) = Vm(i,1);
        else
        end;
    end;
    
end;

%-------------------------------------------------------------------------
% Computes the delTheta
%-------------------------------------------------------------------------
delTheta = bprimematrixnoswing\(delP./Vmtemp);

%-------------------------------------------------------------------------
% Augment the delTheta matrix for the swing bus
%-------------------------------------------------------------------------

delTheta2 = zeros(9,1);
for i=1:9
    if i < swingbus
        delTheta2(i,1) = delTheta(i,1);
    else
        if i > swingbus
         delTheta2(i,1) = delTheta(i-1,1);  
        else
            if i == swingbus
              delTheta2(i,1) = 0;  
            else
            end;
        end;
    end;
end;

delTheta = delTheta2;

%-------------------------------------------------------------------------
% Update Complex Voltage 
%-------------------------------------------------------------------------
Va = Va + delTheta;
V = Vm .* exp(sqrt(-1) * Va);  % This is the complex voltage

return;