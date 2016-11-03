
clear;
clc;

load BT_demo_data.mat
% the data contains the estimated WTP distribution parameters for 2 programs in 9 countries
% we are treating the distributions as if they were (assymptotically) normal

% find MTL for each possible transfer of the WTP for each program


%% Transfer errors:


TE = TEMatrix(B1);


%% TOSZ test:


EQ_min_tosz = zeros(9,9);
for i = 1:9
    for j = 1:9
        if i == j
            EQ_min_tosz(i,j) = 0;
        else
            EQ_min_tosz(i,j) = MTL([B1(i),B1(j)],diag([S1(i),S1(j)].^2));
            
        end
    end
end

% or use:
% EQ_min_tosz = MTLMatrix(B1,S1);


%% TOSC test:


EQ_min_tosc = zeros(9,9);

for i = 1:9
    for j = 1:9
        if i == j
            EQ_min_tosc(i,j) = 0;
        else
            EQ_min_tosc(i,j) = MTL([B1(i),B1(j)],diag([S1(i),S1(j)].^2),EQ1min_tosz(i,j),1,1e4,1e-4);
        end
    end
end

% compare the results of the two approaches
% dEQ1 = EQ1min_tosc - EQ1min_tosz
% dEQ2 = EQ2min_tosc - EQ2min_tosz