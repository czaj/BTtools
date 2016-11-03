function TransferErrors = TEMatrix(V1,varargin)

% TEMatrix.m, 2016-10-17, CC BY 4.0 czaj.org
%
% PURPOSE:  Calculate relative transfer errors (element-wise operation to two arrays with implicit expansion enabled), according to:
%           TE = (WTP_transferred - WTP_observed) ./ WTP_observed
%           where transfered values can be income adjusted, according to a specified (fixed) income elasticity:
%           WTP_transferred = WTP_study*(INC_transferred_country/INC_study_country)^elasticity
%
% OUTPUT:   Relative transfer errors matrix, where
%           size 1 (rows, i) - transfered (from)
%           size 2 (columns, j) - observed (to)
%
% INPUT:
%           nargin:
%           1: V1
%           2: V1, V2
%           3: V1, INC1, el
%           4: V1, V2, INCmtx, el
%           5: V1, V2, INC1, INC2, el

if nargin < 1
    error('Too few input arguments for TEMatrix')
elseif nargin == 1
    if ~isvector(V1)
        error('Expansion not possible for 2D matrices')
    else
        V1 = V1(:);
        V2 = V1';
    end
    INC1 = ones(size(V1));
    INC2 = ones(size(V2));
    el = 0;
elseif nargin == 2
    V2 = varargin{1};
    INC1 = ones(size(V1));
    INC2 = ones(size(V2));
    el = 0;
elseif nargin == 3
    if ~isvector(V1)
        error('Expansion not possible for 2D matrices (V)')
    else
        V2 = V1(:)';
    end
    INC1 = varargin{1};
    if ~isvector(INC1)
        error('Expansion not possible for 2D matrices (INC)')
    else
        INC1 = INC1(:);
        INC2 = INC1';
    end
    el = varargin{2};
elseif nargin == 4
    V2 = varargin{1};
    INCmtx = varargin{2};
    el = varargin{3};
elseif nargin == 5
    V2 = varargin{1};
    INC1 = varargin{2};
    INC2 = varargin{3};
    el = varargin{4};
else
    error('Incorrect number of input variables')
end

if (length(size(V1)) > 2) || (length(size(V2)) > 2)
    error('Matrix cannot be more than 2D')
elseif isvector(V1) && isvector(V2)
    if size(V1,2) > size(V1,1)
        cprintf(rgb('DarkOrange'), 'WARNING: Assuming V1 is a vertical vector \n')
        V1 = V1(:);
    end
    % V2 can be vertical (no expansion) or horizontal (with expansion)
    %     if size(V2,2) < size(V2,1)
    %         cprintf(rgb('DarkOrange'), 'WARNING: Assuming V2 is a horizontal vector \n')
    %         V2 = V2(:)';
    %     end
elseif isvector(V1) && ~isvector(V2)
    if size(V1,2) > size(V1,1)
        cprintf(rgb('DarkOrange'), 'WARNING: Assuming V1 is a vertical vector \n')
        V1 = V1(:);
    end
    if size(V1,1) ~= size(V2,1)
        error('Vector / matrix sizes not consistent')
    end
    V1 = V1.*ones(size(V2));
elseif ~isvector(V1) && isvector(V2)
    if size(V2,2) < size(V2,1)
        cprintf(rgb('DarkOrange'), 'WARNING: Assuming V2 is a horizontal vector \n')
        V2 = V2(:)';
    end
    if size(V1,2) ~= size(V2,2)
        error('Vector / matrix sizes not consistent')
    end
    V2 = V2.*ones(size(V1));
elseif ~isvector(V1) && ~isvector(V2)
    if any(size(V1) ~= size(V2))
        error('Matrix sizes not consistent')
    end
end

if exist('INCmtx','var') && ~isempty(INCmtx) && (any(size(INCmtx) ~= size(V1)))
    error('INCmtx size not consistent with V1')
end

if exist('INC1','var') && ~isempty(INC1)
    if isvector(INC1)
        if size(INC1,1) ~= size(V1,1)
            if all(size(INC1) == size(V1'))
                INC1 = INC1';
            else
                error('Values and Incomes vector sizes not consistent');
            end
        end
    elseif any(size(INC1) ~= size(V1))
        error('Values and Incomes matrix sizes not consistent');
    end
end
if exist('INC2','var') && ~isempty(INC2)
    if isvector(INC2)
        if size(INC2,2) ~= size(V2,2)
            if all(size(INC2) == size(V2'))
                INC2 = INC2';
            else
                error('Values and Incomes matrix not consistent');
            end
        end
    elseif any(size(INC2) ~= size(V2))
        error('Values and Incomes matrix sizes not consistent');
    end
end

if ~exist('INCmtx','var')
    INCmtx = bsxfun(@rdivide,INC2,INC1).^el;
else
    INCmtx = INCmtx.^el;
end

TransferErrors = V1.*INCmtx;
TransferErrors = bsxfun(@minus,TransferErrors,V2);
TransferErrors = bsxfun(@rdivide,TransferErrors,V2);

end






