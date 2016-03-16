what([],0).
what([X],0).
what([X,Y|R],N):-what(R,M), N is M+Y.
what(A,A).