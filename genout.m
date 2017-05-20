function [gennew, genout] = genout(gen)
%GENOUT Displays available generators to be taken out of service
%   Input, the generator matrix
%   Outputs, the gen matrix with the outaged generator removed, the outage
%   generator 

%--------------------------------------------------------------------------
% Plan for Generator Out of Service
%--------------------------------------------------------------------------

% Print the Generator Data

%   Generator Data Format
%       1   bus number
%   (-)     (machine identifier, 0-9, A-Z)
%       2   Pg, real power output (MW)
%       3   Qg, reactive power output (MVAR)
%       4   Qmax, maximum reactive power output (MVAR)
%       5   Qmin, minimum reactive power output (MVAR)
%       6   Vg, voltage magnitude setpoint (p.u.)
%   (-)     (remote controlled bus index)
%       7   mBase, total MVA base of this machine, defaults to baseMVA
%   (-)     (machine impedance, p.u. on mBase)
%   (-)     (step up transformer impedance, p.u. on mBase)
%   (-)     (step up transformer off nominal turns ratio)
%       8   status, 1 - machine in service, 0 - machine out of service
%   (-)     (% of total VARS to come from this gen in order to hold V at
%               remote bus controlled by several generators)
%       9   Pmax, maximum real power output (MW)
%       10  Pmin, minimum real power output (MW)

D = size(gen);
fprintf('\n');
fprintf('\n');

    fprintf('\n=======================================================================================================================================');
    fprintf('\n|     Generator Setup Data                                                                                                             |');
    fprintf('\n========================================================================================================================================');
    fprintf('\n Bus Number # \t Pg real power output (MW) \t Qg reactive power output (MVAR) \t Qmax     \t Qmin     \t Pmax     \t Pmin     \t Status');
    fprintf('\n ------------ \t ------------------------- \t ------------------------------- \t -------- \t -------- \t -------- \t -------- \t --------');
for i=1:D(1)
    fprintf('\n \t%1.0f \t\t\t\t\t%6f \t\t\t\t\t%6f \t\t\t\t\t%6f \t%6f \t%6f \t%6f \t%6f', gen(i,1), gen(i,2), gen(i,3), gen(i,4), gen(i,5), gen(i,9), gen(i,10), gen(i,8));
end;
fprintf('\n');
fprintf('\n');

% Ask for a generator to be taken out of service and perform error checking

genout = -1;
while genout <= 1 || genout > 3
genout = input('Enter the Generator number to be taken out of service:');
fprintf('\n');
fprintf('Your have chosen Generator number: ');
fprintf('%1.0f', genout);
fprintf(' to be out of service.');

    if genout >=2 && genout <= 3

    else
        fprintf('\n');
        fprintf('Your have chosen an invalid Generator number: ');
        fprintf('\n');
        genout = input('Enter the Generator number to be taken out of service:');
        fprintf('\n');
        fprintf('Your have chosen Generator number: ');
        fprintf('%1.0f', genout);
        fprintf(' to be out of service.');
    end;
end;

% Make a new generator data based on the outaged generator

gennew = gen;
gennew(genout,:)=[];

% gennew now contains the eliminated branch
