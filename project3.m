%==========================================================================
% Project # 3
% Kathleen E. Williams
% ECE 557
%==========================================================================

%--------------------------------------------------------------------------
% Run a Fast-Decoupled Power Flow for the 9-Bus system Base Case
%--------------------------------------------------------------------------
options = mpoption('PF_ALG', 2);
[baseMVA, bus, gen, branch, success] = runpf('wscc9bus',options);

%--------------------------------------------------------------------------
% Generator Outage - Ask for a generator to be out
%--------------------------------------------------------------------------

[gennew, genout] = genout(gen);
gen = gennew;

%--------------------------------------------------------------------------
% Setup Base Case Complex Voltage without Generator Outage
%--------------------------------------------------------------------------

Vm = bus(:,8);                  % This is the voltage magnitude column
Va = bus(:,9);                  % This is the column of voltage values
Va = Va.*pi/180;                % Convert the bus angle to radians
V = Vm .* exp(sqrt(-1) * Va);   % This is the complex voltage

%--------------------------------------------------------------------------
% Set-Up B-Prime Matrix, Sbus, Ybus 
%--------------------------------------------------------------------------
branch(genout,4) = 100000000000;
branch(genout,3) = 100000000000;
alg = 2; % BX Method
[Bp, Bpp] =  makeB(baseMVA, bus, branch, alg);
Sbus = makeSbus(baseMVA, bus, gen);
[Ybus, Yf, Yt] = makeYbus(baseMVA, bus, branch);


%--------------------------------------------------------------------------
% Retrieve bus type reference matrices
%--------------------------------------------------------------------------

[ref, pv, pq] = bustypes(bus, gen);

%-------------------------------------------------------------------------
% 1P half-iteration
%-------------------------------------------------------------------------

[V,Va] = Pit(V,Ybus,Sbus,pv,pq,bus,Bp,Vm,Va);

updatedvalues1P  = [bus(:,1) abs(V) angle(V)]

%--------------------------------------------------------------------------
% 1Q half-iteration
%--------------------------------------------------------------------------

[V] = Qit(V,Ybus,Sbus,pv,pq,bus,Bpp,Vm,Va);
updatedvalues1Q  = [bus(:,1) abs(V) angle(V)]

%-------------------------------------------------------------------------
% Compute Branch Flows
%-------------------------------------------------------------------------

[br, Sf, St] = computebranchflows(bus,gen,branch,V,Yf,Yt,baseMVA);

%--------------------------------------------------------------------------
% Display Branch Flows
%--------------------------------------------------------------------------

format short g;

D = size(Sf);
fprintf('\n');
fprintf('\n');

    fprintf('\n=============================================================================================================================================');
    fprintf('\n|                                         Fast-Decoupled 1P1Q Estimated Branch flows                                                         |');
    fprintf('\n=============================================================================================================================================');
    fprintf('\n From Bus  \t To Bus  \t From Bus Real Power (MW) \t From Bus Reactive Power (MVAR) \t To Bus Real Power (MW) \t To Bus Reactive Power (MVAR)');
    fprintf('\n --------- \t ------- \t ------------------------ \t ------------------------------ \t ---------------------- \t ----------------------------');
for i=1:D(1)
    fprintf('\n \t%1.0f \t\t\t%1.0f \t\t\t\t%6f \t\t\t\t\t%6f \t\t\t\t\t\t%6f \t\t\t\t\t%6f', branch(i,1), branch(i,2), real(Sf(i,1)), imag(Sf(i,1)), real(St(i,1)), imag(St(i,1)));
end;
fprintf('\n');
fprintf('\n');
