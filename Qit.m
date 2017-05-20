function [V,swingbus] = Qit(V,Ybus,Sbus,pv,pq,bus,Bpp,Vm,Va)
%Pit Performs 1P for a generator disturbance 
%   Input: complex voltage V vector, Ybus, Sbus, pv, pq, bus, Bpp,Vm,Va
%   Outputs:complex voltage V vector, the swing bus


%--------------------------------------------------------------------------
% Set-Up Bpp Matrix Minus Swing Bus Minus PV Buses
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



% This section removes only the swing bus

bpprimematrixnoswing = zeros(8,8);

for i=1:9
    for j = 1:9
     if (i ~= swingbus & j ~= swingbus)    
        if (i < swingbus & j < swingbus)
          bpprimematrixnoswing(i,j) = Bpp(i,j);  
        else
            if (i > swingbus & j < swingbus)  
                bpprimematrixnoswing(i-1,j) = Bpp(i,j); 
              else
                  if (i < swingbus & j > swingbus)   
                   bpprimematrixnoswing(i,j-1) = Bpp(i,j); 
                  else
                       if (i > swingbus & j > swingbus)  
                          bpprimematrixnoswing(i-1,j-1) = Bpp(i,j);
                       else
                       end;
                   end;                  
                end;
            end;
        end;
     end;

end;
% bpprimematrixnoswing holds the matrix with the swing bus removed

% This section removes the pv buses

D = size(pv); % Determines how many pv buses there are to remove..
pv2 = pv; % used for the loop down below

for k=1:D(1) % loops through the number of pv buses to eliminate them from the bpp matrix no swing
   
    % this is needed to keep the generator pv index algined with the
    % current bpprimematrixnoswing matrix index
    for t=1:D(1)
        if pv2(t) >= 2
         pv2(t) = pv2(t)-1;
        else
         pv2(t) = 1;
     end;
    end;

    
D2 = size(bpprimematrixnoswing); % Determines the current dimensions of the bpp matrix minus swing and minus loop pv bus   
bpprimematrixnoswing2 = zeros(D2(1)-1,D(2)-1); % creates a temporary matrix to store the new Bpp matrix minus loop pv minus swing

for i=1:D2(1)  % for 1 to the size of the bpp matrix with the swing removed and current loop pv bus removed.
    for j = 1:D2(1)
     if (i ~= pv2(k) & j ~= pv2(k))    % pv(k) is the pv bus being removed from the Bpp matrix without the swing. 
        if (i < pv2(k) & j < pv2(k))
          bpprimematrixnoswing2(i,j) = bpprimematrixnoswing(i,j);  
        else
            if (i > pv2(k) & j < pv2(k))  
                bpprimematrixnoswing2(i-1,j) = bpprimematrixnoswing(i,j); 
              else
                  if (i < pv2(k) & j > pv2(k))   
                   bpprimematrixnoswing2(i,j-1) = bpprimematrixnoswing(i,j); 
                  else
                       if (i > pv2(k) & j > pv2(k))  
                          bpprimematrixnoswing2(i-1,j-1) = bpprimematrixnoswing(i,j);
                       else
                       end;
                   end;                  
                end;
            end;
        end;
     end;

end;    

bpprimematrixnoswing = bpprimematrixnoswing2; % assigns the reduced bpp matrix

end;

% Reduce the Va matrix for the swing bus 

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

Vmtemp2 = Vmtemp;


% Reduces the Va matrix minus the swing for the pv buses

D = size(pv);
pv2 = pv;

for k=1:D(1) % loops for each bus
    
    D2 = size(Vmtemp2);
    Vmtemp3 = zeros(D2(1)-1,1);
    
    % this is needed to keep the generator pv index algined with the
    % current Va matrix index
    for t=1:D(1)
        if pv2(t) >= 2
         pv2(t) = pv2(t)-1;
        else
         pv2(t) = 1;
        end;
    end;

    for i=1:D2(1)
     if i < pv2(k)
        Vmtemp3(i,1) = Vmtemp2(i,1) ;
     else
        if i > pv2(k)
          Vmtemp3(i-1,1) = Vmtemp2(i,1);
        else
        end;
     end;
   end;   
    Vmtemp2 = Vmtemp3; 
    
end;

Vmtemp = Vmtemp2;

%-------------------------------------------------------------------------
% Compute the Reative Power MisMatch
%-------------------------------------------------------------------------

mis = V .* conj(Ybus * V) - Sbus;
delQ=-imag(mis(pq));


%-------------------------------------------------------------------------
% Computes the delVmag
%-------------------------------------------------------------------------
delVmag = bpprimematrixnoswing\(delQ./Vmtemp);

%-------------------------------------------------------------------------
% Augment the delVmag matrix for the swing bus and pv buses
%-------------------------------------------------------------------------

delVmag2 = zeros(9,1);
D = size(pv);
increment = 1;
for i=1:9
    if i == swingbus 
    else
        flag = 0;   % determines if it is a pav bus to reconstruct
        for k=1:D(1)
          if pv(k) == i
           flag = 1;    
          else
          end
        end
        
        if flag == 1;
        else
           delVmag2(i) = delVmag(increment);
           increment = increment + 1;
        end
    end
end;

delVmag = delVmag2;

%-------------------------------------------------------------------------
% Update Complex Voltage Values
%-------------------------------------------------------------------------
Vm = Vm + delVmag;
V = Vm .* exp(sqrt(-1) * Va);  % This is the complex voltage

return;