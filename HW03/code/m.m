function Minmod = m(x,y)
    Minmod = 0.5*(sgn(x)+sgn(y))*min([x,y]);
end