function [nlist nN] = search8neighbor(BW, c, n, clock)
[p.c p.ac dir] = neighArray( );

cl = zeros(15,2);
cl(1:15, 1) = c(1);  cl(1:15, 2) = c(2);

switch clock
    case 0
        nlist = p.c + cl;
    case 1
        nlist = p.ac + cl;
end

st =dir(n);

for n = st : st+7
    r = nlist(n, 1); c = nlist(n, 2);
    
    if(BW(r, c))
        nN = n;
        break;
    end
end