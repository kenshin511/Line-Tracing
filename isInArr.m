function T = isInArr(B, S, k)
% B: array of contour 
% S: desire value 
% k: last index of B

T = false;
for i = k-1 : -1 : 1
    if(S(1,1) == B(i, 1) && S(1,2) == B(i, 2))
        T = true;
        break;
    end
end