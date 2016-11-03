function MTLs = MTLMatrix(v1,s1,varargin)

% MTLMatrix.m, 2016-10-18, CC BY 4.0 czaj.org
%
% PURPOSE:  Calculate Minimum Tolerance Levels (element-wise operation to two arrays with implicit expansion enabled),
%           where transfered values can be income adjusted, according to a specified (fixed) income elasticity:
%           WTP_transferred = WTP_study*(INC_transferred_country/INC_study_country)^elasticity
%
% OUTPUT:   Minimum Tolerance Levels, where
%           size 1 (rows, i) - transferred (from)
%           size 2 (columns, j) - observed (to)
%
% INPUT:
%           nargin:
%           2: meanMatrix1, seMatrix1
%           4: meanMatrix1, seMatrix1, meanMatrix2, seMatrix2
%           6: meanMatrix1, seMatrix1, meanMatrix2, seMatrix2, INCmtx, el
%           7: meanMatrix1, seMatrix1, meanMatrix2, seMatrix2, INC1, INC2, el

if nargin < 2
    error('Too few input arguments for MTLMatrix')
elseif nargin == 2
    if ~isvector(v1) || ~isvector(s1)
        error('Expansion not possible for 2D matrices')
    else
        v1 = v1(:);
        s1 = s1(:);
        v2 = v1';
        s2 = s1';
    end
    INC1 = ones(size(v1));
    INC2 = ones(size(v2));
    el = 0;
elseif nargin == 4
    v2 = varargin{1};
    s2 = varargin{2};
    INC1 = ones(size(v1));
    INC2 = ones(size(v2));
    el = 0;
elseif nargin == 6
    v2 = varargin{1};
    s2 = varargin{2};
    INCmtx = varargin{3};
    el = varargin{4};
elseif nargin == 7
    v2 = varargin{1};
    s2 = varargin{2};
    INC1 = varargin{3};
    INC2 = varargin{4};
    el = varargin{5};
else
    error('Incorrect number of input variables')
end

% save tmp1
% return

if any(size(v1) ~= size(s1)) || any(size(v2) ~= size(s2))
    error('Means and s.e. matrix sizes not consistent')
end

if (length(size(v1)) > 2) || (length(size(v2)) > 2)
    error('Matrix cannot be more than 2D')
elseif isvector(v1) && isvector(v2)
    if size(v1,2) > size(v1,1)
        cprintf(rgb('DarkOrange'), 'WARNING: Assuming v1 is a vertical vector \n')
        v1 = v1(:);
    end
    if size(v2,1) < size(v2,2)
        v1 = v1.*ones(size(v2));
        s1 = s1.*ones(size(v2));
        v2 = v2.*ones(size(v1));
        s2 = s2.*ones(size(v1));
    end    
elseif isvector(v1) && ~isvector(v2)
    if size(v1,2) > size(v1,1)
        cprintf(rgb('DarkOrange'), 'WARNING: Assuming v1 is a vertical vector \n')
        v1 = v1(:);
        s1 = s1(:);
    end
    if size(v1,1) ~= size(v2,1)
        error('Vector / matrix sizes not consistent')
    end
    v1 = v1.*ones(size(v2));
    s1 = s1.*ones(size(v2));
elseif ~isvector(v1) && isvector(v2)
    if size(v2,2) < size(v2,1)
        cprintf(rgb('DarkOrange'), 'WARNING: Assuming v2 is a horizontal vector \n')
        v2 = v2(:)';
        s2 = s2(:)';
    end
    if size(v1,2) ~= size(v2,2)
        error('Vector / matrix sizes not consistent')
    end
    v2 = v2.*ones(size(v1));
    s2 = s2.*ones(size(v1));
elseif ~isvector(v1) && ~isvector(v2)
    if any(size(v1) ~= size(v2))
        error('Matrix sizes not consistent')
    end
end

if exist('INCmtx','var') && ~isempty(INCmtx) && (any(size(INCmtx) ~= size(v1)))
    error('INCmtx size not consistent with V1')
end

if exist('INC1','var') && ~isempty(INC1)
    if isvector(INC1)
        if size(INC1,1) ~= size(v1,1)
            if all(size(INC1) == size(v1'))
                INC1 = INC1';
            else
                error('Values and Incomes vector sizes not consistent');
            end
        end
    elseif any(size(INC1) ~= size(v1))
        error('Values and Incomes matrix sizes not consistent');
    end
end
if exist('INC2','var') && ~isempty(INC2)
    if isvector(INC2)
        if size(INC2,2) ~= size(v2,2)
            if all(size(INC2) == size(v2'))
                INC2 = INC2';
            else
                error('Values and Incomes matrix not consistent');
            end        
        end
        if (size(INC2,1) == 1) && (size(v2,1) > 1)
            INC2 = INC2 .* ones(size(v2));
        end
    elseif any(size(INC2) ~= size(v2))
        error('Values and Incomes matrix sizes not consistent');
    end
end

if ~exist('INCmtx','var')
    INCmtx = bsxfun(@rdivide,INC2,INC1).^el;
else
    INCmtx = INCmtx.^el;
end

save tmp1

MTLs = zeros(size(v1));
for i = 1:size(v1,1)
    for j = 1:size(v2,2)
        MTLs(i,j) = MTL([v1(i,j).*INCmtx(i,j),v2(i,j)],diag([s1(i,j).*INCmtx(i,j),s2(i,j)].^2));
    end
end
