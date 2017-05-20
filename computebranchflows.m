function [br, Sf, St] = computebranchflows(bus,gen,branch,V,Yf,Yt,baseMVA)
% COMPUTEBRANCHFLOWS 
%   Input: bus data, gen data (without outaged generator), branch data,
%   1P1Q final complex V, the matrices Yf and Yt
    % which, when multiplied by a complex voltage vector, yield the vector
    % currents injected into each line from the "from" and "to" buses
    % respectively of each line, baseMVA
%   Outputs: branch numbers in service, complex power at the from bus,
%   complex power at the bus

%-------------------------------------------------------------------------
% Compute Branch Flows
%-------------------------------------------------------------------------

%%-----  initialize  -----
%% define named indices into bus, gen, branch matrices
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, ...
    RATE_C, TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST] = idx_brch;
[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, ...
    GEN_STATUS, PMAX, PMIN, MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN] = idx_gen;

%% read data & convert to internal bus numbering
[i2e, bus, gen, branch] = ext2int(bus, gen, branch);


%Branch Flows
br = find(branch(:, BR_STATUS));   
Sf = V(branch(br, F_BUS)) .* conj(Yf(br, :) * V) * baseMVA; % complex power at "from" bus
St = V(branch(br, T_BUS)) .* conj(Yt(br, :) * V) * baseMVA; % complex power injected at "to" bus
return;