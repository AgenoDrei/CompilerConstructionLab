conc([],L,L).
conc([X|R],L,[X|S]):-conc(R,L,S).

split([],E,[],[]).
split([X|R],E,[X|K],G):-X=<E,split(R,E,K,G).
split([X|R],E,K,[X|G]):-X>E,split(R,E,K,G).

qs([],[]).
qs([E|R],S):-split(R,E,K,G),qs(K,SK),qs(G,SG),conc(SK,[E|SG],S).

rev([],[]).
rev([C|A], D):-rev(A,B), conc(B,[C],D).

absort(A,C):-qs(A,B),rev(B,C).

