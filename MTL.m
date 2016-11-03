function [mtl, x] = MTL(M,E,varargin) % mtl0, TOSC,no,delta,optimopt

% MTL.m, 2015-07-29, CC BY 4.0 czaj.org
% 
% PURPOSE: Find minimum tolerance level (error rate) allowing for the two
%          empirical distributions to be equivalent at 5% level
% 
% IDEA:    Take 2 distributions of WTP (or measures of WTP + uncertainty)
%          and test if they are equivalent at the 5% significance level,
%          given the specified tolerance level. 
% 
% TESTS:   For normally (or assymthotically normally) distributed WTP - 
%          two one sided z-tests are used (using constrained optimization). 
%          For other distributions - two one sided convolutions tests are
%          used (using 'manual' iterative optimization procedure) 
% 
% INPUT:   M - vector of means of the 2 distributions
%              (transferred, observed)
%          E - covariance matrix of the 2 distributions
%              (transferred, observed)
%          (some transformation can be necessary, see line 149, 
%           otherwise multivariate normal distribution is assumed)
%          mtl0 - starting value
%          TOSC - 1 if iterative optimization, fmincon otherwise
%          no - the no. of draws to use (optional, grid search only)
%          delta - step for determining the minimum and the tolerance level 
%          (optional, grid search only)
% 
% LITERATURE:
%
%          - Kristofersson D, Navrud S (2005) Validity Tests of Benefit Transfer – 
%            Are We Performing the Wrong Tests? Environmental and Resource Economics 
%            30(3): 279-286
%          - Poe, G. L., Giraud, K. L., and Loomis, J. B., 2005. Computational Methods 
%            for Measuring the Difference of Empirical Distributions. American Journal 
%            of Agricultural Economics, 87(2):353-365.
%          - Poe, G. L., Severance-Lossin, E. K., and Welsh, M. P., 1994. Measuring 
%            the Difference (X - Y) of Simulated Distributions: A Convolutions 
%            Approach. American Journal of Agricultural Economics, 76(4):904-915.
%          - Poe, G.L., Welsh, M.P., and Champ, P.A., 1997. Measuring the Difference 
%            in Mean Willingness to Pay when Dichotomous Choice Contingent Valuation 
%            Responses are Not Independent. Land economics, 73(2):255-267.
%          - Czajkowski, M., and Šèasný, M., 2010. Study on benefit transfer in an 
%            international setting. How to improve welfare estimates in the case of 
%            the countries' income heterogeneity? Ecological Economics, 
%            69(12):2409-2416.
%          - Ahtiainen, H., Artell, J., Czajkowski, M., and Meyerhoff, J., Function or 
%            unit value transfer? Evidence from a nine country benefit transfer 
%            experiment.

%%

% take time for measurement
% c = cputime;

rng(179424673);

if nargin < 2 % check no. of inputs
    error('Too few input arguments)')    
end
if nargin < 7
    OptimOpt = optimoptions('fmincon');
    OptimOpt.Algorithm = 'interior-point';
    % OptimOpt.Algorithm = 'sqp';
    % OptimOpt.Algorithm = 'trust-region-reflective';
    OptimOpt.GradObj = 'off';
    OptimOpt.Hessian = 'off'; %'user-supplied';
    OptimOpt.FinDiffType = 'central'; % ('forward')
    OptimOpt.MaxIter = 1e4; %1e4; %1e4; % no of iterations
    OptimOpt.TolFun = 1e-9;
    OptimOpt.TolX = 1e-9;
    OptimOpt.FunValCheck = 'on';
    OptimOpt.Diagnostics = 'on';
    OptimOpt.MaxFunEvals = 1e4; 
    OptimOpt.OutputFcn = @outputf;
    % OptimOpt.Display = 'iter-detailed';
    if nargin < 6
        delta = [];
        if nargin < 5
            no = [];
            if nargin < 4 
                TOSC = [];
                if nargin < 3
                    mtl0 = [];
                else
                    mtl0 = varargin{1};
                end
            else
                mtl0 = varargin{1};
                TOSC = varargin{2};
            end
        else
            mtl0 = varargin{1};
            TOSC = varargin{2};
            no = varargin{3};
        end
    else
        mtl0 = varargin{1};
        TOSC = varargin{2};
        no = varargin{3};
        delta = varargin{4};
    end
else
    mtl0 = varargin{1};
    TOSC = varargin{2};
    no = varargin{3};
    delta = varargin{4};
    OptimOpt = varargin{5};
end

if isempty(TOSC) || (TOSC ~= 0 && TOSC ~= 1) % no method specified
    cprintf(rgb('DarkOrange'),'\nAssuming constrained optimization method (TOSZ test, for (assymptotically) normally distributed WTP (estimates) only)\n');
	TOSC = 0;
elseif TOSC == 0
    cprintf(rgb('Black'),'\nUsing constrained optimization method (TOSZ, for normally distributed WTP only)\n');
elseif TOSC == 1
    cprintf(rgb('Black'),'\nUsing iterative optimization method (TOSC) \n');
end

if isempty(mtl0) || ~isreal(mtl0) || mtl0 <= 0 % mtl0 not specified
    if mtl0 <= 0 
        cprintf(rgb('DarkOrange'),'Warning - mtl0 must be > 0 \n');
    end
    mtl0 = abs((mean(M(:,1)) - mean(M(:,2)))/mean(M(:,2))); % use transfer error as a starting value
    cprintf(rgb('DarkOrange'),'Assuming mtl0 = TE (%1f) \n', mtl0);
else
	cprintf(rgb('Black'),'Using mtl0 = %1f \n', mtl0);
end


if TOSC == 0 % use this for normal distributions only
    
    f = @(x) mtl0*x; % objcttive function (OF)

    cons = @(x) mintreprob(M(1),sqrt(E(1,1)),M(2),sqrt(E(2,2)),mtl0,x); % define parameters for the constrains
    x0 = 1; % starting value of x

    % call the optimization solver
    [x,mtl] = fmincon(f,x0,[],[],[],[],0,[],cons,OptimOpt); % define cons. and lower bound   
    
elseif TOSC == 1

    if isempty(no) || no == 0 % the no. of draws not specified
        cprintf(rgb('DarkOrange'),'Assuming 1000 draws \n');
        no = 1e3;
    else
        cprintf(rgb('Black'),'Using %1d draws \n', no);
    end
    if isempty(delta) || delta == 0 % delta not specified
        cprintf(rgb('DarkOrange'),'Assuming delta = 0.000001 \n');
        delta = 1e-6;
    else
        cprintf(rgb('Black'),'Using delta = %1f \n', delta);
    end  

    V = mvnrnd(M,E,no);
    
    % If the distributions are not normal - manual data transformations are
    % necessary here, e.g.:
    
    % spike - truncated normal with jump density at 0
    V(V(:,1)<0,1) = 0; 
    V(V(:,2)<0,2) = 0;
       
    % lognormal - means of the underlying normal are provided
    % V = exp(V); 
    
    % etc.

    mtl = mtl0;
        
    % H0:
    % |WTP1-WTP2| > t*mean(WTP2)
    % WTPs equivalent if H0 rejected, i.e.:
    % P(WTP1-WTP2 > t*mean(WTP2)) < 0.05 and P(WTP1-WTP2 < -t*mean(WTP2)) < 0.05
    % jointly (two one-sided tests).
    % covoltest(A,B) returns prob of A > B
    
    % Note that only the mean is scaled (not standard deviation, i.e. not the entire vector)
        
    mark01 = convoltest(V(:,2) - mtl*M(2),V(:,1));
    mark02 = convoltest(V(:,1),V(:,2) + mtl*M(2));

    if max(mark01,mark02) <= 0.05 % can tolerance level be reduced?

        while max(mark01,mark02) <= 0.05
            mtl = mtl - delta;
            mark01 = convoltest(V(:,2) - mtl*M(2),V(:,1));
            mark02 = convoltest(V(:,1),V(:,2) + mtl*M(2));

           % max(mark01,mark02);
        end

    else % need to increase tolerance level, to be able to reject H0

        while max(mark01,mark02) > 0.05
            mtl = mtl + delta;
            mark01 = convoltest(V(:,2) - mtl*M(2),V(:,1));
            mark02 = convoltest(V(:,1),V(:,2) + mtl*M(2));
            %max(mark01,mark02);
        end

    end
    
end    

% set results format
format short g;
format compact;

% give results
% time_elapsed = cputime-c
% transfer_error = mtl0
% tolerance_level = tre
end


function [c, ceq] = mintreprob(m1,s1,m2,s2,mtl0,x)
c(1) = cdf('normal',0,m2*(1+mtl0*x)-m1,sqrt(s1^2+s2^2)) - 0.05;
c(2) = 0.95 - cdf('normal',0,m2*(1-mtl0*x)-m1,sqrt(s1^2+s2^2));

ceq = [];
end


function d = convoltest(v1,v2)
% ---------------------------------------------------------------------
% --   convoltest.m, 2015-07-29, CC BY 4.0 czaj.org                  --
% ---------------------------------------------------------------------
% -- PURPOSE: Apply Complete Combinatorial Convolutions Method       --
% --          for testing difference between two empirical (normal)  --
% --          distributions                                          --
% --                                                                 --
% -- INPUT:   v1    - empirical vector 1                             --
% --          v2    - empirical vector 2                             --
% -- OUTPUT: P(v1 >= v2)                                             --
% --         if P < 0.05 => v2 > v1                                  --
% ---------------------------------------------------------------------

%%
% take time for measurement
% c = cputime;

len1 = length(v1);
len2 = length(v2);

% prepare variables
csum_i = zeros(1,len1);

% main loop 
for i = 1:len1
    csum_i(i) = sum(v1(i)-v2>0);
end

csum = sum(csum_i);

% set results format
format short g
format compact

% give results
d = csum/(len1*len2);
%time_elapsed = cputime-c

end

