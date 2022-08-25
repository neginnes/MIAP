function U = hard_treshloding(u)
    [N,k] = size (u);
    U = zeros(N,k);
    [M,I] = max (u,[],2);
    L = 0 : k : k * (N-1) ;
    index = I' + L ;
    Uprime = U' ;
    Uprime(index) = 1;
    U = Uprime' ;
end