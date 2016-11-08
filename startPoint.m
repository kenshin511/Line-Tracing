function s = startPoint(BW, varargin)
% --------------------------------------------------------------
% Find start position : s
% --------------------------------------------------------------
[re ce] = size(BW);

if(nargin < 1)
    sr = 1; sc = 1;
else
    sr = varargin{1}(1); sc = varargin{1}(2);
end

s = [ ];
for r = sr : re
    for c = sc : ce
        if BW(r, c) == 1;
            s = [r c];
            break;
        end
    end
    
    if BW(r, c) == 1;
        break;
    end
end

    

